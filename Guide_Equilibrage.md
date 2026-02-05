# Guide d'Équilibrage des Cartes - Shard of Eternis

Ce guide vous aide à remplir la colonne **"Valeur_Effet_Estimee"** dans votre tableur `monster_cards.csv`.

Le principe est de convertir chaque effet en **Points de Stats** (équivalent à de l'Attaque ou des PV).

---

## ⚖️ La Règle d'Or (Le Standard)
Pour qu'une carte soit équilibrée "sans effet" (Vanilla), elle doit respecter la formule :
> **Stats Totales (Atk + PV) = (Coût en Mana x 2) + 1**

*Exemple : Une carte à 2 Mana doit avoir ~5 stats (2/3 ou 3/2).*

Tout point manquant dans les stats doit être compensé par l'effet.

---

## 📊 Barème des Effets (En Points)

Ajoutez ces points dans la colonne `Valeur_Effet_Estimee` :

### Mots-Clés (Keywords)
| Effet | Valeur (Points) | Note |
| :--- | :---: | :--- |
| **Provocation** (Taunt) | **1** | Protège les autres |
| **Camouflage** (Stealth) | **1** | Difficile à tuer |
| **Charge / Hâte** | **2** | Impact immédiat |
| **Bouclier Divin** | **2** | Encaisse un coup gratuit |
| **Poison** | **3** | Tue n'importe quoi |
| **Vol de vie** | **1.5** | Différence de PV |

### Actions (Eveil / Crépuscule / Brisé)
*Note : Les effets "Brisé" (Mort) valent souvent un peu plus car ils sont retardés.*

| Type d'Action | Formule / Valeur |
| :--- | :--- |
| **Dégâts directs** | **1 pt** par dégât infligé |
| **Soins** | **0.5 pt** par PV soigné |
| **Piocher une carte** | **3 pts** par carte |
| **Générer une carte** (Aléatoire/Copie) | **1.5 à 2 pts** (Moins fort que piocher) |
| **Détruire un serviteur** | **Infini** (souvent évalué à ~5-6 pts selon condition) |

### Invocations (Tokens)
Si une carte invoque un autre monstre :
> **Valeur = (Attaque du Token + PV du Token)**
* *Exemple : Invoque un loup 2/2 -> Valeur = 4 pts.*

### Buffs (Améliorations)
Si une carte donne +X/+Y à une autre :
> **Valeur = X + Y**
* *Si c'est "A tous les alliés" (Zone) : Multipliez par le nombre moyen de cibles (souvent x2 ou x3).*

---

## 🧮 Exemple de Calcul

**Carte : "James la Calamité"**
*   **Coût :** 2 Mana
*   **Stats :** 5/5 (Atk 5, PV 5) -> Total = 10
*   **Effet :** Camouflage + Pille une carte (Vole 1 carte).

**Analyse :**
1.  **Standard 2 Mana** = (2*2)+1 = **5 pts** attendus.
2.  **Stats Réelles** = 10 pts.
3.  **Score Stats** = 10 - 5 = **+5 pts** (Déjà très fort !).
4.  **Valeur Effet** :
    *   Camouflage = **1 pt**
    *   Pille (Piocher + Voler) = **4 pts** (très fort)
    *   Total Effet = **5 pts**.
5.  **Verdict Final** : +5 (Stats) + 5 (Effet) = **+10**.
    *   *Conclusion : Cette carte est COMPLÈTEMENT CASSÉE (Overpowered).*

---

## 💡 Astuces
*   **Conditions** : Si un effet est conditionnel ("Si vous contrôlez une Bête..."), **réduisez sa valeur de 1 ou 2 pts** car il est plus dur à activer.
*   **Effets Négatifs** : Si une carte a un désavantage ("Inflige 3 dégâts à votre héros"), mettez une valeur **négative** (ex: -3). Cela permet d'avoir de plus grosses stats.
