with journey as ( SELECT * FROM {{ source('src_sfmc','journey') }} )

SELECT distinct
    VersionID as version_id
    ,JourneyID as journey_id
    ,JourneyName as journey_name
    ,CAST(VersionNumber AS INT64) as version_number
    ,( case
        when length(CreatedDate) > 0 then datetime(CAST(CONCAT(Substr(CreatedDate,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as created_dt
    ,( case
        when length(LastPublishedDate) > 0 then datetime(CAST(CONCAT(Substr(LastPublishedDate,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as last_published_dt
    ,( case
        when length(ModifiedDate) > 0 then datetime(CAST(CONCAT(Substr(ModifiedDate,0,22)," America/New_York") as timestamp), "America/New_York")
        else null
    end ) as modified_dt
    ,JourneyStatus as journey_status
FROM journey