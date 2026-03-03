@EndUserText.label: 'Parameter for Material Creation'
define abstract entity ZBSJ_A_MATERIAL_PARAM
{
     MaterialId   : zde_material_id;
  MaterialName : zde_mat_name;
  BaseUom      : abap.unit(3);
  @Semantics.amount.currencyCode: 'Currency'
  UnitPrice    : zde_unit_price;
  Currency     : zde_currency;
  TaxCode      : zbsj_tax_code;
      
}
