-- ============================================================
--  MSMultilider - Módulo de Gestión de Propiedades
--  Base de datos: multilider_propiedades (SQL Server)
--  Ejecutar en SQL Server Management Studio o Azure Data Studio
-- ============================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'multilider_propiedades')
    CREATE DATABASE multilider_propiedades;
GO

USE multilider_propiedades;
GO

-- ============================================================
-- TABLAS
-- ============================================================

CREATE TABLE ciudades (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    nombre       NVARCHAR(255) NOT NULL,
    departamento NVARCHAR(100) NULL,
    estado       BIT NOT NULL DEFAULT 1,
    created_at   DATETIME2 NULL,
    updated_at   DATETIME2 NULL
);

CREATE TABLE distritos (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    ciudad_id  INT NOT NULL REFERENCES ciudades(id) ON DELETE CASCADE,
    nombre     NVARCHAR(255) NOT NULL,
    estado     BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NULL,
    updated_at DATETIME2 NULL
);

CREATE TABLE sectores_urbanos (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    distrito_id INT NOT NULL REFERENCES distritos(id) ON DELETE CASCADE,
    nombre      NVARCHAR(255) NOT NULL,
    tipo        NVARCHAR(100) NULL,
    uv          NVARCHAR(50)  NULL,
    manzano     NVARCHAR(50)  NULL,
    estado      BIT NOT NULL DEFAULT 1,
    created_at  DATETIME2 NULL,
    updated_at  DATETIME2 NULL
);

CREATE TABLE propietarios (
    id               INT IDENTITY(1,1) PRIMARY KEY,
    tipo             NVARCHAR(50)  NOT NULL DEFAULT 'persona_natural',
    ci               NVARCHAR(50)  NULL,
    lugar_expedicion NVARCHAR(20)  NULL,
    nombre_completo  NVARCHAR(255) NOT NULL,
    nombre_empresa   NVARCHAR(255) NULL,
    nit              NVARCHAR(50)  NULL,
    telefono         NVARCHAR(50)  NULL,
    correo           NVARCHAR(255) NULL,
    direccion        NVARCHAR(255) NULL,
    estado           BIT NOT NULL DEFAULT 1,
    created_at       DATETIME2 NULL,
    updated_at       DATETIME2 NULL
);

CREATE TABLE ubicaciones (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    referencia NVARCHAR(500) NULL,
    url_maps   NVARCHAR(1000) NULL,
    longitud   FLOAT NULL,
    latitud    FLOAT NULL,
    created_at DATETIME2 NULL,
    updated_at DATETIME2 NULL
);

CREATE TABLE propiedades (
    id                      INT IDENTITY(1,1) PRIMARY KEY,
    sector_urbano_id        INT NOT NULL REFERENCES sectores_urbanos(id),
    ubicacion_id            INT NULL REFERENCES ubicaciones(id),
    codigo                  NVARCHAR(100) NULL,
    tipo                    NVARCHAR(100) NOT NULL,
    precio_venta            DECIMAL(18,2) NOT NULL,
    moneda                  NVARCHAR(10)  NOT NULL DEFAULT 'USD',
    superficie_m2           DECIMAL(10,2) NOT NULL,
    superficie_construida_m2 DECIMAL(10,2) NULL,
    frente_mts              DECIMAL(10,2) NULL,
    fondo_mts               DECIMAL(10,2) NULL,
    habitaciones            INT NULL,
    banos                   INT NULL,
    es_esquina              BIT NOT NULL DEFAULT 0,
    direccion               NVARCHAR(255) NULL,
    nro_lote                NVARCHAR(50)  NULL,
    colinda_norte           NVARCHAR(255) NULL,
    colinda_sur             NVARCHAR(255) NULL,
    colinda_este            NVARCHAR(255) NULL,
    colinda_oeste           NVARCHAR(255) NULL,
    estado                  NVARCHAR(50)  NOT NULL DEFAULT 'disponible',
    activo                  BIT NOT NULL DEFAULT 1,
    es_destacado            BIT NOT NULL DEFAULT 0,
    created_at              DATETIME2 NULL,
    updated_at              DATETIME2 NULL
);

CREATE TABLE caracteristicas (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    nombre     NVARCHAR(255) NOT NULL,
    tipo       NVARCHAR(100) NULL,
    estado     BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NULL,
    updated_at DATETIME2 NULL
);

CREATE TABLE imagenes_propiedades (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    propiedad_id INT NOT NULL REFERENCES propiedades(id) ON DELETE CASCADE,
    url          NVARCHAR(1000) NOT NULL,
    es_principal BIT NOT NULL DEFAULT 0,
    created_at   DATETIME2 NULL,
    updated_at   DATETIME2 NULL
);

-- Tablas pivote
CREATE TABLE propiedad_propietario (
    propiedades_id  INT NOT NULL REFERENCES propiedades(id)  ON DELETE CASCADE,
    propietarios_id INT NOT NULL REFERENCES propietarios(id) ON DELETE CASCADE,
    PRIMARY KEY (propiedades_id, propietarios_id)
);

CREATE TABLE caracteristica_propiedad (
    propiedades_id    INT NOT NULL REFERENCES propiedades(id)    ON DELETE CASCADE,
    caracteristicas_id INT NOT NULL REFERENCES caracteristicas(id) ON DELETE CASCADE,
    PRIMARY KEY (propiedades_id, caracteristicas_id)
);
GO

-- ============================================================
-- DATOS DE EJEMPLO
-- ============================================================

INSERT INTO ciudades (nombre, departamento, estado, created_at, updated_at) VALUES
('Santa Cruz de la Sierra', 'Santa Cruz', 1, GETUTCDATE(), GETUTCDATE()),
('La Paz', 'La Paz', 1, GETUTCDATE(), GETUTCDATE()),
('Cochabamba', 'Cochabamba', 1, GETUTCDATE(), GETUTCDATE());

INSERT INTO distritos (ciudad_id, nombre, estado, created_at, updated_at) VALUES
(1, 'Distrito 1 - Norte', 1, GETUTCDATE(), GETUTCDATE()),
(1, 'Distrito 2 - Sur', 1, GETUTCDATE(), GETUTCDATE()),
(1, 'Distrito 3 - Este', 1, GETUTCDATE(), GETUTCDATE()),
(2, 'Zona Norte', 1, GETUTCDATE(), GETUTCDATE()),
(3, 'Cercado', 1, GETUTCDATE(), GETUTCDATE());

INSERT INTO sectores_urbanos (distrito_id, nombre, tipo, uv, manzano, estado, created_at, updated_at) VALUES
(1, 'Urb. Los Jardines',  'urbanización', 'UV-12', 'MZ-A', 1, GETUTCDATE(), GETUTCDATE()),
(1, 'Barrio Las Palmas',  'barrio',       'UV-15', 'MZ-B', 1, GETUTCDATE(), GETUTCDATE()),
(2, 'Urb. El Prado',      'urbanización', 'UV-20', 'MZ-C', 1, GETUTCDATE(), GETUTCDATE()),
(3, 'Zona Industrial Sur','zona',         'UV-30', 'MZ-D', 1, GETUTCDATE(), GETUTCDATE());

INSERT INTO caracteristicas (nombre, tipo, estado, created_at, updated_at) VALUES
('Garaje',           'servicio',      1, GETUTCDATE(), GETUTCDATE()),
('Piscina',          'amenidad',      1, GETUTCDATE(), GETUTCDATE()),
('Jardín',           'amenidad',      1, GETUTCDATE(), GETUTCDATE()),
('Seguridad 24h',    'servicio',      1, GETUTCDATE(), GETUTCDATE()),
('Agua potable',     'servicio',      1, GETUTCDATE(), GETUTCDATE()),
('Alcantarillado',   'servicio',      1, GETUTCDATE(), GETUTCDATE()),
('Electricidad',     'servicio',      1, GETUTCDATE(), GETUTCDATE()),
('Gas domiciliario', 'servicio',      1, GETUTCDATE(), GETUTCDATE()),
('Amurallado',       'característica',1, GETUTCDATE(), GETUTCDATE()),
('Alambrado',        'característica',1, GETUTCDATE(), GETUTCDATE());

INSERT INTO propietarios (tipo, ci, lugar_expedicion, nombre_completo, telefono, correo, estado, created_at, updated_at) VALUES
('persona_natural', '12345678', 'SC', 'Juan Carlos Méndez Rojas',  '70012345', 'juan.mendez@email.com', 1, GETUTCDATE(), GETUTCDATE()),
('persona_natural', '87654321', 'LP', 'María Elena Vargas Flores', '71098765', 'maria.vargas@email.com',1, GETUTCDATE(), GETUTCDATE()),
('empresa', NULL, NULL, 'Inversiones del Este S.R.L.', '33445566', 'contacto@investe.com', 1, GETUTCDATE(), GETUTCDATE());

GO
