/****************** [PatientAppointmentsDB_AlanBanh] *********************
 Desc: This file will drop and create the [PatientAppointmentsDB_AlanBanh]
	database, with all its objects. 
Dev: Alan Banh
UWNetID: abanh206
ChangeLog:	<05/30/2017>, Alan Banh, Created the dumby tables to import the data, Imported Clinic Information
			<06/01/2017>, Alan Banh, Created the dumby tables for Doctor and Patients
										Imported the data into tables
 <date>,<Your Name>,Created script for database
**********************************************************/


--********************************************************************--
-- Import sample data
--********************************************************************--

Use [PatientAppointmentsDB_AlanBanh]
GO

-- Drop Table Clinic_Table

Create Table Clinic_Table (
	ClinicID nVarchar(100) NOT NULL,
	ClinicName nVarchar(100) NOT NULL,
	ClinicAddress nVarchar(100) NOT NULL,
	ClinicCity nVarchar(100) NOT NULL,
	ClinicState nVarchar(100) NOT NULL,
	ClinicZip nVarchar(100) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Clinic_Table in "C:\Data\Clinic_Data.csv" -T -c -t "," -r "\n"

-- Drop Table Patient_Table

Create Table Patient_Table (
	PatientID nVarchar(200) NOT NULL,
	PatientFName nVarchar(200) NOT NULL,
	PatientLName nVarchar(200) NOT NULL,
	PatientAddress nVarchar(200) NOT NULL,
	PatientCity nVarchar(200) NOT NULL,
	PatientZip nVarchar(200) NOT NULL,
	PatientPhone nVarchar(200) NOT NULL
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Patient_Table in "C:\Data\Patient_Data.csv" -T -c -t "," -r "\n"

-- Drop Table Doctor_Table

Create Table Doctor_Table (
	DoctorID nVarchar(100) NOT NULL,
	DoctorFName nVarchar(200) NOT NULL,
	DoctorLName nVarchar(200) NOT NULL,
)
GO

!!BCP PatientAppointmentsDB_AlanBanh.dbo.Doctor_Table in "C:\Data\Doctor_Data.csv" -T -c -t "," -r "\n"