-- =============================================================
--  MULTILIDER - Script de Creación de Base de Datos
--  Motor: SQL Server 2016+
--  Generado: 2026-05-20
--  Fuente: Migraciones Laravel del proyecto
-- =============================================================

USE master;
GO

-- Crear base de datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'multilider')
BEGIN
    CREATE DATABASE multilider
        COLLATE Latin1_General_CI_AS;
END
GO

USE multilider;
GO

-- =============================================================
--  TABLAS DE SISTEMA / AUTENTICACIÓN
-- =============================================================

-- users
IF OBJECT_ID('users', 'U') IS NULL
CREATE TABLE users (
    id                  BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre              NVARCHAR(255)                  NOT NULL,
    password            NVARCHAR(255)                  NOT NULL,
    correo              NVARCHAR(255)                  NOT NULL,
    estado              BIT                            NOT NULL  DEFAULT 1,
    email_verified_at   DATETIME2                          NULL,
    remember_token      NVARCHAR(100)                      NULL,
    created_at          DATETIME2                          NULL,
    updated_at          DATETIME2                          NULL,
    CONSTRAINT PK_users PRIMARY KEY (id),
    CONSTRAINT UQ_users_correo UNIQUE (correo)
);
GO

-- password_reset_tokens
IF OBJECT_ID('password_reset_tokens', 'U') IS NULL
CREATE TABLE password_reset_tokens (
    email       NVARCHAR(255)   NOT NULL,
    token       NVARCHAR(255)   NOT NULL,
    created_at  DATETIME2           NULL,
    CONSTRAINT PK_password_reset_tokens PRIMARY KEY (email)
);
GO

-- failed_jobs
IF OBJECT_ID('failed_jobs', 'U') IS NULL
CREATE TABLE failed_jobs (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    uuid        NVARCHAR(255)                  NOT NULL,
    connection  NVARCHAR(MAX)                  NOT NULL,
    queue       NVARCHAR(MAX)                  NOT NULL,
    payload     NVARCHAR(MAX)                  NOT NULL,
    exception   NVARCHAR(MAX)                  NOT NULL,
    failed_at   DATETIME2                      NOT NULL  DEFAULT GETDATE(),
    CONSTRAINT PK_failed_jobs PRIMARY KEY (id),
    CONSTRAINT UQ_failed_jobs_uuid UNIQUE (uuid)
);
GO

-- personal_access_tokens (Sanctum)
IF OBJECT_ID('personal_access_tokens', 'U') IS NULL
CREATE TABLE personal_access_tokens (
    id              BIGINT          IDENTITY(1,1)  NOT NULL,
    tokenable_type  NVARCHAR(255)                  NOT NULL,
    tokenable_id    BIGINT                         NOT NULL,
    name            NVARCHAR(255)                  NOT NULL,
    token           NVARCHAR(64)                   NOT NULL,
    abilities       NVARCHAR(MAX)                      NULL,
    last_used_at    DATETIME2                          NULL,
    expires_at      DATETIME2                          NULL,
    created_at      DATETIME2                          NULL,
    updated_at      DATETIME2                          NULL,
    CONSTRAINT PK_personal_access_tokens PRIMARY KEY (id),
    CONSTRAINT UQ_personal_access_tokens_token UNIQUE (token)
);
GO

CREATE INDEX IX_personal_access_tokens_tokenable
    ON personal_access_tokens (tokenable_type, tokenable_id);
GO

-- jobs (Laravel Queue)
IF OBJECT_ID('jobs', 'U') IS NULL
CREATE TABLE jobs (
    id           BIGINT          IDENTITY(1,1)  NOT NULL,
    queue        NVARCHAR(255)                  NOT NULL,
    payload      NVARCHAR(MAX)                  NOT NULL,
    attempts     TINYINT                        NOT NULL,
    reserved_at  INT                                NULL,
    available_at INT                            NOT NULL,
    created_at   INT                            NOT NULL,
    CONSTRAINT PK_jobs PRIMARY KEY (id)
);
GO

CREATE INDEX IX_jobs_queue ON jobs (queue);
GO

-- job_batches (Laravel Queue Batches)
IF OBJECT_ID('job_batches', 'U') IS NULL
CREATE TABLE job_batches (
    id              NVARCHAR(255)   NOT NULL,
    name            NVARCHAR(255)   NOT NULL,
    total_jobs      INT             NOT NULL,
    pending_jobs    INT             NOT NULL,
    failed_jobs     INT             NOT NULL,
    failed_job_ids  NVARCHAR(MAX)   NOT NULL,
    options         NVARCHAR(MAX)       NULL,
    cancelled_at    INT                 NULL,
    created_at      INT             NOT NULL,
    finished_at     INT                 NULL,
    CONSTRAINT PK_job_batches PRIMARY KEY (id)
);
GO

-- =============================================================
--  ROLES Y PERMISOS
-- =============================================================

-- roles
IF OBJECT_ID('roles', 'U') IS NULL
CREATE TABLE roles (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre      NVARCHAR(100)                  NOT NULL,
    descripcion NVARCHAR(255)                      NULL,
    estado      BIT                            NOT NULL  DEFAULT 1,
    created_at  DATETIME2                          NULL,
    updated_at  DATETIME2                          NULL,
    CONSTRAINT PK_roles PRIMARY KEY (id)
);
GO

-- permisos
IF OBJECT_ID('permisos', 'U') IS NULL
CREATE TABLE permisos (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre      NVARCHAR(100)                  NOT NULL,
    descripcion NVARCHAR(255)                      NULL,
    estado      BIT                            NOT NULL  DEFAULT 1,
    created_at  DATETIME2                          NULL,
    updated_at  DATETIME2                          NULL,
    CONSTRAINT PK_permisos PRIMARY KEY (id)
);
GO

-- rol_permiso
IF OBJECT_ID('rol_permiso', 'U') IS NULL
CREATE TABLE rol_permiso (
    id          BIGINT  IDENTITY(1,1)  NOT NULL,
    rol_id      BIGINT                 NOT NULL,
    permiso_id  BIGINT                 NOT NULL,
    created_at  DATETIME2                  NULL,
    updated_at  DATETIME2                  NULL,
    CONSTRAINT PK_rol_permiso PRIMARY KEY (id),
    CONSTRAINT UQ_rol_permiso UNIQUE (rol_id, permiso_id),
    CONSTRAINT FK_rol_permiso_rol
        FOREIGN KEY (rol_id) REFERENCES roles (id) ON DELETE CASCADE,
    CONSTRAINT FK_rol_permiso_permiso
        FOREIGN KEY (permiso_id) REFERENCES permisos (id) ON DELETE CASCADE
);
GO

-- rol_permiso_usuario
IF OBJECT_ID('rol_permiso_usuario', 'U') IS NULL
CREATE TABLE rol_permiso_usuario (
    id              BIGINT  IDENTITY(1,1)  NOT NULL,
    user_id         BIGINT                 NOT NULL,
    rol_permiso_id  BIGINT                 NOT NULL,
    created_at      DATETIME2                  NULL,
    updated_at      DATETIME2                  NULL,
    CONSTRAINT PK_rol_permiso_usuario PRIMARY KEY (id),
    CONSTRAINT UQ_rol_permiso_usuario UNIQUE (user_id, rol_permiso_id),
    CONSTRAINT FK_rpu_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT FK_rpu_rol_permiso
        FOREIGN KEY (rol_permiso_id) REFERENCES rol_permiso (id) ON DELETE CASCADE
);
GO

-- =============================================================
--  EMPRESA
-- =============================================================

-- mi_empresa
IF OBJECT_ID('mi_empresa', 'U') IS NULL
CREATE TABLE mi_empresa (
    id                      BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre                  NVARCHAR(255)                  NOT NULL,
    -- Logos
    logo                    NVARCHAR(255)                      NULL,
    logo_login              NVARCHAR(255)                      NULL,
    logo_sidebar_compact    NVARCHAR(255)                      NULL,
    logo_sidebar            NVARCHAR(255)                      NULL,
    -- Hero Slider
    imagen_hero             NVARCHAR(255)                      NULL,
    hero_image_1            NVARCHAR(255)                      NULL,
    hero_title_1            NVARCHAR(255)                      NULL,
    hero_subtitle_1         NVARCHAR(255)                      NULL,
    hero_image_2            NVARCHAR(255)                      NULL,
    hero_title_2            NVARCHAR(255)                      NULL,
    hero_subtitle_2         NVARCHAR(255)                      NULL,
    hero_image_3            NVARCHAR(255)                      NULL,
    hero_title_3            NVARCHAR(255)                      NULL,
    hero_subtitle_3         NVARCHAR(255)                      NULL,
    -- Contenido
    eslogan                 NVARCHAR(255)                      NULL,
    descripcion_nosotros    NVARCHAR(MAX)                      NULL,
    imagen_nosotros_1       NVARCHAR(255)                      NULL,
    imagen_nosotros_2       NVARCHAR(255)                      NULL,
    mision                  NVARCHAR(MAX)                      NULL,
    vision                  NVARCHAR(MAX)                      NULL,
    valores                 NVARCHAR(MAX)                      NULL,
    -- Contacto
    direccion               NVARCHAR(255)                      NULL,
    telefono                NVARCHAR(255)                      NULL,
    whatsapp                NVARCHAR(255)                      NULL,
    email                   NVARCHAR(255)                      NULL,
    -- Redes Sociales
    facebook                NVARCHAR(255)                      NULL,
    instagram               NVARCHAR(255)                      NULL,
    tiktok                  NVARCHAR(255)                      NULL,
    youtube                 NVARCHAR(255)                      NULL,
    -- Configuración Landing
    mapa_iframe             NVARCHAR(MAX)                      NULL,
    color_primario          NVARCHAR(255)                  NOT NULL  DEFAULT '#000000',
    color_secundario        NVARCHAR(255)                  NOT NULL  DEFAULT '#ffffff',
    created_at              DATETIME2                          NULL,
    updated_at              DATETIME2                          NULL,
    CONSTRAINT PK_mi_empresa PRIMARY KEY (id)
);
GO

-- =============================================================
--  MÉTODOS DE PAGO
-- =============================================================

-- metodos_pago
IF OBJECT_ID('metodos_pago', 'U') IS NULL
CREATE TABLE metodos_pago (
    id              BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre_metodo   NVARCHAR(100)                  NOT NULL,
    estado          NVARCHAR(10)                   NOT NULL  DEFAULT 'Activo',
    created_at      DATETIME2                          NULL,
    updated_at      DATETIME2                          NULL,
    CONSTRAINT PK_metodos_pago PRIMARY KEY (id),
    CONSTRAINT CK_metodos_pago_estado CHECK (estado IN ('Activo', 'Inactivo'))
);
GO

CREATE INDEX IX_metodos_pago_estado ON metodos_pago (estado);
GO

-- =============================================================
--  GEOGRAFÍA: CIUDADES, DISTRITOS, SECTORES URBANOS
-- =============================================================

-- ciudades
IF OBJECT_ID('ciudades', 'U') IS NULL
CREATE TABLE ciudades (
    id              BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre          NVARCHAR(255)                  NOT NULL,
    departamento    NVARCHAR(255)                  NOT NULL,
    estado          BIT                            NOT NULL  DEFAULT 1,
    created_at      DATETIME2                          NULL,
    updated_at      DATETIME2                          NULL,
    CONSTRAINT PK_ciudades PRIMARY KEY (id)
);
GO

-- distritos (renombrado desde zonas)
IF OBJECT_ID('distritos', 'U') IS NULL
CREATE TABLE distritos (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    ciudad_id   BIGINT                         NOT NULL,
    nombre      NVARCHAR(255)                  NOT NULL,
    estado      BIT                            NOT NULL  DEFAULT 1,
    created_at  DATETIME2                          NULL,
    updated_at  DATETIME2                          NULL,
    CONSTRAINT PK_distritos PRIMARY KEY (id),
    CONSTRAINT FK_distritos_ciudad
        FOREIGN KEY (ciudad_id) REFERENCES ciudades (id) ON DELETE CASCADE
);
GO

-- sectores_urbanos
IF OBJECT_ID('sectores_urbanos', 'U') IS NULL
CREATE TABLE sectores_urbanos (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    distrito_id BIGINT                         NOT NULL,
    nombre      NVARCHAR(150)                  NOT NULL,
    tipo        NVARCHAR(20)                   NOT NULL  DEFAULT 'Barrio',
    uv          NVARCHAR(20)                       NULL,
    manzano     NVARCHAR(20)                       NULL,
    estado      BIT                            NOT NULL  DEFAULT 1,
    created_at  DATETIME2                          NULL,
    updated_at  DATETIME2                          NULL,
    CONSTRAINT PK_sectores_urbanos PRIMARY KEY (id),
    CONSTRAINT FK_sectores_urbanos_distrito
        FOREIGN KEY (distrito_id) REFERENCES distritos (id) ON DELETE CASCADE,
    CONSTRAINT CK_sectores_urbanos_tipo
        CHECK (tipo IN ('Barrio', N'Urbanización', 'Condominio'))
);
GO

-- =============================================================
--  PROPIETARIOS Y PROPIEDADES
-- =============================================================

-- ubicaciones
IF OBJECT_ID('ubicaciones', 'U') IS NULL
CREATE TABLE ubicaciones (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    referencia  NVARCHAR(255)                      NULL,
    url_maps    NVARCHAR(MAX)                      NULL,
    longitud    NVARCHAR(100)                      NULL,
    latitud     NVARCHAR(100)                      NULL,
    created_at  DATETIME2                          NULL,
    updated_at  DATETIME2                          NULL,
    CONSTRAINT PK_ubicaciones PRIMARY KEY (id)
);
GO

-- propietarios
IF OBJECT_ID('propietarios', 'U') IS NULL
CREATE TABLE propietarios (
    id               BIGINT          IDENTITY(1,1)  NOT NULL,
    tipo             NVARCHAR(20)                   NOT NULL  DEFAULT 'persona_natural',
    nombre_empresa   NVARCHAR(255)                      NULL,
    nit              NVARCHAR(50)                       NULL,
    ci               NVARCHAR(50)                       NULL,
    lugar_expedicion NVARCHAR(20)                       NULL,
    nombre_completo  NVARCHAR(255)                  NOT NULL,
    telefono         NVARCHAR(50)                       NULL,
    correo           NVARCHAR(255)                      NULL,
    direccion        NVARCHAR(255)                      NULL,
    estado           BIT                            NOT NULL  DEFAULT 1,
    created_at       DATETIME2                          NULL,
    updated_at       DATETIME2                          NULL,
    CONSTRAINT PK_propietarios PRIMARY KEY (id),
    CONSTRAINT UQ_propietarios_ci UNIQUE (ci),
    CONSTRAINT CK_propietarios_tipo CHECK (tipo IN ('persona_natural', 'empresa'))
);
GO

-- caracteristicas
IF OBJECT_ID('caracteristicas', 'U') IS NULL
CREATE TABLE caracteristicas (
    id          BIGINT          IDENTITY(1,1)  NOT NULL,
    nombre      NVARCHAR(255)                  NOT NULL,
    tipo        NVARCHAR(255)                      NULL,
    estado      BIT                            NOT NULL  DEFAULT 1,
    created_at  DATETIME2                          NULL,
    updated_at  DATETIME2                          NULL,
    CONSTRAINT PK_caracteristicas PRIMARY KEY (id),
    CONSTRAINT UQ_caracteristicas_nombre UNIQUE (nombre)
);
GO

-- cuentas_bancarias
IF OBJECT_ID('cuentas_bancarias', 'U') IS NULL
CREATE TABLE cuentas_bancarias (
    id                    BIGINT          IDENTITY(1,1)  NOT NULL,
    mi_empresa_id         BIGINT                         NOT NULL,
    nombre                NVARCHAR(255)                  NOT NULL,
    tipo                  NVARCHAR(10)                   NOT NULL  DEFAULT 'BANCARIA',
    descripcion           NVARCHAR(MAX)                      NULL,
    banco                 NVARCHAR(100)                      NULL,
    numero_cuenta         NVARCHAR(50)                       NULL,
    titular               NVARCHAR(255)                      NULL,
    iban                  NVARCHAR(50)                       NULL,
    proveedor             NVARCHAR(100)                      NULL,
    codigo_integracion    NVARCHAR(255)                      NULL,
    saldo_inicial         DECIMAL(12,2)                  NOT NULL  DEFAULT 0,
    estado                NVARCHAR(10)                   NOT NULL  DEFAULT 'Activa',
    created_at            DATETIME2                          NULL,
    updated_at            DATETIME2                          NULL,
    CONSTRAINT PK_cuentas_bancarias PRIMARY KEY (id),
    CONSTRAINT FK_cuentas_bancarias_empresa
        FOREIGN KEY (mi_empresa_id) REFERENCES mi_empresa (id) ON DELETE CASCADE,
    CONSTRAINT CK_cuentas_bancarias_tipo
        CHECK (tipo IN ('EFECTIVO', 'BANCARIA', 'DIGITAL', 'OTRA')),
    CONSTRAINT CK_cuentas_bancarias_estado
        CHECK (estado IN ('Activa', 'Inactiva'))
);
GO

CREATE INDEX IX_cuentas_bancarias_empresa ON cuentas_bancarias (mi_empresa_id);
CREATE INDEX IX_cuentas_bancarias_tipo    ON cuentas_bancarias (tipo);
CREATE INDEX IX_cuentas_bancarias_estado  ON cuentas_bancarias (estado);
GO

-- propiedades (estado final: sector_urbano_id, sin zona_id, sin propietario_id)
IF OBJECT_ID('propiedades', 'U') IS NULL
CREATE TABLE propiedades (
    id                          BIGINT          IDENTITY(1,1)  NOT NULL,
    sector_urbano_id            BIGINT                         NOT NULL,
    ubicacion_id                BIGINT                             NULL,
    codigo                      NVARCHAR(100)                      NULL,
    tipo                        NVARCHAR(255)                  NOT NULL,
    precio_venta                DECIMAL(12,2)                  NOT NULL,
    moneda                      NVARCHAR(5)                    NOT NULL  DEFAULT 'USD',
    superficie_m2               DECIMAL(10,2)                  NOT NULL,
    superficie_construida_m2    DECIMAL(10,2)                      NULL,
    frente_mts                  DECIMAL(8,2)                       NULL,
    fondo_mts                   DECIMAL(8,2)                       NULL,
    habitaciones                INT                                NULL,
    banos                       INT                                NULL,
    es_esquina                  BIT                            NOT NULL  DEFAULT 0,
    direccion                   NVARCHAR(255)                      NULL,
    nro_lote                    NVARCHAR(255)                      NULL,
    colinda_norte               NVARCHAR(255)                      NULL,
    colinda_sur                 NVARCHAR(255)                      NULL,
    colinda_este                NVARCHAR(255)                      NULL,
    colinda_oeste               NVARCHAR(255)                      NULL,
    estado                      NVARCHAR(255)                  NOT NULL  DEFAULT 'Disponible',
    activo                      BIT                            NOT NULL  DEFAULT 1,
    es_destacado                BIT                            NOT NULL  DEFAULT 0,
    created_at                  DATETIME2                          NULL,
    updated_at                  DATETIME2                          NULL,
    CONSTRAINT PK_propiedades PRIMARY KEY (id),
    CONSTRAINT UQ_propiedades_codigo UNIQUE (codigo),
    CONSTRAINT FK_propiedades_sector
        FOREIGN KEY (sector_urbano_id) REFERENCES sectores_urbanos (id),
    CONSTRAINT FK_propiedades_ubicacion
        FOREIGN KEY (ubicacion_id) REFERENCES ubicaciones (id) ON DELETE SET NULL,
    CONSTRAINT CK_propiedades_moneda
        CHECK (moneda IN ('USD', 'BOB'))
);
GO

-- propiedad_propietario (tabla pivot M:M)
IF OBJECT_ID('propiedad_propietario', 'U') IS NULL
CREATE TABLE propiedad_propietario (
    propiedad_id    BIGINT  NOT NULL,
    propietario_id  BIGINT  NOT NULL,
    CONSTRAINT PK_propiedad_propietario PRIMARY KEY (propiedad_id, propietario_id),
    CONSTRAINT FK_pp_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedades (id) ON DELETE CASCADE,
    CONSTRAINT FK_pp_propietario
        FOREIGN KEY (propietario_id) REFERENCES propietarios (id) ON DELETE CASCADE
);
GO

-- caracteristica_propiedad (tabla pivot M:M)
IF OBJECT_ID('caracteristica_propiedad', 'U') IS NULL
CREATE TABLE caracteristica_propiedad (
    id                  BIGINT  IDENTITY(1,1)  NOT NULL,
    propiedad_id        BIGINT                 NOT NULL,
    caracteristica_id   BIGINT                 NOT NULL,
    created_at          DATETIME2                  NULL,
    updated_at          DATETIME2                  NULL,
    CONSTRAINT PK_caracteristica_propiedad PRIMARY KEY (id),
    CONSTRAINT FK_cp_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedades (id) ON DELETE CASCADE,
    CONSTRAINT FK_cp_caracteristica
        FOREIGN KEY (caracteristica_id) REFERENCES caracteristicas (id) ON DELETE CASCADE
);
GO

-- imagenes_propiedades
IF OBJECT_ID('imagenes_propiedades', 'U') IS NULL
CREATE TABLE imagenes_propiedades (
    id              BIGINT          IDENTITY(1,1)  NOT NULL,
    propiedad_id    BIGINT                         NOT NULL,
    url             NVARCHAR(255)                  NOT NULL,
    es_principal    BIT                            NOT NULL  DEFAULT 0,
    created_at      DATETIME2                          NULL,
    updated_at      DATETIME2                          NULL,
    CONSTRAINT PK_imagenes_propiedades PRIMARY KEY (id),
    CONSTRAINT FK_imagenes_propiedades_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedades (id) ON DELETE CASCADE
);
GO

-- =============================================================
--  ASESORES Y CLIENTES
-- =============================================================

-- asesores
IF OBJECT_ID('asesores', 'U') IS NULL
CREATE TABLE asesores (
    id                    BIGINT          IDENTITY(1,1)  NOT NULL,
    user_id               BIGINT                         NOT NULL,
    nombre_completo       NVARCHAR(255)                  NOT NULL,
    telefono              NVARCHAR(255)                      NULL,
    correo                NVARCHAR(255)                      NULL,
    direccion             NVARCHAR(255)                      NULL,
    foto                  NVARCHAR(255)                      NULL,
    estado                BIT                            NOT NULL  DEFAULT 1,
    porcentaje_comision   DECIMAL(5,2)                   NOT NULL  DEFAULT 3.00,
    created_at            DATETIME2                          NULL,
    updated_at            DATETIME2                          NULL,
    CONSTRAINT PK_asesores PRIMARY KEY (id),
    CONSTRAINT UQ_asesores_user_id UNIQUE (user_id),
    CONSTRAINT FK_asesores_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);
GO

-- clientes
IF OBJECT_ID('clientes', 'U') IS NULL
CREATE TABLE clientes (
    id                  BIGINT          IDENTITY(1,1)  NOT NULL,
    user_id             BIGINT                         NOT NULL,
    ci                  NVARCHAR(255)                  NOT NULL,
    lugar_expedicion    NVARCHAR(10)                       NULL,
    nombre_completo     NVARCHAR(255)                  NOT NULL,
    telefono            NVARCHAR(255)                      NULL,
    correo              NVARCHAR(255)                      NULL,
    direccion           NVARCHAR(255)                      NULL,
    estado              BIT                            NOT NULL  DEFAULT 1,
    created_at          DATETIME2                          NULL,
    updated_at          DATETIME2                          NULL,
    CONSTRAINT PK_clientes PRIMARY KEY (id),
    CONSTRAINT UQ_clientes_user_id UNIQUE (user_id),
    CONSTRAINT UQ_clientes_ci UNIQUE (ci),
    CONSTRAINT FK_clientes_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);
GO

-- =============================================================
--  VENTAS: NOTAS DE VENTA, PLANES, CUOTAS, CONTRATOS
-- =============================================================

-- notas_ventas
IF OBJECT_ID('notas_ventas', 'U') IS NULL
CREATE TABLE notas_ventas (
    id              BIGINT          IDENTITY(1,1)  NOT NULL,
    asesor_id       BIGINT                         NOT NULL,
    cliente_id      BIGINT                         NOT NULL,
    propiedad_id    BIGINT                         NOT NULL,
    fecha           DATE                           NOT NULL,
    monto_total     DECIMAL(12,2)                  NOT NULL,
    monto_comision  DECIMAL(12,2)                      NULL,
    tipo_venta      NVARCHAR(10)                   NOT NULL,
    descuento       DECIMAL(12,2)                      NULL,
    monto_liquido   DECIMAL(12,2)                      NULL,
    cuota_inicial   DECIMAL(12,2)                      NULL,
    saldo_credito   DECIMAL(12,2)                      NULL,
    estado          NVARCHAR(50)                   NOT NULL  DEFAULT 'Completada',
    created_at      DATETIME2                          NULL,
    updated_at      DATETIME2                          NULL,
    CONSTRAINT PK_notas_ventas PRIMARY KEY (id),
    CONSTRAINT FK_nv_asesor
        FOREIGN KEY (asesor_id) REFERENCES asesores (id),
    CONSTRAINT FK_nv_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes (id),
    CONSTRAINT FK_nv_propiedad
        FOREIGN KEY (propiedad_id) REFERENCES propiedades (id),
    CONSTRAINT CK_notas_ventas_tipo_venta
        CHECK (tipo_venta IN ('CONTADO', 'CREDITO'))
);
GO

-- planes_pagos
IF OBJECT_ID('planes_pagos', 'U') IS NULL
CREATE TABLE planes_pagos (
    id              BIGINT          IDENTITY(1,1)  NOT NULL,
    nota_venta_id   BIGINT                         NOT NULL,
    monto           DECIMAL(12,2)                  NOT NULL,
    numero_cuotas   INT                            NOT NULL,
    fecha_inicio    DATE                           NOT NULL,
    fecha_final     DATE                           NOT NULL,
    plazo           NVARCHAR(50)                   NOT NULL,
    tasa_interes    DECIMAL(5,2)                   NOT NULL  DEFAULT 0,
    tasa_mora       DECIMAL(5,2)                   NOT NULL  DEFAULT 0,
    created_at      DATETIME2                          NULL,
    updated_at      DATETIME2                          NULL,
    CONSTRAINT PK_planes_pagos PRIMARY KEY (id),
    CONSTRAINT UQ_planes_pagos_nota_venta UNIQUE (nota_venta_id),
    CONSTRAINT FK_planes_pagos_nota_venta
        FOREIGN KEY (nota_venta_id) REFERENCES notas_ventas (id) ON DELETE CASCADE
);
GO

-- reprogramaciones
IF OBJECT_ID('reprogramaciones', 'U') IS NULL
CREATE TABLE reprogramaciones (
    id                      BIGINT          IDENTITY(1,1)  NOT NULL,
    plan_pago_id            BIGINT                         NOT NULL,
    usuario_id              BIGINT                             NULL,
    motivo                  NVARCHAR(255)                  NOT NULL,
    fecha_reprogramacion    DATE                           NOT NULL,
    cuota_desde             INT                            NOT NULL,
    saldo_capital_momento   DECIMAL(12,2)                  NOT NULL,
    nueva_tasa_interes      DECIMAL(5,2)                   NOT NULL,
    nuevo_numero_cuotas     INT                            NOT NULL,
    nueva_fecha_inicio      DATE                           NOT NULL,
    observaciones           NVARCHAR(MAX)                      NULL,
    created_at              DATETIME2                          NULL,
    updated_at              DATETIME2                          NULL,
    CONSTRAINT PK_reprogramaciones PRIMARY KEY (id),
    CONSTRAINT FK_reprogramaciones_plan_pago
        FOREIGN KEY (plan_pago_id) REFERENCES planes_pagos (id) ON DELETE CASCADE,
    CONSTRAINT FK_reprogramaciones_usuario
        FOREIGN KEY (usuario_id) REFERENCES users (id) ON DELETE SET NULL
);
GO

-- cuotas
IF OBJECT_ID('cuotas', 'U') IS NULL
CREATE TABLE cuotas (
    id                  BIGINT          IDENTITY(1,1)  NOT NULL,
    plan_pago_id        BIGINT                         NOT NULL,
    numero_cuota        INT                            NOT NULL,
    fecha_vencimiento   DATE                           NOT NULL,
    monto_cuota         DECIMAL(12,2)                  NOT NULL,
    monto_interes       DECIMAL(12,2)                  NOT NULL  DEFAULT 0,
    monto_capital       DECIMAL(12,2)                  NOT NULL,
    saldo_capital       DECIMAL(12,2)                  NOT NULL  DEFAULT 0,
    estado              NVARCHAR(50)                   NOT NULL  DEFAULT 'Pendiente',
    reprogramacion_id   BIGINT                             NULL,
    created_at          DATETIME2                          NULL,
    updated_at          DATETIME2                          NULL,
    CONSTRAINT PK_cuotas PRIMARY KEY (id),
    CONSTRAINT FK_cuotas_plan_pago
        FOREIGN KEY (plan_pago_id) REFERENCES planes_pagos (id) ON DELETE CASCADE,
    CONSTRAINT FK_cuotas_reprogramacion
        FOREIGN KEY (reprogramacion_id) REFERENCES reprogramaciones (id) ON DELETE SET NULL
);
GO

-- contratos
IF OBJECT_ID('contratos', 'U') IS NULL
CREATE TABLE contratos (
    id                  BIGINT          IDENTITY(1,1)  NOT NULL,
    nota_venta_id       BIGINT                         NOT NULL,
    codigo_contrato     NVARCHAR(50)                   NOT NULL,
    fecha_emision       DATE                           NOT NULL,
    fecha_firma         DATE                               NULL,
    tipo_venta          NVARCHAR(100)                  NOT NULL,
    url_doc             NVARCHAR(MAX)                      NULL,
    estado              NVARCHAR(50)                   NOT NULL  DEFAULT 'Pendiente',
    created_at          DATETIME2                          NULL,
    updated_at          DATETIME2                          NULL,
    CONSTRAINT PK_contratos PRIMARY KEY (id),
    CONSTRAINT UQ_contratos_codigo UNIQUE (codigo_contrato),
    CONSTRAINT FK_contratos_nota_venta
        FOREIGN KEY (nota_venta_id) REFERENCES notas_ventas (id) ON DELETE NO ACTION
);
GO

-- =============================================================
--  PAGOS
-- =============================================================

-- pagos (estado final con todos los campos acumulados de migraciones)
IF OBJECT_ID('pagos', 'U') IS NULL
CREATE TABLE pagos (
    id                              BIGINT          IDENTITY(1,1)  NOT NULL,
    nota_venta_id                   BIGINT                         NOT NULL,
    cuota_id                        BIGINT                             NULL,
    concepto_pago                   NVARCHAR(20)                   NOT NULL,
    monto                           DECIMAL(12,2)                  NOT NULL,
    estado                          NVARCHAR(20)                   NOT NULL  DEFAULT 'PENDIENTE_PAGO',
    fecha_pago                      DATE                               NULL,
    observaciones                   NVARCHAR(MAX)                      NULL,
    metodo_pago_id                  BIGINT                             NULL,
    cuenta_id                       BIGINT                             NULL,
    ci_pagador                      NVARCHAR(255)                      NULL,
    telefono_pagador                NVARCHAR(255)                      NULL,
    nombres_pagador                 NVARCHAR(255)                      NULL,
    apellidos_pagador               NVARCHAR(255)                      NULL,
    correo_pagador                  NVARCHAR(255)                      NULL,
    id_transaccion_libelula         NVARCHAR(255)                      NULL,
    libelula_uuid                   NVARCHAR(36)                       NULL,
    codigo_recaudacion_libelula     NVARCHAR(255)                      NULL,
    created_at                      DATETIME2                          NULL,
    updated_at                      DATETIME2                          NULL,
    CONSTRAINT PK_pagos PRIMARY KEY (id),
    CONSTRAINT FK_pagos_nota_venta
        FOREIGN KEY (nota_venta_id) REFERENCES notas_ventas (id) ON DELETE CASCADE,
    CONSTRAINT FK_pagos_cuota
        FOREIGN KEY (cuota_id) REFERENCES cuotas (id) ON DELETE NO ACTION,
    CONSTRAINT FK_pagos_metodo_pago
        FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago (id) ON DELETE SET NULL,
    CONSTRAINT FK_pagos_cuenta
        FOREIGN KEY (cuenta_id) REFERENCES cuentas_bancarias (id) ON DELETE SET NULL,
    CONSTRAINT CK_pagos_concepto
        CHECK (concepto_pago IN ('CUOTA_INICIAL','CUOTA','VENTA_CONTADO','OTRO','AMORTIZACION','MORA')),
    CONSTRAINT CK_pagos_estado
        CHECK (estado IN ('PENDIENTE_PAGO','PAGADO','CANCELADO','RECHAZADO'))
);
GO

CREATE INDEX IX_pagos_nota_venta             ON pagos (nota_venta_id);
CREATE INDEX IX_pagos_cuota                  ON pagos (cuota_id);
CREATE INDEX IX_pagos_fecha_pago             ON pagos (fecha_pago);
CREATE INDEX IX_pagos_estado                 ON pagos (estado);
CREATE INDEX IX_pagos_cuenta                 ON pagos (cuenta_id);
CREATE INDEX IX_pagos_id_transaccion         ON pagos (id_transaccion_libelula);
CREATE INDEX IX_pagos_libelula_uuid          ON pagos (libelula_uuid);
GO

-- metodo_pago_cuenta_default
IF OBJECT_ID('metodo_pago_cuenta_default', 'U') IS NULL
CREATE TABLE metodo_pago_cuenta_default (
    id                  BIGINT  IDENTITY(1,1)  NOT NULL,
    mi_empresa_id       BIGINT                 NOT NULL,
    metodo_pago_id      BIGINT                 NOT NULL,
    cuenta_bancaria_id  BIGINT                 NOT NULL,
    created_at          DATETIME2                  NULL,
    updated_at          DATETIME2                  NULL,
    CONSTRAINT PK_metodo_pago_cuenta_default PRIMARY KEY (id),
    CONSTRAINT UQ_mpcd_empresa_metodo UNIQUE (mi_empresa_id, metodo_pago_id),
    CONSTRAINT FK_mpcd_empresa
        FOREIGN KEY (mi_empresa_id) REFERENCES mi_empresa (id) ON DELETE CASCADE,
    CONSTRAINT FK_mpcd_metodo_pago
        FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago (id) ON DELETE CASCADE,
    CONSTRAINT FK_mpcd_cuenta
        FOREIGN KEY (cuenta_bancaria_id) REFERENCES cuentas_bancarias (id) ON DELETE NO ACTION
);
GO

CREATE INDEX IX_mpcd_empresa     ON metodo_pago_cuenta_default (mi_empresa_id);
CREATE INDEX IX_mpcd_metodo_pago ON metodo_pago_cuenta_default (metodo_pago_id);
GO

-- =============================================================
--  CONTABILIDAD: INGRESOS Y EGRESOS
-- =============================================================

-- ingresos
IF OBJECT_ID('ingresos', 'U') IS NULL
CREATE TABLE ingresos (
    id                  BIGINT          IDENTITY(1,1)  NOT NULL,
    fecha               DATE                           NOT NULL,
    concepto            NVARCHAR(255)                  NOT NULL,
    categoria           NVARCHAR(20)                   NOT NULL,
    monto               DECIMAL(12,2)                  NOT NULL,
    moneda              NVARCHAR(5)                    NOT NULL  DEFAULT 'Bs',
    origen              NVARCHAR(15)                   NOT NULL  DEFAULT 'MANUAL',
    pago_id             BIGINT                             NULL,
    nota_venta_id       BIGINT                             NULL,
    cuenta_bancaria_id  BIGINT                             NULL,
    user_id             BIGINT                             NULL,
    comprobante         NVARCHAR(500)                      NULL,
    observaciones       NVARCHAR(MAX)                      NULL,
    estado              NVARCHAR(15)                   NOT NULL  DEFAULT 'CONFIRMADO',
    created_at          DATETIME2                          NULL,
    updated_at          DATETIME2                          NULL,
    CONSTRAINT PK_ingresos PRIMARY KEY (id),
    CONSTRAINT FK_ingresos_pago
        FOREIGN KEY (pago_id) REFERENCES pagos (id) ON DELETE SET NULL,
    CONSTRAINT FK_ingresos_nota_venta
        FOREIGN KEY (nota_venta_id) REFERENCES notas_ventas (id) ON DELETE SET NULL,
    CONSTRAINT FK_ingresos_cuenta
        FOREIGN KEY (cuenta_bancaria_id) REFERENCES cuentas_bancarias (id) ON DELETE SET NULL,
    CONSTRAINT FK_ingresos_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT CK_ingresos_categoria
        CHECK (categoria IN ('VENTA_CONTADO','CUOTA_INICIAL','CUOTA','OTRO','MORA')),
    CONSTRAINT CK_ingresos_moneda
        CHECK (moneda IN ('Bs', '$')),
    CONSTRAINT CK_ingresos_origen
        CHECK (origen IN ('AUTOMATICO', 'MANUAL')),
    CONSTRAINT CK_ingresos_estado
        CHECK (estado IN ('CONFIRMADO', 'ANULADO'))
);
GO

CREATE INDEX IX_ingresos_fecha        ON ingresos (fecha);
CREATE INDEX IX_ingresos_categoria    ON ingresos (categoria);
CREATE INDEX IX_ingresos_estado       ON ingresos (estado);
CREATE INDEX IX_ingresos_origen       ON ingresos (origen);
CREATE INDEX IX_ingresos_nota_venta   ON ingresos (nota_venta_id);
CREATE INDEX IX_ingresos_cuenta       ON ingresos (cuenta_bancaria_id);
GO

-- egresos
IF OBJECT_ID('egresos', 'U') IS NULL
CREATE TABLE egresos (
    id                  BIGINT          IDENTITY(1,1)  NOT NULL,
    fecha               DATE                           NOT NULL,
    concepto            NVARCHAR(255)                  NOT NULL,
    categoria           NVARCHAR(30)                   NOT NULL,
    monto               DECIMAL(12,2)                  NOT NULL,
    moneda              NVARCHAR(5)                    NOT NULL  DEFAULT 'Bs',
    origen              NVARCHAR(15)                   NOT NULL  DEFAULT 'MANUAL',
    nota_venta_id       BIGINT                             NULL,
    asesor_id           BIGINT                             NULL,
    cuenta_bancaria_id  BIGINT                             NULL,
    user_id             BIGINT                             NULL,
    beneficiario        NVARCHAR(255)                      NULL,
    comprobante         NVARCHAR(500)                      NULL,
    observaciones       NVARCHAR(MAX)                      NULL,
    estado              NVARCHAR(10)                   NOT NULL  DEFAULT 'PENDIENTE',
    created_at          DATETIME2                          NULL,
    updated_at          DATETIME2                          NULL,
    CONSTRAINT PK_egresos PRIMARY KEY (id),
    CONSTRAINT FK_egresos_nota_venta
        FOREIGN KEY (nota_venta_id) REFERENCES notas_ventas (id) ON DELETE SET NULL,
    CONSTRAINT FK_egresos_asesor
        FOREIGN KEY (asesor_id) REFERENCES asesores (id) ON DELETE SET NULL,
    CONSTRAINT FK_egresos_cuenta
        FOREIGN KEY (cuenta_bancaria_id) REFERENCES cuentas_bancarias (id) ON DELETE SET NULL,
    CONSTRAINT FK_egresos_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT CK_egresos_categoria
        CHECK (categoria IN ('COMISION_ASESOR','GASTO_ADMINISTRATIVO','GASTO_OPERATIVO','GASTO_MARKETING','PAGO_PROPIETARIO','OTRO')),
    CONSTRAINT CK_egresos_moneda
        CHECK (moneda IN ('Bs', '$')),
    CONSTRAINT CK_egresos_origen
        CHECK (origen IN ('AUTOMATICO', 'MANUAL')),
    CONSTRAINT CK_egresos_estado
        CHECK (estado IN ('PENDIENTE', 'PAGADO', 'ANULADO'))
);
GO

CREATE INDEX IX_egresos_fecha        ON egresos (fecha);
CREATE INDEX IX_egresos_categoria    ON egresos (categoria);
CREATE INDEX IX_egresos_estado       ON egresos (estado);
CREATE INDEX IX_egresos_origen       ON egresos (origen);
CREATE INDEX IX_egresos_nota_venta   ON egresos (nota_venta_id);
CREATE INDEX IX_egresos_asesor       ON egresos (asesor_id);
CREATE INDEX IX_egresos_cuenta       ON egresos (cuenta_bancaria_id);
GO

-- =============================================================
--  CAMPAÑAS DE CORREO
-- =============================================================

IF OBJECT_ID('campanas_correo', 'U') IS NULL
CREATE TABLE campanas_correo (
    id                      BIGINT          IDENTITY(1,1)  NOT NULL,
    user_id                 BIGINT                         NOT NULL,
    asunto                  NVARCHAR(255)                  NOT NULL,
    mensaje                 NVARCHAR(MAX)                  NOT NULL,
    tipo_destinatario       NVARCHAR(255)                  NOT NULL,
    filtros                 NVARCHAR(MAX)                      NULL,
    total_destinatarios     INT                            NOT NULL  DEFAULT 0,
    total_enviados          INT                            NOT NULL  DEFAULT 0,
    total_fallidos          INT                            NOT NULL  DEFAULT 0,
    estado                  NVARCHAR(15)                   NOT NULL  DEFAULT 'pendiente',
    created_at              DATETIME2                          NULL,
    updated_at              DATETIME2                          NULL,
    CONSTRAINT PK_campanas_correo PRIMARY KEY (id),
    CONSTRAINT FK_campanas_correo_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT CK_campanas_correo_estado
        CHECK (estado IN ('pendiente', 'procesando', 'completado', 'fallido'))
);
GO

-- =============================================================
--  FIN DEL SCRIPT
-- =============================================================
PRINT 'Base de datos multilider creada exitosamente.';
GO
