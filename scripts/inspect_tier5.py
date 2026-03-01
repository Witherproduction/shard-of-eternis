import json
import os

db_path = r"f:\shard of eternis dev\shard-of-eternis\datafiles\cards_database.json"

target_names = [
    "Rôdeur des forêts",
    "Brume trompeuse",
    "VideGousset",
    "Bandit guerrier",
    "Hurlement de la tribu",
    "Cri de la meute",
    "Loup galeux",
    "Morgane la venimeuse",
    "Jeune ours des forêts"
]

with open(db_path, 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

cards = data['cards_database']

print(f"{'Name':<30} | {'ID':<25} | {'ObjectID':<25} | {'Mana':<5} | {'Attack':<5} | {'PV':<5}")
print("-" * 110)

for key, card in cards.items():
    c_name = card.get('name', '')
    match = False
    for target in target_names:
        # Normalize target and card name for comparison
        t_norm = target.lower().replace("é", "e").replace("è", "e").replace("ê", "e").replace("à", "a").replace("â", "a").replace("-", " ")
        c_norm = c_name.lower().replace("é", "e").replace("è", "e").replace("ê", "e").replace("à", "a").replace("â", "a").replace("-", " ")
        
        # Exact match or substring if specific
        if t_norm == c_norm or (len(t_norm) > 5 and t_norm in c_norm):
            match = True
            break
    
    if match:
        print(f"{c_name:<30} | {key:<25} | {card.get('objectId', ''):<25} | {card.get('mana_cost', 0):<5} | {card.get('attack', 0):<5} | {card.get('PV', 0):<5}")
