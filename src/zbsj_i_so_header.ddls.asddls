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
    // 1. User Type
      @Semantics.user.createdBy: true
      local_created_by as LocalCreatedBy,
      
      
      @Semantics.systemDateTime.createdAt: true
      local_created_at as LocalCreatedAt,
      
      // 3. User Type (Use 'lastChangedBy', not 'createdAt'!)
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      
      // 4. Timestamp Type (Local ETag)
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      // 5. Timestamp Type (Total ETag)
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt, 
      case delivery_status
        when 'D' then 3 
        when 'N' then 1 
        else 0          
      end as DeliveryCriticality,
      // 2. Calculate Color for Payment
      case payment_status
        when 'P' then 3 
        when 'N' then 1 
        else 0          
      end as PaymentCriticality,
      
      cast( case delivery_status
        when 'D' then 'Delivered'
        when 'N' then 'Not Delivered'
        else 'Unknown'
      end as abap.char( 20 ) ) as DeliveryStatusText,

      // 2. Generate Text for Payment
       cast( case payment_status
        when 'P' then 'Paid'
        when 'N' then 'Unpaid'
        else 'Unknown'
      end as abap.char( 20 ) ) as PaymentStatusText,
      
      // 3. Color and Text for Billing
      case billing_status
        when 'B' then 3 
        when 'N' then 1 
        else 0          
      end as BillingCriticality,

      cast( case billing_status
        when 'B' then 'Billed'
        when 'N' then 'Not Billed'
        else 'Unknown'
      end as abap.char( 20 ) ) as BillingStatusText,
      
      case overall_status
        when 'C' then 3 
        when 'P' then 2 
        when 'O' then 2 
        when 'X' then 1 
        else 0
      end as OverallCriticality,

      cast( case overall_status
        when 'C' then 'Completed'
        when 'P' then 'In Process'
        when 'O' then 'Open'
        when 'X' then 'Cancelled'
        else 'Unknown'
      end as abap.char( 20 ) ) as OverallStatusText,
      
    _Item,
    _Customer,
    _Company,
    _SalesOrg,
    _Currency,
    _Material
    
}
