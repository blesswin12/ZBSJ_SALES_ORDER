CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR SalesOrder RESULT result.

    METHODS RecalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~RecalcTotalPrice.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesOrder~calculateTotalPrice.

    METHODS CreateMaterial FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~CreateMaterial RESULT result.

ENDCLASS.

CLASS lhc_SalesOrderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesOrderItem~calculateTotalPrice.
    METHODS determineMaterialDefaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesOrderItem~determineMaterialDefaults.
ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      result-%update = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      result-%delete = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%action-Edit = if_abap_behv=>mk-on.
      result-%action-Edit = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(key).
      APPEND VALUE #(
        %tky          = key-%tky
        %update       = if_abap_behv=>auth-allowed
        %delete       = if_abap_behv=>auth-allowed
        %action-Edit  = if_abap_behv=>auth-allowed
      ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD RecalcTotalPrice.
    DATA: headers_for_update TYPE TABLE FOR UPDATE zbsj_i_so_header,
          items_for_update   TYPE TABLE FOR UPDATE zbsj_i_so_item.
    " 1. Read Header Data
    READ ENTITIES OF zbsj_i_so_header IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( GrossAmount NetAmount TaxAmount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(headers).

    CHECK headers IS NOT INITIAL.

    " 2. Read Items using the LINK table (Crucial for Draft mode!)
    READ ENTITIES OF zbsj_i_so_header IN LOCAL MODE
      ENTITY SalesOrder BY \_Item
        FIELDS ( Quantity GrossValue NetValue TaxValue  )
        WITH CORRESPONDING #( headers )
      LINK DATA(item_links) " <--- RAP standard mapping table
      RESULT DATA(items).

    " 3. Loop headers and calculate
    LOOP AT headers ASSIGNING FIELD-SYMBOL(<header>).

      " Safely inherit the exact data type of GrossAmount
      DATA(total_gross) = <header>-GrossAmount.
      DATA(total_net)   = <header>-NetAmount.
      DATA(total_tax)   = <header>-TaxAmount.
      CLEAR: total_gross, total_net, total_tax.




      LOOP AT item_links INTO DATA(item_link) USING KEY id WHERE source-%tky = <header>-%tky.
        TRY.
            DATA(item) = items[ KEY id %tky = item_link-target-%tky ].
            " ---> NEW: Handle empty quantities safely (default to 1 if blank to avoid multiplying by 0)
            DATA(lv_quantity) = COND #( WHEN item-Quantity > 0 THEN item-Quantity ELSE 1 ).

            " ---> NEW: Multiply the item's Net and Tax by the Quantity
            " ---> NEW: Safely inherit the exact data type (with decimals) first
            DATA(multiplied_net) = item-NetValue.
            DATA(multiplied_tax) = item-TaxValue.

            " ---> NEW: Then perform the multiplication
            multiplied_net = item-NetValue * lv_quantity.
            multiplied_tax = item-TaxValue * lv_quantity.
            " ---> NEW: Calculate Item Gross Value (Net + Tax)
            DATA(calculated_item_gross) = item-GrossValue.
            calculated_item_gross = multiplied_net + multiplied_tax.

            " ---> NEW: Append the newly calculated GrossValue to the item update table
            APPEND VALUE #(
              %tky       = item-%tky
              GrossValue = calculated_item_gross
            ) TO items_for_update.

            " Accumulate all three amounts from the child items for the Header
            total_gross += calculated_item_gross. " Use the new calculated value!
            total_net   += multiplied_net.
            total_tax   += multiplied_tax.

          CATCH cx_sy_itab_line_not_found cx_sy_arithmetic_overflow.
        ENDTRY.
      ENDLOOP.


      " 5. Prepare the update structure
      APPEND VALUE #(
        %tky         = <header>-%tky
        GrossAmount  = total_gross
        NetAmount    = total_net
        TaxAmount    = total_tax
      ) TO headers_for_update.

    ENDLOOP.

    " 6. Update the Database/Draft
    MODIFY ENTITIES OF zbsj_i_so_header IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( GrossAmount NetAmount TaxAmount )
        WITH headers_for_update

       ENTITY SalesOrderItem          " <--- NEW: Updates the item GrossValue
        UPDATE FIELDS ( GrossValue )
        WITH items_for_update.
  ENDMETHOD.

  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zbsj_i_so_header IN LOCAL MODE
      ENTITY SalesOrder
        EXECUTE RecalcTotalPrice
        FROM CORRESPONDING #( keys ).
  ENDMETHOD.

  METHOD CreateMaterial.
   LOOP AT keys INTO DATA(key).

      " 2. Use EML to create an independent Material record
      MODIFY ENTITIES OF ZBSJ_I_MATERIAL
        ENTITY Material
        CREATE FIELDS ( MaterialId MaterialName BaseUom UnitPrice Currency TaxCode )
        WITH VALUE #( (
            %cid         = '1'
            %is_draft    = if_abap_behv=>mk-off  " Create as active data
            MaterialId   = key-%param-MaterialId
            MaterialName = key-%param-MaterialName
            BaseUom      = key-%param-BaseUom
            UnitPrice    = key-%param-UnitPrice
            Currency     = key-%param-Currency
            TaxCode      = key-%param-TaxCode
        ) )
        FAILED DATA(failed_mat)
        REPORTED DATA(reported_mat).
    ENDLOOP.

    " 3. Read the current Sales Order to return it back to the UI (required for $self actions)
    READ ENTITIES OF ZBSJ_I_SO_HEADER IN LOCAL MODE
      ENTITY SalesOrder
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(sales_orders).

    result = VALUE #( FOR so IN sales_orders ( %tky = so-%tky %param = so ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_SalesOrderItem IMPLEMENTATION.

  METHOD calculateTotalPrice.
    " 1. Read parent headers via association
    READ ENTITIES OF zbsj_i_so_header IN LOCAL MODE
      ENTITY SalesOrderItem BY \_Header
        FIELDS ( SalesOrderId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(headers).

    " 2. Trigger action directly on parent headers (EML automatically handles duplicates)
    MODIFY ENTITIES OF zbsj_i_so_header IN LOCAL MODE
      ENTITY SalesOrder
        EXECUTE RecalcTotalPrice
        FROM CORRESPONDING #( headers ).
  ENDMETHOD.

  METHOD determineMaterialDefaults.
   READ ENTITIES OF ZBSJ_I_SO_HEADER IN LOCAL MODE
      ENTITY SalesOrderItem
        FIELDS ( MaterialId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(items).

    DATA: items_for_update TYPE TABLE FOR UPDATE ZBSJ_I_SO_ITEM.

    " 2. Loop through the items to fetch master data
    LOOP AT items INTO DATA(item) WHERE MaterialId IS NOT INITIAL.

      " Read the Unit Price and UoM directly from your Material CDS view
      SELECT SINGLE BaseUom, UnitPrice
        FROM ZBSJ_I_MATERIAL
        WHERE MaterialId = @item-MaterialId
        INTO @DATA(material_data).

      IF sy-subrc = 0.
        " 3. Prepare to update the Item's NetValue and UoM
        APPEND VALUE #(
          %tky     = item-%tky
          Uom      = material_data-BaseUom
          NetValue = material_data-UnitPrice
        ) TO items_for_update.
      ENDIF.
    ENDLOOP.

    " 4. Update the item in the draft/database
    IF items_for_update IS NOT INITIAL.
      MODIFY ENTITIES OF ZBSJ_I_SO_HEADER IN LOCAL MODE
        ENTITY SalesOrderItem
          UPDATE FIELDS ( Uom NetValue )
          WITH items_for_update.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
