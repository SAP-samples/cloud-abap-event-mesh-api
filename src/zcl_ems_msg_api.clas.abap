CLASS zcl_ems_msg_api DEFINITION
  PUBLIC
  FINAL
  INHERITING FROM zcl_ems_api.

  PUBLIC SECTION.

    METHODS publish_message_to_queue IMPORTING iv_queue_name     TYPE string
                                               iv_qos            type string default '0'
                                               iv_message        TYPE string
                                     RETURNING VALUE(r_response) TYPE string.
    METHODS publish_message_to_topic IMPORTING iv_topic_name     TYPE string
                                               iv_qos            type string default '0'
                                               iv_message        TYPE string
                                     RETURNING VALUE(r_response) TYPE string.
    METHODS consume_message_from_queue IMPORTING iv_queue_name     TYPE string
                                                 iv_qos            type string default '0'
                                       EXPORTING ev_message_id     TYPE string
                                       RETURNING VALUE(r_response) TYPE string.
    METHODS acknowledge_msg_consumption IMPORTING iv_queue_name     TYPE string
                                                  iv_message_id     TYPE string
                                        RETURNING VALUE(r_response) TYPE string.
    METHODS create_subscription IMPORTING iv_request_text   TYPE string
                                RETURNING VALUE(r_response) TYPE string.
    METHODS get_subscription  IMPORTING iv_subscription_name TYPE string
                              RETURNING VALUE(r_response)    TYPE string.
    METHODS get_subscriptions RETURNING VALUE(r_response) TYPE string.
    METHODS delete_subscription IMPORTING iv_subscription_name TYPE string
                                RETURNING VALUE(r_response)    TYPE string.
    METHODS trigger_subscription_handshake IMPORTING iv_subscription_name TYPE string
                                           RETURNING VALUE(r_response)    TYPE string.
    METHODS update_subscription_state IMPORTING iv_subscription_name TYPE string
                                                iv_request_text      TYPE string
                                      RETURNING VALUE(r_response)    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCL_EMS_MSG_API IMPLEMENTATION.

  METHOD publish_message_to_queue.   "test done

    r_response = execute_ems_request(
                        iv_http_action = if_web_http_client=>post
                        iv_qos = iv_qos
                        iv_uri_path = |/messagingrest/v1/queues/{ iv_queue_name }/messages|
                        iv_request_text = iv_message ).

  ENDMETHOD.


  METHOD publish_message_to_topic.  "test done

    r_response = execute_ems_request(
                        iv_http_action = if_web_http_client=>post
                        iv_qos = iv_qos
                        iv_uri_path = |/messagingrest/v1/topics/{ iv_topic_name }/messages|
                        iv_request_text = iv_message ).

  ENDMETHOD.


  METHOD consume_message_from_queue.  "test done, works for consumption of queue and topic messages

    execute_ems_request(
                     EXPORTING
                         iv_http_action = if_web_http_client=>post
                         iv_qos = iv_qos
                         iv_uri_path = |/messagingrest/v1/queues/{ iv_queue_name }/messages/consumption|
                     IMPORTING
                        et_header_fields = DATA(lt_header_fields)
                     RECEIVING
                        r_response = r_response ).
    READ TABLE lt_header_fields REFERENCE INTO DATA(lr_message_id) WITH KEY name = 'x-message-id'.
    IF sy-subrc = 0.
      ev_message_id = lr_message_id->value.
    ENDIF.

  ENDMETHOD.


  METHOD acknowledge_msg_consumption.  "test done

    r_response = execute_ems_request(
                       iv_http_action = if_web_http_client=>post
                       iv_uri_path = |/messagingrest/v1/queues/{ iv_queue_name }/messages/{ iv_message_id }/acknowledgement| ).

  ENDMETHOD.


  METHOD create_subscription. "test done

    r_response = execute_ems_request(
                   EXPORTING
                     iv_uri_path      = |/messagingrest/v1/subscriptions|
                     iv_http_action   = if_web_http_client=>post
                     iv_request_text  = iv_request_text ).

  ENDMETHOD.


  METHOD get_subscription.  "test done

    r_response = execute_ems_request(
                        iv_uri_path = |/messagingrest/v1/subscriptions/{ iv_subscription_name }| ).

  ENDMETHOD.


  METHOD get_subscriptions. "test done

    r_response = execute_ems_request(
                        iv_uri_path = |/messagingrest/v1/subscriptions| ).

  ENDMETHOD.


  METHOD delete_subscription. "test done

    r_response = execute_ems_request(
                        iv_http_action   = if_web_http_client=>delete
                        iv_uri_path = |/messagingrest/v1/subscriptions/{ iv_subscription_name }| ).

  ENDMETHOD.


  METHOD update_subscription_state.  "test done

    r_response = execute_ems_request(
                        iv_http_action   = if_web_http_client=>put
                        iv_uri_path = |/messagingrest/v1/subscriptions/{ iv_subscription_name }/state|
                        iv_request_text  = iv_request_text ) .

  ENDMETHOD.

  METHOD trigger_subscription_handshake.  "test done

    r_response = execute_ems_request(
                        iv_http_action   = if_web_http_client=>post
                        iv_uri_path = |/messagingrest/v1/subscriptions/{ iv_subscription_name }/handshake| ).

  ENDMETHOD.
ENDCLASS.
