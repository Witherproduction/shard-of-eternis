
import json

try:
    with open('datafiles/cards_database.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    # Search for Tortue vagabonde
    found = False
    for key, val in data.get("cards_database", {}).items():
        if "Tortue vagabonde" in str(val):
            print(f"Key: {key}")
            print(json.dumps(val, indent=2))
            found = True
            
    if not found:
        print("Not found")
        
except Exception as e:
    print(e)
