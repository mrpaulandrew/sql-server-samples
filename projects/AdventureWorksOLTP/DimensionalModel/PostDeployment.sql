-- Post-deployment script: Populate reference data for Dimensional Model
-- This script runs after all schema objects are created

-- =====================================================================
-- Populate DimOrderStatus Reference Data
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM [DimensionalModel].[DimOrderStatus] WHERE [OrderStatusCode] = 1)
BEGIN
    INSERT INTO [DimensionalModel].[DimOrderStatus]
        ([OrderStatusKey], [OrderStatusCode], [OrderStatusName], [OrderStatusDescription], [IsTerminalStatus], [DisplayOrder])
    VALUES
        (1, 1, 'In Process', 'Order being processed', 0, 1),
        (2, 2, 'Approved', 'Order approved for fulfillment', 0, 2),
        (3, 3, 'Backordered', 'Order items on backorder', 0, 3),
        (4, 4, 'Rejected', 'Order rejected', 1, 4),
        (5, 5, 'Shipped', 'Order shipped to customer', 1, 5),
        (6, 6, 'Cancelled', 'Order cancelled', 1, 6),
        (999, 0, 'Unknown', 'Unknown status', 0, 0);
END;
GO

-- =====================================================================
-- Populate DimCurrency Reference Data (Common Currencies)
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM [DimensionalModel].[DimCurrency] WHERE [CurrencyCode] = 'USD')
BEGIN
    INSERT INTO [DimensionalModel].[DimCurrency]
        ([CurrencyCode], [CurrencyName], [CurrencySymbol], [ExchangeRate], [IsActive])
    VALUES
        ('USD', 'US Dollar', '$', 1.0000, 1),
        ('EUR', 'Euro', '€', 0.9200, 1),
        ('GBP', 'British Pound', '£', 1.2700, 1),
        ('JPY', 'Japanese Yen', '¥', 110.0000, 1),
        ('CAD', 'Canadian Dollar', 'C$', 1.2500, 1),
        ('AUD', 'Australian Dollar', 'A$', 1.3500, 1);
END;
GO

-- =====================================================================
-- Print deployment completion message
-- =====================================================================
PRINT N'Kimball Dimensional Model post-deployment setup completed.';
PRINT N'Reference dimensions populated: DimOrderStatus, DimCurrency';
GO
