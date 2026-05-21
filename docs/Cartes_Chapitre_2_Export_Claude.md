# Shard of Eternis — Chapitre 2 : cartes (export pour Claude)

Document de référence pour concevoir / rééquilibrer les **decks** et les **cartes** du Chapitre 2 (*Les landes du sépulcre*).  
Dernière sync avec le dépôt : liste design `Liste_Cartes_Chap_2.md` + objets GameMaker implémentés.

---

## Contexte jeu (résumé)

- **TCG** type Hearthstone : deck de **40 cartes**, main de départ **5**, pioche 1/tour.
- **Héros Ch.2** : Vespera — deck unique `vespera_landes_sepulcre` (*Brumes et tombeaux*).
- **Bots Ch.2** : slots histoire **8 à 14** (Ordre du Sang Pur, Vieille-Aube, Poil-Putride, nécromancie, etc.).
- **Timings des effets** (monstres) :
  - **Eveil** : à l’invocation.
  - **Aube** : début de votre tour (une fois par tour si applicable).
  - **Crépuscule** : fin de votre tour.
  - **Brisé** : quand la carte est détruite.
  - **Passif** : permanent tant que la carte est en jeu.
- **Sorts / secrets / terrains** :
  - **Secret** : se déclenche pendant le **tour adverse** (conditions précisées sur la carte).
  - **Terrain** : reste **3 tours** puis disparaît.
- **Équilibrage** : stats vanilla ≈ `(Coût mana × 2) + 1` en ATK+PV ; l’effet compense le delta. Voir `Guide_Equilibrage.md`.

### Factions / thèmes Ch.2

| Thème | Genre principal | Notes |
|--------|-----------------|--------|
| Landes — Bêtes | Bête | Prédateurs, brumes, nuit |
| Landes — Morts-vivants | Mort-vivant | Squelettes, zombies, banshees, peste |
| Ordre du Sang Pur | Humanoïde | Ex-Croisade écarlate, capitaines, zélotes |
| Sombre-branchie | Humanoïde (Abyssien) | Soutiens murloc-like |
| Poil-Putride | Skarl (Mort-vivant) | Disruption coût main adverse |
| Vieille-Aube | Mort-vivant | Grégor, Thalia, Devlin (synergies famille) |
| Eveillés | Mort-vivant | Farrow, Reine banshee |

---

## Légende colonnes

| Colonne | Description |
|---------|-------------|
| **#** | Numéro fiche design |
| **Nom carte** | Nom affiché en jeu |
| **Slug** | ID design (snake_case) |
| **Objet GM** | Nom d’objet GameMaker (`oNomCarte`) — vide si pas encore codé |
| **Race / Genre** | Typage carte |
| **Rareté** | commun / rare / epique / legendaire |
| **Coût** | Mana |
| **ATK / PV** | Stats serviteur |
| **Timing** | Déclencheur principal |
| **Effet** | Texte carte (design) |
| **Rôle** | Intent deckbuilding |

---

## Monstres — Chapitre 2 (58 fiches)

| # | Nom carte | Slug | Objet GM | Race | Genre | Rareté | Coût | ATK | PV | Timing | Effet | Rôle |
|---|-----------|------|----------|------|-------|--------|-----|-----|-----|--------|-------|------|
| 1 | Mache-les-os | mache-les-os | oMacheOs | Rapace | Bête | rare | 3 | 2 | 4 | Eveil | Eveil : Sélectionnez un serviteur. Jusqu'à la fin du tour, il subit +1 dégâts lors des attaques. | Débuff / burst |
| 2 | Hurlenuit stridente | hurlenuit_stridente | oHurleNuitStrident | Chauve-souris | Bête | rare | 3 | 2 | 4 | Eveil | Eveil : Purge le serviteur en face de lui. | Contrôle (silence) |
| 3 | Sombregueule traqueur | sombregueule_traqueur | oSombregueuleTraqueur | Loup | Bête | rare | 3 | 4 | 1 | Passif + Eveil | Charge. Eveil : Réduit de 2 l'ATK d'un monstre adverse aléatoire jusqu'à la fin du tour. | Aggro / debuff |
| 4 | Molosse du voile noir | molosse_du_voile_noir | oMolosseVoileNoir | Loup | Bête | rare | 3 | 3 | 1 | Eveil | Eveil : Inflige 2 dégâts au serviteur ennemi en face. S'il survit, renvoyez-le dans la main. | Tempo / contrôle |
| 5 | Sombredogue sanguinaire spectral | sombredogue_sanguinaire_spectral | oSombredogueSanguinaireSpectral | Loup | Mort-vivant | rare | 3 | 2 | 3 | Crépuscule | Crépuscule : +1 ATK et 1 dégât au serviteur en face (sinon 1 au héros). | Aggro / saignement |
| 6 | Tisse-nuit nocturne | tisse-nuit_nocturne | oTisseNuitNocturne | Araignée | Bête | rare | 2 | 1 | 2 | Eveil | Eveil : Cible ennemie — 1 dégât à la fin de chacun des 3 prochains tours. | Poison / DoT |
| 7 | Croc-entrave des brumes | croc-entrave_des_brumes | oCrocEntraveBrumes | Loup | Bête | commun | 4 | 2 | 4 | Eveil | Eveil : Serviteur en face Entravé 1 tour + 1 dégât fin de vos 2 prochains tours. | Contrôle / saignement |
| 8 | Guetteuse des conduits | guetteuse_des_conduits | oGuetteuseConduit | Araignée | Bête | rare | 3 | 2 | 2 | Passif + Attaque | Camouflage. Au combat contre un serviteur : entrave. | Contrôle |
| 9 | Matriarche des bois noirs | matriarche_des_bois_noirs | oMatriarcheBoisNoirs | Araignée | Bête | epique | 5 | 4 | 5 | Eveil | Eveil : Cible — 2 dégâts à la fin de chacun des 2 prochains tours. | Poison / DoT |
| 10 | Hibernard, ours pestiféré | hibernard,_ours_pestifere | oHibernarOursPestifere | Ours | Bête | epique | 6 | 5 | 5 | Passif + Eveil | Charge. Eveil : 2 dégâts + entrave au serviteur en face. | Tempo / contrôle |
| 11 | Dévoreur des ombres | devoreur_des_ombres | oDevoreurOmbres | Loup | Bête | rare | 3 | 4 | 1 | Passif + Attaque | Charge. Repoussement. | Tempo / aggro |
| 12 | Exécuteur du Sang-Pur | executeur_du_sang-pur | oExecuteurSangPur | Humain | Humanoïde | rare | 4 | 3 | 3 | Eveil | Eveil : 2 dégâts à un serviteur ; s'il survit, marqué (+1 dégât des attaques jusqu'à votre prochain tour). | Burst / debuff |
| 13 | Hurle-voûte colossal | hurle-voute_colossal | oHurleVouteColossale | Chauve-souris | Bête | epique | 4 | 3 | 2 | Eveil | Eveil : Purge tous les serviteurs ennemis de la ligne de front. | Contrôle zone |
| 14 | Ours pestiféré des Landes du Sépulcre | ours_pestifere_des_landes_du_sepulcre | oOursPestifereLandesSepuclre | Ours | Bête | epique | 8 | 2 | 12 | Crépuscule | Crépuscule : Perd 1 PV. | Bruiser / tank |
| 15 | Aile-sang de la pénombre | aile-sang_de_la_penombre | oAileSangPenombre | Chauve-souris | Bête | epique | 3 | 4 | 3 | Passif | Ponction | Sustain / aggro |
| 16 | Banshee Sépulcrale | banshee_sepulcrale | oBansheeSepulcrale | Banshee | Mort-vivant | epique | 4 | 3 | 3 | Passif (Aura) | Aura : serviteurs ennemis ligne de front -1/-1. | Contrôle / debuff |
| 17 | Capitaine Vachon | capitaine_vachon | oCapitaineVachon | Humain | Humanoïde | rare | 4 | 3 | 3 | Passif + Attaque | Égide. Repoussement | Contrôle / tempo |
| 18 | Bries-os putréfié | bries-os_putrefie | oBriseOsPutrefie | Skarl | Mort-vivant | commun | 3 | 3 | 4 | — | Vanilla (flavor) | Bruiser |
| 19 | Journalier des Landes du sépulcre | journalier_des_landes_du_sepulcre | oJournalierLandeSepulcre | Humain | Humanoïde | commun | 1 | 1 | 2 | — | Vanilla | Early drop |
| 20 | Métayer des Landes du sépulcre | metayer_des_landes_du_sepulcre | oMetayerLandesSepulcre | Humain | Humanoïde | commun | 1 | 1 | 1 | Eveil | Eveil : Invoque un Journalier des Landes du Sépulcre. | Swarm / value |
| 21 | Oracle Sombre-branchie | oracle_sombre-branchie | oOracleSombreBranchie | Abyssien | Humanoïde | commun | 4 | 2 | 4 | Passif + Eveil | Épine (1). Eveil : 1 dégât à un serviteur adverse. | Tempo / ping |
| 22 | Zélote du Sang-pur | zelote_du_sang-pur | oZeloteSangPur | Humain | Humanoïde | commun | 2 | 1 | 1 | Passif | Ambidextrie | Aggro / tempo |
| 23 | Molosse décrépit | molosse_decrepit | oMolosseDecrepit | Loup | Mort-vivant | commun | 3 | 2 | 2 | Passif + Attaque | Charge. Repoussement. | Aggro / tempo |
| 24 | Abomination sanguinolente | abomination_sanguinolente | oAbominationSanguinolente | Goule | Mort-vivant | commun | 3 | 4 | 2 | Brisé | Brisé : serviteur aléatoire du cimetière → main. | Bruiser / value |
| 25 | Spectre délétère | spectre_deletere | oSpectreDeletere | Fantôme | Mort-vivant | rare | 3 | 5 | 3 | Eveil | Eveil : 1 dégât à tous les ennemis. | Tempo / AOE |
| 26 | Capitaine Perrine | capitaine_perrine | oCapitainePerrine | Humain | Humanoïde | legendaire | 4 | 3 | 3 | Passif (Aura) | Égide. Aura : +1 dégâts subis par monstres adverses. | Support / burst |
| 27 | Kodiak du sépulcre | kodiak_du_sepulcre | oKodiakSepulcre | Ours | Bête | epique | 5 | 3 | 6 | Passif + Attaque | Combat vs ligne arrière : +2 ATK temporaire. | Tempo / burst |
| 28 | Moine du Sang-pur | moine_du_sang-pur | oMoineSangPur | Humain | Humanoïde | commun | 3 | 3 | 2 | Passif + Attaque | Fauchage (1) | Aggro / cleave |
| 29 | Sismomancien Sombre-branchie | sismomancien_sombre-branchie | oSismomancienSombreBranchie | Abyssien | Humanoïde | rare | 4 | 2 | 7 | Eveil | Eveil : 1 dégât + purge un monstre adverse. | Contrôle |
| 30 | Titubant pestilentiel | titubant_pestilentiel | oTitubantPestilentiel | Zombie | Mort-vivant | commun | 1 | 0 | 1 | Brisé | Brisé : serviteur en face — 1 dégât fin de chacun des 3 prochains tours. | Poison / DoT |
| 31 | Grégor Vieille-Aube | gregor_vieille-aube | oGregorVieilleAube | Squelette | Mort-vivant | legendaire | 5 | 4 | 6 | Crépuscule | 3 projectiles arcane (1 dégât aléatoire chacun). +2 si Thalia en jeu. | Contrôle / burst |
| 32 | Ossomancien givroeil | ossomancien_givroeil | oOssomancienGivroeil | Squelette | Mort-vivant | commun | 1 | 1 | 1 | Eveil | Eveil : Entrave un serviteur ennemi aléatoire. | Tempo |
| 33 | Lance-éclair Sombre-branchie | lance-eclair_sombre-branchie | oLanceEclairSombreBranchie | Abyssien | Humanoïde | commun | 1 | 1 | 1 | Eveil | Eveil : 1 dégât à un ennemi aléatoire. | Tempo / ping |
| 34 | Patriarche putrescent | patriarche_putrescent | oPatriarchePutrescent | Zombie | Mort-vivant | legendaire | 7 | 0 | 15 | Passif | +1 ATK par Mort-vivant dans votre cimetière. | Scaling |
| 35 | Eclaireur du Sang-Pur | eclaireur_du_du_sang-pur | oEclaireurSangPur | Humain | Humanoïde | commun | 3 | 2 | 3 | Passif | Aube : 1 dégât au héros adverse. | Aggro / burn |
| 36 | Avant-garde du Sang-Pur | avant-garde_du_du_sang-pur | oAvantGardeSangPur | Humain | Humanoïde | commun | 3 | 1 | 6 | — | Tank défensif | Tank |
| 37 | Missionnaire du Sang-pur | missionnaire_du_sang-pur | oMissionnaireSangPur | Humain | Humanoïde | rare | 3 | 2 | 3 | Eveil | Eveil : 2 dégâts à une cible ennemie. | Burst |
| 38 | Capitaine Melrache | capitaine_melrache | oCapitaineMelrache | Humain | Humanoïde | epique | 5 | 4 | 5 | Passif (Aura) | Égide. Aura : -1 dégât subi par vos monstres (min 1). | Support / défense |
| 39 | Thalia Vieille-Aube | thalia_vieille-aube | oThaliaVieilleAube | Banshee | Mort-vivant | legendaire | 4 | 2 | 5 | Passif | Crépuscule : 2 dégâts Ombre aléatoires (+1 si Grégor en jeu). | Contrôle / burst |
| 40 | Devlin Vieille-Aube | devlin_vieille-aube | oDevlinVieilleAube | Goule | Mort-vivant | legendaire | 8 | 5 | 7 | Passif | Buffs si Grégor/Thalia au cimetière ; Crépuscule AOE si les deux. | Fin de partie |
| 41 | Mort pourrissant | mort_pourrissant | oMortPourrissant | Zombie | Mort-vivant | commun | 2 | 1 | 1 | Brisé | Brisé : héros adverse 2 dégâts. | Aggro / burn |
| 42 | Soldat cliquethorax | soldat_cliquethorax | oSoldatCliquethorax | Squelette | Mort-vivant | rare | 3 | 3 | 2 | Brisé | Brisé : invoque 3 Soldats squelettes aléatoires. | Swarm |
| 42.5 | Soldat squelette | soldat_squelette | oSoldatSquelette | Squelette | Mort-vivant | commun | 1 | 1 | 2 | — | Vanilla | Token-like |
| 43 | Cadavre noyé | cadavre_noye | oCadavreNoye | Zombie | Mort-vivant | commun | 2 | 1 | 1 | Brisé | Brisé : Entrave tous les serviteurs ennemis ligne arrière 1 tour. | Tempo |
| 44 | Oeil putride | oeil_putride | oOeilPutride | Skarl | Mort-vivant | epique | 5 | 3 | 4 | Passif (Aura) | Ponction. Aura : cartes en main adverse +1 mana. | Disruption |
| 45 | Profanateur putride | profanateur_putride | oProfanateurPutride | Skarl | Mort-vivant | epique | 5 | 2 | 7 | Passif | Quand un allié meurt : +1 coût à une carte aléatoire en main adverse. | Disruption |
| 46 | Bondisseur Sombre-branchie | bondisseur_sombre-branchie | oBondisseurSombreBranchie | Abyssien | Humanoïde | commun | 2 | 3 | 1 | Passif + Attaque | Charge | Aggro |
| 47 | Esprit vagabond | esprit_vagabond | oEspritVagabond | Fantôme | Mort-vivant | rare | 3 | 4 | 1 | Crépuscule | Crépuscule : 1 dégât à vos autres serviteurs. | Attrition |
| 48 | Décérébré putride | decerebre_putride | oDecerebrePutride | Skarl | Mort-vivant | commun | 3 | 3 | 2 | Brisé | Brisé : +1 coût carte aléatoire main adverse. | Disruption |
| 49 | Néophyte du Sang-pur | neophyte_du_sang-pur | oNeophyteSangPur | Humain | Humanoïde | commun | 2 | 1 | 1 | Passif | Après combat défensif : Entrave l'attaquant. | Tempo |
| 50 | Esprit tourmenteur | esprit_tourmenteur | oEspritTourmenteur | Fantôme | Mort-vivant | commun | 3 | 2 | 2 | Passif + Attaque | Dégâts au combat → 2 au héros adverse. | Aggro / burn |
| 51 | Marche-boue Sombre-branchie | marche-boue_sombre-branchie | oMarcheBoueSombreBranchie | Abyssien | Humanoïde | commun | 3 | 2 | 4 | Passif | Camouflage : +1 ATK tant que camouflage actif. | Aggro |
| 52 | Bâtard putride | batard_putride | oBatardPutride | Skarl | Mort-vivant | commun | 4 | 2 | 5 | Eveil | Eveil : +1 coût carte aléatoire main adverse. | Disruption |
| 53 | Reine Banshee, archère d'ombre | reine_banshee,_archere_dombre | oReineBansheeArchereOmbre | Eveillé | Mort-vivant | legendaire | 6 | 5 | 7 | Passif + Attaque + Brisé | Attaque : 2 dégâts serviteur aléatoire + héros. Brisé : invoque forme spectrale. | Burst |
| 54 | Reine banshee, forme spectrale | reine_banshee,_forme_spectale | oReineBansheeFormeSpectral | Banshee | Mort-vivant | legendaire | 6 | 4 | 6 | Crépuscule | 2 dégâts Ombre à tous les ennemis. | AOE |
| 55 | Roi nécromancien | roi_necromancien | oRoiNecromancien | Humain | Humanoïde | commun | 8 | 5 | 7 | Passif + Crépuscule | Ponction. Crépuscule : invoque MV aléatoire coût ≤3 du cimetière. | Boss |
| 56 | Farrow, tuteur des Eveillés | farrow,_tuteur_des_eveilles | oFarrowTuteurEveille | Eveillé | Mort-vivant | legendaire | 3 | 2 | 4 | Eveil | Eveil : Pioche un Mort-vivant aléatoire du deck. | Tutor |
| 57 | Generalissime du Sang-pur | generalissime_du_sang-pur | oGeneralissimeSangPur | Humain | Humanoïde | legendaire | 7 | 4 | 8 | Eveil + Aube | Eveil : 2 Capitaines Sang Pur → main. Aube : 1 dégât/allié par Capitaine allié. | Boss synergie |
| 58 | Grande prêtresse du Sang-pur | grande_pretresse_du_sang-pur | oGrandePretresseSangPur | Humain | Humanoïde | legendaire | 6 | 3 | 8 | Eveil + Aube | Eveil : Égide aux autres serviteurs. Aube : soigne 2 PV à tous les alliés. | Support |

### Cartes monstres — design sans objet GM (à implémenter)

| Slug design | Nom | Note |
|-------------|-----|------|
| putrefaction_en_chaine | Putréfaction en chaîne | Sort Nature #27 — pas d'objet `oPutrefactionEnChaine` trouvé |

---

## Magies — Chapitre 2 (30 fiches)

| # | Nom carte | Slug | Objet GM | Race | Genre | Rareté | Coût | Effet | Rôle |
|---|-----------|------|----------|------|-------|--------|-----|-------|------|
| 1 | Siphon d'Âme | siphon_dame | oSiphonAme | Ombre | Sort | rare | 2 | 3 dégâts à une cible. Soigne 3 PV au héros. | Burst / sustain |
| 2 | Contrat du Nécromancien | contrat_du_necromancien | oContratNecromancien | Ombre | Sort | rare | 2 | Détruisez un allié, piochez 2 cartes. | Sacrifice / value |
| 3 | Exhumation Rapide | exhumation_rapide | oExhumationRapide | Ombre | Sort | commun | 2 | Monstre du cimetière → main, coûte 1 de moins. | Recycle |
| 4 | Marque de Décomposition | marque_de_decomposition | oMarqueDecomposition | Ombre | Sort | commun | 2 | -2/-2 ennemi ; s'il meurt ce tour, piochez 1. | Contrôle |
| 5 | Moisson Macabre | moisson_macabre | oMoissonMacabre | Ombre | Sort | epique | 4 | Détruisez un allié ; dégâts = ses PV de base, répartis aléatoirement. | Burst |
| 6 | Appel des Cryptes | appel_des_cryptes | oAppelCrypte | Ombre | Sort | rare | 3 | MV coût ≤2 depuis le deck. | Tutor |
| 7 | Secret — Tombe Affamée | secret_tombe_affamee | oTombeAffamee | Ombre | Secret | rare | 2 | Tour adverse : ennemi meurt → MV aléatoire du cimetière en main. | Value |
| 8 | Secret — Linceul d'Os | secret_linceul_dos | oLinceuilOs | Ombre | Secret | rare | 1 | Tour adverse : magie sur allié annulée, allié +1/+1. | Protection |
| 9 | Secret — Dernier Souffle Volé | secret_dernier_souffle_vole | oDernierSouffleVole | Ombre | Secret | commun | 2 | Tour adverse : allié meurt → 2 dégâts héros adverse, soignez 2. | Punition |
| 10 | Secret — Négation Mortuaire | secret_negation_mortuaire | oNegationMortuaire | Ombre | Secret | epique | 3 | Tour adverse : votre monstre meurt → soin = PV de base du monstre. | Sustain |
| 11 | Nécropole Profanée | necropole_profanee | oNecropoleProfanee | Ombre | Terrain | rare | 3 | 3 tours : fin de tour, soin 1 par MV allié. | Sustain |
| 12 | Brouillard des Cimetières | brouillard_des_cimetieres | oBrouillardCimetiere | Ombre | Terrain | rare | 2 | 3 tours : début tour adverse, 1er monstre adverse +1 coût (1×/tour). | Disruption |
| 13 | Purification Écarlate | purification_ecarlate | oPurificationSangPur | Ombre | Sort | epique | 4 | 2 dégâts à tous les monstres ; 4 aux MV. | AOE |
| 14 | Inquisition | inquisition | oInquisition | Ombre | Sort | rare | 2 | Purge puis 2 dégâts. | Contrôle |
| 15 | Serment du Croisé | serment_du_croise | oSermentCroise | Ombre | Sort | rare | 2 | Humain allié +3/+3 ; kill ce tour → pioche 1. | Buff |
| 16 | Frappe Sanctifiée | frappe_sanctifiee | oFrappeSanctifie | Ombre | Sort | rare | 2 | 3 dégâts ; MV ≤3 PV détruit à la place. | Removal |
| 17 | Bouclier de la Foi | bouclier_de_la_foi | oBouclierFoi | Ombre | Sort | epique | 3 | Héros invulnérable jusqu'à fin tour adverse. | Défense |
| 18 | Décret du Bûcher | decret_du_bucher | oDecretBucher | Ombre | Sort | rare | 3 | Détruit un MV ; son contrôleur défausse 1. | Removal |
| 19 | Secret — Jugement du Zélote | secret_jugement_du_zelote | oJugementZelote | Ombre | Secret | rare | 2 | Tour adverse : attaquant subit 3 dégâts avant combat. | Anti-aggro |
| 20 | Secret — Interception | secret_interception | oInterception | Ombre | Secret | rare | 2 | Tour adverse : attaque héros → Humanoïde allié, +2 PV temp. | Protection |
| 21 | Secret — Déclaration d'Hérésie | secret_declaration_dheresie | oDeclarationHeresie | Ombre | Secret | rare | 2 | Tour adverse : magie adverse → 2 dégâts + pioche 1. | Punition |
| 22 | Cathédrale Écarlate | cathedrale_ecarlate | oCathedraleSangPur | Ombre | Terrain | epique | 3 | 3 tours : début tour, Humain aléatoire +1/+1. | Buff |
| 23 | Loi Martiale | loi_martiale | oLoiMartiale | Ombre | Terrain | epique | 3 | 3 tours : 1er monstre adverse/tour arrive Entravé. | Contrôle |
| 24 | Morsure Contagieuse | morsure_contagieuse | oMorsureContagieuse | Nature | Sort | rare | 2 | 2 dégâts ; si meurt, Bête/Bête zombie coût ≤2 du deck. | Tutor |
| 25 | Rage Virale | rage_virale | oRageVirale | Nature | Sort | rare | 2 | Bête +4 ATK ce tour ; 2 dégâts après attaque. | Burst |
| 26 | Spores Nécrotiques | spores_necrotiques | oSporeNecrotique | Nature | Sort | commun | 2 | Poison ; si blessé, pioche 1. | Contrôle |
| 27 | Putréfaction en Chaîne | putrefaction_en_chaine | — | Nature | Sort | rare | 3 | 1 dégât à tous les ennemis ; répète par mort ce tour. | AOE |
| 28 | Secret — Piège Charognard | secret_piege_charognard | oPiegeCharognard | Nature | Secret | rare | 2 | Tour adverse : attaque héros → Poison + annulation attaque. | Défense |
| 29 | Secret — Frénésie du Chenil | secret_frenesie_du_chenil | oFrenesieChenil | Nature | Secret | rare | 2 | Tour adverse : allié attaqué +2 ATK et riposte. | Contre-attaque |
| 30 | Marais Pesteux | marais_pesteux | oMaraisPesteux | Eau | Terrain | rare | 3 | 3 tours : fin tour adverse, 1 dégât à ses monstres blessés. | Attrition |

---

## Deck actuel — Vespera (héros Ch.2)

**Id** : `vespera_landes_sepulcre` · **40 cartes** · Portrait `sPortraitVespera`

| Qté | Objet GM | Nom |
|-----|----------|-----|
| 1 | oMacheOs | Mache-les-os |
| 2 | oHurleNuitStrident | Hurlenuit stridente |
| 2 | oSombregueuleTraqueur | Sombregueule traqueur |
| 2 | oMolosseVoileNoir | Molosse du voile noir |
| 2 | oTisseNuitNocturne | Tisse-nuit nocturne |
| 2 | oCrocEntraveBrumes | Croc-entrave des brumes |
| 1 | oGuetteuseConduit | Guetteuse des conduits |
| 1 | oDevoreurOmbres | Dévoreur des ombres |
| 2 | oAileSangPenombre | Aile-sang de la pénombre |
| 1 | oKodiakSepulcre | Kodiak du sépulcre |
| 3 | oSoldatSquelette | Soldat squelette |
| 2 | oOssomancienGivroeil | Ossomancien givroeil |
| 2 | oTitubantPestilentiel | Titubant pestilentiel |
| 1 | oMortPourrissant | Mort pourrissant |
| 2 | oMolosseDecrepit | Molosse décrépit |
| 2 | oBriseOsPutrefie | Bries-os putréfié |
| 1 | oAbominationSanguinolente | Abomination sanguinolente |
| 1 | oCadavreNoye | Cadavre noyé |
| 2 | oMorsureContagieuse | Morsure contagieuse |
| 2 | oSporeNecrotique | Spore nécrotique |
| 1 | oSiphonAme | Siphon d'âme |
| 1 | oExhumationRapide | Exhumation rapide |
| 1 | oMarqueDecomposition | Marque de décomposition |
| 1 | oAppelCrypte | Appel des cryptes |
| 1 | oTombeAffamee | Tombe affamée |
| 1 | oNecropoleProfanee | Nécropole profanée |

---

## Bots Ch.2 — ids et noms de deck (référence deckbuilding)

| Slot | Id bot | Nom boss | Nom deck (affichage) |
|------|--------|----------|----------------------|
| 8 | Eclaireurs_Ordre_Sang_Pur | Éclaireurs de l'Ordre du Sang Pur | Purification |
| 9 | Inquisiteur_Malvadius | Inquisiteur Malvadius | Inquisition |
| 10 | Gregor_Vieille_Aube | Grégor Vieille-Aube | Noblesse Vieille-Aube |
| 11 | Oeil_Putride | Œil putride | Attaque des Skarls putrides |
| 12 | Roi_Necromancien | Roi nécromancien | Domination necrotique |
| 13 | Kelthazar | Kelthazar | Bastion du Sang Pur |
| 14 | Grande_Pretresse_Sang_Pur | Grande prêtresse du Sang Pur | Lumière du Sang Pur |

Les listes de cartes par bot sont dans `scripts/sDeckBotChap2/sDeckBotChap2.gml` (provisoires, 40 cartes chacun).

---

## Fichiers source projet

| Fichier | Contenu |
|---------|---------|
| `Liste_Cartes_Chap_2.md` | Brouillon design + stats équilibrage |
| `Guide_Equilibrage.md` | Barème effets / vanilla |
| `scripts/sDeckBotChap2/sDeckBotChap2.gml` | Decks bots Ch.2 |
| `scripts/sDeckHeroChap2/sDeckHeroChap2.gml` | Deck Vespera |
| `scripts/sStoryDeckManager/sStoryDeckManager.gml` | Ordre slots 8–14 ↔ ids string |

---

## Prompt suggéré pour Claude

> Tu travailles sur **Shard of Eternis**, Chapitre 2. Utilise ce document comme liste canonique des cartes. Propose un deck de **40 cartes** (objets `o*`) pour [BOT ou VESPERA], en respectant le thème, une courbe de mana cohérente, et les synergies (famille Vieille-Aube, capitaines Sang Pur, disruption Poil-Putride, etc.). Réponds avec un tableau : Qté | Objet GM | Nom | Coût | Rôle dans le deck.
