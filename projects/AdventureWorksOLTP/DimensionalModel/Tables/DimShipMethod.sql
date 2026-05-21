-- Kimball Dimensional Model: Ship Method Dimension
-- Supports shipping analysis and fulfillment tracking
-- Grain: One row per shipping method

CREATE TABLE [DimensionalModel].[DimShipMethod] (
    [ShipMethodKey]             INT             IDENTITY (1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    [ShipMethodID]              INT             NOT NULL UNIQUE,
    [ShipMethodName]            NVARCHAR (50)   NOT NULL,
    [ShipMethodDescription]     NVARCHAR (100)  NULL,
    [IsActive]                  BIT             NOT NULL DEFAULT (1),
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

CREATE NONCLUSTERED INDEX [IX_DimShipMethod_ShipMethodName]
    ON [DimensionalModel].[DimShipMethod]([ShipMethodName] ASC);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball ship method dimension for fulfillment and shipping analysis.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimShipMethod';
GO
