-- Kimball Dimensional Model: Date Dimension
-- Conformed dimension for all temporal analysis
-- Grain: One row per calendar date

CREATE TABLE [DimensionalModel].[DimDate] (
    [DateKey]                   INT             NOT NULL PRIMARY KEY CLUSTERED,
    [Date]                      DATE            NOT NULL,
    [Year]                      SMALLINT        NOT NULL,
    [Quarter]                   TINYINT         NOT NULL,
    [Month]                     TINYINT         NOT NULL,
    [DayOfMonth]                TINYINT         NOT NULL,
    [DayOfWeek]                 TINYINT         NOT NULL,
    [WeekOfYear]                TINYINT         NOT NULL,
    [DayName]                   NVARCHAR (10)   NOT NULL,
    [MonthName]                 NVARCHAR (10)   NOT NULL,
    [QuarterName]               NVARCHAR (10)   NOT NULL,
    [CalendarYear]              SMALLINT        NOT NULL,
    [CalendarQuarter]           NVARCHAR (10)   NOT NULL,
    [CalendarYearMonth]         NVARCHAR (10)   NOT NULL,
    [CalendarYearQuarter]       NVARCHAR (10)   NOT NULL,
    [FiscalYear]                SMALLINT        NOT NULL,
    [FiscalQuarter]             TINYINT         NOT NULL,
    [FiscalYearQuarter]         NVARCHAR (10)   NOT NULL,
    [IsWeekend]                 BIT             NOT NULL,
    [IsHoliday]                 BIT             NOT NULL DEFAULT (0),
    [IsBusinessDay]             BIT             NOT NULL,
    [FullDate]                  NVARCHAR (30)   NOT NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE NONCLUSTERED INDEX [IX_DimDate_Date]
    ON [DimensionalModel].[DimDate]([Date] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimDate_CalendarYear]
    ON [DimensionalModel].[DimDate]([CalendarYear] ASC, [Month] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball conformed date dimension for temporal analysis. Supports fiscal and calendar hierarchies.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimDate';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'YYYYMMDD format integer date key', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DateKey';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fiscal year for AdventureWorks (July-June)', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'FiscalYear';
GO
