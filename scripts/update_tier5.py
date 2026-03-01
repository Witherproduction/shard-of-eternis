import json
import os

db_path = r"f:\shard of eternis dev\shard-of-eternis\datafiles\cards_database.json"

if not os.path.exists(db_path):
    print(f"Error: {db_path} not found")
    exit(1)

with open(db_path, 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

cards = data['cards_database']

# List of updates
updates = {
    'rodeur_foret': {'mana_cost': 5.0},
    'brume_trompeuse': {'mana_cost': 5.0},
    'vide_gousset': {'mana_cost': 5.0, 'attack': 4.0, 'PV': 5.0},
    'bandit_guerrier': {'mana_cost': 5.0, 'attack': 5.0, 'PV': 5.0},
    'hurlement_tribu': {'mana_cost': 5.0, 'description': "Détruisez un Abyssien allié pour donner +4/+4 à tous vos autres monstres."},
    'cri_meute': {'mana_cost': 5.0, 'description': "Vos Bêtes gagnent +3/+3."},
    'loup_galeux': {'mana_cost': 5.0, 'attack': 5.0, 'PV': 5.0},
    'morgane_venimeuse': {'mana_cost': 5.0, 'attack': 4.0, 'PV': 6.0},
    'jeune_ours_foret': {'mana_cost': 5.0, 'attack': 5.0, 'PV': 6.0}
}

updated_count = 0
for card_id, changes in updates.items():
    # Helper to find key if exact match fails
    target_key = card_id
    if card_id not in cards:
        # Try finding by name or similar key
        found = False
        for k in cards.keys():
            if card_id.replace('_', '') in k.replace('_', ''):
                target_key = k
                found = True
                break
        if not found:
             # Special cases mapping based on previous greps
            if card_id == 'loup_gris_foret': target_key = 'loup_gris_forets' # singular/plural guess
            if card_id == 'piege_ronce': target_key = 'piege_de_ronce' # particle guess
            if card_id == 'jeune_ours_foret': target_key = 'jeune_ours_des_forets' # particle guess
            # ... add more if needed based on failures

    if target_key in cards:
        print(f"Updating {target_key}...")
        for key, value in changes.items():
            cards[target_key][key] = value
        updated_count += 1
    else:
        print(f"Warning: Card {card_id} not found in database")

with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=4, ensure_ascii=False)

print(f"Updated {updated_count} cards in cards_database.json successfully.")
