CLASS zcl_ems_api_tester DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_ems_api_tester IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

**** Management API Testing
    TRY.
        DATA(lo_ems_mgnt_api) =   zcl_ems_api=>create_management_api( ).
      CATCH: cx_http_dest_provider_error, cx_web_http_client_error INTO DATA(lx_expx).
        out->write( lx_expx->get_text(  ) ).
    ENDTRY.

* out->write(  lo_ems_mgnt_api->create_update_queue(
*                 iv_queue_name   = `abapqueue`
*                 iv_request_text =  `{` && |\r\n|  &&
*                                    ` "maxQueueMessageCount": 10,` && |\r\n|  &&
*                                    ` "maxRedeliveryCount": 20`  && |\r\n|  &&
*                                    `}`
*               ) ).

* out->write( lo_ems_mgnt_api->get_queue( `abapqueue` ) ).

* out->write( lo_ems_mgnt_api->get_queues( ) ).

* out->write( lo_ems_mgnt_api->delete_queue( `abapqueue` ) ).

* out->write( lo_ems_mgnt_api->get_queue_statistics( `abapqueue` ) ).   "Only works for certain plans

* out->write( lo_ems_mgnt_api->get_queues_statistics(  ) ).   "Only works for certain plans

* out->write( lo_ems_mgnt_api->create_update_queue_sub(
*              iv_queue_name = `abapqueue`
*              iv_topic      = `testtopic%2Fseg1`   "<-- must encode the forward slash
*            ) ).

* out->write( lo_ems_mgnt_api->get_queue_subscriptions( `abapqueue` ) ).

* out->write( lo_ems_mgnt_api->delete_queue_sub(
*              iv_queue_name = `abapqueue`
*              iv_topic      = `testtopic%2Fseg1` "<--  must encode the forward slash
*            ) ).

* out->write( lo_ems_mgnt_api->readiness_check( ) ).

* out->write( lo_ems_mgnt_api->get_resource_usage( ) ).   "Only works for certain plans

* out->write( lo_ems_mgnt_api->get_broker_statistics( ) ). "Only works for certain plans


**** Messaging API Testing
    TRY.
        DATA(lo_ems_msg_api) =  zcl_ems_api=>create_messaging_api( ).
      CATCH: cx_http_dest_provider_error, cx_web_http_client_error INTO DATA(lx_exp).
        out->write( lx_exp->get_text(  ) ).
    ENDTRY.

* Create a subscription
*   out->write( lo_ems_msg_api->create_subscription(
*                                     iv_request_text =  `{` && |\r\n|  &&
*                                                        `   "name": "abapwhsub",` && |\r\n|  &&
*                                                        `   "address": "queue:abapqueue",` && |\r\n|  &&
*                                                        `   "qos": 0,` && |\r\n|  &&
*                                                        '    "pushConfig": {' && |\r\n|  &&
*                                                        '        "type": "webhook",' && |\r\n|  &&
*                                                        '        "endpoint": "https://www.sap.com",' && |\r\n|  &&
*                                                        '        "securitySchema": {' && |\r\n|  &&
*                                                        '            "type": "oauth2",' && |\r\n|  &&
*                                                        '            "grantType": "client_credentials",' && |\r\n|  &&
*                                                        '            "clientId": "<client_id>",' && |\r\n|  &&
*                                                        '            "clientSecret": "<client_secret>",' && |\r\n|  &&
*                                                        '            "tokenUrl": "https://www.sap.com"' && |\r\n|  &&
*                                                        '        }' && |\r\n|  &&
*                                                        '    }'  && |\r\n|  &&
*                                                        `}`
*                                                        ) ).


* Write out webhook subscriptions
*  out->write( lo_ems_msg_api->get_subscriptions( ) ).

* Write out a webhook subscription
*  out->write( lo_ems_msg_api->get_subscription( 'abapwhsub' ) ).

* Trigger a webhook subscription handshake
*  out->write( lo_ems_msg_api->trigger_subscription_handshake( iv_subscription_name =  'abapwhsub' ) ).

* Update a webhook subscription state
*  out->write( lo_ems_msg_api->update_subscription_state(
*                iv_subscription_name = 'abapwhsub'
*                iv_request_text      = '{"action": "pause"}' ) ).

* delete a webhook subscription
*  out->write( lo_ems_msg_api->delete_subscription( iv_subscription_name = 'abapwhsub' ) ).


* Publish a message to a topic
*  out->write( lo_ems_msg_api->publish_message_to_topic(
*                    iv_topic_name = 'testtopic%2Fseg1'
*                    iv_qos        = '0'
*                    iv_message    = '{' && |\n|  &&
*                                    '    "salesorder": "99999",' && |\n|  &&
*                                    '    "custid": "126456",' && |\n|  &&
*                                    '    "custname": "Customer Name",' && |\n|  &&
*                                    '    "creationdate": "2020-10-02",' && |\n|  &&
*                                    '    "credits": "1234"' && |\n|  &&
*                                    '    "salesorg": "9876"' && |\n|  &&
*                                    '}'
*                  ) ).


* Publish message to queue
*  out->write( lo_ems_msg_api->publish_message_to_queue(
*                    iv_queue_name = 'abapqueue'
*                    iv_qos        = '0'
*                    iv_message    = '{' && |\n|  &&
*                                    '    "salesorder": "123456",' && |\n|  &&
*                                    '    "custid": "99998",' && |\n|  &&
*                                    '    "custname": "Customer Name",' && |\n|  &&
*                                    '    "creationdate": "2020-10-02",' && |\n|  &&
*                                    '    "credits": "12365414"' && |\n|  &&
*                                    '    "salesorg": "9876"' && |\n|  &&
*                                    '}'
*                  ) ).


* Consume the messages and acknowledge them
* Once you have processed the message, acknowledge it.
*  data lv_message_id type string.
*  out->write( lo_ems_msg_api->consume_message_from_queue( exporting
*                                                           iv_queue_name = 'abapqueue'
*                                                           iv_qos = '1'
*                                                          importing
*                                                           ev_message_id = lv_message_id ) ).
*  if lv_message_id  is not INITIAL.
*   out->write( lo_ems_msg_api->acknowledge_msg_consumption(
*                    iv_queue_name = 'abapqueue'
*                    iv_message_id = lv_message_id
*                  ) ).
*  endif.

  ENDMETHOD.
ENDCLASS.
