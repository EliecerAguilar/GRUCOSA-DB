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

CREATE PROCEDURE SPI_tipo_proveedor(@id VARCHAR(15),@descr VARCHAR(40))AS
BEGIN
        INSERT INTO tipo_proveedor VALUES(@id,@descr);
END
GO

/*INSERCION DE DATOS EN LA TABLA TIPOS DE PROVEEDOR*/
EXEC SPI_tipo_proveedor '78662921','cilindros de gases para soldadura'
EXEC SPI_tipo_proveedor '5109','Herramienta Electricas'
EXEC SPI_tipo_proveedor  '5109','Mantenimiento'
EXEC SPI_tipo_proveedor '5260','Herramienta Ferreteria'
EXEC SPI_tipo_proveedor  '5260','accesorio de seguridad'
EXEC SPI_tipo_proveedor '230391','Pintura'
EXEC SPI_tipo_proveedor  '230391','accesoriospara pintar'
EXEC SPI_tipo_proveedor '78662921*','Maquinas de soldar'
EXEC SPI_tipo_proveedor  '78662921*','Accesorios para el soldador'
EXEC SPI_tipo_proveedor 'gr034','Herramientas electricas'
EXEC SPI_tipo_proveedor 'gr034','Accesorios de seguridad'
EXEC SPI_tipo_proveedor 'gr034','ferreteria'
GO
/*tabla de planillas*/

CREATE TABLE planilla(
	noPlanilla INT PRIMARY  KEY,
    desde DATE,
    hasta DATE,
    diaPago DATE,
    nombreProyecto VARCHAR(40)
);

CREATE PROCEDURE SPI_planilla(@noPlan INT,@desde DATE,@hasta DATE,@diaP DATE,@nomProy VARCHAR(40))AS
BEGIN
        INSERT INTO planilla VALUES(@noPlan,@desde,@hasta,@diaP,@nomProy);
END
GO
/*INSERCION DATOS DE LA TABLA PLANILLA*/
EXEC SPI_planilla 6,' 2014-07-30','2014-08-12','2014-08-16','MINI MALL'
EXEC SPI_planilla 4,'2014-09-24','2014-10-07','2014-10-11','PERLA MAR'
GO

/*CREACION DE LA TABLA DE DATOS DE LA PLANILLA*/
CREATE TABLE datos_planilla(
	numPlanilla INT,
    FOREIGN KEY (numPlanilla) REFERENCES planilla(noPlanilla),
    noEmpleado VARCHAR(11),
    ocupacion VARCHAR(20) default 'CALIFICADO',
    nombre VARCHAR(30),
    apellido VARCHAR(30),
    noSeguro VARCHAR(10),
    cedula VARCHAR(15),/*DATOS A SOLICITAR EN EL PROCEDURE*/    
    sdoFijo FLOAT default NULL,
    RXH FLOAT default 0,
    IR VARCHAR(4) default 'D',
    Dp INT default 0,
    HReg FLOAT default 0,
    HExt FLOAT default 0,
    SalReg FLOAT default 0,
    salExt FLOAT default 0,
    Cdecuc FLOAT default 0,
    Sdeduc FLOAT default 0,
    I_R FLOAT default 0,
    vida FLOAT default 2.25,
    SE FLOAT default 0,
    sindi FLOAT default 0,
    SS FLOAT default 0,
    Descr FLOAT default 0,
    Pprod FLOAT default 0,
    Ausenc FLOAT default NULL,
    SalBruto FLOAT default 0,
    SalNeto FLOAT default 0,
    FOREIGN KEY (cedula) REFERENCES colaboradores(cedula)
);

ALTER PROCEDURE SPI_dat_plan(
    @numPlan INT,@ced VARCHAR(15),@sdoFijo FLOAT =0,@RxH FLOAT = 0,
    @ir VARCHAR(4)='D',@DP INT = 0,@HReg FLOAT=0,@HExt FLOAT=0,
    @salExt FLOAT=0,@Cdeduc FLOAT=0,@Sdeduc FLOAT=0,@I_R FLOAT=0,   
    @descr FLOAT=0,@Pprod FLOAT=0,@aunse FLOAT=0
)AS
BEGIN
        DECLARE @salReg FLOAT =0;
        DECLARE @vida FLOAT =2.25;
        DECLARE @SE FLOAT=0;
        DECLARE @sindi FLOAT=0;
        DECLARE @salB FLOAT =0;
        DECLARE @salN FLOAT =0;
        DECLARE @ss FLOAT=0;

        --CALCULO DE SALARIO NORMAL
        SELECT @salReg = @RxH * @HReg;
        --CALCULO DE SALARIO BRUTO
        SELECT @salB = @salReg + @salExt + @Cdeduc + @Sdeduc;
        --calculo de seguro social
        SELECT @ss = (@salB-@Sdeduc+@Cdeduc)*0.0975;
        --calculo de seguro educativo
        SELECT @SE =(@salB-@Sdeduc+@Cdeduc) *0.0125;
        -- calculo descuento de sindicato
        SELECT @sindi = (@salB-@Sdeduc+@Cdeduc) * 0.02;
        --calculo de salario neto
        SELECT @salN = @salB -@ss-@sindi-@SE-@vida;

        INSERT INTO datos_planilla SELECT @numPlan,C.noEmpleado,C.ocupacion,C.nombre,
        C.apellido,C.noSeguro,@ced,NULL,@RxH,@ir,@DP,@HReg,@HExt,@salReg,@salExt,
        @Cdeduc,@Sdeduc,@I_R,@vida,@SE,@sindi,@SS,@descr,@Pprod,@aunse,@salB,@salN
        FROM colaboradores AS C WHERE C.cedula = @ced;


END
GO
--exec planilla, cedula,salariofijo,pagoxhora,ir,dp,horaregular,horaextras,salextra,condeduc,sindeduc,i/r,desc,pprod,ausen
EXEC SPI_dat_plan 4,'08-00700-000980',DEFAULT,5,DEFAULT,0,70,3,18.76,0,80
EXEC SPI_dat_plan 4,'08-00303-000530',DEFAULT,4,DEFAULT,0,79,6,30
EXEC SPI_dat_plan 4,'08-00748-000814',DEFAULT,4,DEFAULT,0,77,4,20
EXEC SPI_dat_plan 4,'08-00340-000619',DEFAULT,3,DEFAULT,0,69.50,0,0,0
EXEC SPI_dat_plan 4,'08-00881-000230',DEFAULT,3,DEFAULT,0,55.50,0,0,0,48
EXEC SPI_dat_plan 4,'08-00701-001844',DEFAULT,4,DEFAULT,0,70.50,3,15,0,64
EXEC SPI_dat_plan 4,'08-00365-000108',DEFAULT,4,DEFAULT,0,63,2,10
GO

/*----------------------------------------------------------------------------------------------------------------------------------------------*/
EXEC SPI_dat_plan 6,'09-00102-000049',DEFAULT,4,DEFAULT,0,93,16,80
EXEC SPI_dat_plan 6,'09-00734-002480',DEFAULT,4,DEFAULT,0,85,20,108.5
EXEC SPI_dat_plan 6,'08-00768-000667',DEFAULT,4,DEFAULT,0,93,24,145
EXEC SPI_dat_plan 6,'04-00242-001004',DEFAULT,4,DEFAULT,0,93,28,165,0,67	
EXEC SPI_dat_plan 6,'09-00744-001365',DEFAULT,3,DEFAULT,0,93,28,123.76
EXEC SPI_dat_plan 6,'08-00912-001367',DEFAULT,3,DEFAULT,0,93,26,116.26
EXEC SPI_dat_plan 6,'08-00710-000488',DEFAULT,4,DEFAULT,0,93,16,80
EXEC SPI_dat_plan 6,'08-00904-002049',DEFAULT,3,DEFAULT,0,85,21,97.13
GO

/*----------------------------------------------------------------------------------------------------------------------------------------------*/

/*MUESTRA SOLO LA PLANILLA DE EL NUMERO DE PLANILLA INGRESADO*/
CREATE VIEW planillas AS SELECT * FROM datos_planilla;

CREATE PROCEDURE mostrar_planilla(@noPlanilla INT)AS
BEGIN
		select * from planillas AS P where P.numPlanilla=@noPlanilla;
END
GO

/*VISTA PARA MOSTRAR CUALQUIR TIPO DE PROVEEDOR REGISTRADO*/
CREATE VIEW proved AS SELECT P.nombre, P.id AS numero_de_cuenta, T.descripcion FROM proveedores AS P
INNER JOIN tipo_proveedor AS T ON P.id = T.id;

CREATE PROCEDURE mostrar_proveedor(@tipo_proveedor VARCHAR(40))AS
BEGIN
		SELECT * FROM proved AS P where P.descripcion like'%'+(@tipo_proveedor)+'%';
END
GO


/*view de candidatos se muestran segun el tipo de ocupacion o la cedula*/
create view tip_cand as select * from candidatos;

CREATE PROCEDURE tipo_candidatos(@ocupacion VARCHAR(20) = NULL,@ced VARCHAR(15) = NULL)AS
BEGIN
		SELECT * FROM tip_cand WHERE (tip_cand.ocupacion LIKE '%'+(@ocupacion)+'%') OR (tip_cand.cedula LIKE '%'+(@ced)+'%') ;
END
GO


/*vista solo para el proyecto green garden*/
CREATE VIEW adendas_desc AS SELECT * FROM descripcion_adendas;

CREATE PROCEDURE ad_desc(@cod_adenda VARCHAR(10))AS
BEGIN
		SELECT descripcion,cantidad,unidad,codigo AS codigo_del_producto,costo_unitario,total_presupuesto 
		FROM adendas_desc where cod_adenda LIKE '%'+(@cod_adenda)+'%';
END
GO

CREATE VIEW proyec_ingenieria AS SELECT * FROM proyectos;

CREATE PROCEDURE proy_descr(@nomProyec VARCHAR(40)) AS
BEGIN
		SELECT P.nombre_proyecto, P.descripcion_proyecto,P.descripcion_proyecto,P.fecha_inicio,P.fecha_fin,P.status_proyecto AS Estatus,P.multa FROM proyec_ingenieria AS P
		WHERE P.nombre_proyecto LIKE '%'+(@nomProyec)+'%';
END
GO

--create view todoAdendas as SELECT * FROM adendas; #humm .....
