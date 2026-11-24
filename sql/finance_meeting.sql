
-- 1.0
USE LmsTrainingLab;
GO

-- 1.0 List all tables
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO

-- 1.0 List all columns
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO



-- 1.0 Check invoice statuses
SELECT DISTINCT Status
FROM finance.Invoices
ORDER BY Status;

-- 1.0 Check invoice data
SELECT TOP 10
    Id,
    StudentId,
    InvoiceNumber,
    DueAtUtc,
    TotalAmount,
    PaidAmount,
    Status
FROM finance.Invoices
ORDER BY Id DESC;

-- 1.0 Check student data
SELECT TOP 10
    Id,
    UserId,
    StudentNumber
FROM [identity].StudentProfiles;


-- 1.0
SELECT TOP 10
    Id,
    FirstName,
    LastName
FROM [identity].Users;




-- 1.1
SELECT
    Id,
    StudentId,
    InvoiceNumber,
    TotalAmount,
    PaidAmount,
    TotalAmount - PaidAmount AS RemainingAmount,
    DATEDIFF(DAY, DueAtUtc, GETUTCDATE()) AS DaysLate
INTO #FINANCEMEETING
FROM finance.Invoices
WHERE DueAtUtc < GETUTCDATE()
AND PaidAmount < TotalAmount;

SELECT * FROM #FINANCEMEETING ;

-- 1.2
SELECT * , 
    CASE 
       WHEN DaysLate > 60 OR RemainingAmount > 10000 THEN 'Urgent'
       WHEN DaysLate > 30 THEN 'Medium'
       ELSE 'Low'
       END AS PRIORITY
FROM #FINANCEMEETING 
ORDER BY 
      CASE 
       WHEN DaysLate > 60 OR RemainingAmount > 10000  THEN 1
       WHEN DaysLate > 30 THEN 2
       ELSE  3
       END ASC , RemainingAmount DESC ;

