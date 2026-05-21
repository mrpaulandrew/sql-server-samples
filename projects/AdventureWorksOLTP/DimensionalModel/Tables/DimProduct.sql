-- Kimball Dimensional Model: Product Dimension (SCD Type 2)
-- Supports product analysis with category and subcategory hierarchies
-- SCD Type 2: Tracks product changes over time with effective dates

CREATE TABLE [DimensionalModel].[DimProduct] (
    [ProductKey]                INT             IDENTITY (1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    [ProductID]                 INT             NOT NULL,
    [ProductName]               NVARCHAR (50)   NOT NULL,
    [ProductNumber]             NVARCHAR (25)   NOT NULL,
    [ProductColor]              NVARCHAR (15)   NULL,
    [ProductSize]               NVARCHAR (5)    NULL,
    [ProductWeight]             DECIMAL (8, 2)  NULL,
    [ProductLine]               NCHAR (2)       NULL,
    [ProductClass]              NCHAR (2)       NULL,
    [ProductStyle]              NCHAR (2)       NULL,
    [StandardCost]              DECIMAL (10, 4) NOT NULL,
    [ListPrice]                 DECIMAL (10, 4) NOT NULL,
    [SafetyStockLevel]          SMALLINT        NOT NULL,
    [ReorderPoint]              SMALLINT        NOT NULL,
    [DaysToManufacture]         INT             NOT NULL,
    [MakeFlag]                  BIT             NOT NULL,
    [FinishedGoodsFlag]         BIT             NOT NULL,
    [ProductSubcategoryName]    NVARCHAR (50)   NULL,
    [ProductCategoryName]       NVARCHAR (50)   NULL,
    [ProductModelName]          NVARCHAR (50)   NULL,
    [SellStartDate]             DATE            NOT NULL,
    [SellEndDate]               DATE            NULL,
    [DiscontinuedDate]          DATE            NULL,
    [IsActive]                  BIT             NOT NULL DEFAULT (1),
    -- SCD Type 2 Attributes
    [EffectiveDate]             DATE            NOT NULL,
    [ExpirationDate]            DATE            NOT NULL DEFAULT ('9999-12-31'),
    [IsCurrent]                 BIT             NOT NULL DEFAULT (1),
    [SourceModifiedDate]        DATETIME        NOT NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_DimProduct_ProductID_IsCurrent]
    ON [DimensionalModel].[DimProduct]([ProductID] ASC, [IsCurrent] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimProduct_ProductCategory]
    ON [DimensionalModel].[DimProduct]([ProductCategoryName] ASC, [ProductSubcategoryName] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimProduct_EffectiveDate]
    ON [DimensionalModel].[DimProduct]([EffectiveDate] ASC, [ExpirationDate] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball product dimension with SCD Type 2 support for tracking product attribute changes over time.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimProduct';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Surrogate key - Unique identifier for each product version (SCD Type 2)', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimProduct', @level2type = N'COLUMN', @level2name = N'ProductKey';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Natural key - Source ProductID from Production.Product', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimProduct', @level2type = N'COLUMN', @level2name = N'ProductID';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'SCD Type 2: Date when this version became effective', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimProduct', @level2type = N'COLUMN', @level2name = N'EffectiveDate';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'SCD Type 2: Date when this version expired (9999-12-31 if current)', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimProduct', @level2type = N'COLUMN', @level2name = N'ExpirationDate';
GO
