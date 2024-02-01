from strava_token import client
import json

api_url = 'https://www.strava.com/api/v3/'

def get(path, ps):
    response = client.get(api_url + path, params=ps)
    return json.loads(response.text)

def post(data):
    # nothing to see here!
    return 'success'