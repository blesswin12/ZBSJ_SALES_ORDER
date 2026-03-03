@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VIEW ENTITY - Company Master'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity ZBSJ_I_COMPANY
  as select from zbsj_company
  association [0..1] to I_Currency as _Currency on $projection.Currency = _Currency.Currency
  association [0..1] to I_Country  as _Country  on $projection.Country = _Country.Country
{
      @ObjectModel.text.element: ['CompanyName']
  key company_code as CompanyCode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      company_name as CompanyName,
      currency     as Currency,
      country      as Country,
      is_active    as IsActive,
      _Currency,
      _Country
}
