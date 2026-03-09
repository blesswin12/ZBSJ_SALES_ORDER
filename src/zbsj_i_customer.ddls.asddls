@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VIEW ENTITY - Customer Master'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZBSJ_I_CUSTOMER
  as select from zbsj_customer
  association [0..1] to I_Country as _Country on $projection.Country = _Country.Country
{
      @ObjectModel.text.element: ['CustomerName']
  key customer_id   as CustomerId,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      customer_name as CustomerName,
      phone         as Phone,
      email         as Email,
      address       as Address,
      city          as City,
      country       as Country,
      @Semantics.amount.currencyCode: 'Currency'
      credit_limit  as CreditLimit,
      currency      as Currency,
      is_active     as IsActive,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as LocalLastChangedAt,
      _Country
}
