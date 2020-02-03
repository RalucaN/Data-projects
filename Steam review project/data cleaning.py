import json

with open('dict.json', 'r') as myfile:
    data=myfile.read()

steam_data = json.loads(data)

print(type(steam_data))
