CREATE TABLE academic.PassMarkHistory
(
    CourseId INT,
    OldPassMark INT,
    NewPassMark INT,
    ChangedAt DATETIME2,
    ChangedBy NVARCHAR(100)
);

UPDATE academic.Courses
SET PassingScore = 65
OUTPUT
    inserted.Id,
    deleted.PassingScore,
    inserted.PassingScore,
    SYSDATETIME(),
    SUSER_SNAME()
INTO academic.PassMarkHistory
WHERE DepartmentId = 1;


DROP TABLE IF EXISTS dbo.AnnouncementsArchive;

CREATE TABLE dbo.AnnouncementsArchive
(
    Id BIGINT NOT NULL,
    SectionId BIGINT NULL,
    Title NVARCHAR(200) NOT NULL,
    Body NVARCHAR(MAX) NOT NULL,
    PublishedAtUtc DATETIME2(0) NULL,
    ExpiresAtUtc DATETIME2(0) NULL,
    CreatedByUserId BIGINT NOT NULL,
    CreatedAtUtc DATETIME2(0) NOT NULL,
    UpdatedAtUtc DATETIME2(0) NOT NULL,
    Status TINYINT NOT NULL
);

DELETE FROM communication.Announcements
OUTPUT DELETED.*
INTO dbo.AnnouncementsArchive
WHERE ExpiresAtUtc < DATEADD(MONTH, -6, GETUTCDATE());

