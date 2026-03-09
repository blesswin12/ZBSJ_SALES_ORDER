@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity View For Material'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true 
define root view entity ZBSJ_I_MATERIAL as select from zbsj_material
association [0..1] to I_Currency as _Currency on $projection.Currency = _Currency.Currency
{
    @ObjectModel.text.element: ['MaterialName']
    key material_id as MaterialId,
    
    @Semantics.text: true                      
    @Search.defaultSearchElement: true          
    @Search.fuzzinessThreshold: 0.8
    material_name as MaterialName,
    
    base_uom as BaseUom,
    
    @Semantics.amount.currencyCode: 'Currency'  
    unit_price as UnitPrice,
    
    currency as Currency,
    tax_code as TaxCode,
    is_active as IsActive,
    
    // local ETag field required for draft and concurrency control
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
  
    // total ETag field
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at       as LastChangedAt,
    
    _Currency
}
