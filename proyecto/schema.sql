-- 0. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE SistemaDonaciones; -- Puedes cambiar el nombre por el que prefieras
GO

-- Seleccionar la base de datos recién creada para trabajar en ella
USE SistemaDonaciones;
GO

-- 1. CREACIÓN DE ESQUEMAS
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'donaciones')
    EXEC('CREATE SCHEMA donaciones');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'proyectos')
    EXEC('CREATE SCHEMA proyectos');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'beneficiarios')
    EXEC('CREATE SCHEMA beneficiarios');
GO

-- 2. ESQUEMA: donaciones
CREATE TABLE donaciones.TiposDonacion (
    TipoDonacionID INT IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(255) NULL,
    CONSTRAINT PK_TiposDonacion PRIMARY KEY (TipoDonacionID),
    CONSTRAINT UQ_TipoDonacion_Nombre UNIQUE (Nombre)
);

CREATE TABLE donaciones.CanalesPago (
    CanalPagoID INT IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_CanalesPago PRIMARY KEY (CanalPagoID),
    CONSTRAINT UQ_CanalPago_Nombre UNIQUE (Nombre)
);

CREATE TABLE donaciones.Donantes (
    DonanteID BIGINT IDENTITY(1,1),
    NombreCompleto NVARCHAR(150) NOT NULL,
    Email NVARCHAR(100) NULL,
    Telefono NVARCHAR(20) NULL,
    DocumentoIdentidad NVARCHAR(30) NOT NULL,
    FechaRegistro DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Donantes PRIMARY KEY (DonanteID),
    CONSTRAINT UQ_Donante_Documento UNIQUE (DocumentoIdentidad),
    CONSTRAINT CHK_Donante_Email CHECK (Email LIKE '%_@__%.%')
);

CREATE TABLE donaciones.Donaciones (
    DonacionID BIGINT IDENTITY(1,1),
    DonanteID BIGINT NOT NULL,
    TipoDonacionID INT NOT NULL,
    CanalPagoID INT NOT NULL,
    Monto DECIMAL(18,2) NOT NULL,
    FechaDonacion DATETIME2 DEFAULT SYSDATETIME(),
    Comentario NVARCHAR(MAX) NULL,
    CONSTRAINT PK_Donaciones PRIMARY KEY (DonacionID),
    CONSTRAINT FK_Donaciones_Donantes FOREIGN KEY (DonanteID) 
        REFERENCES donaciones.Donantes(DonanteID),
    CONSTRAINT FK_Donaciones_Tipos FOREIGN KEY (TipoDonacionID) 
        REFERENCES donaciones.TiposDonacion(TipoDonacionID),
    CONSTRAINT FK_Donaciones_Canales FOREIGN KEY (CanalPagoID) 
        REFERENCES donaciones.CanalesPago(CanalPagoID),
    CONSTRAINT CHK_Donacion_Monto CHECK (Monto > 0)
);

-- 3. ESQUEMA: proyectos
CREATE TABLE proyectos.CategoriasProyecto (
    CategoriaID INT IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_CategoriasProyecto PRIMARY KEY (CategoriaID),
    CONSTRAINT UQ_Categoria_Nombre UNIQUE (Nombre)
);

CREATE TABLE proyectos.Proyectos (
    ProyectoID INT IDENTITY(1,1),
    CategoriaID INT NOT NULL,
    NombreProyecto NVARCHAR(200) NOT NULL,
    PresupuestoMeta DECIMAL(18,2) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    Estado NVARCHAR(20) DEFAULT 'Activo',
    CONSTRAINT PK_Proyectos PRIMARY KEY (ProyectoID),
    CONSTRAINT FK_Proyectos_Categorias FOREIGN KEY (CategoriaID) 
        REFERENCES proyectos.CategoriasProyecto(CategoriaID),
    CONSTRAINT CHK_Proyecto_Presupuesto CHECK (PresupuestoMeta > 0),
    CONSTRAINT CHK_Proyecto_Estado CHECK (Estado IN ('Planificación', 'Activo', 'Finalizado', 'Suspendido')),
    CONSTRAINT CHK_Proyecto_Fechas CHECK (FechaFin IS NULL OR FechaFin >= FechaInicio)
);

CREATE TABLE proyectos.AsignacionFondos (
    AsignacionID BIGINT IDENTITY(1,1),
    DonacionID BIGINT NOT NULL,
    ProyectoID INT NOT NULL,
    MontoAsignado DECIMAL(18,2) NOT NULL,
    FechaAsignacion DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT PK_AsignacionFondos PRIMARY KEY (AsignacionID),
    CONSTRAINT FK_Asignacion_Donaciones FOREIGN KEY (DonacionID) 
        REFERENCES donaciones.Donaciones(DonacionID),
    CONSTRAINT FK_Asignacion_Proyectos FOREIGN KEY (ProyectoID) 
        REFERENCES proyectos.Proyectos(ProyectoID),
    CONSTRAINT CHK_Asignacion_Monto CHECK (MontoAsignado > 0)
);

-- 4. ESQUEMA: beneficiarios
CREATE TABLE beneficiarios.Comunidades (
    ComunidadID INT IDENTITY(1,1),
    NombreComunidad NVARCHAR(100) NOT NULL,
    UbicacionGeografica NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_Comunidades PRIMARY KEY (ComunidadID)
);

CREATE TABLE beneficiarios.Beneficiarios (
    BeneficiarioID BIGINT IDENTITY(1,1),
    ComunidadID INT NOT NULL,
    NombreCompleto NVARCHAR(150) NOT NULL,
    DocumentoIdentidad NVARCHAR(30) NULL,
    TipoBeneficiario NVARCHAR(50) DEFAULT 'Individual',
    FechaRegistro DATE DEFAULT CAST(SYSDATETIME() AS DATE),
    CONSTRAINT PK_Beneficiarios PRIMARY KEY (BeneficiarioID),
    CONSTRAINT FK_Beneficiarios_Comunidades FOREIGN KEY (ComunidadID) 
        REFERENCES beneficiarios.Comunidades(ComunidadID),
    CONSTRAINT CHK_Beneficiario_Tipo CHECK (TipoBeneficiario IN ('Individual', 'Familiar', 'Comunitario'))
);

CREATE TABLE beneficiarios.EntregasAyuda (
    EntregaID BIGINT IDENTITY(1,1),
    ProyectoID INT NOT NULL,
    BeneficiarioID BIGINT NOT NULL,
    FechaEntrega DATETIME2 DEFAULT SYSDATETIME(),
    DescripcionAyuda NVARCHAR(MAX) NOT NULL,
    CantidadEntregada DECIMAL(18,2) DEFAULT 1.00,
    CONSTRAINT PK_EntregasAyuda PRIMARY KEY (EntregaID),
    CONSTRAINT FK_Entregas_Proyectos FOREIGN KEY (ProyectoID) 
        REFERENCES proyectos.Proyectos(ProyectoID),
    CONSTRAINT FK_Entregas_Beneficiarios FOREIGN KEY (BeneficiarioID) 
        REFERENCES beneficiarios.Beneficiarios(BeneficiarioID),
    CONSTRAINT CHK_Entrega_Cantidad CHECK (CantidadEntregada > 0)
);
GO
