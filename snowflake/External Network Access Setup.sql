// Playing around with External Network Access
USE ROLE ACCOUNTADMIN;
USE DATABASE {MY_DATABASE};

CREATE OR REPLACE NETWORK RULE strava_api_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('www.strava.com:443');

CREATE OR REPLACE SECRET strava_client_id
  TYPE = GENERIC_STRING
  SECRET_STRING = 'Replace with your client id';
  
CREATE OR REPLACE SECRET strava_client_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'Replace with your client secret';

CREATE OR REPLACE SECURITY INTEGRATION strava_oauth
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  OAUTH_CLIENT_ID = 'Replace with your client id'
  OAUTH_CLIENT_SECRET = 'Replace with your client secret'
  OAUTH_TOKEN_ENDPOINT = 'https://www.strava.com/oauth/token?client_id={Replace with your client id}&client_secret={Replace with your client secret}'
  OAUTH_AUTHORIZATION_ENDPOINT = 'https://www.strava.com/oauth/authorize'
  OAUTH_GRANT = 'AUTHORIZATION_CODE'
  OAUTH_ALLOWED_SCOPES = ('activity:read_all')
  ENABLED = TRUE;

CREATE OR REPLACE SCHEMA SECRET_SCHEMA;
USE SCHEMA SECRET_SCHEMA;
CREATE OR REPLACE SECRET strava_oauth_token
  TYPE = oauth2
  API_AUTHENTICATION = strava_oauth;

SELECT SYSTEM$START_OAUTH_FLOW('{MY_DATABASE}.secret_schema.strava_oauth_token');

SELECT SYSTEM$FINISH_OAUTH_FLOW('Replace with url after "state" generated from SYSTEM$START_OAUTH_FLOW');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION strava_access_integration
  ALLOWED_NETWORK_RULES = (strava_api_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (strava_oauth_token)
  ENABLED = TRUE;

GRANT READ ON SECRET strava_oauth_token TO ROLE {MY_ROLE};
GRANT USAGE ON SCHEMA secret_schema TO ROLE {MY_ROLE};
GRANT USAGE ON INTEGRATION strava_access_integration TO ROLE {MY_ROLE};
GRANT EXECUTE TASK ON ACCOUNT TO ROLE {MY_ROLE};
