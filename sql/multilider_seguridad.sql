-- ============================================================
--  MSMultilider - Módulo de Gestión de Usuarios y Permisos
--  Base de datos: multilider_seguridad (MySQL Server separado)
--
--  Usuarios de prueba:
--    admin@multilider.com      → contraseña: password
--    fernando@tecnoweb.edu     → contraseña: password
--    denisse@tecnoweb.edu      → contraseña: password
--    carlos@tecnoweb.edu       → contraseña: password
--    laura@tecnoweb.edu        → contraseña: password
-- ============================================================

DROP DATABASE IF EXISTS multilider_seguridad;

CREATE DATABASE multilider_seguridad
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE multilider_seguridad;

-- ============================================================
-- TABLAS
-- ============================================================

CREATE TABLE users (
    id                BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(255)     NOT NULL,
    correo            VARCHAR(255)     NOT NULL,
    password          VARCHAR(255)     NOT NULL,
    estado            TINYINT(1)       NOT NULL DEFAULT 1,
    email_verified_at TIMESTAMP        NULL,
    remember_token    VARCHAR(100)     NULL,
    created_at        TIMESTAMP        NULL,
    updated_at        TIMESTAMP        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY users_correo_unique (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE roles (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100)    NOT NULL,
    descripcion VARCHAR(255)    NULL,
    estado      TINYINT(1)      NOT NULL DEFAULT 1,
    created_at  TIMESTAMP       NULL,
    updated_at  TIMESTAMP       NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permisos (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100)    NOT NULL,
    descripcion VARCHAR(255)    NULL,
    estado      TINYINT(1)      NOT NULL DEFAULT 1,
    created_at  TIMESTAMP       NULL,
    updated_at  TIMESTAMP       NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol_permiso (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    rol_id      BIGINT UNSIGNED NOT NULL,
    permiso_id  BIGINT UNSIGNED NOT NULL,
    created_at  TIMESTAMP       NULL,
    updated_at  TIMESTAMP       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY rol_permiso_unique (rol_id, permiso_id),
    CONSTRAINT fk_rp_rol     FOREIGN KEY (rol_id)     REFERENCES roles(id)    ON DELETE CASCADE,
    CONSTRAINT fk_rp_permiso FOREIGN KEY (permiso_id) REFERENCES permisos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol_permiso_usuario (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id        BIGINT UNSIGNED NOT NULL,
    rol_permiso_id BIGINT UNSIGNED NOT NULL,
    created_at     TIMESTAMP       NULL,
    updated_at     TIMESTAMP       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY rpu_unique (user_id, rol_permiso_id),
    CONSTRAINT fk_rpu_user       FOREIGN KEY (user_id)        REFERENCES users(id)       ON DELETE CASCADE,
    CONSTRAINT fk_rpu_rolpermiso FOREIGN KEY (rol_permiso_id) REFERENCES rol_permiso(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- ROLES  (id 1=Administrador, 2=Asesor de Ventas, 3=Cliente)
-- ============================================================
INSERT INTO roles (id, nombre, descripcion, estado, created_at, updated_at) VALUES
(1, 'Administrador',   'Acceso total al sistema y configuraciones',                           1, NOW(), NOW()),
(2, 'Asesor de Ventas','Acceso operativo a clientes y propiedades',                           1, NOW(), NOW()),
(3, 'Cliente',         'Acceso exclusivo al portal del cliente para ver sus lotes y pagos',   1, NOW(), NOW());


-- ============================================================
-- PERMISOS  (20 permisos — fuente: todos los seeders de Laravel)
-- ============================================================
INSERT INTO permisos (id, nombre, descripcion, estado, created_at, updated_at) VALUES
-- Módulo Seguridad
( 1, 'acceso_usuarios',         'Acceso completo al módulo de Usuarios',                                    1, NOW(), NOW()),
( 2, 'acceso_roles',            'Acceso completo al módulo de Roles',                                       1, NOW(), NOW()),
( 3, 'acceso_permisos',         'Acceso completo al módulo de Permisos',                                    1, NOW(), NOW()),
-- Módulo Gestión Operativa
( 4, 'acceso_propietarios',     'Acceso completo al módulo de Propietarios',                                1, NOW(), NOW()),
( 5, 'acceso_propiedades',      'Acceso completo al módulo de Propiedades',                                 1, NOW(), NOW()),
( 6, 'acceso_ciudades',         'Acceso completo al módulo de Ciudades',                                    1, NOW(), NOW()),
( 7, 'acceso_zonas',            'Acceso completo al módulo de Zonas/Distritos',                             1, NOW(), NOW()),
( 8, 'acceso_caracteristicas',  'Acceso completo al módulo de Características',                             1, NOW(), NOW()),
-- Módulo Gestión Comercial
( 9, 'acceso_asesores',         'Acceso completo al módulo de Asesores de Ventas',                          1, NOW(), NOW()),
(10, 'acceso_clientes',         'Acceso completo al módulo de Clientes',                                    1, NOW(), NOW()),
(11, 'acceso_ventas',           'Acceso para registrar y anular notas de ventas y planes de pago',          1, NOW(), NOW()),
(12, 'acceso_historial_ventas', 'Acceso para ver y filtrar el historial de ventas registradas',             1, NOW(), NOW()),
(13, 'acceso_pagos',            'Acceso completo al módulo de Pagos',                                       1, NOW(), NOW()),
(14, 'acceso_reportes_pagos',   'Acceso a los reportes de ingresos por pagos',                              1, NOW(), NOW()),
(15, 'acceso_contratos',        'Acceso completo al módulo de Contratos',                                   1, NOW(), NOW()),
-- Módulo Configuración
(16, 'acceso_empresa',          'Acceso completo para gestionar información y branding de la empresa',      1, NOW(), NOW()),
(17, 'acceso_correo_masivo',    'Acceso completo al módulo de Correo Masivo',                               1, NOW(), NOW()),
-- Módulo Finanzas
(18, 'acceso_ingresos',         'Acceso completo al módulo de Ingresos (flujo de caja)',                    1, NOW(), NOW()),
(19, 'acceso_egresos',          'Acceso completo al módulo de Egresos (flujo de caja)',                     1, NOW(), NOW()),
-- Módulo Entregas
(20, 'acceso_entregas',         'Acceso completo al módulo de Entregas de propiedades',                     1, NOW(), NOW());


-- ============================================================
-- ROL_PERMISO
--   IDs  1-20 → Administrador  (todos los permisos)
--   IDs 21-30 → Asesor de Ventas (permisos operativos)
-- ============================================================

-- Administrador: todos los permisos (1-20)
INSERT INTO rol_permiso (id, rol_id, permiso_id, created_at, updated_at) VALUES
( 1, 1,  1, NOW(), NOW()),
( 2, 1,  2, NOW(), NOW()),
( 3, 1,  3, NOW(), NOW()),
( 4, 1,  4, NOW(), NOW()),
( 5, 1,  5, NOW(), NOW()),
( 6, 1,  6, NOW(), NOW()),
( 7, 1,  7, NOW(), NOW()),
( 8, 1,  8, NOW(), NOW()),
( 9, 1,  9, NOW(), NOW()),
(10, 1, 10, NOW(), NOW()),
(11, 1, 11, NOW(), NOW()),
(12, 1, 12, NOW(), NOW()),
(13, 1, 13, NOW(), NOW()),
(14, 1, 14, NOW(), NOW()),
(15, 1, 15, NOW(), NOW()),
(16, 1, 16, NOW(), NOW()),
(17, 1, 17, NOW(), NOW()),
(18, 1, 18, NOW(), NOW()),
(19, 1, 19, NOW(), NOW()),
(20, 1, 20, NOW(), NOW());

-- Asesor de Ventas: permisos operativos (sin seguridad, finanzas ni config)
INSERT INTO rol_permiso (id, rol_id, permiso_id, created_at, updated_at) VALUES
(21, 2,  1, NOW(), NOW()),  -- acceso_usuarios
(22, 2,  4, NOW(), NOW()),  -- acceso_propietarios
(23, 2,  5, NOW(), NOW()),  -- acceso_propiedades
(24, 2,  6, NOW(), NOW()),  -- acceso_ciudades
(25, 2,  7, NOW(), NOW()),  -- acceso_zonas
(26, 2,  8, NOW(), NOW()),  -- acceso_caracteristicas
(27, 2, 10, NOW(), NOW()),  -- acceso_clientes
(28, 2, 11, NOW(), NOW()),  -- acceso_ventas
(29, 2, 12, NOW(), NOW()),  -- acceso_historial_ventas
(30, 2, 13, NOW(), NOW());  -- acceso_pagos

-- Cliente: sin permisos de panel (solo accede al portal público)


-- ============================================================
-- USERS
--   ID 1 → admin@multilider.com     (Admin123!)
--   ID 2 → fernando@tecnoweb.edu    (password)
--   ID 3 → denisse@tecnoweb.edu     (password)
--   ID 4 → carlos@tecnoweb.edu      (password)
--   ID 5 → laura@tecnoweb.edu       (password)
-- ============================================================
INSERT INTO users (id, nombre, correo, password, estado, created_at, updated_at) VALUES
(1, 'Administrador',       'admin@multilider.com',   '$2y$10$ra9sumHDkTmS0zi8lsX4uuDtRC4tDCIbQ5K9XDIvrHylxVo0iPOu6', 1, NOW(), NOW()),
(2, 'Fernando Administrador', 'fernando@tecnoweb.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, NOW(), NOW()),
(3, 'Denisse Administradora', 'denisse@tecnoweb.edu',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, NOW(), NOW()),
(4, 'Carlos Mendoza',      'carlos@tecnoweb.edu',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, NOW(), NOW()),
(5, 'Laura Castillo',      'laura@tecnoweb.edu',     '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, NOW(), NOW());


-- ============================================================
-- ROL_PERMISO_USUARIO
--   Users 1,2,3 → Administrador  (rol_permiso IDs 1-20)
--   Users 4,5   → Asesor de Ventas (rol_permiso IDs 21-30)
-- ============================================================

-- admin@multilider.com → Administrador (todos los permisos)
INSERT INTO rol_permiso_usuario (user_id, rol_permiso_id, created_at, updated_at) VALUES
(1,  1, NOW(), NOW()), (1,  2, NOW(), NOW()), (1,  3, NOW(), NOW()), (1,  4, NOW(), NOW()), (1,  5, NOW(), NOW()),
(1,  6, NOW(), NOW()), (1,  7, NOW(), NOW()), (1,  8, NOW(), NOW()), (1,  9, NOW(), NOW()), (1, 10, NOW(), NOW()),
(1, 11, NOW(), NOW()), (1, 12, NOW(), NOW()), (1, 13, NOW(), NOW()), (1, 14, NOW(), NOW()), (1, 15, NOW(), NOW()),
(1, 16, NOW(), NOW()), (1, 17, NOW(), NOW()), (1, 18, NOW(), NOW()), (1, 19, NOW(), NOW()), (1, 20, NOW(), NOW());

-- fernando@tecnoweb.edu → Administrador (todos los permisos)
INSERT INTO rol_permiso_usuario (user_id, rol_permiso_id, created_at, updated_at) VALUES
(2,  1, NOW(), NOW()), (2,  2, NOW(), NOW()), (2,  3, NOW(), NOW()), (2,  4, NOW(), NOW()), (2,  5, NOW(), NOW()),
(2,  6, NOW(), NOW()), (2,  7, NOW(), NOW()), (2,  8, NOW(), NOW()), (2,  9, NOW(), NOW()), (2, 10, NOW(), NOW()),
(2, 11, NOW(), NOW()), (2, 12, NOW(), NOW()), (2, 13, NOW(), NOW()), (2, 14, NOW(), NOW()), (2, 15, NOW(), NOW()),
(2, 16, NOW(), NOW()), (2, 17, NOW(), NOW()), (2, 18, NOW(), NOW()), (2, 19, NOW(), NOW()), (2, 20, NOW(), NOW());

-- denisse@tecnoweb.edu → Administrador (todos los permisos)
INSERT INTO rol_permiso_usuario (user_id, rol_permiso_id, created_at, updated_at) VALUES
(3,  1, NOW(), NOW()), (3,  2, NOW(), NOW()), (3,  3, NOW(), NOW()), (3,  4, NOW(), NOW()), (3,  5, NOW(), NOW()),
(3,  6, NOW(), NOW()), (3,  7, NOW(), NOW()), (3,  8, NOW(), NOW()), (3,  9, NOW(), NOW()), (3, 10, NOW(), NOW()),
(3, 11, NOW(), NOW()), (3, 12, NOW(), NOW()), (3, 13, NOW(), NOW()), (3, 14, NOW(), NOW()), (3, 15, NOW(), NOW()),
(3, 16, NOW(), NOW()), (3, 17, NOW(), NOW()), (3, 18, NOW(), NOW()), (3, 19, NOW(), NOW()), (3, 20, NOW(), NOW());

-- carlos@tecnoweb.edu → Asesor de Ventas (permisos operativos)
INSERT INTO rol_permiso_usuario (user_id, rol_permiso_id, created_at, updated_at) VALUES
(4, 21, NOW(), NOW()), (4, 22, NOW(), NOW()), (4, 23, NOW(), NOW()), (4, 24, NOW(), NOW()), (4, 25, NOW(), NOW()),
(4, 26, NOW(), NOW()), (4, 27, NOW(), NOW()), (4, 28, NOW(), NOW()), (4, 29, NOW(), NOW()), (4, 30, NOW(), NOW());

-- laura@tecnoweb.edu → Asesor de Ventas (permisos operativos)
INSERT INTO rol_permiso_usuario (user_id, rol_permiso_id, created_at, updated_at) VALUES
(5, 21, NOW(), NOW()), (5, 22, NOW(), NOW()), (5, 23, NOW(), NOW()), (5, 24, NOW(), NOW()), (5, 25, NOW(), NOW()),
(5, 26, NOW(), NOW()), (5, 27, NOW(), NOW()), (5, 28, NOW(), NOW()), (5, 29, NOW(), NOW()), (5, 30, NOW(), NOW());
