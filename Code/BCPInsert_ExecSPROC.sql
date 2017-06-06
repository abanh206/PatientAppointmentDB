/****************** [PatientAppointmentsDB_AlanBanh] *********************
 Desc: This file will drop and create the [PatientAppointmentsDB_AlanBanh]
	database, with all its objects. 
Dev: Alan Banh
UWNetID: abanh206
ChangeLog:	<05/30/2017>, Alan Banh, Created the dumby tables to import the data, Imported Clinic Information
			<06/01/2017>, Alan Banh, Created the dumby tables for Doctor and Patients
										Imported the data into tables
			<06/01/2017>, Alan Banh, Create code to delete dumby table
			<06/02/2017>, Alan Banh, Create Appointment dumby table, import the data 
									 Finish inserts into correct table, Backup created
			<06/05/2017>, Alan Banh, Finish Commit and Rollbacks for the Exec of SProcs
 <date>,<Your Name>,Created script for database
**********************************************************/

Use [PatientAppointmentsDB_AlanBanh]
GO

--********************************************************************--
-- Import sample data to dumbie tables to correct tables
--********************************************************************--

-- Clinic Dumby Table

IF OBJECT_ID('Clinic_Table') IS NOT NULL 
	DROP TABLE Clinic_Table
GO

Create Table Clinic_Table (
	ClinicName nVarchar(100) NOT NULL,
	ClinicAddress nVarchar(100) NOT NULL,
	ClinicCity nVarchar(100) NOT NULL,
	ClinicState nVarchar(100) NOT NULL,
	ClinicZip nVarchar(100) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Clinic_Table in "C:\Users\Alan\Documents\PatientAppointmentDB\Data\Clinic_data.csv" -T -c -t "," -r "\n"

Select * from Clinic_Table -- Check for BCP Insert
Delete from Clinics -- Clear for Insert

Insert Into Clinics
Select	ClinicName, 
		ClinicAddress, 
		ClinicCity, 
		ClinicState, 
		ClinicZip 
from Clinic_Table

Select * from Clinics -- Check for Insert

-- Patients Dumby Table

IF OBJECT_ID('Patient_Table') IS NOT NULL 
	DROP TABLE Patient_Table
GO

Create Table Patient_Table (
	PatientFName nVarchar(100) NOT NULL,
	PatientLName nVarchar(100) NOT NULL,
	PatientAddress nVarchar(100) NOT NULL,
	PatientCity nVarchar(100) NOT NULL,
	PatientState nVarchar(100) NOT NULL,
	PatientZip nVarchar(100) NOT NULL,
	PatientPhone nVarchar(100) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Patient_Table IN "C:\Users\Alan\Documents\PatientAppointmentDB\Data\Patient_data.csv" -T -c -t "," -r "\n"

Select * from Patient_Table -- Check for BCP Insert
Delete from Patients -- Clear for Insert

Insert Into Patients
Select	PatientFName,
		PatientLName,
		PatientAddress,
		PatientCity,
		PatientState,
		PatientZip,
		Cast(PatientPhone as nVarchar(20))
From Patient_Table

Select * from Patients -- Check for Insert

-- Doctor Dumby Table

IF OBJECT_ID('Doctor_Table') IS NOT NULL
	DROP TABLE Doctor_Table
GO

Create Table Doctor_Table (
	DoctorFName nVarchar(100) NOT NULL,
	DoctorLName nVarchar(100) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Doctor_Table in "C:\Users\Alan\Documents\PatientAppointmentDB\Data\Doctor_data.csv" -T -c -t "," -r "\n"

Select * from Doctor_Table -- Check for BCP Insert
Delete from Doctors -- Clear for Insert

Insert Into Doctors
Select	DoctorFName,
		DoctorLName
from Doctor_Table

Select * from Doctors -- Check for Insert

-- Appointment Dumby Table

IF OBJECT_ID('Appointment_Table') IS NOT NULL
	DROP TABLE Appointment_Table
GO

Create Table Appointment_Table (
	PatientID nVarchar(100) NOT NULL,
	DoctorID nVarchar(100) NOT NULL,
	ClinicID nVarchar(100) NOT NULL,
	AppointmentTime nVarchar(100) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Appointment_Table in "C:\Users\Alan\Documents\PatientAppointmentDB\Data\Appointment_data.csv" -T -c -t "," -r "\n"

Select * from Appointment_Table -- Check for BCP Insert
Delete from Appointments -- Clear for Insert

Insert Into Appointments
Select	Cast(PatientID as int),
		Cast(DoctorID as int),
		Cast(ClinicID as int),
		Cast(AppointmentTime as datetime)
from Appointment_Table

Select * from Appointments -- Check for Insert


--********************************************************************--
-- Validation and Execution wtih Stored Procedures
--********************************************************************--

DECLARE @ErrorNumber int
BEGIN TRANSACTION
  EXEC @ErrorNumber = pInsAppointment '1', '2', '3', '20170909 18:12:11'
  IF @ErrorNumber = 100
    COMMIT TRANSACTION
  ELSE
    ROLLBACK TRANSACTION
SELECT @ErrorNumber
Go

--CLINICS INS
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pInsClinic 'Westside', '123 True St.', 'Bgame', 'CA', '94010';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vClinics


--CLINICS UPD
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pUpdClinic 'Westside', '123 True St.', 'Bgame', 'CA', '94010', 
									'Eastside', '123 True St.', 'Burlingame', 'CA', '94010';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vClinics


--CLINICS DEL
DECLARE @errornumber int = -100
	BEGIN TRANSACTION
	Exec @errornumber = pDelClinic 'Westside', '123 True St.', 'Bgame', 'CA', '94010'
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vClinics


--PATIENT INS
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pInsPatient 'Martha', 'asdf', '123 ast at.', 'seattle', 'WA', '94010', '123124312';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vPatients


--PATIENT UPD
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pUpdPatient 'Martha', 'S', '123 ast at.', 'seattle', 'WA', '94010', '123124312',
									'Martha', 'Smith', '123 ast at.', 'Seattle', 'WA', '94010', '12314312'
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vPatients


--PATIENT DEL
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pDelPatient 'Martha', 'Smith', '123 ast at.', 'Seattle', 'WA', '94010', '12314312';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vPatients


--DOCTOR INS
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pInsDoctor 'Miranda', 'Gonzales';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vDoctors


--DOCTOR UPD
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pUpdDoctor 'Miranda', 'Gonzales',
									'Miranda', 'Guidina';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vDoctors

--DOCTOR DEL
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pDelDoctor 'Miranda', 'Guidina';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vDoctors


--APPOINTMENT INS
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pInsAppointment '2', '1', '4', '20170808 18:12:00';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vAppointments

--APPOINTMENT UPD
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pUpdAppointment '2', '1', '4', '20170808 18:12:00',
										'3', '1', '2', '20170808 18:30:00';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vAppointments

--APPOINTMENT DEL
DECLARE @errornumber int
	BEGIN TRANSACTION
	Exec @errornumber = pDelAppointment '3', '1', '2', '20170808 18:30:00';
		if @errornumber = 100
			commit tran
		else
			rollback tran
	select @errornumber
Go
Select * from vAppointments

--********************************************************************--
-- Backup database
--********************************************************************--

Backup
Database PatientAppointmentsDB_AlanBanh
To Disk ='C:\Data\PatientAppointmentsDB_AlanBanh_Full.bak'
GO