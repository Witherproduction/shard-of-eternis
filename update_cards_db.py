import os
import glob
import re
import json
import datetime

PROJECT_ROOT = r"f:\shard of eternis dev\shard-of-eternis"
OBJECTS_DIR = os.path.join(PROJECT_ROOT, "objects")
DB_PATH = os.path.join(PROJECT_ROOT, "datafiles", "cards_database.json")

def clean_json_string(s):
    # Remove BOM if present
    if s.startswith('\ufeff'):
        s = s[1:]
    return s

def normalize_id(name):
    s = name.lower()
    s = s.replace(" ", "_")
    s = s.replace("'", "")
    s = s.replace("é", "e")
    s = s.replace("è", "e")
    s = s.replace("ê", "e")
    s = s.replace("à", "a")
    s = s.replace("â", "a")
    s = s.replace("î", "i")
    s = s.replace("ô", "o")
    s = s.replace("û", "u")
    s = s.replace("ç", "c")
    return s

def parse_yy_file(yy_path):
    try:
        with open(yy_path, 'r', encoding='utf-8') as f:
            content = f.read()
            # Extract parent object
            parent_match = re.search(r'"parentObjectId":\s*\{\s*"name":\s*"(.*?)"', content)
            parent = parent_match.group(1) if parent_match else None
            
            # Extract sprite
            sprite_match = re.search(r'"spriteId":\s*\{\s*"name":\s*"(.*?)"', content)
            sprite = sprite_match.group(1) if sprite_match else "sprInvisible"
            
            return parent, sprite
    except Exception as e:
        print(f"Error parsing {yy_path}: {e}")
        return None, None

def parse_gml_file(gml_path):
    data = {}
    try:
        with open(gml_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Helper for regex extraction
            def extract(pattern, default=None, is_int=False, is_float=False):
                match = re.search(pattern, content, re.MULTILINE)
                if match:
                    val = match.group(1)
                    if is_int:
                        return int(val)
                    if is_float:
                        return float(val)
                    return val
                return default

            data['name'] = extract(r'name\s*=\s*"(.*?)"', "")
            data['mana_cost'] = extract(r'mana_cost\s*=\s*(\d+)', 0, is_float=True)
            data['attack'] = extract(r'attack\s*=\s*(\d+)', 0, is_float=True)
            data['PV'] = extract(r'PV\s*=\s*(\d+)', 0, is_float=True)
            data['description'] = extract(r'description\s*=\s*"(.*?)"', "")
            data['rarity'] = extract(r'rarity\s*=\s*"(.*?)"', "commun")
            data['race'] = extract(r'race\s*=\s*"(.*?)"', "")
            data['genre'] = extract(r'genre\s*=\s*"(.*?)"', "")
            data['booster'] = extract(r'booster\s*=\s*"(.*?)"', "Base")
            
            # Tags extraction (list of strings)
            tags_match = re.search(r'tags\s*=\s*\[(.*?)\]', content, re.DOTALL)
            tags = []
            if tags_match:
                tags_str = tags_match.group(1)
                # Find all strings in quotes
                tags = re.findall(r'"(.*?)"', tags_str)
            data['tags'] = tags
            
            return data
    except Exception as e:
        print(f"Error parsing {gml_path}: {e}")
        return {}

def main():
    print("Starting database update...")
    cards_db = {}
    count = 0
    
    # Iterate over all object directories
    for obj_dir in glob.glob(os.path.join(OBJECTS_DIR, "o*")):
        obj_name = os.path.basename(obj_dir)
        yy_path = os.path.join(obj_dir, obj_name + ".yy")
        gml_path = os.path.join(obj_dir, "Create_0.gml")
        
        if not os.path.exists(yy_path) or not os.path.exists(gml_path):
            continue
            
        parent, sprite = parse_yy_file(yy_path)
        
        # Filter only card objects
        if parent not in ["oCardParent", "oCardMonster", "oCardMagic"]:
            continue
            
        if obj_name in ["oCardMonster", "oCardMagic", "oCardParent"]:
            continue
            
        # Parse GML stats
        gml_data = parse_gml_file(gml_path)
        
        if not gml_data.get('name'):
            # Fallback name from object name
            gml_data['name'] = obj_name[1:] # Remove 'o' prefix
            
        # Determine ID
        card_id = normalize_id(gml_data['name'])
        
        # Determine Type
        card_type = "Unit"
        if parent == "oCardMagic":
            card_type = "Magic"
        elif parent == "oCardMonster":
            card_type = "Unit"
        
        # Build card entry
        card_entry = {
            "id": card_id,
            "objectId": obj_name,
            "name": gml_data['name'],
            "type": card_type,
            "mana_cost": gml_data['mana_cost'],
            "attack": gml_data['attack'],
            "PV": gml_data['PV'],
            "description": gml_data['description'],
            "rarity": gml_data['rarity'],
            "race": gml_data['race'],
            "genre": gml_data['genre'],
            "booster": gml_data['booster'],
            "tags": gml_data['tags'],
            "sprite": sprite
        }
        
        cards_db[card_id] = card_entry
        print(f"Added {card_id} ({obj_name})")
        count += 1
        
    # Construct final DB structure
    final_db = {
        "version": "2.0 (Python-Gen)",
        "cards_database": cards_db,
        "save_date": datetime.datetime.now().timestamp() / 86400.0 + 25569.0, # Excel serial date approximation if needed, or just standard timestamp
        # Actually existing JSON used 46082.48 which is Excel date for ~2026.
        # Let's use standard timestamp or keep format. 
        # GameMaker date_current_datetime() returns days since Dec 30 1899.
        # Python datetime to OA date:
        "total_cards": count
    }
    
    # Calculate OA date for consistency with GameMaker
    base_date = datetime.datetime(1899, 12, 30)
    delta = datetime.datetime.now() - base_date
    oa_date = delta.days + (delta.seconds / 86400.0)
    final_db["save_date"] = oa_date

    # Write to JSON
    with open(DB_PATH, 'w', encoding='utf-8') as f:
        json.dump(final_db, f, indent=4, ensure_ascii=False)
        
    print(f"Successfully wrote {count} cards to {DB_PATH}")

if __name__ == "__main__":
    main()
