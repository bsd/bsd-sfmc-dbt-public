with job as ( SELECT * FROM {{ source('src_sfmc','job') }} )

SELECT
    CAST(JobID AS INT64) as job_id
    ,CAST(EmailID AS INT64) as email_id
    ,CAST(AccountID AS INT64) as account_id
    ,CAST(AccountUserID AS INT64) as account_user_id
    ,FromName as from_name
    ,FromEmail as from_email
    ,( case
        when length(SchedTime) > 0 then datetime(CAST(CONCAT(Substr(SchedTime,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as sched_dt
    ,( case
        when length(PickupTime) > 0 then datetime(CAST(CONCAT(Substr(PickupTime,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as pickup_dt
    ,( case
        when length(DeliveredTime) > 0 then datetime(CAST(CONCAT(Substr(DeliveredTime,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as delivered_dt    
    ,EventID as event_id
    ,CAST(IsMultipart AS BOOL) as is_multipart
    ,JobType as job_type
    ,JobStatus as job_status
    ,ModifiedBy as modified_by
    ,( case
        when length(ModifiedDate) > 0 then datetime(CAST(CONCAT(Substr(ModifiedDate,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as modified_dt       
    ,EmailName as email_name
    ,EmailSubject as email_subject
    ,CAST(IsWrapped AS BOOL) as is_wrapped
    ,TestEmailAddr as test_email_addr
    ,Category as category
    ,BccEmail as bcc_email
    ,OriginalSchedTime as original_sched_time
    ,( case
        when length(CreatedDate) > 0 then datetime(CAST(CONCAT(Substr(CreatedDate,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as created_dt      
    ,CharacterSet as character_set
    ,IPAddress as ip_address
    ,CAST(SalesForceTotalSubscriberCount AS INT64) as salesforce_total_subscriber_count
    ,CAST(SalesforceErrorSubscriberCount AS INT64) as salesforce_error_subscriber_count
    ,SendType as send_type
    ,DynamicEmailSubject as dynamic_email_subject
    ,CAST(SuppressTracking AS BOOL) as suppress_tracking
    ,SendClassificationType as send_classification_type
    ,SendClassification as send_classification
    ,CAST(ResolveLinksWithCurrentData AS BOOL) as resolve_links_with_current_data
    ,EmailSendDefinition as email_send_definition
    ,CAST(DeduplicateByEmail AS BOOL) as deduplicated_by_email
    ,TriggererSendDefinitionObjectID as triggerrer_send_definition_object_id
    ,TriggeredSendCustomerKey as triggered_send_customer_key
FROM (SELECT *, row_number() OVER (PARTITION BY JobID ORDER BY PickupTime DESC) as row_num
      FROM job)
WHERE row_num = 1
