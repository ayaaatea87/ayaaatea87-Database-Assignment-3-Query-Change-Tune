CREATE INDEX IX_Users_Email ON [identity].Users (Email) INCLUDE (FirstName, LastName);
CREATE INDEX IX_Users_LastName ON [identity].Users (LastName) INCLUDE (FirstName, Email);
CREATE INDEX IX_Users_CreatedAtUtc ON [identity].Users (CreatedAtUtc) INCLUDE (Email);
CREATE INDEX IX_Payments_PaidAtUtc ON finance.Payments (PaidAtUtc) INCLUDE (InvoiceId, Amount);
CREATE INDEX IX_Invoices_Number ON finance.Invoices (InvoiceNumber);


SET STATISTICS IO ON;
-- 7.1 Slow
SELECT Id, Email
FROM [identity].Users
WHERE YEAR(CreatedAtUtc) = 2026
AND MONTH(CreatedAtUtc) = 3;


-- 7.1 Optimized
SET STATISTICS IO ON;
SELECT Id, Email
FROM [identity].Users
WHERE CreatedAtUtc >= '2026-03-01'
AND CreatedAtUtc < '2026-04-01';


-- 7.2 Slow
SET STATISTICS IO ON;
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE DATEDIFF(DAY, PaidAtUtc, SYSUTCDATETIME()) <= 30;

-- 7.2 Optimized
SET STATISTICS IO ON;
SELECT Id, InvoiceId, Amount
FROM finance.Payments
WHERE PaidAtUtc >= DATEADD(DAY, -30, SYSUTCDATETIME())
AND PaidAtUtc <= SYSUTCDATETIME();


-- 7.3 Slow
SET STATISTICS IO ON;
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LEFT(LastName, 3) = N'Abd';

-- 7.3 Optimized
SET STATISTICS IO ON;
SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE LastName LIKE N'Abd%';


-- 7.4 Slow
SET STATISTICS IO ON;
SELECT *
FROM operations.AuditLogs
WHERE Id + 1 = 50001;

-- 7.4 Optimized
SET STATISTICS IO ON;
SELECT *
FROM operations.AuditLogs
WHERE Id = 50000;

-- 7.5 Slow
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber = N'LAB-INV-2026-000001';

-- 7.5 Optimized
SELECT Id, TotalAmount, PaidAmount
FROM finance.Invoices
WHERE InvoiceNumber = 'LAB-INV-2026-000001';

-- 7.6 Slow
DECLARE @Email NVARCHAR(320) = N'data.stu14299@lms.local';

SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE UPPER(Email) = UPPER(@Email);

-- 7.6 Optimized
SET STATISTICS IO ON;
DECLARE @Emaill NVARCHAR(320) = N'data.stu14299@lms.local';

SELECT Id, FirstName, LastName
FROM [identity].Users
WHERE Email = @Emaill;

-- 7.7 Slow
SET STATISTICS IO ON;
DECLARE @LastName NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE (@LastName IS NULL
OR LastName = @LastName);


-- 7.7 Optimized
SET STATISTICS IO ON;
DECLARE @LastName2 NVARCHAR(100) = N'Hassan';
SELECT Id, FirstName, Email
FROM [identity].Users
WHERE LastName = @LastName2
OPTION (RECOMPILE);

-- 7.8 Slow
SET STATISTICS IO ON;
SELECT Id, Title, EstimatedMinutes
FROM content.Lessons
WHERE EstimatedMinutes * 2 > 60;

-- 7.8 Optimized
SET STATISTICS IO ON;
SELECT Id, Title, EstimatedMinutes
FROM content.Lessons
WHERE EstimatedMinutes > 30;
