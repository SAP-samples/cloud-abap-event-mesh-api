CLASS zcl_ems_mgnt_api DEFINITION
  PUBLIC
  FINAL
  INHERITING FROM zcl_ems_api.

  PUBLIC SECTION.

    METHODS get_queues RETURNING VALUE(r_response) TYPE string.

    METHODS get_queue IMPORTING iv_queue_name     TYPE string
                      RETURNING VALUE(r_response) TYPE string.

    METHODS create_update_queue IMPORTING iv_queue_name     TYPE string
                                          iv_request_text   TYPE string
                                RETURNING VALUE(r_response) TYPE string.

    METHODS delete_queue IMPORTING iv_queue_name     TYPE string
                         RETURNING VALUE(r_response) TYPE string.

    METHODS get_queue_statistics IMPORTING iv_queue_name TYPE string
                      RETURNING VALUE(r_response) TYPE string.

    METHODS get_queues_statistics
                      RETURNING VALUE(r_response) TYPE string.

    METHODS get_queue_subscriptions IMPORTING iv_queue_name     TYPE string
                      RETURNING VALUE(r_response) TYPE string.

    METHODS create_update_queue_sub
                                IMPORTING iv_queue_name     TYPE string
                                          iv_topic          type string
                                RETURNING VALUE(r_response) TYPE string.

    METHODS delete_queue_sub IMPORTING iv_queue_name  TYPE string
                                                 iv_topic    type string
                         RETURNING VALUE(r_response) TYPE string.

    METHODS readiness_check
                      RETURNING VALUE(r_response) TYPE string.

    METHODS get_resource_usage
                      RETURNING VALUE(r_response) TYPE string.

    METHODS get_broker_statistics
                      RETURNING VALUE(r_response) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS ZCL_EMS_MGNT_API IMPLEMENTATION.

  METHOD get_queues.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues| ).

  ENDMETHOD.

  METHOD get_queue.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }| ).

  ENDMETHOD.

  METHOD create_update_queue.

    r_response = execute_ems_request(
                        iv_http_action  = if_web_http_client=>put
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }|
                        iv_request_text  = iv_request_text ) .

  ENDMETHOD.

  METHOD delete_queue.

    r_response = execute_ems_request(
                        iv_http_action  = if_web_http_client=>delete
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }| ).

  ENDMETHOD.

  METHOD get_queue_statistics.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }/statistics| ).

  ENDMETHOD.

  METHOD get_queues_statistics.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queuesStatistics| ).

  ENDMETHOD.

  METHOD get_queue_subscriptions.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }/subscriptions| ).

  ENDMETHOD.

  METHOD create_update_queue_sub.

    r_response = execute_ems_request(
                        iv_http_action  = if_web_http_client=>put
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }/subscriptions/{ iv_topic }| ).

  ENDMETHOD.

  METHOD delete_queue_sub.

    r_response = execute_ems_request(
                        iv_http_action  = if_web_http_client=>delete
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/queues/{ iv_queue_name }/subscriptions/{ iv_topic }| ).

  ENDMETHOD.

  METHOD readiness_check.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/readinessCheck| ).

  ENDMETHOD.

  METHOD get_resource_usage.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/resourceusage| ).

  ENDMETHOD.

  METHOD get_broker_statistics.

    r_response = execute_ems_request(
                        iv_uri_path = |/hub/rest/api/v1/management/messaging/statistics| ).

  ENDMETHOD.

ENDCLASS.
