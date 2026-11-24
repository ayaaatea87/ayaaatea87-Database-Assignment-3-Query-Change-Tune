CREATE SEQUENCE  finance.InvoiceNumberSequence
    AS BIGINT
        START WITH 1  INCREMENT BY 1


-- 3.1 Test Invoice Number

SELECT
    CONCAT(
        'LAB-INV-',
        YEAR(GETDATE()),
        '-',
        RIGHT(
            '000000' + CAST(
                NEXT VALUE FOR finance.InvoiceNumberSequence
                AS VARCHAR(20)
            ),
            6
        )
    ) AS InvoiceNumber;

SELECT TOP 5
    StudentId,
    TermId,
    CurrencyCode,
    Status
FROM finance.Invoices
WHERE TotalAmount > 0
ORDER BY Id DESC;



-- 3.2

INSERT INTO finance.Invoices
    (InvoiceNumber, StudentId, TermId, CurrencyCode,
     IssuedAtUtc, DueAtUtc, TotalAmount, PaidAmount,
     CreatedAtUtc, Status)
VALUES
    (
        CONCAT(
            'LAB-INV-',
            YEAR(GETDATE()),
            '-',
            RIGHT('000000' + CAST(NEXT VALUE FOR finance.InvoiceNumberSequence AS VARCHAR(20)), 6)
        ),
       84939,
        12,
        'EGP',
        GETUTCDATE(),
        DATEADD(DAY, 30, GETUTCDATE()),
        4500,
        0,
        GETUTCDATE(),
        4
    );

SELECT * FROM finance.Invoices 
    WHERE TermId = 12 AND StudentId = 84939 ;

BEGIN TRANSACTION;
SELECT
    CONCAT(
        'LAB-INV-',
        YEAR(GETDATE()),
        '-',
        RIGHT(
            '000000' + CAST(
                NEXT VALUE FOR finance.InvoiceNumberSequence
                AS VARCHAR(20)
            ),
            6
        )
    ) AS InvoiceNumber;
 ROLLBACK TRANSACTION;


SELECT
    CONCAT(
        'LAB-INV-',
        YEAR(GETDATE()),
        '-',
        RIGHT(
            '000000' + CAST(
                NEXT VALUE FOR finance.InvoiceNumberSequence
                AS VARCHAR(20)
            ),
            6
        )
    ) AS NEXTINvoiceNumber;
