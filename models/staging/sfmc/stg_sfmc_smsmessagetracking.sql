with smsmessagetracking as ( SELECT * FROM {{ source('src_sfmc','smsmessagetracking') }} )

#FIX THIS ONE LATER

SELECT distinct
*

FROM smsmessagetracking
