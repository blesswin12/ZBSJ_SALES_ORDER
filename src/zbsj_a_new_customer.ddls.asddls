@EndUserText.label: 'Parameter for New Customer'
define abstract entity ZBSJ_A_NEW_CUSTOMER
{
  customer_id : zbsj_de_customer_id;
  customer_name   : zde_cus_name;
  phone           : zde_phone;
  email           : zde_email;
  address         : zde_address;
  city            : zde_city;
  country         : land1;
  @Semantics.amount.currencyCode : 'currency'
  credit_limit    : zde_credit_limit;
  currency        : zde_currency;
  is_active       : abap_boolean;
    
}
