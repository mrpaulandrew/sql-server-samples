-- Kimball Dimensional Model: Currency Dimension
-- Supports multi-currency and international sales analysis
-- Grain: One row per currency

CREATE TABLE [DimensionalModel].[DimCurrency] (
    [CurrencyKey]               INT             IDENTITY (1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    [CurrencyCode]              NCHAR (3)       NOT NULL UNIQUE,
    [CurrencyName]              NVARCHAR (50)   NOT NULL,
    [CurrencySymbol]            NCHAR (1)       NULL,
    [ExchangeRate]              DECIMAL (8, 4)  NOT NULL DEFAULT (1.0000),
    [IsActive]                  BIT             NOT NULL DEFAULT (1),
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE NONCLUSTERED INDEX [IX_DimCurrency_CurrencyName]
    ON [DimensionalModel].[DimCurrency]([CurrencyName] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball currency dimension for multi-currency and international sales analysis.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimCurrency';
GO
