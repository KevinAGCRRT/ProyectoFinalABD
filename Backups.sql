


--RESPALDO COMPLETO
USE master;
GO
ALTER DATABASE SistemaDonaciones SET RECOVERY FULL;
GO
SELECT name, recovery_model_desc FROM sys.databases WHERE name = N'SistemaDonaciones';
GO


BACKUP DATABASE SistemaDonaciones
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E1_full.bak'
WITH INIT, CHECKSUM, COMPRESSION, STATS = 10, NAME = N'SD_E1_full';
GO

RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E1_full.bak'
WITH CHECKSUM;
GO


-- RESPALDO DIFERENCIAL Y DE LOG
USE SistemaDonaciones;
INSERT INTO dbo.PruebaRespaldo VALUES (2, N'Despues del completo');
GO
BACKUP DATABASE SistemaDonaciones
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E2_diff.dif'
WITH DIFFERENTIAL, INIT, CHECKSUM, COMPRESSION, NAME = N'SD_E2_diff';
GO


-- Nombres logicos de los archivos dentro del respaldo
RESTORE FILELISTONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E1_full.bak';
GO

DECLARE @datos NVARCHAR(260) = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(260));
DECLARE @log   NVARCHAR(260) = CAST(SERVERPROPERTY('InstanceDefaultLogPath')  AS NVARCHAR(260));
DECLARE @mdf   NVARCHAR(300) = @datos + N'SistemaDonaciones_Test.mdf';
DECLARE @ldf   NVARCHAR(300) = @log   + N'SistemaDonaciones_Test_log.ldf';

RESTORE DATABASE SistemaDonaciones_Test
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E1_full.bak'
WITH MOVE N'SistemaDonaciones'     TO @mdf,
     MOVE N'SistemaDonaciones_log' TO @ldf,
     NORECOVERY, REPLACE;

RESTORE DATABASE SistemaDonaciones_Test
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E2_diff.dif'
WITH NORECOVERY;

RESTORE LOG SistemaDonaciones_Test
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SD_E2_log.trn'
WITH RECOVERY;
GO




-- AUTOMATIZACION CON SQL SERVER AGENT
USE msdb;
GO


IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = N'SD_Operador')
    EXEC msdb.dbo.sp_add_operator
        @name = N'SD_Operador',
        @enabled = 1,
        @email_address = N'admin@example';   -- cambiar aqui por el corep de cuenta de admin
GO

----------------------------------------------------------------
--COMPLETO: domingos 02:00 
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'SD_Respaldo_Completo')
    EXEC msdb.dbo.sp_delete_job @job_name = N'SD_Respaldo_Completo';
GO
EXEC msdb.dbo.sp_add_job
    @job_name = N'SD_Respaldo_Completo',
    @enabled = 1,
    @description = N'Respaldo completo semanal de SistemaDonaciones';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'SD_Respaldo_Completo',
    @step_name = N'Respaldo completo y verificacion',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'DECLARE @f NVARCHAR(400) = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SistemaDonaciones_FULL_'' + FORMAT(GETDATE(), ''yyyyMMdd_HHmmss'') + N''.bak'';
BACKUP DATABASE SistemaDonaciones TO DISK = @f WITH INIT, CHECKSUM, COMPRESSION, NAME = N''SD_FULL_job'';
RESTORE VERIFYONLY FROM DISK = @f WITH CHECKSUM;',
    @on_success_action = 3,   
    @on_fail_action = 2;     

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'SD_Respaldo_Completo',
    @step_name = N'Borrar respaldos de mas de 14 dias',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'DECLARE @limite DATETIME = DATEADD(DAY, -14, GETDATE());
EXEC master.dbo.xp_delete_file 0, N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup'', N''bak'', @limite;
EXEC master.dbo.xp_delete_file 0, N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup'', N''dif'', @limite;
EXEC master.dbo.xp_delete_file 0, N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup'', N''trn'', @limite;',
    @on_success_action = 1,   
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'SD_Respaldo_Completo',
    @name = N'SD_Domingo_0200',
    @enabled = 1,
    @freq_type = 8,                 -- semanal
    @freq_interval = 1,             -- domingo
    @freq_recurrence_factor = 1,
    @active_start_time = 020000;

EXEC msdb.dbo.sp_update_job
    @job_name = N'SD_Respaldo_Completo',
    @notify_level_email = 2,        
    @notify_email_operator_name = N'SD_Operador';

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'SD_Respaldo_Completo',
    @server_name = N'(LOCAL)';
GO

----------------------------------------------------------------
--  DIFERENCIAL: lunes a sabado 02:00
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'SD_Respaldo_Diferencial')
    EXEC msdb.dbo.sp_delete_job @job_name = N'SD_Respaldo_Diferencial';
GO
EXEC msdb.dbo.sp_add_job
    @job_name = N'SD_Respaldo_Diferencial',
    @enabled = 1,
    @description = N'Respaldo diferencial diario de SistemaDonaciones';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'SD_Respaldo_Diferencial',
    @step_name = N'Respaldo diferencial y verificacion',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'DECLARE @f NVARCHAR(400) = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SistemaDonaciones_DIFF_'' + FORMAT(GETDATE(), ''yyyyMMdd_HHmmss'') + N''.dif'';
BACKUP DATABASE SistemaDonaciones TO DISK = @f WITH DIFFERENTIAL, INIT, CHECKSUM, COMPRESSION, NAME = N''SD_DIFF_job'';
RESTORE VERIFYONLY FROM DISK = @f WITH CHECKSUM;',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'SD_Respaldo_Diferencial',
    @name = N'SD_LunesSabado_0200',
    @enabled = 1,
    @freq_type = 8,
    @freq_interval = 126,           -- lun(2)+mar(4)+mie(8)+jue(16)+vie(32)+sab(64)
    @freq_recurrence_factor = 1,
    @active_start_time = 020000;

EXEC msdb.dbo.sp_update_job
    @job_name = N'SD_Respaldo_Diferencial',
    @notify_level_email = 2,
    @notify_email_operator_name = N'SD_Operador';

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'SD_Respaldo_Diferencial',
    @server_name = N'(LOCAL)';
GO

----------------------------------------------------------------
--  LOG DE TRANSACCIONES: cada 30 minutos
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'SD_Respaldo_Log')
    EXEC msdb.dbo.sp_delete_job @job_name = N'SD_Respaldo_Log';
GO
EXEC msdb.dbo.sp_add_job
    @job_name = N'SD_Respaldo_Log',
    @enabled = 1,
    @description = N'Respaldo del log de SistemaDonaciones cada 30 minutos';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'SD_Respaldo_Log',
    @step_name = N'Respaldo de log',
    @subsystem = N'TSQL',
    @database_name = N'master',
    @command = N'DECLARE @f NVARCHAR(400) = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SistemaDonaciones_LOG_'' + FORMAT(GETDATE(), ''yyyyMMdd_HHmmss'') + N''.trn'';
BACKUP LOG SistemaDonaciones TO DISK = @f WITH INIT, CHECKSUM, COMPRESSION, NAME = N''SD_LOG_job'';',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'SD_Respaldo_Log',
    @name = N'SD_Cada30min',
    @enabled = 1,
    @freq_type = 4,                 -- diario
    @freq_interval = 1,
    @freq_subday_type = 4,          -- minutos
    @freq_subday_interval = 30,
    @active_start_time = 000000,
    @active_end_time = 235959;

EXEC msdb.dbo.sp_update_job
    @job_name = N'SD_Respaldo_Log',
    @notify_level_email = 2,
    @notify_email_operator_name = N'SD_Operador';

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'SD_Respaldo_Log',
    @server_name = N'(LOCAL)';
GO





