@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity- Sales Org Master'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZBSJ_I_SALES_ORG
  as select from zbsj_sales_org
  association [1..1] to ZBSJ_I_COMPANY as _Company on $projection.CompanyCode = _Company.CompanyCode
{
  key sales_org    as SalesOrg,
  
      company_code as CompanyCode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      description  as Description,
      is_active    as IsActive,
      _Company
}
