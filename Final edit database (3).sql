DROP DATABASE IF EXISTS BiomedicalResearchDB;
#Database  project codes:
#1- Create Database
CREATE DATABASE IF NOT EXISTS BiomedicalResearchDB;
USE BiomedicalResearchDB; 
#2-create tables 
CREATE TABLE IF NOT EXISTS Publisher (
    PublisherID INT PRIMARY KEY,
    Name VARCHAR(100),
    PublicationTypes TEXT,
    PaymentMethods TEXT
);
CREATE TABLE IF NOT EXISTS Journal (
    JournalID INT PRIMARY KEY,
    Name VARCHAR(100),
    ImpactFactor FLOAT,
    Volume VARCHAR(50),
    PublicationType VARCHAR(50),
    OpenAccess BOOLEAN,
    PublisherID INT,
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);
CREATE TABLE IF NOT EXISTS Author (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Qualification VARCHAR(50),
    Affiliation VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Research (
    ResearchID INT PRIMARY KEY,
    Title VARCHAR(255),
    Abstract TEXT,
    Date DATE,
    Field VARCHAR(100),
    Citations INT,
    JournalID INT,
    FOREIGN KEY (JournalID) REFERENCES Journal(JournalID)
);

CREATE TABLE IF NOT EXISTS Research_Author (
    ResearchID INT,
    AuthorID INT,
    PRIMARY KEY (ResearchID, AuthorID),
    FOREIGN KEY (ResearchID) REFERENCES Research(ResearchID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE IF NOT EXISTS Author_Field (
    AuthorID INT,
    FieldOfInterest VARCHAR(100),
    PRIMARY KEY (AuthorID, FieldOfInterest),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

#3- INSERT SAMPLE DATA
INSERT IGNORE INTO Publisher (PublisherID, Name, PublicationTypes, PaymentMethods)
VALUES
(1, 'Springer', 'Journals, Books', 'Credit Card, PayPal'),
(2, 'Elsevier', 'Journals', 'Bank Transfer'),
(3, 'Wiley', 'Journals, Books, eBooks', 'Cash, Online Payment');
INSERT IGNORE INTO Journal (JournalID, Name, ImpactFactor, Volume, PublicationType, OpenAccess, PublisherID)
VALUES
(1, 'Nature Immunology', 12.5, 'Vol. 20', 'Monthly', TRUE, 1),
(2, 'Cell Reports', 10.3, 'Vol. 33', 'Quarterly', FALSE, 2),
(3, 'Journal of Genomics', 8.7, 'Vol. 15', 'Annually', TRUE, 1);
INSERT IGNORE INTO Author (AuthorID, Name, Qualification, Affiliation, Email)
VALUES
(1, 'Dr. Sara Ali', 'PhD', 'Cairo University',  'sara@example.com'),
(2, 'Dr. Omar Youssef', 'MD', 'Ain Shams University', 'omar@example.com'),
(3, 'Prof. Mona Hassan', 'PhD', 'Nile University','mona@example.com');
INSERT IGNORE INTO Research (ResearchID, Title, Abstract, Date, Field, Citations, JournalID)
VALUES
(1, 'Immunotherapy in Pediatric Cancer', 'Study on immune treatments in children', '2023-06-10', 'Immunology', 80, 1),
(2, 'Gene Editing in Embryos', 'CRISPR/Cas9 approach', '2022-11-22', 'Genetics', 45, 2),
(3, 'Neurodevelopment and Vitamin D', 'Vitamin D role in brain function', '2023-03-15', 'Neurology', 90, 3);
INSERT IGNORE INTO Research_Author (ResearchID, AuthorID)
VALUES
(1, 1),
(2, 2),
(3, 1),
(3, 3);
INSERT IGNORE INTO Author_Field (AuthorID, FieldOfInterest)
VALUES
(1, 'Immunology'),
(1, 'Neurology'),
(2, 'Genetics'),
(3, 'Neurology');
#4- Sample Queries
 #1. Authors whose research interest is Immunology
SELECT DISTINCT a.Name
FROM Author a
JOIN Author_Field af ON a.AuthorID = af.AuthorID
WHERE af.FieldOfInterest = 'Immunology';

#2. Author with the most citations in 2023
SELECT a.Name, SUM(r.Citations) AS TotalCitations
FROM Author a
JOIN Research_Author ra ON a.AuthorID = ra.AuthorID
JOIN Research r ON ra.ResearchID = r.ResearchID
WHERE YEAR(r.Date) = 2023
GROUP BY a.Name
ORDER BY TotalCitations DESC
LIMIT 1;

#3. Open access journals published by Springer
SELECT j.Name
FROM Journal j
JOIN Publisher p ON j.PublisherID = p.PublisherID
WHERE j.OpenAccess = TRUE AND p.Name = 'Springer';

