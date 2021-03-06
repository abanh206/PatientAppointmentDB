/****************** [PatientAppointmentsDB_AlanBanh] *********************
 Desc: This file will drop and create the [PatientAppointmentsDB_AlanBanh]
	database, with all its objects. 
Dev: Alan Banh
UWNetID: abanh206
ChangeLog:	<05/25/2017> Alan Banh, Created Clinics Table, Procedures, Views, Restrictions,
			<05/28/2017> Alan Banh, Created Patients Table, Procedures, Views, Restrictions
			<05/29/2017> Alan Banh, Created Doctor Table, Procedures, Views, Restrictions
			<05/29/2017> Alan Banh, Created Appointment Table, Procedures, Views, Restrictions
			<05/30/2017> Alan Banh, Created Report View, Fix Updates and Deletes Stored Procedures
			<06/01/2017> Alan Banh, Worked on creating the check sprocs
			<06/05/2017> Alan Banh, SProc Error Handling Finished
 <date>,<Your Name>,Created script for database
**********************************************************/

USE [master]
GO
If Exists (Select * from Sysdatabases Where Name = 'PatientAppointmentsDB_AlanBanh')
	Begin 
		ALTER DATABASE [PatientAppointmentsDB_AlanBanh] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE [PatientAppointmentsDB_AlanBanh]
	End
GO

Create Database [PatientAppointmentsDB_AlanBanh]
GO

--********************************************************************--
-- Create the Tables
--********************************************************************--
USE [PatientAppointmentsDB_AlanBanh]
GO

/****** [dbo].[Clinics] ******/
Create Table [dbo].[Clinics] (
	ClinicID int NOT NULL Primary Key identity(1, 1),
	ClinicName nVarchar(100) NOT NULL,
	ClinicAddress nVarchar(100) NOT NULL,
	ClinicCity nVarchar(100) NOT NULL,
	ClinicState nVarchar(100) NOT NULL,
	ClinicZip nVarchar(100) NOT NULL
)
GO

/****** [dbo].[Patients] ******/
Create Table [dbo].[Patients] (
	PatientID int NOT NULL Primary Key identity(1, 1),
	PatientFName nVarchar(100) NOT NULL,
	PatientLName nVarchar(100) NOT NULL,
	PatientAddress nVarchar(100) NOT NULL,
	PatientCity nVarchar(100) NOT NULL,
	PatientState nVarchar(100) NOT NULL,
	PatientZip nVarchar(100) NOT NULL,
	PatientPhone nVarchar(20) NOT NULL
	CONSTRAINT [UQ_PatientInfo] UNIQUE NONCLUSTERED
	(
		[PatientFName], [PatientLName], [PatientPhone]
	)
)
GO

/****** [dbo].[Doctors] ******/
Create Table [dbo].[Doctors] (
	DoctorID int NOT NULL Primary Key identity(1, 1),
	DoctorFName nVarchar(100) NOT NULL,
	DoctorLName nVarchar(100) NOT NULL,
	CONSTRAINT [UQ_DoctorInfo] UNIQUE NONCLUSTERED
	(
		[DoctorFName], [DoctorLName]
	)
)
GO

/****** [dbo].[Appointments] ******/
Create Table [dbo].[Appointments] (
	AppointmentID int NOT NULL Primary Key identity(1, 1),
	PatientID int FOREIGN KEY REFERENCES Patients(PatientID),
	DoctorID int FOREIGN KEY REFERENCES Doctors(DoctorID),
	ClinicID int FOREIGN KEY REFERENCES Clinics(ClinicID),
	AppointmentTime datetime NOT NULL,
	CONSTRAINT [UQ_AppointmentInfo] UNIQUE NONCLUSTERED
	(
		[DoctorID], [ClinicID], [AppointmentTime]
	)
)
GO

--********************************************************************--
-- Create the Views
--********************************************************************--

-- View all Clinics
-- Looks as though the view on the patient's application reveals only 
-- names of the clinics
Create View vClinics AS
	Select ClinicName from [Clinics]
GO

-- In the picture it does not display the phone number, therefore I left it out of the view
Create View vPatients AS
	Select PatientID, PatientFName, PatientLName, PatientAddress, PatientCity, PatientZip from [Patients]
GO

Create View vDoctors AS
	Select * from [Doctors]
GO

Create View vAppointments AS
	Select * from [Appointments]
GO

-- REPORTING VIEW
Create View vReportingAppointments AS
	Select C.[ClinicName] AS 'Clinic',
	 A.[AppointmentTime] AS 'Time', 
	 P.[PatientFName] + ' ' + P.PatientLName AS 'Patient', 
	 D.[DoctorFName] + ' ' + D.[DoctorLName] AS 'Doctor'
	FROM Appointments AS A JOIN Patients AS P ON A.PatientID = P.PatientID
	JOIN Clinics as C ON A.ClinicID = C.ClinicID
	JOIN Doctors as D ON A.DoctorID = D.DoctorID
GO
 
--********************************************************************--
-- Create the Procedures for Inserts & Updates
--********************************************************************--

-- Clinics Insert
Create Proc pInsClinic (
	@ClinicName nVarchar(100),
	@ClinicAddress nVarchar(100),
	@ClinicCity nVarchar(100),
	@ClinicState nVarchar(100),
	@ClinicZip nVarchar(100)
)
As 
DECLARE @ErrorNumber int
	Begin try
		Begin Tran
			Insert Into [dbo].[Clinics](
				ClinicName,
				ClinicAddress,
				ClinicCity,
				ClinicState,
				ClinicZip
			) 
			Values (
				@ClinicName,
				@ClinicAddress,
				@ClinicCity,
				@ClinicState,
				@ClinicZip
			)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
	Begin Catch
		Rollback Tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO


-- Clinics Update
Create Proc pUpdClinic (
	@OldClinicName nvarchar(100),
	@OldClinicAddress nVarchar(100),
	@OldClinicCity nVarchar(100),
	@OldClinicState nVarchar(100),
	@OldClinicZip nVarchar(100),
	@NewClinicName nvarchar(100),
	@NewClinicAddress nVarchar(100),
	@NewClinicCity nVarchar(100),
	@NewClinicState nVarchar(100),
	@NewClinicZip nVarchar(100)
)
As 
Declare @ErrorNumber int
	Begin try
		Begin Tran
			Update [dbo].[Clinics] 
			Set 
				ClinicName = @NewClinicName,
				ClinicAddress = @NewClinicAddress,
				ClinicCity = @NewClinicCity,
				ClinicState = @NewClinicState,
				ClinicZip = @NewClinicZip
			Where 
				(ClinicName = @OldClinicName) and
				(ClinicAddress = @OldClinicAddress) and
				(ClinicCity = @OldClinicCity) and
				(ClinicState = @OldClinicState) and
				(ClinicZip = @OldClinicZip)
		Commit Tran
		Set @ErrorNumber = 100
	End try
	Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Clinics Delete
Create Proc pDelClinic (
	@ClinicName nvarchar(100),
	@ClinicAddress nVarchar(100),
	@ClinicCity nVarchar(100),
	@ClinicState nVarchar(100),
	@ClinicZip nVarchar(100)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Delete from [dbo].[Clinics]
			Where 
				(ClinicName = @ClinicName) and
				(ClinicAddress = @ClinicAddress) and
				(ClinicCity = @ClinicCity) and
				(ClinicState = @ClinicState) and
				(ClinicZip = @ClinicZip)
		Commit Tran
	End Try
	Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Patient Insert
Create Proc pInsPatient (
	@PatientFName nVarchar(100),
	@PatientLName nVarchar(100),
	@PatientAddress nVarchar(100),
	@PatientCity nVarchar(100),
	@PatientState nVarchar(100),
	@PatientZip nVarchar(100),
	@PatientPhone nVarchar(15)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Insert Into [dbo].[Patients](
				PatientFName,
				PatientLName,
				PatientAddress,
				PatientCity,
				PatientState,
				PatientZip,
				PatientPhone
			) 
			Values (
				@PatientFName,
				@PatientLName,
				@PatientAddress,
				@PatientCity,
				@PatientState,
				@PatientZip,
				@PatientPhone
			)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
	Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Patients Update
Create Proc pUpdPatient (
	@OldPatientFName nVarchar(100),
	@OldPatientLName nVarchar(100),
	@OldPatientAddress nVarchar(100),
	@OldPatientCity nVarchar(100),
	@OldPatientZip nVarchar(100),
	@OldPatientPhone nVarchar(15),
	@NewPatientFName nVarchar(100),
	@NewPatientLName nVarchar(100),
	@NewPatientAddress nVarchar(100),
	@NewPatientCity nVarchar(100),
	@NewPatientZip nVarchar(100),
	@NewPatientPhone nVarchar(15)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Update [dbo].[Patients] 
			Set 
				PatientFName = @NewPatientFName,
				PatientLName = @NewPatientLName,
				PatientAddress = @NewPatientAddress,
				PatientCity = @NewPatientCity,
				PatientZip = @NewPatientZip,
				PatientPhone = @NewPatientPhone
			Where 
				PatientFName = @OldPatientFName and
				PatientLName = @OldPatientLName and
				PatientAddress = @OldPatientAddress and
				PatientCity = @OldPatientCity and
				PatientZip = @OldPatientZip and
				PatientPhone = @OldPatientPhone
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Patient Delete
Create Proc pDelPatient (
	@PatientFName nVarchar(100),
	@PatientLName nVarchar(100),
	@PatientAddress nVarchar(100),
	@PatientCity nVarchar(100),
	@PatientZip nVarchar(100),
	@PatientPhone nVarchar(15)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Delete [dbo].[Patients] 
			Where 
				PatientFName = @PatientFName and
				PatientLName = @PatientLName and
				PatientAddress = @PatientAddress and
				PatientCity = @PatientCity and
				PatientZip = @PatientZip and
				PatientPhone = @PatientPhone
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Doctor Insert
Create Proc pInsDoctor (
	@DoctorFName nVarchar(100),
	@DoctorLName nVarchar(100)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Insert Into [dbo].[Doctors](
				DoctorFName,
				DoctorLName
			) 
			Values (
				@DoctorFName,
				@DoctorLName
			)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Doctor Update
Create Proc pUpdDoctor (
	@OldDoctorFName nVarchar(100),
	@OldDoctorLName nVarchar(100),
	@NewDoctorFName nVarchar(100),
	@NewDoctorLName nVarchar(100)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Update [dbo].[Doctors] 
			Set 
				DoctorFName = @NewDoctorFName,
				DoctorLName = @NewDoctorLName
			Where 
				(DoctorFName = @OldDoctorFName) and 
				(DoctorLName = @OldDoctorLName)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Doctor Delete
Alter Proc pDelDoctor (
	@DoctorFName nVarchar(100),
	@DoctorLName nVarchar(100)
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Delete [dbo].[Doctors] 
			Where 
				(DoctorFName = @DoctorFName) and 
				(DoctorLName = @DoctorLName)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Checks date time
CREATE PROC pCheckTime
	(@DatetoVerify DateTime)
AS
	DECLARE @ErrorNumber int
	IF @DatetoVerify < GETDATE() 
		BEGIN
			SET @ErrorNumber = -100 -- Appointment date is before current date
		END
	ELSE
		BEGIN
			SET @ErrorNumber = 100 -- Appointment Date is after current date
		END
RETURN @ErrorNumber
GO
-- End of pCheckDateRange


-- Appointment Insert
Create Proc pInsAppointment (
	@PatientID int,
	@DoctorID int,
	@ClinicID int,
	@AppointmentTime datetime
)
As 
Declare @ErrorNumber int
Exec @ErrorNumber = pCheckTime @AppointmentTime

IF @ErrorNumber = -100
	Begin
		Set @ErrorNumber = -100
	End
ELSE IF @ErrorNumber = 100
	Begin
		Insert Into [dbo].[Appointments](
			PatientID,
			DoctorID,
			ClinicID,
			AppointmentTime
		) 
		Values (
			@PatientID,
			@DoctorID,
			@ClinicID,
			@AppointmentTime
		)
Return @ErrorNumber
End
GO

-- Appointment Update
Create Proc pUpdAppointment (
	@OldPatientID int,
	@OldDoctorID int,
	@OldClinicID int,
	@OldAppointmentTime datetime,
	@NewPatientID int,
	@NewDoctorID int,
	@NewClinicID int,
	@NewAppointmentTime datetime
)
As 
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Update [dbo].[Appointments] 
			Set 
				PatientID = @NewPatientID,
				DoctorID = @NewDoctorID,
				ClinicID = @NewClinicID,
				AppointmentTime = @NewAppointmentTime
			Where 
				(PatientID = @OldPatientID) and 
				(DoctorID = @OldDoctorID) and 
				(ClinicID = @OldClinicID) and 
				(AppointmentTime = @OldAppointmentTime)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

-- Appointment Delete
Create Proc pDelAppointment (
	@PatientID int,
	@DoctorID int,
	@ClinicID int,
	@AppointmentTime datetime
)
As
Declare @ErrorNumber int
	Begin Try
		Begin Tran
			Delete from [dbo].[Appointments]
			Where 
				(PatientID = @PatientID) and 
				(DoctorID = @DoctorID) and 
				(ClinicID = @ClinicID) and 
				(AppointmentTime = @AppointmentTime)
		Commit Tran
		Set @ErrorNumber = 100
	End Try
		Begin Catch
		Rollback tran
		Set @ErrorNumber = -100
	End Catch
	Return @ErrorNumber
GO

--********************************************************************--
-- Create the Restrictions
--********************************************************************--

-- Clinic
Deny Select on Clinics to Public
Deny Insert on Clinics to Public
Deny Update on Clinics to Public
Deny Delete on Clinics to Public

-- Patient
Deny Select on Patients to Public
Deny Insert on Patients to Public
Deny Update on Patients to Public
Deny Delete on Patients to Public

-- Doctor
Deny Select on Doctors to Public
Deny Insert on Doctors to Public
Deny Update on Doctors to Public
Deny Delete on Doctors to Public

-- Appointment
Deny Select on Appointments to Public
Deny Insert on Appointments to Public
Deny Update on Appointments to Public
Deny Delete on Appointments to Public

-- vClinic
Grant Select on vClinics to Public

-- vPatient
Grant Select on vPatients to Public

-- vDoctor
Grant Select on vDoctors to Public

-- vAppointment
Grant Select on vAppointments to Public

-- vReportingAppointments
Grant Select on vReportingAppointments to Public

-- Stored Procedures

-- Clinic
Grant Exec on pInsClinic to Public
Grant Exec on pUpdClinic to Public
Grant Exec on pDelClinic to Public

-- Patient
Grant Exec on pInsPatient to Public
Grant Exec on pUpdPatient to Public
Grant Exec on pDelPatient to Public

-- Doctor
Grant Exec on pInsDoctor to Public
Grant Exec on pUpdDoctor to Public
Grant Exec on pDelDoctor to Public

-- Appointment
Grant Exec on pInsAppointment to Public
Grant Exec on pUpdAppointment to Public
Grant Exec on pDelAppointment to Public
