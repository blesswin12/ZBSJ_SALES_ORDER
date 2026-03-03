@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT VIEW ENTITY - Sales Order Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZBSJ_I_SO_HEADER as select from zbsj_so_header
composition [0..*] of ZBSJ_I_SO_ITEM as _Item
association [0..1] to ZBSJ_I_CUSTOMER   as _Customer  on $projection.CustomerId = _Customer.CustomerId
  association [0..1] to ZBSJ_I_COMPANY    as _Company   on $projection.CompanyCode = _Company.CompanyCode
  association [0..1] to ZBSJ_I_SALES_ORG  as _SalesOrg  on $projection.SalesOrg = _SalesOrg.SalesOrg
  association [0..1] to I_Currency        as _Currency  on $projection.Currency = _Currency.Currency
  association [0..1] to ZBSJ_I_MATERIAL   as _Material  on $projection.MaterialId = _Material.MaterialId
{ 
    key sales_order_id as SalesOrderId,
    material_id as MaterialId,
    order_type as OrderType,
    company_code as CompanyCode,
    sales_org as SalesOrg,
    customer_id as CustomerId,
    order_date as OrderDate,
    req_delivery_date as ReqDeliveryDate,
    @Semantics.amount.currencyCode: 'Currency'
    net_amount as NetAmount,
    @Semantics.amount.currencyCode: 'Currency'
    tax_amount as TaxAmount,
    @Semantics.amount.currencyCode: 'Currency'
    gross_amount as GrossAmount,
    currency as Currency,
    overall_status as OverallStatus,
    delivery_status as DeliveryStatus,
    billing_status as BillingStatus,
    payment_status as PaymentStatus,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    _Item,
    _Customer,
    _Company,
    _SalesOrg,
    _Currency,
    _Material
    
}
