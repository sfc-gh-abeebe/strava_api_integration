import json
from requests_oauthlib import OAuth2Session

# this is a one time process to initially aquire access token with correct scope, needs to be regenerated if scope changes
# could potentially add additional step to check for token and remove if scope needs to change, but not neccessary for demo purposes

creds = json.load(open("secrets.json"))
params = json.load(open("params.json"))

oauth = OAuth2Session(creds["client_id"], redirect_uri=params["redirect_uri"], scope=params["scope"])

# authorization flow for oauth 2.0
def get_authorization():
    authorization_url, state = oauth.authorization_url('https://www.strava.com/oauth/authorize', client_secret=creds["client_secret"])

    print('Please go to %s and authorize access.' % authorization_url)
    authorization_response = input('Enter the full callback URL')

    get_token(authorization_response)

def get_token(auth_response):
    response = oauth.fetch_token(
            'https://www.strava.com/oauth/token',
            authorization_response=auth_response,
            include_client_id=True,
            client_secret=creds["client_secret"])

    creds["token"] = {
        "access_token": response["access_token"],
        "refresh_token": response["refresh_token"]
    }

    with open("secrets.json", "w") as cf:
        cf.write(json.dumps(creds))