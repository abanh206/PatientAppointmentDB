/****************** [PatientAppointmentsDB_AlanBanh] *********************
 Desc: This file will drop and create the [PatientAppointmentsDB_AlanBanh]
	database, with all its objects. 
Dev: Alan Banh
UWNetID: abanh206
ChangeLog:	<05/30/2017>, Alan Banh, Created the dumby tables to import the data, Imported Clinic Information
			<06/01/2017>, Alan Banh, Created the dumby tables for Doctor and Patients
										Imported the data into tables
			<06/01/2017>, Alan Banh, Create code to delete dumby table, Backup created
 <date>,<Your Name>,Created script for database
**********************************************************/

Use [PatientAppointmentsDB_AlanBanh]
GO

--********************************************************************--
-- Import sample data
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

Select * from Clinic_Table

-- Patients Dumby Table

IF OBJECT_ID('Patient_Table') IS NOT NULL 
	DROP TABLE Patient_Table
GO

Create Table Patient_Table (
	PatientFName nVarchar(2000) NOT NULL,
	PatientLName nVarchar(2000) NOT NULL,
	PatientAddress nVarchar(2000) NOT NULL,
	PatientCity nVarchar(2000) NOT NULL,
	PatientState nVarchar(2000) NOT NULL,
	PatientZip nVarchar(2000) NOT NULL,
	PatientPhone nVarchar(2000) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Patient_Table in "C:\Users\Alan\Documents\PatientAppointmentDB\Data\Patient_data.csv" -T -c -t "," -r "\n"

Select * from Patient_Table

-- Doctor Dumby Table

IF OBJECT_ID('Doctor_Table') IS NOT NULL 
	DROP TABLE Doctor_Table
GO

Create Table Doctor_Table (
	DoctorFName nVarchar(1000) NOT NULL,
	DoctorLName nVarchar(1000) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Doctor_Table in "C:\Users\Alan\Documents\PatientAppointmentDB\Data\Doctor_data.csv" -T -c -t "," -r "\n"

Select * from Doctor_Table

--********************************************************************--
-- Validation and Execution wtih Stored Procedures
--********************************************************************--



--********************************************************************--
-- Backup database
--********************************************************************--

--Backup
--Database PatientAppointmentsDB_AlanBanh
--To Disk ='C:\Data\PatientAppointmentsDB_AlanBanh_Full.bak'
--GO