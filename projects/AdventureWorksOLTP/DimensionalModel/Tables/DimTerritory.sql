-- Kimball Dimensional Model: Territory Dimension
-- Supports geographic and organizational hierarchy analysis
-- Grain: One row per territory (current state)

CREATE TABLE [DimensionalModel].[DimTerritory] (
    [TerritoryKey]              INT             IDENTITY (1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    [TerritoryID]               INT             NOT NULL UNIQUE,
    [TerritoryName]             NVARCHAR (50)   NOT NULL,
    [CountryRegionCode]         NVARCHAR (3)    NOT NULL,
    [CountryRegionName]         NVARCHAR (50)   NOT NULL,
    [TerritoryGroup]            NVARCHAR (50)   NOT NULL,
    [IsActive]                  BIT             NOT NULL DEFAULT (1),
    [SalesYTD]                  DECIMAL (12, 2) NOT NULL,
    [SalesLastYear]             DECIMAL (12, 2) NOT NULL,
    [CostYTD]                   DECIMAL (12, 2) NOT NULL,
    [CostLastYear]              DECIMAL (12, 2) NOT NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE NONCLUSTERED INDEX [IX_DimTerritory_CountryRegion]
    ON [DimensionalModel].[DimTerritory]([CountryRegionCode] ASC, [TerritoryGroup] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimTerritory_TerritoryName]
    ON [DimensionalModel].[DimTerritory]([TerritoryName] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball territory dimension for geographic and regional sales analysis with hierarchy support.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimTerritory';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Surrogate key - Unique identifier for each territory', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimTerritory', @level2type = N'COLUMN', @level2name = N'TerritoryKey';
GO
