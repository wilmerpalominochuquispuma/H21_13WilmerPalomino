USE MASTER;
GO
/*Eliminar la base de datos conferencias*/
DROP database IF EXISTS CONFERENCIAS;

/*Crear la base de datos conferencias*/
CREATE DATABASE CONFERENCIAS;
GO

/* Poner en uso la base de datos conferencias */
USE  CONFERENCIAS;
GO
/* Tabla: CONFERENCIA */
CREATE TABLE CONFERENCIA (
    CODCONF int  NOT NULL IDENTITY(1,1),
    NOMCONF varchar(50)  NOT NULL,
    NOMPRICONF varchar(40)  NOT NULL,
    NOMSEGCONF varchar(40)  NOT NULL,
    PRECONF int  NOT NULL,
    DESCONF varchar(60)  NOT NULL,
    FECCONF date  NOT NULL,
    ESTCONF char(1)  NOT NULL DEFAULT 'A',
    CONSTRAINT CONFERENCIA_pk PRIMARY KEY  (CODCONF)
);

SELECT * FROM CONFERENCIA
GO

/* Tabla: CONFERENCIA_DETALLE */
CREATE TABLE CONFERENCIA_DETALLE (
    CODCONDET int  NOT NULL IDENTITY(1,1),
    CODCONF int  NOT NULL,
    DESCONDET varchar(60)  NOT NULL,
    ACUCONDET int  NOT NULL,
    MONCONDET int  NOT NULL,
    CONSTRAINT CONFERENCIA_DETALLE_pk PRIMARY KEY  (CODCONDET)
);

/* Tabla: PAGO */
CREATE TABLE PAGO (
    CODPAG int  NOT NULL IDENTITY(1,1),
    FECPAG date  NOT NULL,
    CANPAG int  NOT NULL,
    MONPAG int  NOT NULL,
    CODCLI int  NOT NULL,
    CODCONF int  NOT NULL,
    CONSTRAINT PAGO_pk PRIMARY KEY  (CODPAG)
);

/* Tabla: PERSONA */
CREATE TABLE CLIENTE (
    CODCLI int  NOT NULL IDENTITY(1,1),
    NOMCLI varchar(20)  NOT NULL,
    APECLI varchar(20)  NOT NULL,
    PASCLI varchar(16)  NOT NULL,
    EMACLI varchar(40)  NOT NULL,
	DIRCLI varchar(50) not null,
    DNICLI char(8)  NOT NULL,
    CELCLI char(9)  NOT NULL,
    ESTCLI char(1)  NOT NULL DEFAULT 'A',
    ROLCLI char(1)  NOT NULL,
    CLIENTE_CODCLI int  NULL,
    CONSTRAINT CLIENTE_pk PRIMARY KEY  (CODCLI)
);

SELECT * FROM CLIENTE
GO

/* CREANDO RELACIONES DE LAS TABLAS */
/* Reference: CONFERENCIA_DETALLE_CONFERENCIAS (table: CONFERENCIA_DETALLE) */ 
ALTER TABLE CONFERENCIA_DETALLE ADD CONSTRAINT CONFERENCIA_DETALLE_CONFERENCIA
    FOREIGN KEY (CODCONF)
    REFERENCES CONFERENCIA (CODCONF);
GO

/* Reference: PAGO_CONFERENCIA (table: PAGO) */
ALTER TABLE PAGO ADD CONSTRAINT PAGO_CONFERENCIA
    FOREIGN KEY (CODCONF)
    REFERENCES CONFERENCIA (CODCONF);
GO

/* Reference: PAGO_CLIENTE (table: PAGO) */
ALTER TABLE PAGO ADD CONSTRAINT PAGO_CLIENTE
    FOREIGN KEY (CODCLI)
    REFERENCES CLIENTE (CODCLI);
GO

/* Reference: CLIENTE_CLIENTE (table: CLIENTE) */
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_CLIENTE
    FOREIGN KEY (CLIENTE_CODCLI)
    REFERENCES CLIENTE (CODCLI);
GO

/* VALIDAR SI HAY ADMINISTRADORES con el mismo DNI */
CREATE OR ALTER PROCEDURE sptAdministrador
(
    @nombre VARCHAR(20),
    @apellido VARCHAR(20),
	@password VARCHAR(16),
	@email varchar(40),
	@direccion varchar(50),
    @dni CHAR(8),
	@celular CHAR(9),
    @estado CHAR(1),
	@rol CHAR(1)
    
)
AS
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(*) FROM dbo.CLIENTE AS V WHERE V.DNICLI = @dni) = 1
                ROLLBACK TRAN
            ELSE
                INSERT INTO dbo.CLIENTE
                (NOMCLI, APECLI,PASCLI, EMACLI,DIRCLI,DNICLI,CELCLI,ESTCLI,ROLCLI)
                VALUES
                (UPPER(@nombre), UPPER(@apellido), @password, @email, @direccion, @dni, @celular, @estado,@rol)
                COMMIT TRAN

        END TRY
        BEGIN CATCH
            SELECT 'Este vendedor ya ha sido registrado.' AS 'ERROR'
                IF @@TRANCOUNT > 0 ROLLBACK TRAN; 
        END CATCH
    END
GO
/* Insertar datos de administradores*/
EXEC sptAdministrador 'PEDRO', 'SANCHEZ', 'QUID1343','ADMIN@GO.COM','JR. PUNO', '72717476','945654234','A','A'
EXEC sptAdministrador 'JULIO', 'SANCHEZ', 'QUID1343','ADMIN@GO.COM','JR. CHINCHA', '37717377','945654234','A','A'
EXEC sptAdministrador 'MARTIN', 'CHAVEZ', 'QUID1343','ADMIN@GO.COM','JR. AREQUIPA', '27717322','945654234','A','A'
EXEC sptAdministrador 'LUCAS', 'FILM', 'QUID1343','ADMIN@GO.COM','JR. CHACHAPOLLAS', '17717372','945654234','A','A'
EXEC sptAdministrador 'SIMON', 'FERNADEZ', 'QUID1343','ADMIN@GO.COM','JR. ICA', '66757362','945654234','A','A'
GO

/* VALIDAR SI EXISTEN PERSONAS INSCRITAS EN LAS CONFERENCIAS CON EL MISMO DNI */
CREATE OR ALTER PROCEDURE sptPersonasInscritas
(
    @nombre VARCHAR(20),
    @apellido VARCHAR(20),
	@password VARCHAR(16),
	@email varchar(40),
	@direccion varchar(50),
    @dni CHAR(8),
	@celular CHAR(9),
    @estado CHAR(1),
	@rol CHAR(1),
	@identificadorPersonal int 
)
AS
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(*) FROM dbo.CLIENTE AS V WHERE V.DNICLI = @dni) = 1
                ROLLBACK TRAN
            ELSE
                INSERT INTO dbo.CLIENTE
                (NOMCLI, APECLI,PASCLI, EMACLI,DIRCLI,DNICLI,CELCLI,ESTCLI,ROLCLI,CLIENTE_CODCLI)
                VALUES
                (UPPER(@nombre), UPPER(@apellido), @password, @email, @direccion, @dni, @celular, @estado,@rol,@identificadorPersonal)
                COMMIT TRAN

        END TRY
        BEGIN CATCH
            SELECT 'Este vendedor ya ha sido registrado.' AS 'ERROR'
                IF @@TRANCOUNT > 0 ROLLBACK TRAN; 
        END CATCH
    END
GO
/* INSERCION DE DATOS*/
EXEC sptPersonasInscritas 'MARIANA', 'MANRIQUE', 'QUID1343','user1@GO.COM','JR. moquegua', '62227476','945654234','A','P','1'
EXEC sptPersonasInscritas 'WILLY', 'PINO', 'Mala','user2@GO.COM','JR. parteos', '47733377','945654234','A','P','1'
EXEC sptPersonasInscritas 'BRIHANA', 'RIOS', 'Imper123','user3@GO.COM','JR. MARCAHUASI', '17744322','945654234','A','P','2'
EXEC sptPersonasInscritas 'MELISSA', 'FERNANDEZ', 'Justin12','user5@GO.COM','JR. CHIN', '67733372','945654234','A','P','1'
EXEC sptPersonasInscritas 'THALIA', 'CAMPOS', 'Martfff','user22@GO.COM','JR. AYACY', '16717362','945654234','A','P','4'
GO

/* Procedimiento Almacenado para insertar conferencias sin que se repita el nombre de las conferencias*/
CREATE OR ALTER PROCEDURE spInsertConf
    (
		@nombreConf VARCHAR(50),
		@NombrePrimero VARCHAR(40),
		@NombreSegundo VARCHAR(40),
		@PrecioConferencia int,
        @descripcionConf VARCHAR(60),
        @FechaConf date,
        @estadoConf CHAR(1)
    )
AS
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
        BEGIN TRAN;
            SET DATEFORMAT dmy
            IF (SELECT COUNT(*) FROM dbo.CONFERENCIA AS P WHERE P.NOMCONF = @nombreConf) = 1
                ROLLBACK TRAN;
            ELSE
                INSERT INTO dbo.CONFERENCIA
               (NOMCONF, NOMPRICONF, NOMSEGCONF, PRECONF, DESCONF, FECCONF,ESTCONF)
                VALUES
               (UPPER(@nombreConf),UPPER(@NombrePrimero),UPPER(@NombreSegundo), @PrecioConferencia, @descripcionConf, @FechaConf, @estadoConf)
               COMMIT TRAN;
        END TRY
        BEGIN CATCH
            SELECT 'El producto ya existe.' AS 'ERROR'
            IF @@TRANCOUNT > 0 ROLLBACK TRAN; 
        END CATCH
    END
GO
EXEC spInsertConf 'Ciberseguridad', 'JUAN CALDERON', 'THALIA CAMPOS', '40', 'MEDIO AMBIENTE Y DESARROLLO', '2021-12-04','A'
EXEC spInsertConf 'Transformación Digital', 'MARCIAL ANDERSON', 'XIOMARA MEZA', '40', 'JAVA Y OTROS', '2021-12-05','A'
EXEC spInsertConf 'Desarrollo de Software Empresarial', 'EDWIN FELIPE', 'MIRTHA LLANOS', '40', 'NUEVOS PARADIGMAS', '2021-12-05','A'
EXEC spInsertConf 'conferencia 4', 'ALICIA MONTOYA', 'FRANKLIN CESPEDES', '40', 'NUEVAS TECNOLOGIAS', '2021-12-05','A'
GO

INSERT INTO PAGO (FECPAG,CANPAG,MONPAG,CODCLI,CODCONF)
VALUES	('2021-12-05','40','30','1','1'),
		('2021-12-05','40','10','2','3'),
		('2021-12-05','40','20','1','2'),
		('2021-12-05','40','35','2','1');
GO

INSERT INTO CONFERENCIA_DETALLE(CODCONF,DESCONDET,ACUCONDET,MONCONDET)
VALUES	('1','GASTOS ADMINISTRATIVOS','80','60'),
		('2','GASTOS EXTRAS','90','50'),
		('3','EXTRAS','40','30'),
		('4','DETALLES','50','90');
GO

SELECT * FROM CONFERENCIA
GO

SELECT * FROM CLIENTE
GO

/*CREAR VISTA PAGO*/
CREATE OR ALTER  VIEW V_PAGO as
SELECT CODPAG,CANPAG,MONPAG,FECPAG,CONCAT(CLIENTE.NOMCLI,' ',CLIENTE.APECLI)AS PERPAG,CONFERENCIA.NOMCONF,CONFERENCIA.CODCONF,CLIENTE.CODCLI FROM PAGO
inner join CLIENTE ON PAGO.CODPAG= CLIENTE.CODCLI
inner join CONFERENCIA ON PAGO.CODPAG= CONFERENCIA.CODCONF;
GO

/*CREAR VISTA CLIENTE */
CREATE  OR ALTER VIEW V_CLIENTE as
select ROW_NUMBER() OVER( ORDER BY super.CODCLI desc) AS FILA, SUPER.CODCLI,
super.NOMCLI,super.APECLI,super.PASCLI,
super.EMACLI,super.DIRCLI,super.DNICLI,super.CELCLI,
super.ROLCLI,super.ESTCLI ,CONCAT(infer.NOMCLI,' ',infer.APECLI)
as RELACION  from CLIENTE  as super
left join CLIENTE as infer on super.CLIENTE_CODCLI =infer.CODCLI;
GO

/* FUNCION */
CREATE OR ALTER FUNCTION  SaldoCuota
( 
@idConferencia integer,
@idCLIENTE integer
)
RETURNS integer
    as 
	
    BEGIN
        declare @monto int;
		declare @acu int;
		select @acu = isnull(sum(MONPAG),0) from PAGO where CODCONF=@idConferencia and CODCLI = @idCLIENTE;
		select @monto =PRECONF from CONFERENCIA where CODCONF=@idConferencia;
        RETURN @monto - @acu;
    END
	GO

	/* SELECT dbo.SaldoCuota(1,1) ;*/
