use healthin;
 TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    BloodType VARCHAR(5),
    MedicalCondition VARCHAR(100),
    Age_bin VARCHAR(20)
);
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100)
);
CREATE TABLE Hospitals (
    HospitalID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100)
);
CREATE TABLE Insurance (
    InsuranceID INT AUTO_INCREMENT PRIMARY KEY,
    ProviderName VARCHAR(100)
);
CREATE TABLE Medications (
    MedicationID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100)
);
CREATE TABLE TestResults (
    TestResultID INT AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(50)
);
CREATE TABLE Admissions (
    AdmissionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    HospitalID INT,
    InsuranceID INT,
    MedicationID INT,
    TestResultID INT,
    DateOfAdmission DATE,
    DischargeDate DATE,
    BillingAmount DECIMAL(10, 2),
    AdmissionType VARCHAR(20),
    LengthOfStay INT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (HospitalID) REFERENCES Hospitals(HospitalID),
    FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID),
    FOREIGN KEY (TestResultID) REFERENCES TestResults(TestResultID)
);


INSERT INTO Patients (Name, Age, Gender, BloodType, MedicalCondition, Age_bin)
SELECT DISTINCT 
    `Name`, `Age`, `Gender`, `Blood Type`, `Medical Condition`, `Age_bin`
FROM new_healthcare_dataset;


INSERT INTO Doctors (Name)
SELECT DISTINCT Doctor
FROM new_healthcare_dataset;


INSERT INTO Hospitals (Name)
SELECT DISTINCT Hospital
FROM new_healthcare_dataset;


INSERT INTO Insurance (ProviderName)
SELECT DISTINCT `Insurance Provider`
FROM new_healthcare_dataset;


INSERT INTO Medications (Name)
SELECT DISTINCT Medication
FROM new_healthcare_dataset;

INSERT INTO TestResults (Description)
SELECT DISTINCT `Test Results`
FROM new_healthcare_dataset;


INSERT INTO Admissions (
    PatientID,
    DoctorID,
    HospitalID,
    InsuranceID,
    MedicationID,
    TestResultID,
    DateOfAdmission,
    DischargeDate,
    BillingAmount,
    AdmissionType,
    LengthOfStay
)
SELECT 
    p.PatientID,
    d.DoctorID,
    h.HospitalID,
    i.InsuranceID,
    m.MedicationID,
    t.TestResultID,
    n.`Date of Admission`,
    n.`Discharge Date`,
    CAST(n.`Billing Amount` AS DECIMAL(10, 2)),
    n.`Admission Type`,
    n.`Length of Stay`
FROM 
    new_healthcare_dataset n
JOIN 
    Patients p ON n.Name = p.Name
JOIN 
    Doctors d ON n.Doctor = d.Name
JOIN 
    Hospitals h ON n.Hospital = h.Name
JOIN 
    Insurance i ON n.`Insurance Provider` = i.ProviderName
JOIN 
    Medications m ON n.Medication = m.Name
JOIN 
    TestResults t ON n.`Test Results` = t.Description
SELECT 
    p.Name AS PatientName, 
    p.Age, 
    p.BloodType, 
    a.DateOfAdmission, 
    a.DischargeDate, 
    a.BillingAmount, 
    h.Name AS HospitalName, 
    d.Name AS DoctorName
FROM 
    Admissions a
JOIN 
    Patients p ON a.PatientID = p.PatientID
JOIN 
    Hospitals h ON a.HospitalID = h.HospitalID
JOIN 
    Doctors d ON a.DoctorID = d.DoctorID
WHERE 
    a.BillingAmount > 5000
ORDER BY 
    a.BillingAmount DESC
LIMIT 10;

show tables;
    

   

