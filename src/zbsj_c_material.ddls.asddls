@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Material'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['MaterialId']
define root view entity ZBSJ_C_MATERIAL provider contract transactional_query as projection on ZBSJ_I_MATERIAL
{
     @Search.defaultSearchElement: true
    key MaterialId,
    @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
    MaterialName,
    @EndUserText.label: 'Base Unit of Measure'
    BaseUom,
    @Semantics.amount.currencyCode: 'Currency'    
    UnitPrice,   
    Currency,
    TaxCode,
    IsActive,
     @UI.hidden: true // <-- 2. Hides the technical ETag field from the user
      LocalLastChangedAt // <-- 3. Exposes the ETag required for Draft saving
}
