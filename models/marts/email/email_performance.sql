WITH  click as ( SELECT * FROM {{ ref('stg_sfmc_click') }} )
,complaint as ( SELECT * FROM {{ ref('stg_sfmc_complaint') }} )
,job as ( SELECT * FROM {{ ref('stg_sfmc_job') }} )
,open as ( SELECT * FROM {{ ref('stg_sfmc_open') }} )
,sent as ( SELECT * FROM {{ ref('stg_sfmc_sent') }} )
,bounce as ( SELECT * FROM {{ ref('stg_sfmc_bounce') }} )
,unsub as ( SELECT * FROM {{ ref('stg_sfmc_unsubscribe') }} )

,clicks as (
    SELECT
        job_id
        ,count(subscriber_key) as total_clicks
        ,count(distinct subscriber_key) as unique_clicks
        FROM click
        GROUP BY 1
)

,opens as (
    SELECT
        job_id
        ,count(subscriber_key) as total_opens
        ,count(distinct subscriber_key) as unique_opens
        FROM open
        GROUP BY 1
)

,recipients  as (
    SELECT
        job_id
        ,count(distinct subscriber_key) as recipients
        FROM sent
        GROUP BY 1
)

,jobs as (
    SELECT 
        job_id
        ,email_id
        ,from_name
        ,from_email
        ,sched_dt
        ,pickup_dt
        ,delivered_dt
        ,email_name
        ,email_subject
        ,category
    FROM job
)

,bounces as (
    SELECT
        job_id
        ,count( distinct CASE WHEN bounce_category = 'Hard bounce' THEN subscriber_key ELSE Null END) as hard_bounces
        ,count( distinct CASE WHEN bounce_category = 'Block bounce' THEN subscriber_key ELSE Null END) as block_bounces
        ,count( distinct CASE WHEN bounce_category = 'Technical/Other bounce' THEN subscriber_key ELSE Null END) as tech_bounces
        ,count( distinct CASE WHEN bounce_category = 'Soft bounce' THEN subscriber_key ELSE Null END) as soft_bounces
        ,count( distinct CASE WHEN bounce_category = 'Unknown bounce' THEN subscriber_key ELSE Null END) as unknown_bounces
        ,count(distinct subscriber_key) as total_bounces
    FROM bounce
    GROUP BY 1
)

,unsubs as (
    SELECT
        job_id
        ,count(distinct subscriber_key) as unsubs
    FROM unsub
    GROUP BY 1
)

,final as (
    SELECT 
        j.* 
        ,recipients
        ,total_opens
        ,unique_opens
        ,total_clicks
        ,unique_clicks
        ,total_bounces
        ,block_bounces
        ,tech_bounces
        ,soft_bounces
        ,unknown_bounces
        ,unsubs
        ,CONCAT('https://members.s10.exacttarget.com/Content/Email/EmailThumbnail.aspx?eid=',CAST(j.email_id as string),'&w=800&h=2000&showHF=true') as preview_url

    
    FROM jobs j
    LEFT JOIN recipients r
        ON j.job_id = r.job_id
    LEFT JOIN opens o 
        ON j.job_id = o.job_id
    LEFT JOIN clicks c 
        ON j.job_id = c.job_id
    LEFT JOIN bounces b 
        ON j.job_id = b.job_id
    LEFT JOIN unsubs u 
        ON j.job_id = u.job_id
)

SELECT * FROM final