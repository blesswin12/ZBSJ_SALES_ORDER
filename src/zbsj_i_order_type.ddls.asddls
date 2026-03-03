@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity- Order Type Master'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZBSJ_I_ORDER_TYPE
  as select from zbsj_order_type
{
      @ObjectModel.text.element: ['Description']
  key order_type  as OrderType,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      description as Description,
      is_return   as IsReturn,
      is_credit   as IsCredit,
      is_active   as IsActive
}
