USE [BI_Warehouse];
GO

-- Create Dimension Tables First (for FK references)
-- 1. Dim_Date
CREATE TABLE [Dim_Date] (
    [Date_SK] INT PRIMARY KEY,
    [Date] DATE NOT NULL,
    [Jour_semaine] NVARCHAR(10) NOT NULL,
    [Annee_mois] CHAR(7) NOT NULL,
    [Jour_Mois] TINYINT NOT NULL,
    [Nom_Mois] NVARCHAR(10) NOT NULL,
    [Est_Weekend] BIT NOT NULL
);
GO

-- 2. Dim_Temps
CREATE TABLE [Dim_Temps] (
    [Temps_SK] INT PRIMARY KEY,
    [Heure] TIME NOT NULL,
    [Moment_journee] NVARCHAR(20) NOT NULL
);
GO

-- 3. Dim_Emplacement
CREATE TABLE [Dim_Emplacement] (
    [Emplacement_SK] INT IDENTITY(1,1) PRIMARY KEY,
    [Ville] NVARCHAR(100) NOT NULL,
    [Type_magasin] NVARCHAR(50) NOT NULL
);
GO

-- 4. Dim_Type_Incident
CREATE TABLE [Dim_Type_Incident] (
    [Type_SK] INT IDENTITY(1,1) PRIMARY KEY,
    [Type_incident] NVARCHAR(100) NOT NULL,
    [Domaine] NVARCHAR(100) NOT NULL,
    [Sous_domaine] NVARCHAR(100) NULL,
    [Code_cloture] NVARCHAR(50) NULL
);
GO

-- 5. Dim_Statut
CREATE TABLE [Dim_Statut] (
    [Statut_SK] INT IDENTITY(1,1) PRIMARY KEY,
    [Etat_alerte] NVARCHAR(50) NOT NULL,
    [Etat] NVARCHAR(50) NOT NULL
);
GO

-- 6. Dim_Service
CREATE TABLE [Dim_Service] (
    [Service_SK] INT IDENTITY(1,1) PRIMARY KEY,
    [Nom_service] NVARCHAR(100) NOT NULL,
    [Groupe_resolu] NVARCHAR(100) NULL
);
GO

-- Create Fact Table (with all FKs)
CREATE TABLE [Fait_Incidents] (
    [Incident_SK] INT IDENTITY(1,1) PRIMARY KEY,
    [ID_Incident] NVARCHAR(20) NOT NULL,
    
    -- Time Periods
    [Date_ouverture_SK] INT NOT NULL,
    [Temps_ouverture_SK] INT NOT NULL,
    [Date_cloture_SK] INT NULL,
    [Temps_cloture_SK] INT NULL,
    
    -- Measures
    [Duree_Resolution_Heures] DECIMAL(9,2) NULL,
    
    -- Foreign Keys
    [Emplacement_SK] INT NOT NULL,
    [Type_incident_SK] INT NOT NULL,
    [Statut_SK] INT NOT NULL,
    [Service_SK] INT NOT NULL,
    
    -- Degenerate dimension
    [Titre] NVARCHAR(255) NULL,
    
    -- Constraints
    CONSTRAINT FK_DateOuverture FOREIGN KEY ([Date_ouverture_SK]) REFERENCES Dim_Date([Date_SK]),
    CONSTRAINT FK_TempsOuverture FOREIGN KEY ([Temps_ouverture_SK]) REFERENCES Dim_Temps([Temps_SK]),
    CONSTRAINT FK_DateCloture FOREIGN KEY ([Date_cloture_SK]) REFERENCES Dim_Date([Date_SK]),
    CONSTRAINT FK_TempsCloture FOREIGN KEY ([Temps_cloture_SK]) REFERENCES Dim_Temps([Temps_SK]),
    CONSTRAINT FK_Emplacement FOREIGN KEY ([Emplacement_SK]) REFERENCES Dim_Emplacement([Emplacement_SK]),
    CONSTRAINT FK_TypeIncident FOREIGN KEY ([Type_incident_SK]) REFERENCES Dim_Type_Incident([Type_SK]),
    CONSTRAINT FK_Statut FOREIGN KEY ([Statut_SK]) REFERENCES Dim_Statut([Statut_SK]),
    CONSTRAINT FK_Service FOREIGN KEY ([Service_SK]) REFERENCES Dim_Service([Service_SK])
);
GO

-- Add indexes for performance 
CREATE INDEX IX_Fait_Incidents_DateOuverture ON [Fait_Incidents] ([Date_ouverture_SK]);
CREATE INDEX IX_Fait_Incidents_DateCloture ON [Fait_Incidents] ([Date_cloture_SK]);
CREATE INDEX IX_Fait_Incidents_TypeIncident ON [Fait_Incidents] ([Type_incident_SK]);
GO