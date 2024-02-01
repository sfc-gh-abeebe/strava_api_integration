use schema data;
CREATE OR REPLACE FUNCTION get_strava_activities_by_date_range(startDate timestamp_ntz, endDate timestamp_ntz)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.8
HANDLER = 'get_activities_by_date_range'
EXTERNAL_ACCESS_INTEGRATIONS = (strava_access_integration)
PACKAGES = ('snowflake-snowpark-python','requests')
SECRETS = ('cred' = abeebe_db.secret_schema.strava_oauth_token )
AS
$$
import _snowflake
import requests
import json
import datetime, calendar
from datetime import timedelta

session = requests.Session()
def get_activities_by_date_range(start, end):

  start_time = datetime.datetime(start.year, start.month, start.day, 0, 0, 0)
  end_time = datetime.datetime(end.year, end.month, end.day, 0, 0, 0)
  start_epoch = calendar.timegm(start_time.timetuple())
  end_epoch = calendar.timegm(end_time.timetuple())

  token = _snowflake.get_oauth_access_token('cred')
  url = "https://www.strava.com/api/v3/athlete/activities?after=" + str(start_epoch) + "&before=" + str(end_epoch)
  page = 1
  activities_json = True
  activities_obj = []

  while activities_json:
    activities_json = session.get(url + f"&page={page}", headers = {"Authorization": "Bearer " + token}).json()
    activities_obj.extend(activities_json)
    page+=1

  if len(activities_obj) == 0:
    return None
    
  return json.dumps(activities_obj)
$$;