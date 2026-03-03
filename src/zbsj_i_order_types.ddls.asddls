@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Type Dropdown'
@ObjectModel.resultSet.sizeCategory: #XS 
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBSJ_I_ORDER_TYPES as select from zbsj_order_types
{
   @ObjectModel.text.element: [ 'Description' ]
   @UI.textArrangement: #TEXT_ONLY
    key order_type as OrderType,
     @Semantics.text: true
    description as Description
}
