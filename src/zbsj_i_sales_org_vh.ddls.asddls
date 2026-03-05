@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Organization Value Help'
@ObjectModel.resultSet.sizeCategory: #XS 
define view entity ZBSJ_I_SALES_ORG_VH
  as select from zbsj_sales_org_m
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['SalesOrgName']
  key sales_org as SalesOrg,

      @Semantics.text: true
      name      as SalesOrgName
}
