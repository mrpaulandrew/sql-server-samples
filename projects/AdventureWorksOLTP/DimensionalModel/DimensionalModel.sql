-- Kimball Dimensional Model Schema
-- Container for data warehouse star schema objects
-- Separates analytical schema from transactional OLTP schema

CREATE SCHEMA [DimensionalModel] AUTHORIZATION [dbo];
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @value = N'Kimball dimensional model schema for business intelligence and analytical reporting. Contains conformed dimensions and fact tables supporting product sales analytics.', 
    @level0type = N'SCHEMA', @level0name = N'DimensionalModel';
GO
