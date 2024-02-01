create or replace table strava_activities_raw as
with activities as (
select 
    parse_json(get_strava_activities_by_date_range((DATEADD('days',-1,CURRENT_DATE()))::timestamp_ntz, CURRENT_DATE()::timestamp_ntz)) as response
)
select
    res.value:start_date_local::timestamp_ntz as activity_start_time,
    res.value as activity
from activities,
table(flatten(input => activities.response)) as res;

select activity_start_time::date as activity_date, * from strava_activities_raw where activity_date > '2024-01-01';