CREATE DATABASE grucosadb;
USE grucosadb;


CREATE TABLE proyectos(
    id_proy VARCHAR(10) PRIMARY KEY,
    nombre_proyecto VARCHAR(40),
    nombre_empresa VARCHAR(30),
    descripcion_proyecto VARCHAR(150),
    /*parte opcional del usuario para llenar la tabla*/
    fecha_inicio DATE DEFAULT NULL,/*AÑO-MES_DIA*/
    fecha_fin DATE DEFAULT NULL,
    status_proyecto VARCHAR(10) DEFAULT NULL,
    multa FLOAT DEFAULT 0.00
)

ALTER PROCEDURE SPI_proyectos  (@id VARCHAR(10),@nomP VARCHAR(40),@nomE VARCHAR(30),
                                @descr VARCHAR(150),@ini DATE,@fin DATE,@status VARCHAR(10),
                                @multa float) AS
BEGIN
        INSERT INTO proyectos VALUES(@id,@nomP,@nomE,@descr,@ini,@fin,@status,@multa);
END
GO

EXEC dbo.SPI_proyectos 'co-gre-741','GreenGarden','INGENIERIA R-M S.A.',
'BARANDAS DE ESCALERA PRINCIPAL #1 Y #2 DEL NIVEL 000. ESTRUTURA DE ACERO PARA FOSO DE ELEVADORES PRINCIPALES 1 Y 2',
NULL,NULL,NULL,0.00

EXEC dbo.SPI_proyectos 'co-est-155','ESTACIONAMIENTOS UNIVERSIDAD LATINA','INGENIERIA R-M S.A.',
'BARANDAS Y PASAMANOS DE ESCALERA, LOBBY Y PARED PERIMETAL',
null,null,null,0.00

EXEC dbo.SPI_proyectos 'co-kin-155','KINGS PARK','INGENIERIA R-M S.A.',
'CONFECCION DE PERGOLAS DE PORTA COCHERA TORRE 300 Y 400 N.000',
null,null,null,0.00

EXEC dbo.SPI_proyectos 'co-tor-106','TORRES DE CASTILLA','INGENIERIA R-M S.A.',
'VIGAS DE FOSO DE ASCENSOR',
null,null,null,0.00

GO

/*		creacion de la tabla de ADENDAS	*/
CREATE TABLE adendas(
	cod_adenda VARCHAR(10) PRIMARY KEY,
    cod_proy VARCHAR(10) UNIQUE,
    FOREIGN KEY (cod_proy) REFERENCES proyectos(id_proy)
);

CREATE PROCEDURE SPI_adendas(@codA VARCHAR(10),@codP VARCHAR(10))AS
BEGIN
    INSERT INTO adendas VALUES(@codA,@codP);
END
GO

EXEC SPI_adendas 'ad-gre-741','co-gre-741'

EXEC SPI_adendas 'ad-est-155','co-est-155'

EXEC SPI_adendas 'ad-kin-155','co-kin-155'

EXEC SPI_adendas 'ad-tor-106','co-tor-106'
GO

CREATE TABLE descripcion_adendas(
	cod_adenda VARCHAR(10),
    FOREIGN KEY (cod_adenda) REFERENCES adendas(cod_adenda),
    descripcion VARCHAR(60),
    cantidad FLOAT default 0.00,
    unidad VARCHAR(4),
    codigo VARCHAR(10) NOT NULL,
    costo_unitario FLOAT DEFAULT 0.00,
    total_presupuesto FLOAT DEFAULT 0.00/*ES COMO UN SUBTOTAL POR FILA*/
);

ALTER PROCEDURE SPI_descAdendas    (@codA VARCHAR(10),@descr VARCHAR(60),@cant FLOAT,@uni VARCHAR(4),
                                    @cod VARCHAR(10),@costU FLOAT)AS
BEGIN
        INSERT INTO descripcion_adendas VALUES(@codA,@descr,@cant,@uni,@cod,@costU,@cant*@costU);
END
GO
/*INSERCION DE LOS DATOS DE LA TABLA DESCRICION_ADENDAS*/
EXEC SPI_descAdendas 'ad-gre-741','ADICIONAL ESCALERAS',658.25,'ml','05-503-SUB',6.55
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.000',1,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.100@N400',4,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.500',1,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.600',1,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.700@N1700',10,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.1800@N2700',10,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.2800@N3700',10,'C/U','05-090-SUB',486.96
EXEC SPI_descAdendas 'ad-gre-741','(EST. FOSO ASC. PRINCIPAL 1 Y 2) N.3800@N4600',9,'C/U','05-090-SUB',486.96 
GO
/*A ESTA ADENDA NO TENIA ALGUNOS VALORES DE CANTIDAD Y COSTOS */
INSERT INTO descripcion_adendas VALUES('ad-est-155','BARANDAS EN LOBBY N200,N300,N400',37.70,'ml','P39-2013',0,2284.13); /*INSERCION DIRECTA DEL PRESUPUESTO POR QUE NO SE ENCUENTRA INDIVIDUAL*/
INSERT INTO descripcion_adendas VALUES('ad-tor-106','ESCALERAS CUARTO DE MAQUINAS',0,NULL,'',0,11782.54);/*LE COLOQUE EL COSTO FINAL DIRECTAMENTE YA QUE NO TENIA POR SEPARADO*/)
EXEC SPI_descAdendas 'ad-est-155','PLATINAS 3 X 1/4',0,NULL,'P39-2013',0
EXEC SPI_descAdendas 'ad-est-155','CODOS 90 ESCALA 80',0,NULL,'P39-2013',0
EXEC SPI_descAdendas 'ad-est-155','PINTURA CROMATO DE ZINC',0,NULL,'P39-2013',0
EXEC SPI_descAdendas 'ad-kin-155','REFUERZO ADICIONAL PARA PERGOLAS TORRE 300',1,'UN','05-503 SUB',1861.00
EXEC SPI_descAdendas 'ad-tor-106','ESCALERAS DE GATO',0,NULL,'',0
EXEC SPI_descAdendas 'ad-tor-106','BARANDAS',0,NULL,'',0
EXEC SPI_descAdendas 'ad-tor-106','ESCOTILLA DE TANQUE DE AGUA',0,NULL,'',0
GO


/*tabla de LOS EMPLEADOS CANDIDATOS (que son aspirantes a algun puesto de trabajo)*/
CREATE TABLE candidatos(
	cedula VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(30),
    apellido VARCHAR(30),
    ocupacion VARCHAR(20) default 'AYUDANTE GENERAL',
    telefono VARCHAR(8)UNIQUE,
    fecha_nac DATE,
    direccion VARCHAR(80),
    licencia_soldador VARCHAR(20) default 'SIN LICENCIA'
);

ALTER PROCEDURE SPI_candidatos(@ced VARCHAR(15),@nom VARCHAR(30),@ape VARCHAR(30),@ocupa VARCHAR(20)="AYUDANTE GENERAL",
                                @tel VARCHAR(8)=NULL,@nac DATE = NULL,@dir VARCHAR(80)= NULL,@lic VARCHAR(20)="SIN LICENCIA")AS
BEGIN
		--MODIFICAR LOS NUMERO DE TELEFONOS VACIOS PARA QUE NO DEN ERROR
        IF( @tel IS NULL)
            SELECT @tel= CAST((MAX(CAST(telefono AS INT))+1) AS VARCHAR(8)) FROM candidatos;

        INSERT INTO candidatos VALUES(@ced,@nom,@ape,@ocupa,@tel,@nac,@dir,@lic);
END
GO
/*INSERCION DE DATOS EN LA TABLA candidatos*/

EXEC SPI_candidatos '8-420-89','Victor','Pajaro','soldador','64545157','1972-05-09','La chorrera, barrio balboa, casa 11-16','1970'
EXEC SPI_candidatos '8-517-1641','Juan','Solis','soldador',NULL,NULL,'La chorrera','7091'
EXEC SPI_candidatos '6-80-120','Antonio','Ramos','soldador','60911659','1973-05-04','La chorrera, Nazareno',default
EXEC SPI_candidatos '8-730-2179','Vicencio','Maylin','soldador','68425937','1979-07-27','Residencial vista alegre, casa #365',default
EXEC SPI_candidatos '8-896-1480','Wilmer','Gusman','Ayudante general','62863795','1995-09-13','La chorrera, Puerto caimito,  barriada el carmen, casa #48',default
EXEC SPI_candidatos '8-787-3198','Virgilio','magallon',default,'65598657',NULL,NULL,'8882'
EXEC SPI_candidatos '6-713-2075','Ezequiel','Tuñon','soldador','63771609','1973-05-04','La chorrera, Bda. Mystic City, calle larga',default
EXEC SPI_candidatos '8-748-28','Gabriel','Sanchez',NULL,'67249349','1981-03-23',NULL,default
EXEC SPI_candidatos '8-829-446','Manuel','Espinosa',default,NULL,'1986-10-15','La chorrera, Nazareno',default
EXEC SPI_candidatos '8-271-900','Orlando','Gonzales','soldador',NULL,NULL,'La chorrera, Nazareno','3063'
EXEC SPI_candidatos 'b-204-631','Azael','garcia','soldador',NULL,NULL,NULL,'701'
EXEC SPI_candidatos '8-861-832','Jose','Santos',default,'64761823','1992-06-11','La chorrera, Nazareno',default
GO

/*insercion de los colaboradores en la tabla de candidaatos para enlazarlos*/
EXEC SPI_candidatos '09-00102-000049','CECILIO','GUEVARA','CALIFICADO'
EXEC SPI_candidatos '09-00734-002480','JOSE','JIMENEZ','CALIFICADO'
EXEC SPI_candidatos '08-00768-000667','SERAFIN','JIMENEZ','CALIFICADO'
EXEC SPI_candidatos '04-00242-001004','MARTIN','MEJIAS','CALIFICADO'
EXEC SPI_candidatos '09-00744-001365','JENRI','JIMENEZ','AYUDANTE G'
EXEC SPI_candidatos '08-00912-001367','MARTIN','MARTINEZ','AYUDANTE G'
EXEC SPI_candidatos '08-00710-000488','WILSON','GONZALEZ','CALIFICADO'
EXEC SPI_candidatos '08-00904-002049','JAIME','SANSHEZ','AYUDANTE G'
EXEC SPI_candidatos '08-00700-000980','MANUEL','MEJIAS','SOLDADOR2A'
EXEC SPI_candidatos '08-00303-000530','AQUILINO','BELLIDO','CALIFICADO'
EXEC SPI_candidatos '08-00748-000814','JORGE','ALVARADO','CALIFICADO'
EXEC SPI_candidatos '08-00340-000619','HECTOR','ORTEGA','AYUDANTE G'
EXEC SPI_candidatos '08-00701-001844','RAUL','MARTINEZ','CALIFICADO'
EXEC SPI_candidatos '08-00365-000108','MANUEL','BATISTA','CALIFICADO'
GO

/*creacion de la tabla de los colaboradores (personas que ya laboran dentro de la empresa)*/
CREATE TABLE colaboradores(
	cedula VARCHAR(15) PRIMARY KEY,
    FOREIGN KEY (cedula) REFERENCES candidatos(cedula),
    noEmpleado VARCHAR(11) UNIQUE,
    noSeguro VARCHAR(10),
    nombre VARCHAR(30),
    apellido VARCHAR(30),
    ocupacion VARCHAR(20)    
);

CREATE PROCEDURE SPI_colaboradores(@ced VARCHAR(15),@noEmp VARCHAR(11),@noSeg VARCHAR(10))AS
BEGIN
        INSERT INTO colaboradores SELECT @ced,@noEmp,@noSeg,ca.nombre,ca.apellido,ca.ocupacion FROM candidatos AS ca WHERE ca.cedula = @ced;
END
GO


/*INSERCION DE DATOS DE LOS TRABAJADORES YA REGISTRADOS EN LA TABLA CANDIDATOS*/

EXEC SPI_colaboradores '09-00102-000049','15-01-00016','158-9988'
EXEC SPI_colaboradores '09-00734-002480','15-01-00019','999-9999'
EXEC SPI_colaboradores '08-00768-000667','15-01-00020','999-9999'
EXEC SPI_colaboradores '04-00242-001004','15-01-00059','375-4977'
EXEC SPI_colaboradores '09-00744-001365','15-01-00063','999-9999'
EXEC SPI_colaboradores '08-00912-001367','15-01-00073','999-9999'
EXEC SPI_colaboradores '08-00710-000488','15-01-00074','999-9999'
EXEC SPI_colaboradores '08-00904-002049','15-01-00079','999-9999'
EXEC SPI_colaboradores '08-00700-000980','17-01-00025','405-6760'
EXEC SPI_colaboradores '08-00303-000530','17-01-00040','182-1263'
EXEC SPI_colaboradores '08-00748-000814','17-01-00078','999-9999'
EXEC SPI_colaboradores '08-00340-000619','17-01-00080','078-3598'
EXEC SPI_colaboradores '08-00881-000230','17-01-00083','999-9999'
EXEC SPI_colaboradores '08-00701-001844','17-01-00084','405-7443'
EXEC SPI_colaboradores '08-00365-000108','17-01-00086','152-7931'
GO

/*CREACION DE TABLA DE PROVEEDORES*/
CREATE TABLE proveedores(
	id VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(40)
);

CREATE PROCEDURE SPI_proveedores(@id VARCHAR(15),@nom VARCHAR(40))AS
BEGIN
    INSERT INTO proveedores VALUES(@id,@nom);
END
GO
/*INSERCION DE DATOS EN TABLA PROVEEDORES*/
EXEC SPI_proveedores '78662921','Gases industriales SA'
EXEC SPI_proveedores'5109','Casa economico'
EXEC SPI_proveedores'5260','Cochez y compañía SA'
EXEC SPI_proveedores'230391','Pintura sur de Panama'
EXEC SPI_proveedores'78662921*','Almacenes geneva SA'
EXEC SPI_proveedores'gr034','Fausto Salazar SA'
GO

/*creacion de tabla para los tipos de proveedores*/
CREATE TABLE tipo_proveedor(
	id VARCHAR(15),
    FOREIGN KEY (id) REFERENCES proveedores(id),
    descripcion VARCHAR(40)
);
/*INSERCION DE DATOS EN LA TABLA TIPOS DE PROVEEDOR*/
insert into tipo_proveedor values('78662921','cilindros de gases para soldadura');
insert into tipo_proveedor values('5109','Herramienta Electricas'),('5109','Mantenimiento');
insert into tipo_proveedor values('5260','Herramienta Ferreteria'),('5260','accesorio de seguridad');
insert into tipo_proveedor values('230391','Pintura'),('230391','accesoriospara pintar');
insert into tipo_proveedor values('78662921*','Maquinas de soldar'),('78662921*','Accesorios para el soldador');
insert into tipo_proveedor values('gr034','Herramientas electricas'),('gr034','Accesorios de seguridad'),('gr034','ferreteria');


