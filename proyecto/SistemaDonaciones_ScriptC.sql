

USE [master]
GO
/****** Object:  Database [SistemaDonaciones]    Script Date: 15/11/2026 23:33:15 ******/
CREATE DATABASE [SistemaDonaciones]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SistemaDonaciones', FILENAME = N'/var/opt/mssql/data/SistemaDonaciones.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SistemaDonaciones_log', FILENAME = N'/var/opt/mssql/data/SistemaDonaciones_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [SistemaDonaciones] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SistemaDonaciones].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SistemaDonaciones] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET ARITHABORT OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SistemaDonaciones] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SistemaDonaciones] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET  ENABLE_BROKER 
GO
ALTER DATABASE [SistemaDonaciones] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SistemaDonaciones] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET RECOVERY FULL 
GO
ALTER DATABASE [SistemaDonaciones] SET  MULTI_USER 
GO
ALTER DATABASE [SistemaDonaciones] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SistemaDonaciones] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SistemaDonaciones] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SistemaDonaciones] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SistemaDonaciones] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [SistemaDonaciones] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'SistemaDonaciones', N'ON'
GO
ALTER DATABASE [SistemaDonaciones] SET QUERY_STORE = ON
GO
ALTER DATABASE [SistemaDonaciones] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
-- Logins -----------------------------------
use master;
go
if suser_id(N'admin_seguridad') is null
    create login admin_seguridad with password = 'Seguridad123', check_policy = on, check_expiration = off;
go

if suser_id(N'admin_finanzas') is null
    create login admin_finanzas with password = 'Finanzas123', check_policy = on, check_expiration = off;
go

if suser_id(N'admin_operaciones') is null
    create login admin_operaciones with password = 'Operaciones123', check_policy = on, check_expiration = off;
go

USE [SistemaDonaciones]
GO
/****** Object:  User [seguridadONG]    Script Date: 15/11/2026 23:33:16 ******/
CREATE USER [seguridadONG] FOR LOGIN [admin_seguridad] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [operacionesONG]    Script Date: 15/11/2026 23:33:16 ******/
CREATE USER [operacionesONG] FOR LOGIN [admin_operaciones] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [finanzasONG]    Script Date: 15/11/2026 23:33:16 ******/
CREATE USER [finanzasONG] FOR LOGIN [admin_finanzas] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [rol_seguridad]    Script Date: 15/11/2026 23:33:16 ******/
CREATE ROLE [rol_seguridad]
GO
/****** Object:  DatabaseRole [rol_finanzas]    Script Date: 15/11/2026 23:33:16 ******/
CREATE ROLE [rol_finanzas]
GO
/****** Object:  DatabaseRole [rol_coordinador]    Script Date: 15/11/2026 23:33:16 ******/
CREATE ROLE [rol_coordinador]
GO
ALTER ROLE [rol_seguridad] ADD MEMBER [seguridadONG]
GO
ALTER ROLE [rol_coordinador] ADD MEMBER [operacionesONG]
GO
ALTER ROLE [rol_finanzas] ADD MEMBER [finanzasONG]
GO
/****** Object:  Schema [Operaciones]    Script Date: 15/11/2026 23:33:16 ******/
CREATE SCHEMA [Operaciones]
GO
/****** Object:  Schema [Recaudaciones]    Script Date: 15/11/2026 23:33:16 ******/
CREATE SCHEMA [Recaudaciones]
GO
/****** Object:  Table [dbo].[PruebaRespaldo]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PruebaRespaldo](
	[ID] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operaciones].[AsignacionFondos]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operaciones].[AsignacionFondos](
	[AsignacionID] [bigint] IDENTITY(1,1) NOT NULL,
	[DonacionID] [bigint] NOT NULL,
	[ProyectoID] [int] NOT NULL,
	[MontoAsignado] [decimal](18, 2) NOT NULL,
	[FechaAsignacion] [datetime2](7) NULL,
 CONSTRAINT [PK_AsignacionFondos] PRIMARY KEY CLUSTERED 
(
	[AsignacionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operaciones].[Beneficiarios]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operaciones].[Beneficiarios](
	[BeneficiarioID] [bigint] IDENTITY(1,1) NOT NULL,
	[ComunidadID] [int] NOT NULL,
	[NombreCompleto] [nvarchar](150) NOT NULL,
	[DocumentoIdentidad] [nvarchar](30) NULL,
	[TipoBeneficiario] [nvarchar](50) NULL,
	[FechaRegistro] [date] NULL,
 CONSTRAINT [PK_Beneficiarios] PRIMARY KEY CLUSTERED 
(
	[BeneficiarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operaciones].[CategoriasProyecto]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operaciones].[CategoriasProyecto](
	[CategoriaID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_CategoriasProyecto] PRIMARY KEY CLUSTERED 
(
	[CategoriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Categoria_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operaciones].[Comunidades]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operaciones].[Comunidades](
	[ComunidadID] [int] IDENTITY(1,1) NOT NULL,
	[NombreComunidad] [nvarchar](100) NOT NULL,
	[UbicacionGeografica] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Comunidades] PRIMARY KEY CLUSTERED 
(
	[ComunidadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Operaciones].[EntregasAyuda]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operaciones].[EntregasAyuda](
	[EntregaID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProyectoID] [int] NOT NULL,
	[BeneficiarioID] [bigint] NOT NULL,
	[FechaEntrega] [datetime2](7) NULL,
	[DescripcionAyuda] [nvarchar](max) NOT NULL,
	[CantidadEntregada] [decimal](18, 2) NULL,
 CONSTRAINT [PK_EntregasAyuda] PRIMARY KEY CLUSTERED 
(
	[EntregaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Operaciones].[Proyectos]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operaciones].[Proyectos](
	[ProyectoID] [int] IDENTITY(1,1) NOT NULL,
	[CategoriaID] [int] NOT NULL,
	[NombreProyecto] [nvarchar](200) NOT NULL,
	[PresupuestoMeta] [decimal](18, 2) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[Estado] [nvarchar](20) NULL,
 CONSTRAINT [PK_Proyectos] PRIMARY KEY CLUSTERED 
(
	[ProyectoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Recaudaciones].[CanalesPago]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Recaudaciones].[CanalesPago](
	[CanalPagoID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CanalesPago] PRIMARY KEY CLUSTERED 
(
	[CanalPagoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_CanalPago_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Recaudaciones].[Donaciones]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Recaudaciones].[Donaciones](
	[DonacionID] [bigint] IDENTITY(1,1) NOT NULL,
	[DonanteID] [bigint] NOT NULL,
	[TipoDonacionID] [int] NOT NULL,
	[CanalPagoID] [int] NOT NULL,
	[Monto] [decimal](18, 2) NOT NULL,
	[FechaDonacion] [datetime2](7) NULL,
	[Comentario] [nvarchar](max) NULL,
 CONSTRAINT [PK_Donaciones] PRIMARY KEY CLUSTERED 
(
	[DonacionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Recaudaciones].[Donantes]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Recaudaciones].[Donantes](
	[DonanteID] [bigint] IDENTITY(1,1) NOT NULL,
	[NombreCompleto] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Telefono] [nvarchar](20) NULL,
	[DocumentoIdentidad] [nvarchar](30) NOT NULL,
	[FechaRegistro] [datetime2](7) NULL,
 CONSTRAINT [PK_Donantes] PRIMARY KEY CLUSTERED 
(
	[DonanteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Donante_Documento] UNIQUE NONCLUSTERED 
(
	[DocumentoIdentidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Recaudaciones].[TiposDonacion]    Script Date: 15/11/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Recaudaciones].[TiposDonacion](
	[TipoDonacionID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_TiposDonacion] PRIMARY KEY CLUSTERED 
(
	[TipoDonacionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_TipoDonacion_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_AsignacionFondos_Proyecto]    Script Date: 15/11/2026 23:33:16 ******/
CREATE NONCLUSTERED INDEX [IX_AsignacionFondos_Proyecto] ON [Operaciones].[AsignacionFondos]
(
	[ProyectoID] ASC
)
INCLUDE([MontoAsignado]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Proyectos_Estado_Covering]    Script Date: 15/11/2026 23:33:16 ******/
CREATE NONCLUSTERED INDEX [IX_Proyectos_Estado_Covering] ON [Operaciones].[Proyectos]
(
	[Estado] ASC
)
INCLUDE([CategoriaID],[NombreProyecto],[PresupuestoMeta]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Donaciones_Donante]    Script Date: 15/11/2026 23:33:16 ******/
CREATE NONCLUSTERED INDEX [IX_Donaciones_Donante] ON [Recaudaciones].[Donaciones]
(
	[DonanteID] ASC
)
INCLUDE([Monto]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Donaciones_FechaDonacion]    Script Date: 15/11/2026 23:33:16 ******/
CREATE NONCLUSTERED INDEX [IX_Donaciones_FechaDonacion] ON [Recaudaciones].[Donaciones]
(
	[FechaDonacion] DESC
)
INCLUDE([DonanteID],[TipoDonacionID],[CanalPagoID],[Monto],[Comentario]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Operaciones].[AsignacionFondos] ADD  DEFAULT (sysdatetime()) FOR [FechaAsignacion]
GO
ALTER TABLE [Operaciones].[Beneficiarios] ADD  DEFAULT ('Individual') FOR [TipoBeneficiario]
GO
ALTER TABLE [Operaciones].[Beneficiarios] ADD  DEFAULT (CONVERT([date],sysdatetime())) FOR [FechaRegistro]
GO
ALTER TABLE [Operaciones].[EntregasAyuda] ADD  DEFAULT (sysdatetime()) FOR [FechaEntrega]
GO
ALTER TABLE [Operaciones].[EntregasAyuda] ADD  DEFAULT ((1.00)) FOR [CantidadEntregada]
GO
ALTER TABLE [Operaciones].[Proyectos] ADD  DEFAULT ('Activo') FOR [Estado]
GO
ALTER TABLE [Recaudaciones].[Donaciones] ADD  DEFAULT (sysdatetime()) FOR [FechaDonacion]
GO
ALTER TABLE [Recaudaciones].[Donantes] ADD  DEFAULT (sysdatetime()) FOR [FechaRegistro]
GO
ALTER TABLE [Operaciones].[AsignacionFondos]  WITH CHECK ADD  CONSTRAINT [FK_Asignacion_Donaciones] FOREIGN KEY([DonacionID])
REFERENCES [Recaudaciones].[Donaciones] ([DonacionID])
GO
ALTER TABLE [Operaciones].[AsignacionFondos] CHECK CONSTRAINT [FK_Asignacion_Donaciones]
GO
ALTER TABLE [Operaciones].[AsignacionFondos]  WITH CHECK ADD  CONSTRAINT [FK_Asignacion_Proyectos] FOREIGN KEY([ProyectoID])
REFERENCES [Operaciones].[Proyectos] ([ProyectoID])
GO
ALTER TABLE [Operaciones].[AsignacionFondos] CHECK CONSTRAINT [FK_Asignacion_Proyectos]
GO
ALTER TABLE [Operaciones].[Beneficiarios]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiarios_Comunidades] FOREIGN KEY([ComunidadID])
REFERENCES [Operaciones].[Comunidades] ([ComunidadID])
GO
ALTER TABLE [Operaciones].[Beneficiarios] CHECK CONSTRAINT [FK_Beneficiarios_Comunidades]
GO
ALTER TABLE [Operaciones].[EntregasAyuda]  WITH CHECK ADD  CONSTRAINT [FK_Entregas_Beneficiarios] FOREIGN KEY([BeneficiarioID])
REFERENCES [Operaciones].[Beneficiarios] ([BeneficiarioID])
GO
ALTER TABLE [Operaciones].[EntregasAyuda] CHECK CONSTRAINT [FK_Entregas_Beneficiarios]
GO
ALTER TABLE [Operaciones].[EntregasAyuda]  WITH CHECK ADD  CONSTRAINT [FK_Entregas_Proyectos] FOREIGN KEY([ProyectoID])
REFERENCES [Operaciones].[Proyectos] ([ProyectoID])
GO
ALTER TABLE [Operaciones].[EntregasAyuda] CHECK CONSTRAINT [FK_Entregas_Proyectos]
GO
ALTER TABLE [Operaciones].[Proyectos]  WITH CHECK ADD  CONSTRAINT [FK_Proyectos_Categorias] FOREIGN KEY([CategoriaID])
REFERENCES [Operaciones].[CategoriasProyecto] ([CategoriaID])
GO
ALTER TABLE [Operaciones].[Proyectos] CHECK CONSTRAINT [FK_Proyectos_Categorias]
GO
ALTER TABLE [Recaudaciones].[Donaciones]  WITH CHECK ADD  CONSTRAINT [FK_Donaciones_Canales] FOREIGN KEY([CanalPagoID])
REFERENCES [Recaudaciones].[CanalesPago] ([CanalPagoID])
GO
ALTER TABLE [Recaudaciones].[Donaciones] CHECK CONSTRAINT [FK_Donaciones_Canales]
GO
ALTER TABLE [Recaudaciones].[Donaciones]  WITH CHECK ADD  CONSTRAINT [FK_Donaciones_Donantes] FOREIGN KEY([DonanteID])
REFERENCES [Recaudaciones].[Donantes] ([DonanteID])
GO
ALTER TABLE [Recaudaciones].[Donaciones] CHECK CONSTRAINT [FK_Donaciones_Donantes]
GO
ALTER TABLE [Recaudaciones].[Donaciones]  WITH CHECK ADD  CONSTRAINT [FK_Donaciones_Tipos] FOREIGN KEY([TipoDonacionID])
REFERENCES [Recaudaciones].[TiposDonacion] ([TipoDonacionID])
GO
ALTER TABLE [Recaudaciones].[Donaciones] CHECK CONSTRAINT [FK_Donaciones_Tipos]
GO
ALTER TABLE [Operaciones].[AsignacionFondos]  WITH CHECK ADD  CONSTRAINT [CHK_Asignacion_Monto] CHECK  (([MontoAsignado]>(0)))
GO
ALTER TABLE [Operaciones].[AsignacionFondos] CHECK CONSTRAINT [CHK_Asignacion_Monto]
GO
ALTER TABLE [Operaciones].[Beneficiarios]  WITH CHECK ADD  CONSTRAINT [CHK_Beneficiario_Tipo] CHECK  (([TipoBeneficiario]='Comunitario' OR [TipoBeneficiario]='Familiar' OR [TipoBeneficiario]='Individual'))
GO
ALTER TABLE [Operaciones].[Beneficiarios] CHECK CONSTRAINT [CHK_Beneficiario_Tipo]
GO
ALTER TABLE [Operaciones].[EntregasAyuda]  WITH CHECK ADD  CONSTRAINT [CHK_Entrega_Cantidad] CHECK  (([CantidadEntregada]>(0)))
GO
ALTER TABLE [Operaciones].[EntregasAyuda] CHECK CONSTRAINT [CHK_Entrega_Cantidad]
GO
ALTER TABLE [Operaciones].[Proyectos]  WITH CHECK ADD  CONSTRAINT [CHK_Proyecto_Estado] CHECK  (([Estado]='Suspendido' OR [Estado]='Finalizado' OR [Estado]='Activo' OR [Estado]='Planificación'))
GO
ALTER TABLE [Operaciones].[Proyectos] CHECK CONSTRAINT [CHK_Proyecto_Estado]
GO
ALTER TABLE [Operaciones].[Proyectos]  WITH CHECK ADD  CONSTRAINT [CHK_Proyecto_Fechas] CHECK  (([FechaFin] IS NULL OR [FechaFin]>=[FechaInicio]))
GO
ALTER TABLE [Operaciones].[Proyectos] CHECK CONSTRAINT [CHK_Proyecto_Fechas]
GO
ALTER TABLE [Operaciones].[Proyectos]  WITH CHECK ADD  CONSTRAINT [CHK_Proyecto_Presupuesto] CHECK  (([PresupuestoMeta]>(0)))
GO
ALTER TABLE [Operaciones].[Proyectos] CHECK CONSTRAINT [CHK_Proyecto_Presupuesto]
GO
ALTER TABLE [Recaudaciones].[Donaciones]  WITH CHECK ADD  CONSTRAINT [CHK_Donacion_Monto] CHECK  (([Monto]>(0)))
GO
ALTER TABLE [Recaudaciones].[Donaciones] CHECK CONSTRAINT [CHK_Donacion_Monto]
GO
ALTER TABLE [Recaudaciones].[Donantes]  WITH CHECK ADD  CONSTRAINT [CHK_Donante_Email] CHECK  (([Email] like '%_@__%.%'))
GO
ALTER TABLE [Recaudaciones].[Donantes] CHECK CONSTRAINT [CHK_Donante_Email]
GO
USE [master]
GO
ALTER DATABASE [SistemaDonaciones] SET  READ_WRITE 
GO

-- ================================================================
-- POBLADO DE LA BASE DE DATOS
-- ================================================================
USE [SistemaDonaciones];
GO


-- 1. Tipos de Donación (Esquema Recaudaciones)
INSERT INTO [Recaudaciones].[TiposDonacion] ([Nombre], [Descripcion]) VALUES
('Económica Puntual', 'Aporte monetario único no recurrente'),
('Económica Recurrente Mensual', 'Compromiso domiciliado de aporte mensual periódico'),
('Campaña de Emergencia', 'Fondos designados a desastres naturales o contingencias críticas'),
('Patrocinio Institucional', 'Subvenciones corporativas o de organismos internacionales'),
('Fondo Semilla Emprendimiento', 'Aporte enfocado a financiar microproyectos productivos');

-- 2. Canales de Pago (Esquema Recaudaciones)
INSERT INTO [Recaudaciones].[CanalesPago] ([Nombre]) VALUES
('Transferencia Bancaria Directa'),
('Tarjeta de Crédito / Débito'),
('Plataforma Digital (PayPal / Web)'),
('Efectivo en Ventanilla / Colecta'),
('Cheque Certificado');

-- 3. Categorías de Proyecto (Esquema Operaciones)
INSERT INTO [Operaciones].[CategoriasProyecto] ([Nombre]) VALUES
('Educación y Becas'),
('Salud, Nutrición y Bienestar'),
('Infraestructura y Agua Potable'),
('Desarrollo Económico Comunitario'),
('Medio Ambiente y Reforestación');

-- 4. Comunidades (Esquema Operaciones)
INSERT INTO [Operaciones].[Comunidades] ([NombreComunidad], [UbicacionGeografica]) VALUES
('Caserío San José El Jocote', 'Departamento de La Paz, Zona Rural'),
('Comunidad El Espino', 'Antiguo Cuscatlán, Sector Cordillera'),
('Barrio Las Flores', 'Distrito Capital, Sector Central Urbano'),
('Cantón La Ceiba', 'Sonsonate, Zona Costera'),
('Comunidad Monte Bello', 'Morazán, Región Montañosa'),
('Colonia El Milagro', 'Santa Ana, Suburbio Periférico'),
('Caserío Las Pampas', 'Usulután, Zona Agrícola Baja');
GO


-- 5. Donantes (Esquema Recaudaciones - 20 Donantes con Documento único y Email válido)
INSERT INTO [Recaudaciones].[Donantes] ([NombreCompleto], [Email], [Telefono], [DocumentoIdentidad], [FechaRegistro]) VALUES
('Carlos Roberto Mendoza', 'carlos.mendoza@gmail.com', '7123-4567', '04589211-1', '2025-09-01 08:30:00'),
('Elena Patricia Solórzano', 'elena.patricia@outlook.com', '7890-1122', '03215894-5', '2025-09-05 09:15:00'),
('Fundación Esperanza SV', 'contacto@esperanzasv.org', '2250-9988', '0614-120590-101-2', '2025-09-10 14:00:00'),
('Distribuidora Agrícola Salvadoreña', 'donaciones@distriagricola.com', '2228-4400', '0614-250885-102-1', '2025-09-12 11:20:00'),
('Jorge Alberto Henríquez', 'jorge.henriquez@yahoo.com', '7455-8899', '01984572-8', '2025-09-20 16:45:00'),
('Ana Julia Vásquez', 'ana.vasquez@empresa.net', '7001-2345', '05478912-3', '2025-10-01 10:10:00'),
('Corporación Textilera Global', 'csr@corptextil.com', '2525-0011', '0614-010198-103-9', '2025-10-05 13:00:00'),
('Mauricio Ernesto Rivas', 'mauricio.rivas@servicios.sv', '7633-9021', '02874125-9', '2025-10-15 15:30:00'),
('Lucía Beatriz Morales', 'lucia.morales@correo.com', '7911-3344', '04992134-7', '2025-10-22 11:00:00'),
('Roberto Antonio Flores', 'roberto.flores@tecnologia.org', '2244-1234', '01123456-0', '2025-11-01 08:45:00'),
('Banco Regional Solidario', 'rse@bancoregional.com', '2299-8800', '0614-150682-105-4', '2025-11-04 10:15:00'),
('Gabriela María Cornejo', 'gabriela.cornejo@live.com', '7500-4411', '03889123-6', '2025-11-10 16:20:00'),
('Supermercados La Canasta', 'ayuda@lacanasta.com.sv', '2211-5566', '0614-301175-101-8', '2025-11-15 09:00:00'),
('Fernando José Meléndez', 'fer.melendez@gmail.com', '7322-8877', '02456712-4', '2025-11-20 14:10:00'),
('Sofía Guadalupe Aguilar', 'sofia.aguilar@hotmail.com', '7844-0099', '05123987-1', '2025-12-01 11:30:00'),
('Industrias Plásticas Unidas', 'gerencia@plasticosunidos.com', '2288-6633', '0614-040790-104-3', '2025-12-05 15:00:00'),
('Manuel Antonio Carballo', 'manuel.carballo@dominio.sv', '7211-9900', '03665421-9', '2025-12-12 17:00:00'),
('Valeria Irene Castaneda', 'valeria.castaneda@red.edu.sv', '7988-1254', '01887452-2', '2026-01-05 08:00:00'),
('Asociación Médica Humanitaria', 'proyectos@medicoshum.org', '2233-7711', '0614-180900-106-7', '2026-01-10 12:45:00'),
('Guillermo Enrique Peña', 'guillermo.pena@gmail.com', '7712-3300', '04221199-8', '2026-01-15 10:30:00');

-- 6. Proyectos (Esquema Operaciones - 10 Proyectos con CategoriaID 1..5)
INSERT INTO [Operaciones].[Proyectos] ([CategoriaID], [NombreProyecto], [PresupuestoMeta], [FechaInicio], [FechaFin], [Estado]) VALUES
(1, 'Becas Escolares y Mochilas Digitales 2026', 15000.00, '2026-01-15', '2026-11-30', 'Activo'),
(2, 'Brigadas Médicas Rurales y Vacunación', 8500.00, '2026-02-01', '2026-08-31', 'Activo'),
(3, 'Construcción de Pozo de Agua Potable Las Flores', 30000.00, '2026-03-01', NULL, 'Planificación'),
(4, 'Huertos Familiares Sostenibles', 6000.00, '2025-06-01', '2025-12-15', 'Finalizado'),
(5, 'Fondo de Ayuda Inmediata ante Inundaciones', 12000.00, '2026-05-01', '2026-10-31', 'Planificación'),
(1, 'Capacitación en Habilidades Tecnológicas Juveniles', 10000.00, '2026-02-15', '2026-09-30', 'Activo'),
(2, 'Nutrición Infantil y Comedores Comunitarios', 18000.00, '2026-01-10', '2026-12-20', 'Activo'),
(3, 'Rehabilitación de Techos y Pisos de Viviendas', 22000.00, '2025-08-01', '2026-01-30', 'Finalizado'),
(4, 'Talleres Vocacionales y Emprendimiento Femenino', 9500.00, '2026-03-15', '2026-11-15', 'Activo'),
(5, 'Reforestación de Cuencas Hidrográficas', 7000.00, '2026-04-01', '2026-08-31', 'Planificación');

-- 7. Beneficiarios (Esquema Operaciones - 20 Beneficiarios con ComunidadID 1..7)
INSERT INTO [Operaciones].[Beneficiarios] ([ComunidadID], [NombreCompleto], [DocumentoIdentidad], [TipoBeneficiario], [FechaRegistro]) VALUES
(1, 'Familia Gómez Pérez', '01234567-8', 'Familiar', '2025-10-01'),
(1, 'José Santos Ramos', '02891234-1', 'Individual', '2025-10-02'),
(2, 'Rosa Elvira Martínez', '09876543-2', 'Individual', '2025-10-05'),
(2, 'Familia Cruz Rodríguez', '03456781-9', 'Familiar', '2025-10-08'),
(3, 'Comité Comunitario Sector Central Las Flores', '0614-220185-102-1', 'Comunitario', '2025-10-15'),
(4, 'Asociación Agropecuaria La Ceiba', '0614-150992-104-5', 'Comunitario', '2025-10-20'),
(5, 'Familia Ventura Quintanilla', '04128765-3', 'Familiar', '2025-11-01'),
(5, 'Marta Lilian Portillo', '05987123-0', 'Individual', '2025-11-05'),
(6, 'Carlos Alberto Renderos', '01774433-7', 'Individual', '2025-11-12'),
(6, 'Familia Morales Orellana', '02334411-8', 'Familiar', '2025-11-15'),
(7, 'Cooperativa Agrícola Las Pampas', '0614-080388-101-3', 'Comunitario', '2025-12-01'),
(7, 'Tomás Edmundo Serrano', '04771234-5', 'Individual', '2025-12-05'),
(1, 'Silvia Lorena Cañas', '03112299-4', 'Individual', '2025-12-10'),
(2, 'Familia Menjívar Guardado', '05443322-1', 'Familiar', '2025-12-18'),
(3, 'Nelson Oswaldo Barahona', '02998877-6', 'Individual', '2026-01-08'),
(4, 'Familia Chicas Benítez', '01665544-2', 'Familiar', '2026-01-12'),
(5, 'Directiva Pro-Mejoramiento Monte Bello', '0614-191095-103-6', 'Comunitario', '2026-01-15'),
(6, 'Miriam Elizabeth Rosales', '04889900-3', 'Individual', '2026-01-20'),
(7, 'Familia Velásquez Coto', '03776655-9', 'Familiar', '2026-01-25'),
(3, 'Héctor Daniel Amaya', '01445588-0', 'Individual', '2026-02-01');
GO


-- 8. Donaciones (Esquema Recaudaciones - 35 transacciones)
INSERT INTO [Recaudaciones].[Donaciones] ([DonanteID], [TipoDonacionID], [CanalPagoID], [Monto], [FechaDonacion], [Comentario]) VALUES
(1, 1, 1, 300.00, '2026-01-10 09:15:00', 'Donación única para inicio de clases'),
(2, 2, 2, 80.00, '2026-01-12 10:00:00', 'Membresía recurrente mensual enero'),
(3, 4, 1, 6000.00, '2026-01-15 11:30:00', 'Subvención anual para proyectos educativos y agua'),
(4, 4, 5, 3500.00, '2026-01-18 14:00:00', 'Fondo corporativo asignado al área médica'),
(5, 1, 3, 120.00, '2026-01-22 16:45:00', 'Donación realizada por botón web'),
(6, 2, 2, 60.00, '2026-01-25 08:30:00', 'Cuota de afiliación periódica'),
(7, 4, 1, 8000.00, '2026-01-28 15:20:00', 'Donación de apoyo a infraestructura básica'),
(8, 1, 4, 200.00, '2026-02-01 11:10:00', 'Entrega directa en caja de oficina central'),
(9, 1, 2, 150.00, '2026-02-03 09:40:00', 'Apoyo para comedores comunitarios'),
(10, 2, 1, 100.00, '2026-02-05 14:15:00', 'Aporte recurrente domiciliado'),
(11, 4, 1, 10000.00, '2026-02-08 10:00:00', 'Patrocinio bancario de impacto social 2026'),
(12, 1, 3, 90.00, '2026-02-10 17:30:00', 'Aporte digital a campaña de salud'),
(13, 4, 5, 4500.00, '2026-02-12 11:00:00', 'Cheque donado para equipamiento y raciones'),
(14, 1, 2, 250.00, '2026-02-15 13:50:00', 'Aporte para becas y útiles escolares'),
(15, 2, 2, 75.00, '2026-02-18 09:10:00', 'Cuota mensual recurrente febrero'),
(16, 4, 1, 5000.00, '2026-02-20 16:00:00', 'Fondo ambiental e hídrico'),
(17, 1, 4, 180.00, '2026-02-22 12:20:00', 'Aporte en efectivo en ventanilla'),
(18, 1, 3, 50.00, '2026-02-24 18:05:00', 'Donación vía app móvil'),
(19, 4, 1, 4000.00, '2026-02-26 10:40:00', 'Convenio interinstitucional de salud'),
(20, 1, 1, 350.00, '2026-02-28 14:25:00', 'Aporte único a programas juveniles'),
(2, 2, 2, 80.00, '2026-03-01 09:00:00', 'Cuota mensual recurrente marzo'),
(6, 2, 2, 60.00, '2026-03-01 09:05:00', 'Cuota mensual recurrente marzo'),
(10, 2, 1, 100.00, '2026-03-02 10:15:00', 'Cuota mensual recurrente marzo'),
(1, 1, 1, 500.00, '2026-03-03 11:30:00', 'Segundo aporte trimestral'),
(3, 4, 1, 7500.00, '2026-03-05 15:00:00', 'Desembolso fase II proyecto de agua'),
(5, 1, 3, 200.00, '2026-03-07 16:40:00', 'Colaboración campañas nutricionales'),
(7, 4, 1, 6000.00, '2026-03-09 09:50:00', 'Donación empresarial para talleres productivos'),
(8, 1, 4, 300.00, '2026-03-10 13:10:00', 'Donación de voluntariado en efectivo'),
(11, 4, 1, 5000.00, '2026-03-12 11:45:00', 'Segundo desembolso programa comunitario'),
(13, 4, 5, 2000.00, '2026-03-15 14:30:00', 'Soporte alimentario complementario'),
(14, 1, 2, 180.00, '2026-03-18 10:20:00', 'Aporte a brigada médica'),
(15, 2, 2, 75.00, '2026-03-20 09:15:00', 'Cuota mensual recurrente marzo'),
(18, 1, 3, 110.00, '2026-03-22 17:10:00', 'Donación para mochilas digitales'),
(19, 4, 1, 3000.00, '2026-03-25 15:35:00', 'Fondos para compra de medicamentos'),
(20, 1, 1, 400.00, '2026-03-28 11:00:00', 'Aporte para reforestación local');

-- 9. Asignación de Fondos (Esquema Operaciones - Puente de DonacionID a ProyectoID)
INSERT INTO [Operaciones].[AsignacionFondos] ([DonacionID], [ProyectoID], [MontoAsignado], [FechaAsignacion]) VALUES
(1, 1, 300.00, '2026-01-11 08:30:00'),
(2, 2, 80.00, '2026-01-13 09:00:00'),
(3, 1, 3000.00, '2026-01-16 10:00:00'),
(3, 3, 3000.00, '2026-01-16 10:05:00'),
(4, 2, 3500.00, '2026-01-19 11:15:00'),
(5, 7, 120.00, '2026-01-23 14:00:00'),
(6, 6, 60.00, '2026-01-26 15:30:00'),
(7, 3, 8000.00, '2026-01-29 09:00:00'),
(8, 2, 200.00, '2026-02-02 10:20:00'),
(9, 7, 150.00, '2026-02-04 11:00:00'),
(10, 6, 100.00, '2026-02-06 14:40:00'),
(11, 1, 5000.00, '2026-02-09 10:30:00'),
(11, 9, 5000.00, '2026-02-09 10:35:00'),
(12, 2, 90.00, '2026-02-11 16:00:00'),
(13, 7, 4500.00, '2026-02-13 10:00:00'),
(14, 1, 250.00, '2026-02-16 14:20:00'),
(15, 2, 75.00, '2026-02-19 09:30:00'),
(16, 3, 3500.00, '2026-02-21 11:10:00'),
(16, 10, 1500.00, '2026-02-21 11:15:00'),
(17, 7, 180.00, '2026-02-23 12:45:00'),
(18, 6, 50.00, '2026-02-25 17:00:00'),
(19, 2, 4000.00, '2026-02-27 10:15:00'),
(20, 6, 350.00, '2026-03-01 11:00:00'),
(21, 2, 80.00, '2026-03-02 09:30:00'),
(22, 6, 60.00, '2026-03-02 09:35:00'),
(23, 1, 100.00, '2026-03-03 10:30:00'),
(24, 1, 500.00, '2026-03-04 12:00:00'),
(25, 3, 7500.00, '2026-03-06 14:00:00'),
(26, 7, 200.00, '2026-03-08 16:00:00'),
(27, 9, 6000.00, '2026-03-10 10:00:00'),
(28, 2, 300.00, '2026-03-11 11:30:00'),
(29, 3, 5000.00, '2026-03-13 12:15:00'),
(30, 7, 2000.00, '2026-03-16 15:00:00'),
(31, 2, 180.00, '2026-03-19 10:45:00'),
(32, 2, 75.00, '2026-03-21 09:30:00'),
(33, 1, 110.00, '2026-03-23 16:30:00'),
(34, 2, 3000.00, '2026-03-26 14:00:00'),
(35, 10, 400.00, '2026-03-29 11:30:00');

-- 10. Entregas de Ayuda (Esquema Operaciones - Proyectos a Beneficiarios)
INSERT INTO [Operaciones].[EntregasAyuda] ([ProyectoID], [BeneficiarioID], [FechaEntrega], [DescripcionAyuda], [CantidadEntregada]) VALUES
(1, 1, '2026-01-25 10:00:00', 'Paquetes de cuadernos, libros de texto y mochila escolar', 3.00),
(1, 4, '2026-01-26 11:30:00', 'Kit escolar completo para educación básica', 2.00),
(1, 13, '2026-02-02 09:45:00', 'Mochila digital con tableta para formación secundaria', 1.00),
(1, 14, '2026-02-05 14:20:00', 'Lote de papelería y uniformes escolares', 2.00),
(2, 2, '2026-02-10 08:30:00', 'Chequeo médico integral y suministro de antibióticos', 1.00),
(2, 3, '2026-02-10 09:15:00', 'Consulta médica general y vitaminas para adulto mayor', 1.00),
(2, 8, '2026-02-12 11:00:00', 'Tratamiento pediátrico y sueros de rehidratación oral', 2.00),
(2, 9, '2026-02-15 15:00:00', 'Atención médica y paquete de medicamentos para hipertensión', 1.00),
(3, 5, '2026-02-18 10:00:00', 'Dotación de tubería PVC de alta presión para la red comunitaria', 25.00),
(3, 5, '2026-02-25 14:00:00', 'Válvulas reguladoras de caudal y accesorios de bombeo', 4.00),
(4, 7, '2025-10-10 09:00:00', 'Kit de semillas certificadas y herramientas agrícolas menores', 1.00),
(4, 11, '2025-11-15 10:30:00', 'Sacos de abono orgánico y sistema de riego por goteo', 10.00),
(6, 12, '2026-02-20 16:00:00', 'Manuales técnicos y acceso a plataforma de computación', 1.00),
(6, 15, '2026-02-22 17:00:00', 'Certificación inicial en programación web', 1.00),
(7, 1, '2026-02-24 11:30:00', 'Raciones de alimentos fortificados y granos básicos', 5.00),
(7, 4, '2026-02-26 12:00:00', 'Canastas básicas familiares de emergencia alimentaria', 4.00),
(7, 10, '2026-03-02 09:30:00', 'Suministro mensual de leche fortificada y cereales infantiles', 6.00),
(7, 16, '2026-03-05 10:15:00', 'Dotación de víveres no perecederos', 3.00),
(8, 14, '2025-12-05 14:00:00', 'Láminas de zinc y costaneras para reparación de techo', 12.00),
(8, 19, '2026-01-10 11:00:00', 'Bolsas de cemento y arena para reconstrucción de piso', 15.00),
(9, 6, '2026-03-12 15:00:00', 'Kits de costura y confección para taller vocacional', 5.00),
(9, 17, '2026-03-15 16:30:00', 'Materia prima textil para emprendedoras comunitarias', 8.00),
(10, 11, '2026-03-20 08:30:00', 'Plantines de especies nativas para siembra comunitaria', 150.00),
(2, 18, '2026-03-22 10:00:00', 'Jornada médica preventiva y desparasitación', 1.00),
(1, 20, '2026-03-25 11:45:00', 'Beca de transporte escolar para culminar año lectivo', 1.00);
GO

SELECT 'Recaudaciones.TiposDonacion' AS Tabla, COUNT(*) AS Filas FROM [Recaudaciones].[TiposDonacion]
UNION ALL
SELECT 'Recaudaciones.CanalesPago', COUNT(*) FROM [Recaudaciones].[CanalesPago]
UNION ALL
SELECT 'Recaudaciones.Donantes', COUNT(*) FROM [Recaudaciones].[Donantes]
UNION ALL
SELECT 'Recaudaciones.Donaciones', COUNT(*) FROM [Recaudaciones].[Donaciones]
UNION ALL
SELECT 'Operaciones.CategoriasProyecto', COUNT(*) FROM [Operaciones].[CategoriasProyecto]
UNION ALL
SELECT 'Operaciones.Proyectos', COUNT(*) FROM [Operaciones].[Proyectos]
UNION ALL
SELECT 'Operaciones.AsignacionFondos', COUNT(*) FROM [Operaciones].[AsignacionFondos]
UNION ALL
SELECT 'Operaciones.Comunidades', COUNT(*) FROM [Operaciones].[Comunidades]
UNION ALL
SELECT 'Operaciones.Beneficiarios', COUNT(*) FROM [Operaciones].[Beneficiarios]
UNION ALL
SELECT 'Operaciones.EntregasAyuda', COUNT(*) FROM [Operaciones].[EntregasAyuda];
GO

use SistemaDonaciones;
go
--select 1 ranking de donadores

GO
select 
    d.DonanteID, 
    d.NombreCompleto,
    sum (ds.Monto) as TotalDonado, 
    count (ds.DonacionID) as CantidadDonaciones,
    rank() over( order by sum (ds.Monto) desc ) as Posicion
from Recaudaciones.Donantes as d
inner join Recaudaciones.Donaciones as ds
    on d.DonanteID = ds.DonanteID
group by d.DonanteID, d.NombreCompleto
order by Posicion asc 
GO

-- Consulta 2: Asignaciones de fondos ordenadas por monto
select
    row_number() over (
        order by sum(a.MontoAsignado)  desc, p.ProyectoID
    ) as Posicion,
    p.NombreProyecto,
    sum(a.MontoAsignado) as TotalAsignado,
    count(a.AsignacionID) as CantidadAsignaciones
from Operaciones.AsignacionFondos as a
INNER JOIN Operaciones.Proyectos as p
    on a.ProyectoID = p.ProyectoID
group by
    p.NombreProyecto,
    p.ProyectoID
order by  Posicion asc;
GO

use SistemaDonaciones;
go

-- rol_finanzas
grant select, insert, update
on schema::Recaudaciones
to rol_finanzas;

-- rol_coordinador
grant select, insert, update
on schema::Operaciones
to rol_coordinador;

-- permiso DELETE únicamente sobre Proyectos
grant delete
on object::Operaciones.Proyectos
to rol_coordinador;

-- rol_seguridad
grant select
on schema::Recaudaciones
to rol_seguridad;

grant select
on schema::Operaciones
to rol_seguridad;

-- permiso de respaldo a nivel de base de datos
grant backup database
to rol_seguridad;
go

---- Auditoria del servidor ----
USE master;
GO

CREATE SERVER AUDIT AuditoriaONG
TO FILE (
    FILEPATH = '/var/opt/mssql/data/',
    MAXSIZE = 10 MB,
    MAX_ROLLOVER_FILES = UNLIMITED
)
WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
GO

ALTER SERVER AUDIT AuditoriaONG WITH (STATE = ON);
GO

USE SistemaDonaciones;
GO

CREATE DATABASE AUDIT SPECIFICATION AuditoriaONG_DB
FOR SERVER AUDIT AuditoriaONG 
ADD (INSERT, UPDATE, DELETE ON OBJECT :: Recaudaciones.Donaciones BY public),
ADD (INSERT, UPDATE, DELETE ON OBJECT :: Operaciones.Proyectos BY public)
WITH (STATE = ON);
GO

SELECT 
    event_time AS [Fecha y Hora],
    server_principal_name AS [Login del Servidor],
    database_principal_name AS [Usuario de BD],
    CASE action_id
        WHEN 'IN' THEN 'INSERCIÓN (INSERT)'
        WHEN 'UP' THEN 'ACTUALIZACIÓN (UPDATE)'
        WHEN 'DL' THEN 'ELIMINACIÓN (DELETE)'
        ELSE action_id
    END AS [Tipo de Movimiento],
    schema_name + '.' + object_name AS [Tabla Afectada],
    statement AS [Sentencia SQL Ejecutada]
FROM sys.fn_get_audit_file('/var/opt/mssql/data/AuditoriaONG_*.sqlaudit', DEFAULT, DEFAULT)
WHERE database_name = 'SistemaDonaciones'
  AND action_id IN ('IN', 'UP', 'DL')
ORDER BY event_time DESC;
GO

-- ================================================================
-- 1. RESPALDO COMPLETO (FULL)
-- ================================================================
USE master;
GO

ALTER DATABASE SistemaDonaciones SET RECOVERY FULL;
GO

SELECT name, recovery_model_desc 
FROM sys.databases 
WHERE name = N'SistemaDonaciones';
GO

-- Creamos la tabla de prueba antes del respaldo completo para validar la recuperación
USE SistemaDonaciones;
GO
IF OBJECT_ID('dbo.PruebaRespaldo', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.PruebaRespaldo (
        ID INT PRIMARY KEY,
        Descripcion NVARCHAR(100)
    );
END
INSERT INTO dbo.PruebaRespaldo VALUES (1, N'Antes del respaldo completo');
GO

USE master;
GO
BACKUP DATABASE SistemaDonaciones
TO DISK = N'/var/opt/mssql/data/SD_E1_full.bak'
WITH INIT, CHECKSUM, COMPRESSION, STATS = 10, NAME = N'SD_E1_full';
GO

RESTORE VERIFYONLY
FROM DISK = N'/var/opt/mssql/data/SD_E1_full.bak'
WITH CHECKSUM;
GO

-- ================================================================
-- 2. RESPALDO DIFERENCIAL Y DE LOG DE TRANSACCIONES
-- ================================================================
USE SistemaDonaciones;
GO
INSERT INTO dbo.PruebaRespaldo VALUES (2, N'Despues del completo - para Diferencial');
GO

USE master;
GO
BACKUP DATABASE SistemaDonaciones
TO DISK = N'/var/opt/mssql/data/SD_E2_diff.dif'
WITH DIFFERENTIAL, INIT, CHECKSUM, COMPRESSION, NAME = N'SD_E2_diff';
GO

-- Nuevo cambio después del diferencial para probar el respaldo de Log
USE SistemaDonaciones;
GO
INSERT INTO dbo.PruebaRespaldo VALUES (3, N'Despues del diferencial - para Log');
GO

USE master;
GO
BACKUP LOG SistemaDonaciones
TO DISK = N'/var/opt/mssql/data/SD_E2_log.trn'
WITH INIT, CHECKSUM, COMPRESSION, NAME = N'SD_E2_log';
GO

-- ================================================================
-- 3. PRUEBA DE RESTAURACIÓN EN BASE DE DATOS DE PRUEBA
-- ================================================================
RESTORE FILELISTONLY
FROM DISK = N'/var/opt/mssql/data/SD_E1_full.bak';
GO

DECLARE @datos NVARCHAR(260) = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(260));
DECLARE @log   NVARCHAR(260) = CAST(SERVERPROPERTY('InstanceDefaultLogPath')  AS NVARCHAR(260));
DECLARE @mdf   NVARCHAR(300) = @datos + N'SistemaDonaciones_Test.mdf';
DECLARE @ldf   NVARCHAR(300) = @log   + N'SistemaDonaciones_Test_log.ldf';

-- Paso A: Restaurar el Full (con NORECOVERY para seguir aplicando cadena)
RESTORE DATABASE SistemaDonaciones_Test
FROM DISK = N'/var/opt/mssql/data/SD_E1_full.bak'
WITH MOVE N'SistemaDonaciones'     TO @mdf,
     MOVE N'SistemaDonaciones_log' TO @ldf,
     NORECOVERY, REPLACE;

-- Paso B: Aplicar el Diferencial (con NORECOVERY)
RESTORE DATABASE SistemaDonaciones_Test
FROM DISK = N'/var/opt/mssql/data/SD_E2_diff.dif'
WITH NORECOVERY;

-- Paso C: Aplicar el Log y dejar la BD operativa (con RECOVERY)
RESTORE LOG SistemaDonaciones_Test
FROM DISK = N'/var/opt/mssql/data/SD_E2_log.trn'
WITH RECOVERY;
GO

-- Verificación: deben aparecer los 3 registros (Full, Diff y Log)
SELECT * FROM SistemaDonaciones_Test.dbo.PruebaRespaldo;
GO

-- ================================================================
-- 4. AUTOMATIZACIÓN CON SQL SERVER AGENT (JOBS)
-- ================================================================
USE msdb;
GO

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = N'SD_Operador')
    EXEC msdb.dbo.sp_add_operator
        @name = N'SD_Operador',
        @enabled = 1,
        @email_address = N'admin@ong.org';
GO

----------------------------------------------------------------
-- JOB 1 - COMPLETO: Domingos 02:00 AM + Limpieza > 14 días
----------------------------------------------------------------
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
    @command = N'DECLARE @f NVARCHAR(400) = N''/var/opt/mssql/data/SistemaDonaciones_FULL_'' + FORMAT(GETDATE(), ''yyyyMMdd_HHmmss'') + N''.bak'';
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
EXEC master.dbo.xp_delete_file 0, N''/var/opt/mssql/data'', N''bak'', @limite;
EXEC master.dbo.xp_delete_file 0, N''/var/opt/mssql/data'', N''dif'', @limite;
EXEC master.dbo.xp_delete_file 0, N''/var/opt/mssql/data'', N''trn'', @limite;',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'SD_Respaldo_Completo',
    @name = N'SD_Domingo_0200',
    @enabled = 1,
    @freq_type = 8,
    @freq_interval = 1,
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
-- JOB 2 - DIFERENCIAL: Lunes a Sábado 02:00 AM
----------------------------------------------------------------
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
    @command = N'DECLARE @f NVARCHAR(400) = N''/var/opt/mssql/data/SistemaDonaciones_DIFF_'' + FORMAT(GETDATE(), ''yyyyMMdd_HHmmss'') + N''.dif'';
BACKUP DATABASE SistemaDonaciones TO DISK = @f WITH DIFFERENTIAL, INIT, CHECKSUM, COMPRESSION, NAME = N''SD_DIFF_job'';
RESTORE VERIFYONLY FROM DISK = @f WITH CHECKSUM;',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'SD_Respaldo_Diferencial',
    @name = N'SD_LunesSabado_0200',
    @enabled = 1,
    @freq_type = 8,
    @freq_interval = 126,
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
-- JOB 3 - LOG DE TRANSACCIONES: Cada 30 minutos
----------------------------------------------------------------
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
    @command = N'DECLARE @f NVARCHAR(400) = N''/var/opt/mssql/data/SistemaDonaciones_LOG_'' + FORMAT(GETDATE(), ''yyyyMMdd_HHmmss'') + N''.trn'';
BACKUP LOG SistemaDonaciones TO DISK = @f WITH INIT, CHECKSUM, COMPRESSION, NAME = N''SD_LOG_job'';',
    @on_success_action = 1,
    @on_fail_action = 2;

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'SD_Respaldo_Log',
    @name = N'SD_Cada30min',
    @enabled = 1,
    @freq_type = 4,
    @freq_interval = 1,
    @freq_subday_type = 4,
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
