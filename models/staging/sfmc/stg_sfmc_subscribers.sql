with subscribers as ( SELECT * FROM {{ source('src_sfmc','subscribers') }} )

#FIX THIS ONE LATER

SELECT distinct
*

FROM subscribers
