with sent as ( SELECT * FROM {{ source('src_sfmc','sent') }} )

SELECT distinct
    CAST(AccountID AS INT64) as account_id
    ,CAST(OYBAccountID AS INT64) as oyb_account_id
    ,CAST(JobID AS INT64) as job_id
    ,CAST(ListID AS INT64) as list_id
    ,CAST(BatchID AS INT64) as batch_id
    ,CAST(SubscriberID AS INT64) as subscriber_id
    ,SubscriberKey as subscriber_key
    ,datetime(CAST(CONCAT(Substr(EventDate,0,22)," America/New_York") as timestamp), "America/New_York") as event_dt
    ,Domain as domain 
    ,TriggererSendDefinitionObjectID as triggerrer_send_definition_object_id
    ,TriggeredSendCustomerKey as triggered_send_customer_key

FROM sent 