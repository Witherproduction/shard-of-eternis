import os
import glob
import re
import json
import datetime
import argparse
import unicodedata
import math

PROJECT_ROOT = r"f:\shard of eternis dev\shard-of-eternis"
OBJECTS_DIR = os.path.join(PROJECT_ROOT, "objects")
DB_PATH = os.path.join(PROJECT_ROOT, "datafiles", "cards_database.json")
CHAP2_LIST_PATH = os.path.join(PROJECT_ROOT, "Liste_Cartes_Chap_2.md")

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

def escape_md_cell(s):
    if s is None:
        return ""
    s = str(s).replace("\r", " ").replace("\n", " ")
    s = s.replace("|", "\\|")
    s = re.sub(r"\s+", " ", s).strip()
    return s

def normalize_key(s):
    if s is None:
        return ""
    s = str(s).strip().replace("’", "'").lower()
    s = unicodedata.normalize("NFKD", s)
    s = "".join(ch for ch in s if not unicodedata.combining(ch))
    s = re.sub(r"[^a-z0-9]+", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    return s

def compact_key(s):
    return normalize_key(s).replace("_", "")

def update_chap2_monsters_list(cards_db, md_path):
    by_norm_id = {}
    by_norm_name = {}
    by_compact_id = {}
    by_compact_name = {}
    cards_list = list(cards_db.values())
    for cid, card in cards_db.items():
        nid = normalize_key(cid)
        nname = normalize_key(card.get("name", ""))
        by_norm_id[nid] = card
        by_norm_name[nname] = card
        by_compact_id[compact_key(cid)] = card
        by_compact_name[compact_key(card.get("name", ""))] = card

    with open(md_path, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()

    header_idx = None
    magies_idx = None
    for i, line in enumerate(lines):
        if header_idx is None and line.startswith("| # | Monstre WoW |"):
            header_idx = i
        if line.startswith("## Magies"):
            magies_idx = i
            break

    if header_idx is None or magies_idx is None:
        raise RuntimeError("Table Monstres ou section Magies introuvable dans Liste_Cartes_Chap_2.md")

    header_line = lines[header_idx]
    separator_line = lines[header_idx + 1] if header_idx + 1 < len(lines) else ""

    rows = []
    for line in lines[header_idx + 2:magies_idx]:
        if not line.startswith("|"):
            continue
        parts = [p.strip() for p in line.strip().strip("|").split("|")]
        while len(parts) < 18:
            parts.append("")
        rows.append(parts[:18])

    missing_ids = []
    updated_count = 0
    for parts in rows:
        key_slug = parts[3].strip()
        key_name = parts[2].strip()
        key_monstre = parts[1].strip()

        card = cards_db.get(key_slug)
        if card is None:
            card = by_norm_id.get(normalize_key(key_slug))
        if card is None:
            nk = normalize_key(key_name)
            card = by_norm_name.get(nk) or by_norm_id.get(nk)
        if card is None:
            nk = normalize_key(key_monstre)
            card = by_norm_name.get(nk) or by_norm_id.get(nk)
        if card is None:
            ck = compact_key(key_slug)
            card = by_compact_id.get(ck)
        if card is None:
            ck = compact_key(key_name)
            card = by_compact_name.get(ck) or by_compact_id.get(ck)
        if card is None:
            ck = compact_key(key_monstre)
            card = by_compact_name.get(ck) or by_compact_id.get(ck)

        if card is None:
            try:
                row_cost = int(parts[7])
            except Exception:
                row_cost = None
            try:
                row_atk = int(parts[8])
            except Exception:
                row_atk = None
            try:
                row_hp = int(parts[9])
            except Exception:
                row_hp = None

            row_race = parts[4].strip()
            row_genre = parts[5].strip()
            row_rarity = parts[6].strip()

            row_name_compact = compact_key(key_name)
            row_monstre_compact = compact_key(key_monstre)
            row_race_n = normalize_key(row_race)
            row_genre_n = normalize_key(row_genre)
            row_rarity_n = normalize_key(row_rarity)

            best = None
            best_score = -1
            tie = False

            for c in cards_list:
                if c.get("type") != "Unit":
                    continue
                cost = int(round(float(c.get("mana_cost", 0) or 0)))
                atk = int(round(float(c.get("attack", 0) or 0)))
                hp = int(round(float(c.get("PV", 0) or 0)))

                c_race_n = normalize_key(c.get("race", ""))
                c_genre_n = normalize_key(c.get("genre", ""))
                c_rarity_n = normalize_key(c.get("rarity", ""))

                score = 0
                if row_cost is not None and cost == row_cost:
                    score += 3
                if row_atk is not None and atk == row_atk:
                    score += 2
                if row_hp is not None and hp == row_hp:
                    score += 2
                if row_race_n and c_race_n and row_race_n == c_race_n:
                    score += 2
                if row_genre_n and c_genre_n and row_genre_n == c_genre_n:
                    score += 2
                if row_rarity_n and c_rarity_n and row_rarity_n == c_rarity_n:
                    score += 1

                c_name_compact = compact_key(c.get("name", ""))
                if row_name_compact and (row_name_compact in c_name_compact or c_name_compact in row_name_compact):
                    score += 5
                if row_monstre_compact and (row_monstre_compact in c_name_compact or c_name_compact in row_monstre_compact):
                    score += 3

                if score > best_score:
                    best = c
                    best_score = score
                    tie = False
                elif score == best_score and score != -1:
                    tie = True

            if best is not None and not tie and best_score >= 7:
                card = best

        if card is None:
            missing_ids.append((parts[0], parts[2], parts[3]))
            continue

        cost = int(round(float(card.get("mana_cost", 0) or 0)))
        atk = int(round(float(card.get("attack", 0) or 0)))
        hp = int(round(float(card.get("PV", 0) or 0)))
        stats = atk + hp
        standard = (cost * 2) + 1
        delta = stats - standard

        parts[2] = card.get("name", parts[2])
        parts[3] = card.get("id", parts[3])
        parts[4] = card.get("race", parts[4])
        parts[5] = card.get("genre", parts[5])
        parts[6] = card.get("rarity", parts[6])
        parts[7] = str(cost)
        parts[8] = str(atk)
        parts[9] = str(hp)
        parts[10] = str(stats)
        parts[11] = str(standard)
        parts[12] = str(delta)
        parts[15] = card.get("description", parts[15])
        updated_count += 1

    section_lines = [header_line, separator_line]
    for parts in rows:
        section_lines.append("| " + " | ".join(escape_md_cell(x) for x in parts) + " |")

    new_lines = lines[:header_idx] + section_lines + lines[magies_idx:]
    with open(md_path, "w", encoding="utf-8") as f:
        f.write("\n".join(new_lines) + "\n")

    return {
        "rows_total": len(rows),
        "updated_rows": updated_count,
        "missing_rows": missing_ids,
    }

def parse_chap2_monsters_rows(md_path):
    with open(md_path, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()

    header_idx = None
    magies_idx = None
    for i, line in enumerate(lines):
        if header_idx is None and line.startswith("| # | Monstre WoW |"):
            header_idx = i
        if line.startswith("## Magies"):
            magies_idx = i
            break

    if header_idx is None or magies_idx is None:
        raise RuntimeError("Table Monstres ou section Magies introuvable dans Liste_Cartes_Chap_2.md")

    rows = []
    for line in lines[header_idx + 2:magies_idx]:
        if not line.startswith("|"):
            continue
        parts = [p.strip() for p in line.strip().strip("|").split("|")]
        while len(parts) < 18:
            parts.append("")
        rows.append(parts[:18])

    return rows

def parse_effect_value(s):
    if s is None:
        return 0.0
    s = str(s).strip().replace(",", ".")
    if not s:
        return 0.0
    try:
        return float(s)
    except Exception:
        return 0.0

def rarity_bonus(rarity):
    r = normalize_key(rarity)
    if r.startswith("leg"):
        return 1.5
    if r.startswith("epi"):
        return 1.0
    if r.startswith("rar"):
        return 0.5
    return 0.0

def adjust_atk_pv(atk, pv, target_stats):
    atk = int(atk)
    pv = int(pv)
    target_stats = int(target_stats)

    if pv < 1:
        pv = 1
    if atk < 0:
        atk = 0

    diff = target_stats - (atk + pv)
    if diff == 0:
        return atk, pv

    if diff > 0:
        pv += diff
        return atk, pv

    need = -diff
    take_pv = min(need, pv - 1)
    pv -= take_pv
    need -= take_pv

    if need > 0:
        take_atk = min(need, atk)
        atk -= take_atk
        need -= take_atk

    if need > 0:
        pv = max(1, pv - need)

    return atk, pv

def update_gml_int(gml_text, key, new_value):
    pattern = rf"^(\s*{re.escape(key)}\s*=\s*)(\d+)(\s*;)"
    repl = rf"\g<1>{int(new_value)}\g<3>"
    out, n = re.subn(pattern, repl, gml_text, flags=re.MULTILINE, count=1)
    return out, n

def balance_chap2_monsters_stats(cards_db, md_path):
    rows = parse_chap2_monsters_rows(md_path)
    changes = []
    missing = []

    for parts in rows:
        card_id = parts[3].strip()
        card = cards_db.get(card_id)
        if card is None:
            missing.append((parts[0], parts[2], parts[3]))
            continue

        obj_id = card.get("objectId")
        if not obj_id:
            missing.append((parts[0], parts[2], parts[3]))
            continue

        gml_path = os.path.join(OBJECTS_DIR, obj_id, "Create_0.gml")
        if not os.path.exists(gml_path):
            missing.append((parts[0], parts[2], parts[3]))
            continue

        cost = int(round(float(card.get("mana_cost", 0) or 0)))
        atk = int(round(float(card.get("attack", 0) or 0)))
        pv = int(round(float(card.get("PV", 0) or 0)))
        standard = (cost * 2) + 1
        effect_val = parse_effect_value(parts[13])
        bonus = rarity_bonus(card.get("rarity", parts[6]))
        target_stats = int(math.floor((standard - effect_val + bonus) + 0.5))

        new_atk, new_pv = adjust_atk_pv(atk, pv, target_stats)
        if new_atk == atk and new_pv == pv:
            continue

        gml_text = open(gml_path, "r", encoding="utf-8").read()
        gml_text, n1 = update_gml_int(gml_text, "attack", new_atk)
        gml_text, n2 = update_gml_int(gml_text, "PV", new_pv)

        if n1 == 0 or n2 == 0:
            missing.append((parts[0], parts[2], parts[3]))
            continue

        with open(gml_path, "w", encoding="utf-8") as f:
            f.write(gml_text)

        changes.append((obj_id, card_id, atk, pv, new_atk, new_pv))

    return {
        "rows_total": len(rows),
        "changed": changes,
        "missing": missing,
    }

def build_cards_db():
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
    return final_db

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--update-chap2-md", action="store_true")
    parser.add_argument("--balance-chap2-stats", action="store_true")
    parser.add_argument("--no-write-db", action="store_true")
    args = parser.parse_args()

    print("Starting database update...")
    final_db = build_cards_db()

    if args.balance_chap2_stats:
        report = balance_chap2_monsters_stats(final_db["cards_database"], CHAP2_LIST_PATH)
        print(f"Balanced Chap2 stats: {len(report['changed'])}/{report['rows_total']} cartes")
        if report["missing"]:
            print("Missing cards/objects for these rows:")
            for idx, name, cid in report["missing"]:
                print(f"- #{idx}: {name} (id={cid})")
        final_db = build_cards_db()

    if args.update_chap2_md:
        report = update_chap2_monsters_list(final_db["cards_database"], CHAP2_LIST_PATH)
        print(f"Updated Liste_Cartes_Chap_2.md: {report['updated_rows']}/{report['rows_total']} lignes")
        if report["missing_rows"]:
            print("Missing cards in DB for these rows:")
            for idx, name, cid in report["missing_rows"]:
                print(f"- #{idx}: {name} (id={cid})")

    if not args.no_write_db:
        with open(DB_PATH, "w", encoding="utf-8") as f:
            json.dump(final_db, f, indent=4, ensure_ascii=False)
        print(f"Successfully wrote {final_db['total_cards']} cards to {DB_PATH}")

if __name__ == "__main__":
    main()
