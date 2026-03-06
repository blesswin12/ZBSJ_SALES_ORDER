@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZBSJ_C_SO_ITEM
  as projection on ZBSJ_I_SO_ITEM
{
      @Search.defaultSearchElement: true
  key SalesOrderId,
      @Search.defaultSearchElement: true
  key ItemNo,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBSJ_I_MATERIAL', element: 'MaterialId' } }]
      @ObjectModel.text.element: ['MaterialName']
      @Search.defaultSearchElement: true
      MaterialId,
      @Search.defaultSearchElement: true
      _Material.MaterialName as MaterialName,
      Uom,
      Currency,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      @EndUserText.label: 'Quantity'
      Quantity,
      @Semantics.amount.currencyCode: 'Currency'
      NetValue,
      @Semantics.amount.currencyCode: 'Currency'
      TaxValue,
      @Semantics.amount.currencyCode: 'Currency'
      GrossValue,
      @ObjectModel.text.element: ['ItemStatusText']
      ItemStatus,
      @UI.hidden: true 
      ItemStatusText,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _Header : redirected to parent ZBSJ_C_SO_HEADER,
      _Material
}
