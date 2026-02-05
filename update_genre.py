
import json
import os
import re

file_path = r'f:\shard of eternis dev\shard-of-eternis\datafiles\cards_database.json'

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    changed_count = 0
    
    # Iterate through all cards
    for card_id, card_data in data.items():
        if "genre" in card_data and card_data["genre"] == "Direct":
            card_data["genre"] = "Sort"
            changed_count += 1
            print(f"Updated {card_id} genre from Direct to Sort")

    if changed_count > 0:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print(f"Successfully updated {changed_count} cards.")
    else:
        print("No cards found with genre 'Direct'.")

except Exception as e:
    print(f"Error: {e}")
