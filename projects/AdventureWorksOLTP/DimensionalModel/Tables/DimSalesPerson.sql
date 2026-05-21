-- Kimball Dimensional Model: Sales Person Dimension
-- Supports sales performance analysis and attribution
-- Grain: One row per salesperson (current state snapshot)

CREATE TABLE [DimensionalModel].[DimSalesPerson] (
    [SalesPersonKey]            INT             IDENTITY (1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    [SalesPersonID]             INT             NOT NULL UNIQUE,
    [SalesPersonName]           NVARCHAR (100)  NOT NULL,
    [SalesPersonTitle]          NVARCHAR (50)   NULL,
    [SalesPersonDepartment]     NVARCHAR (50)   NULL,
    [TerritoryID]               INT             NULL,
    [TerritoryName]             NVARCHAR (50)   NULL,
    [TerritoryGroup]            NVARCHAR (50)   NULL,
    [SalesQuota]                DECIMAL (10, 2) NULL,
    [Bonus]                     DECIMAL (10, 2) NOT NULL,
    [CommissionPercent]         DECIMAL (5, 4)  NOT NULL,
    [SalesYTD]                  DECIMAL (12, 2) NOT NULL,
    [SalesLastYear]             DECIMAL (12, 2) NOT NULL,
    [EmploymentStatus]          NVARCHAR (20)   NOT NULL DEFAULT ('Active'),
    [HireDate]                  DATE            NULL,
    [TerminationDate]           DATE            NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE NONCLUSTERED INDEX [IX_DimSalesPerson_TerritoryID]
    ON [DimensionalModel].[DimSalesPerson]([TerritoryID] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimSalesPerson_SalesPersonName]
    ON [DimensionalModel].[DimSalesPerson]([SalesPersonName] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball sales person dimension for sales attribution and performance analysis.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimSalesPerson';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Surrogate key - Unique identifier for each salesperson', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimSalesPerson', @level2type = N'COLUMN', @level2name = N'SalesPersonKey';
GO
