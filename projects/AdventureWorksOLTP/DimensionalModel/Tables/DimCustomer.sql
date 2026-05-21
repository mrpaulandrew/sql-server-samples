-- Kimball Dimensional Model: Customer Dimension (SCD Type 2)
-- Supports customer analysis with individual and store customer tracking
-- SCD Type 2: Tracks customer attribute changes over time

CREATE TABLE [DimensionalModel].[DimCustomer] (
    [CustomerKey]               INT             IDENTITY (1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    [CustomerID]                INT             NOT NULL,
    [CustomerType]              NVARCHAR (15)   NOT NULL,  -- 'Individual' or 'Store'
    [CustomerName]              NVARCHAR (100)  NOT NULL,
    [PersonFirstName]           NVARCHAR (50)   NULL,
    [PersonLastName]            NVARCHAR (50)   NULL,
    [PersonMiddleName]          NVARCHAR (50)   NULL,
    [StoreName]                 NVARCHAR (50)   NULL,
    [StoreContactName]          NVARCHAR (100)  NULL,
    [AccountNumber]             NVARCHAR (20)   NULL,
    [TerritoryID]               INT             NULL,
    [TerritoryName]             NVARCHAR (50)   NULL,
    [CountryRegionCode]         NVARCHAR (3)    NULL,
    [CountryRegionName]         NVARCHAR (50)   NULL,
    [TerritoryGroup]            NVARCHAR (50)   NULL,
    [BillingCity]               NVARCHAR (30)   NULL,
    [BillingStateProvince]      NVARCHAR (50)   NULL,
    [BillingPostalCode]         NVARCHAR (15)   NULL,
    [BillingCountryRegion]      NVARCHAR (50)   NULL,
    [ShippingCity]              NVARCHAR (30)   NULL,
    [ShippingStateProvince]     NVARCHAR (50)   NULL,
    [ShippingPostalCode]        NVARCHAR (15)   NULL,
    [ShippingCountryRegion]     NVARCHAR (50)   NULL,
    [IsActive]                  BIT             NOT NULL DEFAULT (1),
    -- SCD Type 2 Attributes
    [EffectiveDate]             DATE            NOT NULL,
    [ExpirationDate]            DATE            NOT NULL DEFAULT ('9999-12-31'),
    [IsCurrent]                 BIT             NOT NULL DEFAULT (1),
    [SourceModifiedDate]        DATETIME        NOT NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_DimCustomer_CustomerID_IsCurrent]
    ON [DimensionalModel].[DimCustomer]([CustomerID] ASC, [IsCurrent] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimCustomer_TerritoryID]
    ON [DimensionalModel].[DimCustomer]([TerritoryID] ASC, [IsCurrent] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_DimCustomer_EffectiveDate]
    ON [DimensionalModel].[DimCustomer]([EffectiveDate] ASC, [ExpirationDate] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball customer dimension with SCD Type 2 support for tracking customer profile changes over time.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimCustomer';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Surrogate key - Unique identifier for each customer version', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimCustomer', @level2type = N'COLUMN', @level2name = N'CustomerKey';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'SCD Type 2: Tracks when customer territory or address changes', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimCustomer', @level2type = N'COLUMN', @level2name = N'EffectiveDate';
GO
