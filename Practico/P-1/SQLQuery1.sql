CREATE DATABASE BD2_Practico;

CREATE TABLE Proveedores(
	prov_id int not null,
	prov_nombre varchar(255),
	prov_mail varchar(255),
	prov_tel varchar(10),
	prov_otros varchar(255)
);

ALTER TABLE Proveedores ADD CONSTRAINT U_MailProveedor UNIQUE(prov_mail);

ALTER TABLE Proveedores ADD CONSTRAINT PK_Proveedor PRIMARY KEY (prov_id);

--Ejercicio 0 

CREATE TABLE Personas (
	nroDocumento varchar(8) not null,
	tipoDocumento varchar(20) not null,
	pais varchar (20) not null,
	nombre varchar(255) not null,
	apellido varchar(255) not null
);

CREATE TABLE Pais(
	codPais varchar(8) not null,
	nombre varchar(255) not null,
	sigla varchar(3) not null
);

CREATE TABLE Organizacion(
	codOrganizacion varchar(8) not null,
	fecha_creacion Date not null,
	descripcion varchar(255)
);

CREATE TABLE es_ciudadano(
	nroDocumento varchar(8) not null,
	tipoDocumento varchar(20) not null,
	pais varchar (20) not null,
	codPais varchar(8) not null,
	tipo varchar (8) not null,
);

CREATE TABLE recorre(
	codPais varchar(8) not null,
	codOrganizacion varchar(8) not null,
);

ALTER TABLE es_ciudadano ADD CONSTRAINT CK_Ciudadano CHECK (tipo in ('Legal', 'Natural', 'Otro'));

ALTER TABLE Personas ADD CONSTRAINT PK_Persona PRIMARY KEY (nroDocumento, tipoDocumento, pais);

ALTER TABLE Pais ADD CONSTRAINT PK_Pais PRIMARY KEY (codPais);

ALTER TABLE Organizacion ADD CONSTRAINT PK_Organizacion PRIMARY KEY (codOrganizacion);

ALTER TABLE es_ciudadano ADD CONSTRAINT PK_EsCiudadano PRIMARY KEY(nroDocumento, tipoDocumento, pais, codPais);

ALTER TABLE es_ciudadano ADD CONSTRAINT FK_EsCiudadanoPersona FOREIGN KEY (nroDocumento, tipoDocumento, pais)
REFERENCES Personas(nroDocumento, tipoDocumento, pais);

ALTER TABLE es_ciudadano ADD CONSTRAINT FK_EsCiudadanoPais FOREIGN KEY (codPais) REFERENCES Pais(codpais);

ALTER TABLE recorre ADD CONSTRAINT PK_Recorre PRIMARY KEY (codPais, codOrganizacion);

ALTER TABLE recorre ADD CONSTRAINT FK_RecorrePais FOREIGN KEY (codPais) REFERENCES Pais(codPais);

ALTER TABLE recorre ADD CONSTRAINT FK_RecorreOrganizacion FOREIGN KEY (codOrganizacion) REFERENCES Organizacion(codOrganizacion);

CREATE INDEX idx_Personas on Personas(nombre, apellido);

CREATE INDEX idx_EsCiudadano on es_ciudadano(tipo);

CREATE INDEX idx_Pais on Pais(nombre, sigla);

CREATE INDEX idx_OrganizacionFecha on Organizacion(fecha_creacion);

CREATE INDEX idx_OrganizacionDesc on Organizacion(descripcion);