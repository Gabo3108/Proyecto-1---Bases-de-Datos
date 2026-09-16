-- DROP SCHEMA prototipo;

CREATE SCHEMA prototipo AUTHORIZATION postgres;

-- DROP SEQUENCE prototipo.categorias_id_categoria_seq;

CREATE SEQUENCE prototipo.categorias_id_categoria_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE prototipo.categorias_id_categoria_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE prototipo.categorias_id_categoria_seq TO postgres;

-- DROP SEQUENCE prototipo.eventos_id_evento_seq;

CREATE SEQUENCE prototipo.eventos_id_evento_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE prototipo.eventos_id_evento_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE prototipo.eventos_id_evento_seq TO postgres;

-- DROP SEQUENCE prototipo.log_accesos_id_log_seq;

CREATE SEQUENCE prototipo.log_accesos_id_log_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE prototipo.log_accesos_id_log_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE prototipo.log_accesos_id_log_seq TO postgres;

-- DROP SEQUENCE prototipo.ubicaciones_id_ubicacion_seq;

CREATE SEQUENCE prototipo.ubicaciones_id_ubicacion_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE prototipo.ubicaciones_id_ubicacion_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE prototipo.ubicaciones_id_ubicacion_seq TO postgres;

-- DROP SEQUENCE prototipo.usuarios_id_usuario_seq;

CREATE SEQUENCE prototipo.usuarios_id_usuario_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE prototipo.usuarios_id_usuario_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE prototipo.usuarios_id_usuario_seq TO postgres;
-- prototipo.disponibilidad definition

-- Drop table

-- DROP TABLE prototipo.disponibilidad;

CREATE TABLE prototipo.disponibilidad (
	tipo_disponibilidad varchar(15) NOT NULL,
	fecha_inicio timestamp NOT NULL,
	fecha_fin timestamp NULL,
	hora_inicio timestamp NOT NULL,
	hora_fin timestamp NOT NULL,
	CONSTRAINT disponibilidad_fecha_not_null NOT NULL fecha_inicio,
	CONSTRAINT disponibilidad_pkey PRIMARY KEY (tipo_disponibilidad),
	CONSTRAINT disponibilidad_tipo_disponibilidad_not_null NOT NULL tipo_disponibilidad,
	CONSTRAINT disponibilidad_hora_inicio_not_null NOT NULL hora_inicio,
	CONSTRAINT disponibilidad_hora_fin_not_null NOT NULL hora_fin
);

-- Permissions

ALTER TABLE prototipo.disponibilidad OWNER TO postgres;
GRANT ALL ON TABLE prototipo.disponibilidad TO postgres;


-- prototipo.tareas definition

-- Drop table

-- DROP TABLE prototipo.tareas;

CREATE TABLE prototipo.tareas (
	titulo varchar(25) NOT NULL,
	estado varchar(15) NOT NULL,
	prioridad varchar(20) NOT NULL,
	fecha_limite timestamp NOT NULL,
	descripcion varchar(50) NULL,
	CONSTRAINT tareas_estado_not_null NOT NULL estado,
	CONSTRAINT tareas_fecha_limite_not_null NOT NULL fecha_limite,
	CONSTRAINT tareas_pkey PRIMARY KEY (titulo),
	CONSTRAINT tareas_prioridad_not_null NOT NULL prioridad,
	CONSTRAINT tareas_titulo_not_null NOT NULL titulo
);

-- Permissions

ALTER TABLE prototipo.tareas OWNER TO postgres;
GRANT ALL ON TABLE prototipo.tareas TO postgres;


-- prototipo.ubicaciones definition

-- Drop table

-- DROP TABLE prototipo.ubicaciones;

CREATE TABLE prototipo.ubicaciones (
	id_ubicacion serial4 NOT NULL,
	nombre varchar(50) NOT NULL,
	direccion varchar(100) NOT NULL,
	ciudad varchar(30) NOT NULL,
	capacidad int4 NOT NULL,
	CONSTRAINT ubicaciones_capacidad_not_null NOT NULL capacidad,
	CONSTRAINT ubicaciones_ciudad_not_null NOT NULL ciudad,
	CONSTRAINT ubicaciones_direccion_not_null NOT NULL direccion,
	CONSTRAINT ubicaciones_id_ubicacion_not_null NOT NULL id_ubicacion,
	CONSTRAINT ubicaciones_nombre_not_null NOT NULL nombre,
	CONSTRAINT ubicaciones_pkey PRIMARY KEY (id_ubicacion)
);

-- Permissions

ALTER TABLE prototipo.ubicaciones OWNER TO postgres;
GRANT ALL ON TABLE prototipo.ubicaciones TO postgres;


-- prototipo.usuarios definition

-- Drop table

-- DROP TABLE prototipo.usuarios;

CREATE TABLE prototipo.usuarios (
	id_usuario serial4 NOT NULL,
	nombre varchar(50) NOT NULL,
	apellido varchar(50) NOT NULL,
	fecha_registro date DEFAULT CURRENT_DATE NOT NULL,
	activo bool DEFAULT true NULL,
	CONSTRAINT usuarios_apellido_not_null NOT NULL apellido,
	CONSTRAINT usuarios_fecha_registro_not_null NOT NULL fecha_registro,
	CONSTRAINT usuarios_id_usuario_not_null NOT NULL id_usuario,
	CONSTRAINT usuarios_nombre_not_null NOT NULL nombre,
	CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario)
);

-- Permissions

ALTER TABLE prototipo.usuarios OWNER TO postgres;
GRANT ALL ON TABLE prototipo.usuarios TO postgres;


-- prototipo.categorias definition

-- Drop table

-- DROP TABLE prototipo.categorias;

CREATE TABLE prototipo.categorias (
	id_categoria serial4 NOT NULL,
	nombre varchar(50) NOT NULL,
	id_categoria_padre int4 NULL,
	CONSTRAINT categorias_id_categoria_not_null NOT NULL id_categoria,
	CONSTRAINT categorias_nombre_not_null NOT NULL nombre,
	CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria),
	CONSTRAINT categorias_id_categoria_padre_fkey FOREIGN KEY (id_categoria_padre) REFERENCES prototipo.categorias(id_categoria)
);

-- Table Triggers

create trigger trg_evitar_ciclo before
insert
    or
update
    on
    prototipo.categorias for each row execute function prototipo.evitar_ciclo_categorias();

-- Permissions

ALTER TABLE prototipo.categorias OWNER TO postgres;
GRANT ALL ON TABLE prototipo.categorias TO postgres;


-- prototipo.eventos definition

-- Drop table

-- DROP TABLE prototipo.eventos;

CREATE TABLE prototipo.eventos (
	id_evento serial4 NOT NULL,
	id_usuario_propietario int4 NOT NULL,
	id_categoria int4 NOT NULL,
	titulo varchar(100) NOT NULL,
	descripcion text NULL,
	fecha_inicio timestamp NOT NULL,
	fecha_fin timestamp NOT NULL,
	id_ubicacion int4 NULL,
	CONSTRAINT check_fechas CHECK ((fecha_fin > fecha_inicio)),
	CONSTRAINT eventos_fecha_fin_not_null NOT NULL fecha_fin,
	CONSTRAINT eventos_fecha_inicio_not_null NOT NULL fecha_inicio,
	CONSTRAINT eventos_id_categoria_not_null NOT NULL id_categoria,
	CONSTRAINT eventos_id_evento_not_null NOT NULL id_evento,
	CONSTRAINT eventos_id_usuario_propietario_not_null NOT NULL id_usuario_propietario,
	CONSTRAINT eventos_pkey PRIMARY KEY (id_evento),
	CONSTRAINT eventos_titulo_not_null NOT NULL titulo,
	CONSTRAINT eventos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES prototipo.categorias(id_categoria),
	CONSTRAINT eventos_id_usuario_propietario_fkey FOREIGN KEY (id_usuario_propietario) REFERENCES prototipo.usuarios(id_usuario),
	CONSTRAINT id_ubicacion_fk FOREIGN KEY (id_ubicacion) REFERENCES prototipo.ubicaciones(id_ubicacion)
);

-- Permissions

ALTER TABLE prototipo.eventos OWNER TO postgres;
GRANT ALL ON TABLE prototipo.eventos TO postgres;


-- prototipo.log_accesos definition

-- Drop table

-- DROP TABLE prototipo.log_accesos;

CREATE TABLE prototipo.log_accesos (
	id_log serial4 NOT NULL,
	id_usuario int4 NULL,
	fecha_acceso timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT log_accesos_id_log_not_null NOT NULL id_log,
	CONSTRAINT log_accesos_pkey PRIMARY KEY (id_log),
	CONSTRAINT log_accesos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES prototipo.usuarios(id_usuario)
);

-- Permissions

ALTER TABLE prototipo.log_accesos OWNER TO postgres;
GRANT ALL ON TABLE prototipo.log_accesos TO postgres;


-- prototipo.participaciones definition

-- Drop table

-- DROP TABLE prototipo.participaciones;

CREATE TABLE prototipo.participaciones (
	id_evento int4 NOT NULL,
	id_invitado int4 NOT NULL,
	rol varchar(50) NULL,
	estado_confirmacion varchar(20) DEFAULT 'pendiente'::character varying NULL,
	CONSTRAINT participaciones_id_evento_not_null NOT NULL id_evento,
	CONSTRAINT participaciones_id_invitado_not_null NOT NULL id_invitado,
	CONSTRAINT participaciones_pkey PRIMARY KEY (id_evento, id_invitado),
	CONSTRAINT participaciones_id_evento_fkey FOREIGN KEY (id_evento) REFERENCES prototipo.eventos(id_evento) ON DELETE CASCADE,
	CONSTRAINT participaciones_id_invitado_fkey FOREIGN KEY (id_invitado) REFERENCES prototipo.usuarios(id_usuario)
);

-- Permissions

ALTER TABLE prototipo.participaciones OWNER TO postgres;
GRANT ALL ON TABLE prototipo.participaciones TO postgres;


-- prototipo.usuario_emails definition

-- Drop table

-- DROP TABLE prototipo.usuario_emails;

CREATE TABLE prototipo.usuario_emails (
	id_usuario int4 NOT NULL,
	email varchar(100) NOT NULL,
	CONSTRAINT usuario_emails_email_not_null NOT NULL email,
	CONSTRAINT usuario_emails_id_usuario_not_null NOT NULL id_usuario,
	CONSTRAINT usuario_emails_pkey PRIMARY KEY (id_usuario, email),
	CONSTRAINT usuario_emails_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES prototipo.usuarios(id_usuario)
);

-- Permissions

ALTER TABLE prototipo.usuario_emails OWNER TO postgres;
GRANT ALL ON TABLE prototipo.usuario_emails TO postgres;


-- prototipo.usuario_telefonos definition

-- Drop table

-- DROP TABLE prototipo.usuario_telefonos;

CREATE TABLE prototipo.usuario_telefonos (
	id_usuario int4 NOT NULL,
	telefono varchar(20) NOT NULL,
	CONSTRAINT usuario_telefonos_id_usuario_not_null NOT NULL id_usuario,
	CONSTRAINT usuario_telefonos_pkey PRIMARY KEY (id_usuario, telefono),
	CONSTRAINT usuario_telefonos_telefono_not_null NOT NULL telefono,
	CONSTRAINT usuario_telefonos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES prototipo.usuarios(id_usuario)
);

-- Permissions

ALTER TABLE prototipo.usuario_telefonos OWNER TO postgres;
GRANT ALL ON TABLE prototipo.usuario_telefonos TO postgres;


-- prototipo.vista_antiguedad_usuarios source

CREATE OR REPLACE VIEW prototipo.vista_antiguedad_usuarios
AS SELECT id_usuario,
    nombre,
    fecha_registro,
    age(CURRENT_DATE::timestamp with time zone, fecha_registro::timestamp with time zone) AS antiguedad
   FROM prototipo.usuarios;

-- Permissions

ALTER TABLE prototipo.vista_antiguedad_usuarios OWNER TO postgres;
GRANT ALL ON TABLE prototipo.vista_antiguedad_usuarios TO postgres;


-- prototipo.vista_duracion_eventos_diarios source

CREATE OR REPLACE VIEW prototipo.vista_duracion_eventos_diarios
AS SELECT id_usuario_propietario,
    fecha_inicio::date AS dia,
    sum(EXTRACT(epoch FROM fecha_fin - fecha_inicio) / 60::numeric) AS duracion_total_minutos
   FROM prototipo.eventos
  GROUP BY id_usuario_propietario, (fecha_inicio::date);

-- Permissions

ALTER TABLE prototipo.vista_duracion_eventos_diarios OWNER TO postgres;
GRANT ALL ON TABLE prototipo.vista_duracion_eventos_diarios TO postgres;



-- DROP FUNCTION prototipo.evitar_ciclo_categorias();

CREATE OR REPLACE FUNCTION prototipo.evitar_ciclo_categorias()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.id_categoria_padre = NEW.id_categoria THEN
        RAISE EXCEPTION 'Una categoría no puede ser padre de sí misma.';
    END IF;
    -- Aquí se podría añadir una consulta recursiva para validar ancestros, 
    -- pero para Postgres 14 es altamente eficiente usar el camino (path) o este chequeo simple.
    RETURN NEW;
END;
$function$
;

-- Permissions

ALTER FUNCTION prototipo.evitar_ciclo_categorias() OWNER TO postgres;
GRANT ALL ON FUNCTION prototipo.evitar_ciclo_categorias() TO postgres;


-- Permissions

GRANT ALL ON SCHEMA prototipo TO postgres;