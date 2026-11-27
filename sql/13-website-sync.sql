CREATE TABLE dbo.WebsiteCourses
(
    CourseId INT PRIMARY KEY,
    CourseCode NVARCHAR(50),
    Title NVARCHAR(200),
    Credits INT,
    IsVisible BIT
);


MERGE dbo.WebsiteCourses AS Target
USING academic.Courses AS Source
ON Target.CourseId = Source.Id

WHEN MATCHED AND
(
    Source.IsActive = 0
    OR
    (
        Source.IsActive = 1
        AND
        (
            Target.CourseCode <> Source.Code
            OR Target.Title <> Source.Title
            OR Target.Credits <> Source.CreditHours
            OR Target.IsVisible = 0
        )
    )
)
THEN UPDATE SET
    CourseCode = Source.Code,
    Title = Source.Title,
    Credits = Source.CreditHours,
    IsVisible = Source.IsActive

WHEN NOT MATCHED BY TARGET AND Source.IsActive = 1 THEN
    INSERT (CourseId, CourseCode, Title, Credits, IsVisible)
    VALUES (Source.Id, Source.Code, Source.Title, Source.CreditHours, 1);


SELECT * FROM dbo.WebsiteCourses;

UPDATE academic.Courses
SET Title = 'New Course Title'
WHERE Id = 1;


UPDATE academic.Courses
SET IsActive = 0
WHERE Id = 2;

SELECT * FROM dbo.WebsiteCourses
 where Title = 'New Course Title' and CourseId = 1;
