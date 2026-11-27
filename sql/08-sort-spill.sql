
-- 1. Create Large Table
CREATE TABLE dbo.LargeTable
(
    Id INT IDENTITY PRIMARY KEY,
    Category INT,
    Amount DECIMAL(10,2),
    CreatedAt DATETIME2
);

-- Insert 1 Million Rows
;WITH Numbers AS
(
    SELECT 1 AS N
    UNION ALL
    SELECT N + 1 FROM Numbers WHERE N < 1000000
)
INSERT INTO dbo.LargeTable (Category, Amount, CreatedAt)
SELECT
    N % 100,
    N % 10000,
    DATEADD(DAY, N % 365, '2025-01-01')
FROM Numbers
OPTION (MAXRECURSION 0);


-- 2. Query That Produces Sort Warning
ALTER TABLE dbo.LargeTable ADD TestKey INT;

UPDATE dbo.LargeTable
SET TestKey = 1
WHERE Id <= 300000;

SELECT Id, Category, Amount, CreatedAt
FROM dbo.LargeTable
WHERE TestKey = 1
ORDER BY Amount DESC;


-- 3. Fix Statistics
UPDATE STATISTICS dbo.LargeTable ST_TestKey WITH FULLSCAN;


-- 4. Final Query Without Warning
SELECT Id, Amount
FROM dbo.LargeTable
WHERE TestKey = 1
ORDER BY Amount DESC
OPTION (RECOMPILE);
