with journeyactivity as ( SELECT * FROM {{ source('src_sfmc','journeyactivity') }} )

SELECT distinct
    VersionID as version_id
    ,ActivityID as activity_id
    ,ActivityName as activity_name
    ,ActivityExternalKey as activity_external_key
    ,JourneyActivityObjectID as journey_activity_object_id
    ,ActivityType as activity_type

FROM journeyactivity