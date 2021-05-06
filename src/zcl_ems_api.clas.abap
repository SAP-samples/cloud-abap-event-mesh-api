CLASS zcl_ems_api DEFINITION
   PUBLIC ABSTRACT.

  PUBLIC SECTION.

    CLASS-METHODS create_messaging_api
      RETURNING
                VALUE(msg_api) TYPE REF TO zcl_ems_msg_api
      RAISING   cx_http_dest_provider_error
                cx_web_http_client_error.

    CLASS-METHODS create_management_api
      RETURNING
                VALUE(mgnt_api) TYPE REF TO zcl_ems_mgnt_api
      RAISING   cx_http_dest_provider_error
                cx_web_http_client_error.

  PROTECTED SECTION.

    METHODS execute_ems_request
      IMPORTING iv_uri_path       TYPE string
                iv_qos            TYPE string DEFAULT '0'
                iv_http_action    TYPE if_web_http_client=>method
                  DEFAULT if_web_http_client=>get
                iv_request_text   TYPE string OPTIONAL
      EXPORTING et_header_fields  TYPE if_web_http_request=>name_value_pairs
                es_status         TYPE if_web_http_response=>http_status
      RETURNING VALUE(r_response) TYPE string
      RAISING   cx_web_message_error.

  PRIVATE SECTION.

    CONSTANTS: gc_em_msg_url TYPE string VALUE ''.
    CONSTANTS: gc_em_mgnt_url TYPE string VALUE ''.
    CONSTANTS: gc_token_url TYPE string VALUE  ''. "must include URL parameters ?grant_type=client_credentials&response_type=token
    CONSTANTS: gc_user TYPE string VALUE ''.
    CONSTANTS: gc_password TYPE string VALUE ''.
    CLASS-DATA: gv_em_url TYPE string.

    METHODS get_access_token
      RETURNING VALUE(r_token) TYPE string
      RAISING   cx_web_message_error.

ENDCLASS.


CLASS zcl_ems_api IMPLEMENTATION.

  METHOD create_messaging_api.

    msg_api = NEW zcl_ems_msg_api( ).
    gv_em_url = gc_em_msg_url.

  ENDMETHOD.

  METHOD create_management_api.

    mgnt_api = NEW zcl_ems_mgnt_api( ).
    gv_em_url = gc_em_mgnt_url.

  ENDMETHOD.

  METHOD get_access_token.

    TYPES: BEGIN OF ty_token,
             access_token TYPE string,
             token_type   TYPE string,
             expires_in   TYPE string,
           END OF ty_token.
    DATA: ls_token TYPE ty_token.

    TRY.

* request a new access token for primary API call
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                                 i_destination = cl_http_destination_provider=>create_by_url( gc_token_url ) ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_authorization_basic( i_username = gc_user i_password = gc_password ).
        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
        /ui2/cl_json=>deserialize( EXPORTING json = lo_response->get_text( )
                                   CHANGING data = ls_token ).
        r_token = ls_token-access_token.   "<-- return token string to caller
        lo_http_client->close( ).
      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
    ENDTRY.

  ENDMETHOD.

  METHOD execute_ems_request.

    TRY.

* Setup request
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                                 i_destination = cl_http_destination_provider=>create_by_url( gv_em_url && iv_uri_path  ) ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_request->set_header_field( i_name = 'Authorization' i_value = |Bearer { me->get_access_token( ) }| ).
        lo_request->set_header_field( i_name  = 'x-qos' i_value = iv_qos ).

        IF iv_request_text IS SUPPLIED.
          lo_request->set_text( iv_request_text ).
        ENDIF.

* Execute request
        DATA ls_status TYPE if_web_http_response=>http_status.
        CASE iv_http_action.
          WHEN if_web_http_client=>get OR if_web_http_client=>post.
            DATA(lo_response) = lo_http_client->execute( i_method = iv_http_action ).
            IF lo_response->get_text( ) IS INITIAL.
              ls_status = lo_response->get_status( ).
              r_response = |Response is: { ls_status-code } { ls_status-reason }.| .
            ELSE.
              r_response = lo_response->get_text( ).
            ENDIF.

            IF et_header_fields IS REQUESTED.
              et_header_fields = lo_response->get_header_fields( ).
            ENDIF.
            IF es_status IS REQUESTED.
              es_status = lo_response->get_status( ).
            ENDIF.

          WHEN if_web_http_client=>patch OR
               if_web_http_client=>delete OR
               if_web_http_client=>put.
            lo_response = lo_http_client->execute( i_method = iv_http_action ).
            ls_status = lo_response->get_status( ).
            r_response = |Response is: { ls_status-code } { ls_status-reason }.| .
          WHEN OTHERS.
            r_response = |Response is: 405 Method Not Allowed.| .
        ENDCASE.

        lo_http_client->close( ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
        r_response =  lx_error->get_text( ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
