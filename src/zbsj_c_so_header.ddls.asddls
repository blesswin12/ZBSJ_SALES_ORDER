@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For Sales Order Header'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZBSJ_C_SO_HEADER
  provider contract transactional_query
  as projection on ZBSJ_I_SO_HEADER
{
      @Search.defaultSearchElement: true
  key SalesOrderId,
      @Consumption.valueHelpDefinition: [{
             entity: { name: 'ZBSJ_I_ORDER_TYPES', element: 'OrderType' }
             }] 
      OrderType,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBSJ_I_MATERIAL', element: 'MaterialId' } }]
      @ObjectModel.text.element: ['MaterialName']
      MaterialId,
      _Material.MaterialName as MaterialName,
      CompanyCode,
      SalesOrg,
      @ObjectModel.text.element: ['CustomerName']
      @Consumption.valueHelpDefinition: [{
         entity: { name: 'ZBSJ_I_CUSTOMER', element: 'CustomerId' },
         useForValidation: true
      }]
      CustomerId,
      _Customer.CustomerName as CustomerName,
      @EndUserText.label: 'Order Date'
      OrderDate,
      @EndUserText.label: 'Required Delivery Date'
      ReqDeliveryDate,
      @Semantics.amount.currencyCode: 'Currency'
      NetAmount,
      @Semantics.amount.currencyCode: 'Currency'
      TaxAmount,
      @Semantics.amount.currencyCode: 'Currency'
      GrossAmount,
      Currency,
      @EndUserText.label: 'Overall Status'
      OverallStatus,
      DeliveryStatus,
      BillingStatus,
      PaymentStatus,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _Company,
      _Currency,
      _Customer,
      _Item     : redirected to composition child ZBSJ_C_SO_ITEM,
      _SalesOrg,
      _Material : redirected to ZBSJ_C_MATERIAL
}
