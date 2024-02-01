CREATE OR REPLACE FUNCTION get_strava_athelete()
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.8
HANDLER = 'get_activities'
EXTERNAL_ACCESS_INTEGRATIONS = (strava_access_integration)
PACKAGES = ('snowflake-snowpark-python','requests')
SECRETS = ('cred' = abeebe_db.secret_schema.strava_oauth_token )
AS
$$
import _snowflake
import requests
import json
session = requests.Session()
def get_activities():
  token = _snowflake.get_oauth_access_token('cred')
  url = "https://www.strava.com/api/v3/athlete"
  response = session.get(url, headers = {"Authorization": "Bearer " + token})
  return response.json()
$$;