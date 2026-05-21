-- Kimball Dimensional Model: Order Status Dimension
-- Supports order lifecycle analysis
-- Grain: One row per order status code

CREATE TABLE [DimensionalModel].[DimOrderStatus] (
    [OrderStatusKey]            INT             NOT NULL PRIMARY KEY CLUSTERED,
    [OrderStatusCode]           TINYINT         NOT NULL UNIQUE,
    [OrderStatusName]           NVARCHAR (30)   NOT NULL,
    [OrderStatusDescription]    NVARCHAR (100)  NULL,
    [IsTerminalStatus]          BIT             NOT NULL DEFAULT (0),
    [DisplayOrder]              TINYINT         NOT NULL,
    [RowModifiedDate]           DATETIME        NOT NULL DEFAULT (GETDATE())
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball order status dimension for tracking sales order lifecycle states.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', 
    @level1type = N'TABLE', @level1name = N'DimOrderStatus';
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Status codes: 1=In process, 2=Approved, 3=Backordered, 4=Rejected, 5=Shipped, 6=Cancelled', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel', @level1type = N'TABLE', @level1name = N'DimOrderStatus', @level2type = N'COLUMN', @level2name = N'OrderStatusCode';
GO
