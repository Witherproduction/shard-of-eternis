$path = "datafiles\cards_database.json"
$json = Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
$cards = $json.cards_database

# --- Tier 8 ---
$cards.massacreur_geule_roche.mana_cost = 8.0
$cards.massacreur_geule_roche.attack = 9.0
$cards.massacreur_geule_roche.PV = 9.0

$cards.tarrinox.mana_cost = 8.0
$cards.tarrinox.attack = 8.0
$cards.tarrinox.PV = 10.0

# --- Tier 7 ---
$cards.matriarche_peau_roc.mana_cost = 7.0
$cards.matriarche_peau_roc.attack = 7.0
$cards.matriarche_peau_roc.PV = 7.0

$cards.frere_gorrak.mana_cost = 7.0
$cards.frere_gorrak.attack = 6.0
$cards.frere_gorrak.PV = 8.0

$cards.recolteur.mana_cost = 7.0
$cards.recolteur.attack = 6.0
$cards.recolteur.PV = 7.0

$cards.lieutenant_gorrak.mana_cost = 7.0
$cards.lieutenant_gorrak.attack = 8.0
$cards.lieutenant_gorrak.PV = 6.0

# --- Tier 6 ---
$cards.envahisseur_geule_roche.mana_cost = 6.0
$cards.envahisseur_geule_roche.attack = 6.0
$cards.envahisseur_geule_roche.PV = 6.0

$cards.sous_chef_tunnelin.mana_cost = 6.0
$cards.sous_chef_tunnelin.attack = 6.0
$cards.sous_chef_tunnelin.PV = 7.0

$cards.peau_roc_robuste.mana_cost = 6.0
$cards.peau_roc_robuste.attack = 5.0
$cards.peau_roc_robuste.PV = 7.0

$cards.tarentule_foret.mana_cost = 6.0
$cards.tarentule_foret.attack = 6.0
$cards.tarentule_foret.PV = 5.0

$cards.patte_brise_larmoyant.mana_cost = 6.0
$cards.patte_brise_larmoyant.attack = 5.0
$cards.patte_brise_larmoyant.PV = 9.0

$cards.maitre_passe.mana_cost = 6.0
$cards.maitre_passe.attack = 5.0
$cards.maitre_passe.PV = 6.0
$cards.maitre_passe.description = "CrÃ©puscule : Invoque un HumanoÃ¯de de coÃ»t 3 ou moins depuis votre main."

$cards.sorcier_voleur.mana_cost = 6.0
$cards.sorcier_voleur.attack = 5.0
$cards.sorcier_voleur.PV = 6.0

# --- Tier 5 ---
$cards.vide_gousset.mana_cost = 5.0
$cards.vide_gousset.attack = 4.0
$cards.vide_gousset.PV = 5.0

$cards.bandit_guerrier.mana_cost = 5.0
$cards.bandit_guerrier.attack = 5.0
$cards.bandit_guerrier.PV = 5.0

$cards.hurlement_tribu.mana_cost = 5.0
$cards.hurlement_tribu.description = "DÃ©truisez un Abyssien alliÃ© pour donner +4/+4 Ã  tous vos autres serviteurs."

$cards.cri_meute.mana_cost = 5.0
$cards.cri_meute.description = "Vos BÃªtes gagnent +3/+3."

$cards.loup_galeux.mana_cost = 5.0
$cards.loup_galeux.attack = 5.0
$cards.loup_galeux.PV = 5.0

$cards.morgane_venimeuse.mana_cost = 5.0
$cards.morgane_venimeuse.attack = 4.0
$cards.morgane_venimeuse.PV = 6.0

$cards.jeune_ours_foret.mana_cost = 5.0
$cards.jeune_ours_foret.attack = 5.0
$cards.jeune_ours_foret.PV = 6.0

# --- Tier 4 ---
$cards.tortue_vagabonde.mana_cost = 4.0
$cards.tortue_vagabonde.attack = 2.0
$cards.tortue_vagabonde.PV = 8.0

$cards.james_calamite.mana_cost = 4.0
$cards.james_calamite.attack = 4.0
$cards.james_calamite.PV = 4.0

$cards.yvan_costaud.mana_cost = 4.0
$cards.yvan_costaud.attack = 3.0
$cards.yvan_costaud.PV = 6.0

$cards.vieil_ours.mana_cost = 4.0
$cards.vieil_ours.attack = 3.0
$cards.vieil_ours.PV = 5.0

$cards.loup_gris_foret.mana_cost = 4.0
$cards.loup_gris_foret.attack = 4.0
$cards.loup_gris_foret.PV = 5.0

$cards.cape_ombre.mana_cost = 4.0
$cards.cape_ombre.description = "Donne +4/+4 et Camouflage Ã  un serviteur."

$cards.piege_ronce.mana_cost = 4.0
$cards.piege_ronce.description = "Secret : Quand un ennemi vous attaque, Inflige 3 dÃ©gats Ã  tous les adversaires."

$cards.sanglier_peau_roc.mana_cost = 4.0
$cards.sanglier_peau_roc.attack = 4.0
$cards.sanglier_peau_roc.PV = 4.0

$cards.bandit.mana_cost = 4.0
$cards.bandit.attack = 4.0
$cards.bandit.PV = 3.0

$cards.gobelin_furtif.mana_cost = 4.0
$cards.gobelin_furtif.attack = 5.0
$cards.gobelin_furtif.PV = 3.0

# --- Tier 3 ---
$cards.distraction.mana_cost = 3.0
$cards.distraction.description = "Secret : Quand un serviteur ennemi est invoquÃ©, le renvoie dans la main et augmente son coÃ»t de (2)."

$cards.skarl_chetif.mana_cost = 3.0
$cards.skarl_chetif.attack = 4.0
$cards.skarl_chetif.PV = 2.0

$cards.bougimencien_tunnelin.mana_cost = 3.0
$cards.bougimencien_tunnelin.attack = 3.0
$cards.bougimencien_tunnelin.PV = 2.0

$cards.mineur_tunnelin.mana_cost = 3.0
$cards.mineur_tunnelin.attack = 3.0
$cards.mineur_tunnelin.PV = 3.0

# --- Tier 2 ---
$cards.tunnelin.mana_cost = 2.0
$cards.tunnelin.PV = 2.0

# --- Tier 1 ---
$cards.anneau_voleur.mana_cost = 1.0
$cards.saut_predateur.mana_cost = 1.0
$cards.renard_mystique.mana_cost = 1.0
$cards.renard_mystique.attack = 2.0
$cards.renard_mystique.PV = 2.0

$json | ConvertTo-Json -Depth 10 | Out-File $path -Encoding UTF8