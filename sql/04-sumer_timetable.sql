SELECT TOP 5 *
FROM delivery.AcademicTerms
ORDER BY StartDate DESC;


-- 4.1
INSERT INTO delivery.Sections
(
    CourseId,
    TermId,
    SectionCode,
    Capacity,
    Location,
    CreatedAtUtc,
    DeliveryMode,
    Status
)
SELECT
    CourseId,
    13,
    SectionCode,
    Capacity,
    Location,
    GETUTCDATE(),
    DeliveryMode,
    Status
FROM delivery.Sections
WHERE TermId = 12;



-- 4.2
SELECT top 5 *
FROM delivery.Sections
WHERE TermId =12 ;

-- 4.2
SELECT top 5 *
FROM delivery.Sections
WHERE TermId =13 ;