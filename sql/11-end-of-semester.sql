UPDATE academic.Courses
SET PassingScore = 65
WHERE DepartmentId = (
    SELECT Id
    FROM academic.Departments
    WHERE Code = 'DSAI'
);

UPDATE delivery.Enrollments
SET FinalGrade =
    CASE
        WHEN FinalScore >= 90 THEN 'A'
        WHEN FinalScore >= 80 THEN 'B'
        WHEN FinalScore >= 70 THEN 'C'
        WHEN FinalScore >= 60 THEN 'D'
        ELSE 'F'
    END
WHERE FinalScore IS NOT NULL;

DELETE FROM [identity].[Roles]
WHERE Name = 'Teaching Assistant';



CREATE TABLE dbo.PaymentStaging
(
    PaymentId INT,
    StudentId INT,
    Amount DECIMAL(10,2)
);

INSERT INTO dbo.PaymentStaging
VALUES
(1, 101, 500),
(2, 102, 750),
(3, 103, 1000);

TRUNCATE TABLE dbo.PaymentStaging;


DROP TABLE IF EXISTS dbo.LargeTable;
DROP TABLE IF EXISTS dbo.PaymentStaging;