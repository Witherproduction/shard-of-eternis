
import json
import os

db_path = r"f:\shard of eternis dev\shard-of-eternis\datafiles\cards_database.json"

if not os.path.exists(db_path):
    print(f"Error: {db_path} not found")
    exit(1)

with open(db_path, 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

cards = data['cards_database']

# --- Tier 8 ---
if 'massacreur_geule_roche' in cards:
    cards['massacreur_geule_roche']['mana_cost'] = 8.0
    cards['massacreur_geule_roche']['attack'] = 9.0
    cards['massacreur_geule_roche']['PV'] = 9.0

if 'tarrinox' in cards:
    cards['tarrinox']['mana_cost'] = 8.0
    cards['tarrinox']['attack'] = 8.0
    cards['tarrinox']['PV'] = 10.0

# --- Tier 7 ---
if 'matriarche_peau_roc' in cards:
    cards['matriarche_peau_roc']['mana_cost'] = 7.0
    cards['matriarche_peau_roc']['attack'] = 7.0
    cards['matriarche_peau_roc']['PV'] = 7.0

if 'frere_gorrak' in cards:
    cards['frere_gorrak']['mana_cost'] = 7.0
    cards['frere_gorrak']['attack'] = 6.0
    cards['frere_gorrak']['PV'] = 8.0

if 'recolteur' in cards:
    cards['recolteur']['mana_cost'] = 7.0
    cards['recolteur']['attack'] = 6.0
    cards['recolteur']['PV'] = 7.0

if 'lieutenant_gorrak' in cards:
    cards['lieutenant_gorrak']['mana_cost'] = 7.0
    cards['lieutenant_gorrak']['attack'] = 8.0
    cards['lieutenant_gorrak']['PV'] = 6.0

# --- Tier 6 ---
if 'envahisseur_geule_roche' in cards:
    cards['envahisseur_geule_roche']['mana_cost'] = 6.0
    cards['envahisseur_geule_roche']['attack'] = 6.0
    cards['envahisseur_geule_roche']['PV'] = 6.0

if 'sous_chef_tunnelin' in cards:
    cards['sous_chef_tunnelin']['mana_cost'] = 6.0
    cards['sous_chef_tunnelin']['attack'] = 6.0
    cards['sous_chef_tunnelin']['PV'] = 7.0

if 'peau_roc_robuste' in cards:
    cards['peau_roc_robuste']['mana_cost'] = 6.0
    cards['peau_roc_robuste']['attack'] = 5.0
    cards['peau_roc_robuste']['PV'] = 7.0

if 'tarentule_foret' in cards:
    cards['tarentule_foret']['mana_cost'] = 6.0
    cards['tarentule_foret']['attack'] = 6.0
    cards['tarentule_foret']['PV'] = 5.0

if 'patte_brise_larmoyant' in cards:
    cards['patte_brise_larmoyant']['mana_cost'] = 6.0
    cards['patte_brise_larmoyant']['attack'] = 5.0
    cards['patte_brise_larmoyant']['PV'] = 9.0

if 'maitre_passe' in cards:
    cards['maitre_passe']['mana_cost'] = 6.0
    cards['maitre_passe']['attack'] = 5.0
    cards['maitre_passe']['PV'] = 6.0
    cards['maitre_passe']['description'] = "Crépuscule : Invoque un Humanoïde de coût 3 ou moins depuis votre main."

if 'sorcier_voleur' in cards:
    cards['sorcier_voleur']['mana_cost'] = 6.0
    cards['sorcier_voleur']['attack'] = 5.0
    cards['sorcier_voleur']['PV'] = 6.0

# --- Tier 5 ---
if 'vide_gousset' in cards:
    cards['vide_gousset']['mana_cost'] = 5.0
    cards['vide_gousset']['attack'] = 4.0
    cards['vide_gousset']['PV'] = 5.0

if 'bandit_guerrier' in cards:
    cards['bandit_guerrier']['mana_cost'] = 5.0
    cards['bandit_guerrier']['attack'] = 5.0
    cards['bandit_guerrier']['PV'] = 5.0

if 'hurlement_tribu' in cards:
    cards['hurlement_tribu']['mana_cost'] = 5.0
    cards['hurlement_tribu']['description'] = "Détruisez un Abyssien allié pour donner +4/+4 à tous vos autres serviteurs."

if 'cri_meute' in cards:
    cards['cri_meute']['mana_cost'] = 5.0
    cards['cri_meute']['description'] = "Vos Bêtes gagnent +3/+3."

if 'loup_galeux' in cards:
    cards['loup_galeux']['mana_cost'] = 5.0
    cards['loup_galeux']['attack'] = 5.0
    cards['loup_galeux']['PV'] = 5.0

if 'morgane_venimeuse' in cards:
    cards['morgane_venimeuse']['mana_cost'] = 5.0
    cards['morgane_venimeuse']['attack'] = 4.0
    cards['morgane_venimeuse']['PV'] = 6.0

if 'jeune_ours_foret' in cards:
    cards['jeune_ours_foret']['mana_cost'] = 5.0
    cards['jeune_ours_foret']['attack'] = 5.0
    cards['jeune_ours_foret']['PV'] = 6.0

# --- Tier 4 ---
if 'tortue_vagabonde' in cards:
    cards['tortue_vagabonde']['mana_cost'] = 4.0
    cards['tortue_vagabonde']['attack'] = 2.0
    cards['tortue_vagabonde']['PV'] = 8.0

if 'james_calamite' in cards:
    cards['james_calamite']['mana_cost'] = 4.0
    cards['james_calamite']['attack'] = 4.0
    cards['james_calamite']['PV'] = 4.0

if 'yvan_costaud' in cards:
    cards['yvan_costaud']['mana_cost'] = 4.0
    cards['yvan_costaud']['attack'] = 3.0
    cards['yvan_costaud']['PV'] = 6.0

if 'vieil_ours' in cards:
    cards['vieil_ours']['mana_cost'] = 4.0
    cards['vieil_ours']['attack'] = 3.0
    cards['vieil_ours']['PV'] = 5.0

if 'loup_gris_foret' in cards:
    cards['loup_gris_foret']['mana_cost'] = 4.0
    cards['loup_gris_foret']['attack'] = 4.0
    cards['loup_gris_foret']['PV'] = 5.0

if 'cape_ombre' in cards:
    cards['cape_ombre']['mana_cost'] = 4.0
    cards['cape_ombre']['description'] = "Donne +4/+4 et Camouflage à un serviteur."

if 'piege_ronce' in cards:
    cards['piege_ronce']['mana_cost'] = 4.0
    cards['piege_ronce']['description'] = "Secret : Quand un ennemi vous attaque, Inflige 3 dégats à tous les adversaires."

if 'sanglier_peau_roc' in cards:
    cards['sanglier_peau_roc']['mana_cost'] = 4.0
    cards['sanglier_peau_roc']['attack'] = 4.0
    cards['sanglier_peau_roc']['PV'] = 4.0

if 'bandit' in cards:
    cards['bandit']['mana_cost'] = 4.0
    cards['bandit']['attack'] = 4.0
    cards['bandit']['PV'] = 3.0

if 'gobelin_furtif' in cards:
    cards['gobelin_furtif']['mana_cost'] = 4.0
    cards['gobelin_furtif']['attack'] = 5.0
    cards['gobelin_furtif']['PV'] = 3.0

# --- Tier 3 ---
if 'distraction' in cards:
    cards['distraction']['mana_cost'] = 3.0
    cards['distraction']['description'] = "Secret : Quand un serviteur ennemi est invoqué, le renvoie dans la main et augmente son coût de (2)."

if 'skarl_chetif' in cards:
    cards['skarl_chetif']['mana_cost'] = 3.0
    cards['skarl_chetif']['attack'] = 4.0
    cards['skarl_chetif']['PV'] = 2.0

if 'bougimencien_tunnelin' in cards:
    cards['bougimencien_tunnelin']['mana_cost'] = 3.0
    cards['bougimencien_tunnelin']['attack'] = 3.0
    cards['bougimencien_tunnelin']['PV'] = 2.0

if 'mineur_tunnelin' in cards:
    cards['mineur_tunnelin']['mana_cost'] = 3.0
    cards['mineur_tunnelin']['attack'] = 3.0
    cards['mineur_tunnelin']['PV'] = 3.0

# --- Tier 2 ---
if 'tunnelin' in cards:
    cards['tunnelin']['mana_cost'] = 2.0
    cards['tunnelin']['PV'] = 2.0

# --- Tier 1 ---
if 'anneau_voleur' in cards:
    cards['anneau_voleur']['mana_cost'] = 1.0

if 'saut_predateur' in cards:
    cards['saut_predateur']['mana_cost'] = 1.0

if 'renard_mystique' in cards:
    cards['renard_mystique']['mana_cost'] = 1.0
    cards['renard_mystique']['attack'] = 2.0
    cards['renard_mystique']['PV'] = 2.0

with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=4, ensure_ascii=False)

print("cards_database.json updated successfully.")
