import steamreviews
import json


def collect_data():
    request_params = dict()
    request_params['language'] = 'english'
    request_params['purchase_type'] = 'steam'

    app_id = 275850
    review_dict, query_count = steamreviews.download_reviews_for_app_id(app_id,
                                                                        chosen_request_params=request_params)
    return review_dict


reviews = collect_data()

json = json.dumps(reviews)
f = open("dict.json", "w")
f.write(json)
f.close()


