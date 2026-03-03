@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity - Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBSJ_I_SO_ITEM as select from zbsj_so_item
association to parent ZBSJ_I_SO_HEADER as _Header 
    on $projection.SalesOrderId = _Header.SalesOrderId
association [0..1] to ZBSJ_I_MATERIAL  as _Material 
    on $projection.MaterialId = _Material.MaterialId

{
    
    key sales_order_id as SalesOrderId,
    key item_no as ItemNo,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBSJ_I_MATERIAL', element: 'MaterialId' } }]
    material_id as MaterialId,
    uom as Uom,     
    currency as Currency,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    quantity as Quantity,
      @Semantics.amount.currencyCode: 'Currency'
    net_value as NetValue,
      @Semantics.amount.currencyCode: 'Currency'
    tax_value as TaxValue,
      @Semantics.amount.currencyCode: 'Currency'
    gross_value as GrossValue,
    item_status as ItemStatus,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    _Header,
    _Material
}
