create or replace task strava_activities_task_daily
warehouse = abeebe_wh
schedule = 'USING CRON 0 5 * * * America/Los_Angeles'
AS
    INSERT INTO strava_activities_raw (activity_start_time, activity)
    with activities as (
        select 
            parse_json(get_strava_activities_by_date_range((DATEADD('days',-1,CURRENT_DATE()))::timestamp_ntz, CURRENT_DATE()::timestamp_ntz)) as response
    )
    select
        res.value:start_date_local::timestamp_ntz as activity_start_time,
        res.value as activity
    from activities,
    table(flatten(input => activities.response)) as res;

alter task strava_activities_task_daily resume;