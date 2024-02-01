import json
from requests_oauthlib import OAuth2Session
import strava_authorization as auth

creds = json.load(open("secrets.json"))
params = json.load(open("params.json"))

if "token" not in creds:
    auth.get_authorization()
    creds = json.load(open("secrets.json")) # need to reload creds after token is created

def set_token(token):
    creds["token"] = token

client = OAuth2Session(
    client_id=creds["client_id"],
    token=creds["token"],
    auto_refresh_url='https://www.strava.com/oauth/token',
    auto_refresh_kwargs=creds, token_updater=set_token)