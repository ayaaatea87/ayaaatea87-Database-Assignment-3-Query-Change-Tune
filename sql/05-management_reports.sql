-- 5.1
SELECT
    Code AS [Course Code],
    Title AS [Course Title],
    CreditHours AS [Credits]
FROM academic.Courses
ORDER BY
    CreditHours DESC,
    Title ASC;

-- 5.2
SELECT TOP 5 *
FROM [identity].StudentProfiles
ORDER BY NEWID();


-- 5.3
SELECT *
FROM [identity].Users
WHERE Email <> TRIM(Email);


-- 5.4
SELECT *
FROM [identity].Users
WHERE Email != lower(Email);

-- 5.5
SELECT *
FROM [identity].Users
WHERE Email NOT LIKE '%@%'
OR Email LIKE '@%' 
OR Email  NOT LIKE '%@%.%'


-- 5.6
SELECT DISTINCT
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Email Provider]
FROM [identity].Users
WHERE Email LIKE '%@%'
ORDER BY [Email Provider] ASC;


-- 5.7
SELECT *
FROM [identity].Users
ORDER BY
    CASE
        WHEN LastLoginAtUtc IS NULL THEN 1
        ELSE 0
    END,
    LastLoginAtUtc DESC;

SELECT * FROM finance.Payments
WHERE CreatedAtUtc >= '2026-10-01' 
       AND CreatedAtUtc < '2026-11-1';

-- 5.9
SELECT
    *,
    CreatedAtUtc AT TIME ZONE 'UTC'
    AT TIME ZONE 'Egypt Standard Time' AS CairoTime
FROM finance.Payments
WHERE DATEPART(HOUR,
    CreatedAtUtc AT TIME ZONE 'UTC'
    AT TIME ZONE 'Egypt Standard Time'
) < 5;

-- 5.10
SELECT  
 SectionId, SessionDate , CreatedAtUtc ,
 DATENAME(WEEKDAY, CreatedAtUtc) AS SessionDay
FROM attendance.AttendanceSessions
WHERE DATENAME(WEEKDAY, CreatedAtUtc) = 'Friday' ;


-- 5.11       010 011 012 015
SELECT 
    PhoneNumber
FROM [identity].Users
WHERE PhoneNumber LIKE '+201[0125]%';


-- 5.12
SELECT
    PhoneNumber,
    CONCAT(
        SUBSTRING(PhoneNumber ,3,3),
               '******',
        RIGHT(PhoneNumber, 2)
    ) AS HiddenPhoneNumber
FROM [identity].Users
WHERE LEN(PhoneNumber) > 5;

-- 5.13
SELECT
    InvoiceNumber,
    CAST(
        RIGHT(
           InvoiceNumber ,
            CHARINDEX('-', REVERSE(InvoiceNumber)) - 1
        ) AS INT
    ) AS RunningNumber
FROM finance.Invoices
WHERE TermId = 12 AND StudentId = 84939 
ORDER BY RunningNumber ASC;


-- 5.14
SELECT
    Title,
    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not set'
        ELSE CONCAT(
            EstimatedMinutes / 60, ' h ',
            EstimatedMinutes % 60, ' min'
        )
    END AS [Lesson Length]
FROM content.Lessons;

-- 5.15
SELECT Body , Title
FROM communication.Announcements
WHERE Body LIKE '%[%]%';

-- 5.16
SELECT TOP 5  WITH TIES *
FROM finance.Invoices
ORDER BY TotalAmount DESC;

-- 5.17
SELECT TOP 10 PERCENT *
FROM finance.Payments
ORDER BY Amount DESC;

-- 5.18
SELECT CourseId,TermId,Location
FROM delivery.Sections
WHERE Location != 'Hall A'
   OR Location IS NULL;

-- 5.19
SELECT
    InvoiceNumber,
    TotalAmount,
    PaidAmount,
    TotalAmount - PaidAmount AS AmountOwed,

    CASE
        WHEN PaidAmount > 0 THEN 'Partially Paid'
        ELSE 'Not Paid'
    END AS PaymentStatus,

    CASE
        WHEN DueAtUtc < GETDATE() THEN 'Overdue'
        ELSE 'Not Overdue'
    END AS OverdueStatus,
    CAST(
        PaidAmount * 100.0 / NULLIF(TotalAmount, 0)
        AS DECIMAL(5,1)
    ) AS PercentagePaid

FROM finance.Invoices
WHERE TotalAmount > PaidAmount
ORDER BY AmountOwed DESC;


-- 5.20
SELECT *
FROM [identity].Users
ORDER BY CreatedAtUtc DESC
OFFSET 40 ROWS
FETCH NEXT 20 ROWS ONLY;


-- 5.21
SELECT TOP 50 *
FROM operations.AuditLogs
WHERE Id > 50341
ORDER BY Id ASC;

-- 5.22
SELECT TOP 10 *
FROM finance.Payments
ORDER BY CreatedAtUtc DESC;



-- 5.23
SELECT DISTINCT TOP 10
    UPPER(TRIM(Title)) AS LessonTitle,
    LEN(TRIM(Title)) AS TitleLength,

    CASE
        WHEN EstimatedMinutes IS NULL THEN 'Not set'
        WHEN EstimatedMinutes <= 15 THEN 'Quick'
        WHEN EstimatedMinutes <= 45 THEN 'Standard'
        ELSE 'Long'
    END AS LessonType

FROM content.Lessons
WHERE IsPublished = 1
  AND LEN(TRIM(Title)) > 40
ORDER BY
    TitleLength DESC;


-- 5.24
SELECT TOP 12
    FORMAT(DueAtUtc, 'yyyy-MM') AS DueMonth,
    CurrencyCode,
    CASE
        WHEN PaidAmount > 0 THEN 'Partially Paid'
        ELSE 'Not Paid'
    END AS PaymentStatus,
    COUNT(*) AS InvoiceCount,
    SUM(TotalAmount - PaidAmount) AS TotalAmountOwed

FROM finance.Invoices
WHERE DueAtUtc < GETDATE()
  AND TotalAmount > PaidAmount
GROUP BY
    FORMAT(DueAtUtc, 'yyyy-MM'),
    CurrencyCode,
    CASE
        WHEN PaidAmount > 0 THEN 'Partially Paid'
        ELSE 'Not Paid'
    END
ORDER BY DueMonth DESC;