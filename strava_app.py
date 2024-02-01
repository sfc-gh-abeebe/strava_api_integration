import json
import strava_api as api
import datetime, calendar

def get_activities_by_date_range(start, end):
    start_time = datetime.datetime(start.year, start.month, start.day, 0, 0, 0)
    end_time = datetime.datetime(end.year, end.month, end.day, 0, 0, 0)
    start_epoch = calendar.timegm(start_time.timetuple())
    end_epoch = calendar.timegm(end_time.timetuple())

    page = 1
    activities_json = True
    response_obj = []

    # max page count is 30 by default, need to paginate through results
    while activities_json:
        activities_json = api.get('athlete/activities', 'after=' + str(start_epoch) + '&before=' + str(end_epoch) + f"&page={page}")
        response_obj.extend(activities_json)
        page+=1

    if len(response_obj) == 0:
        return None
        
    return json.dumps(response_obj)

start = datetime.datetime.strptime('2024-01-10', '%Y-%m-%d')
end = datetime.datetime.strptime('2024-01-11', '%Y-%m-%d')
print(get_activities_by_date_range(start, end))
