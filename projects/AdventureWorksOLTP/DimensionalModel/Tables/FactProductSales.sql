-- Kimball Dimensional Model: Product Sales Fact Table
-- Central fact table for product sales analysis
-- Grain: One row per sales order detail line item
-- Measures: Quantity, Price, Discount, Tax information
-- Time Variant: Captures sales transactions at point in time

CREATE TABLE [DimensionalModel].[FactProductSales] (
    -- Foreign Keys (Dimension References)
    [DateKey]                   INT             NOT NULL,
    [ShipDateKey]               INT             NULL,
    [DueDateKey]                INT             NULL,
    [ProductKey]                INT             NOT NULL,
    [CustomerKey]               INT             NOT NULL,
    [SalesPersonKey]            INT             NULL,
    [TerritoryKey]              INT             NULL,
    [OrderStatusKey]            INT             NOT NULL,
    [ShipMethodKey]             INT             NULL,
    [CurrencyKey]               INT             NOT NULL,
    
    -- Degenerate Dimensions (Business Keys from source)
    [SalesOrderID]              INT             NOT NULL,
    [SalesOrderDetailID]        INT             NOT NULL,
    [SalesOrderNumber]          NVARCHAR (25)   NOT NULL,
    
    -- Fact Measures (Additive)
    [OrderQuantity]             SMALLINT        NOT NULL,
    [UnitPrice]                 DECIMAL (10, 4) NOT NULL,
    [UnitPriceDiscount]         DECIMAL (10, 4) NOT NULL,
    [LineExtendedPrice]         DECIMAL (12, 2) NOT NULL,
    [LineDiscountAmount]        DECIMAL (12, 2) NOT NULL,
    [LineTotalAmount]           DECIMAL (12, 2) NOT NULL,
    
    -- Order-level Measures (Semi-Additive - use only on orders, not for details)
    [OrderSubtotal]             DECIMAL (12, 2) NOT NULL,
    [OrderTaxAmount]            DECIMAL (12, 2) NOT NULL,
    [OrderFreight]              DECIMAL (12, 2) NOT NULL,
    [OrderTotalDue]             DECIMAL (12, 2) NOT NULL,
    
    -- Non-Additive Facts (Ratios/Percentages)
    [DiscountPercent]           DECIMAL (5, 4)  NOT NULL,
    [LineMarginPercent]         DECIMAL (7, 4)  NULL,
    [OrderMarginPercent]        DECIMAL (7, 4)  NULL,
    
    -- Fact Flags (Analysis Attributes)
    [IsOnlineOrder]             BIT             NOT NULL DEFAULT (0),
    [IsShipped]                 BIT             NOT NULL DEFAULT (0),
    [IsCancelled]               BIT             NOT NULL DEFAULT (0),
    [IsBackordered]             BIT             NOT NULL DEFAULT (0),
    
    -- Audit Columns
    [SourceModifiedDate]        DATETIME        NOT NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE()),
    
    -- Composite Primary Key
    PRIMARY KEY CLUSTERED ([SalesOrderID], [SalesOrderDetailID])
);
GO

-- Fact Table Indexes
-- Fact indexes should support common query patterns and drill-downs

CREATE NONCLUSTERED INDEX [IX_FactProductSales_DateKey]
    ON [DimensionalModel].[FactProductSales]([DateKey] ASC)
    INCLUDE ([ProductKey], [CustomerKey], [LineTotalAmount]);
GO

CREATE NONCLUSTERED INDEX [IX_FactProductSales_ProductKey]
    ON [DimensionalModel].[FactProductSales]([ProductKey] ASC)
    INCLUDE ([DateKey], [OrderQuantity], [LineTotalAmount]);
GO

CREATE NONCLUSTERED INDEX [IX_FactProductSales_CustomerKey]
    ON [DimensionalModel].[FactProductSales]([CustomerKey] ASC)
    INCLUDE ([DateKey], [ProductKey], [LineTotalAmount]);
GO

CREATE NONCLUSTERED INDEX [IX_FactProductSales_SalesPersonKey]
    ON [DimensionalModel].[FactProductSales]([SalesPersonKey] ASC)
    INCLUDE ([DateKey], [LineTotalAmount], [OrderTotalDue]);
GO

CREATE NONCLUSTERED INDEX [IX_FactProductSales_TerritoryKey]
    ON [DimensionalModel].[FactProductSales]([TerritoryKey] ASC)
    INCLUDE ([DateKey], [LineTotalAmount]);
GO

CREATE NONCLUSTERED INDEX [IX_FactProductSales_OrderStatusKey]
    ON [DimensionalModel].[FactProductSales]([OrderStatusKey] ASC)
    INCLUDE ([DateKey], [LineTotalAmount]);
GO

-- Aggregate awareness index for common drill-paths
CREATE NONCLUSTERED INDEX [IX_FactProductSales_DateProductTerritory]
    ON [DimensionalModel].[FactProductSales]([DateKey] ASC, [ProductKey] ASC, [TerritoryKey] ASC)
    INCLUDE ([OrderQuantity], [LineTotalAmount], [OrderTotalDue]);
GO

CREATE NONCLUSTERED INDEX [IX_FactProductSales_DateCustomerSalesPerson]
    ON [DimensionalModel].[FactProductSales]([DateKey] ASC, [CustomerKey] ASC, [SalesPersonKey] ASC)
    INCLUDE ([OrderQuantity], [LineTotalAmount]);
GO

-- Extended Properties
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball fact table for product sales analysis. Grain: One row per sales order detail. Supports temporal analysis of sales transactions, product performance, customer purchases, and sales territory performance.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'FactProductSales';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Source SalesOrderID from Sales.SalesOrderHeader', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'FactProductSales', @level2type = N'COLUMN', @level2name = N'SalesOrderID';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Additive: Order quantity for the line item', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'FactProductSales', @level2type = N'COLUMN', @level2name = N'OrderQuantity';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Additive: Extended price = UnitPrice * (1 - Discount) * Quantity', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'FactProductSales', @level2type = N'COLUMN', @level2name = N'LineTotalAmount';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Non-Additive: Calculate line margin % for profitability analysis', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'FactProductSales', @level2type = N'COLUMN', @level2name = N'LineMarginPercent';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag: Whether item was part of an online order', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'FactProductSales', @level2type = N'COLUMN', @level2name = N'IsOnlineOrder';
GO
