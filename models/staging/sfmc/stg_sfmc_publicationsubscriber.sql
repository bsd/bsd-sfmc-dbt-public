WITH publicationsubscriber as (SELECT * FROM {{ source('src_sfmc','publicationsubscriber') }} )

SELECT distinct
    PublicationID as publication_id
    ,ListName as list_name
    ,SubscriberID as subscriber_id
    ,TransactionalOptIn as transactional_opt_in
    ,datetime(CAST(CONCAT(Substr(TransactionalOptInDate,0,22)," America/New_York") as timestamp), "America/New_York") as transactional_opt_in_dt
    ,datetime(CAST(CONCAT(Substr(TransactionalOptOutDate,0,22)," America/New_York") as timestamp), "America/New_York") as transactional_opt_out_dt
    ,MarketingOptIn as marketing_opt_in
    ,datetime(CAST(CONCAT(Substr(MarketingOptInDate,0,22)," America/New_York") as timestamp), "America/New_York") as marketing_opt_in_dt
    ,datetime(CAST(CONCAT(Substr(MarketingOptOutDate,0,22)," America/New_York") as timestamp), "America/New_York") as marketing_opt_out_dt

FROM publicationsubscriber