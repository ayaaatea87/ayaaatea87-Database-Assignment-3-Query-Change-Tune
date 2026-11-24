-- TASK.2

SELECT * FROM academic.Departments 
    ORDER BY Id ;

INSERT INTO academic.Departments ( Code ,Name ,IsActive ,IsDeleted ,CreatedAtUtc )
VALUES ( 'DSAI' , N'Data Science AND Artificial Intelligence', 1, 0, GETUTCDATE())


SELECT 
 *
FROM academic.Departments
WHERE Code = 'DSAI'

INSERT INTO academic.Courses ( DepartmentId ,Code ,Title ,CreditHours ,PassingScore ,CreatedAtUtc)
VALUES ( 18 , 'DSAI-101' , N'Introduction to Data Analysis' , 3 ,60 ,GETUTCDATE());



-- 2.3

INSERT INTO delivery.AcademicTerms
    (AcademicYear, TermCode, Name, StartDate, EndDate,
     RegistrationStartDate, RegistrationEndDate, Status)
VALUES
    (
        2027,
        'SUMMER',
        'Summer 2027',
        '2027-06-15',
        '2027-08-31',
        '2027-05-01',
        '2027-06-10',
        1
    );

    
-- 2.4

INSERT INTO communication.Announcements
    (SectionId, Title, Body, PublishedAtUtc,
     CreatedByUserId, CreatedAtUtc, Status)
VALUES
    (
        NULL,
        'Summer 2027 Registration',
        'Summer 2027 registration opens on 1 May 2027.',
        GETUTCDATE(),
        304,
        GETUTCDATE(),
        1
    );


    
-- 2.5

INSERT INTO [identity].Roles
    (Code, Name, Description, IsSystem, IsDeleted)
VALUES
    (
        'TA',
        'Teaching Assistant',
        'Teaching Assistant role',
        0,
        0
    );