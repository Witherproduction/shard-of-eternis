/// @function region_get_zones_ForetDesVoleur()
/// @description Retourne la configuration des zones de révélation pour la Forêt des Voleurs
function region_get_zones_ForetDesVoleur() {
    return [
        {
            // Zone Acte 1 (Fin Chapitre 0)
            condition_check: function() { return is_act_complete(0, 1); },
            points: [ 
                 {x:11, y:-116}, 
                 {x:55, y:-148}, 
                 {x:100, y:-210}, 
                 {x:89, y:-284}, 
                 {x:77, y:-353}, 
                 {x:9, y:-361}, 
                 {x:-111, y:-337}, 
                 {x:-148, y:-307}, 
                 {x:-184, y:-259}, 
                 {x:-175, y:-213}, 
                 {x:-156, y:-153}, 
                 {x:-119, y:-109}, 
                 {x:-49, y:-111}, 
                 {x:-23, y:-102}, 
                 {x:11, y:-114} 
             ]
        },
        {
            // Zone Acte 2 (Fin Chapitre 1 Acte 1)
            condition_check: function() { return is_act_complete(1, 1); },
            points: [ 
                 {x:12, y:-119}, 
                 {x:52, y:-140}, 
                 {x:93, y:-125}, 
                 {x:169, y:-86}, 
                 {x:163, y:-27}, 
                 {x:186, y:-18}, 
                 {x:212, y:2}, 
                 {x:210, y:37}, 
                 {x:206, y:99}, 
                 {x:138, y:106}, 
                 {x:83, y:79}, 
                 {x:28, y:55}, 
                 {x:-14, y:45}, 
                 {x:-51, y:26}, 
                 {x:-87, y:13}, 
                 {x:-99, y:-3}, 
                 {x:-97, y:-54}, 
                 {x:-102, y:-99}, 
                 {x:-9, y:-107}, 
                 {x:11, y:-117} 
             ]
        },
        {
            // Zone Acte 2 (Après le 1er duel / Mi-Acte)
            // Note : Il faudra appeler story_progress_unlock_reward("chap1_act2_duel1_win") dans le scénario après la victoire
            condition_check: function() { return story_progress_is_reward_unlocked("chap1_act2_duel1_win"); },
            points: [ 
                 {x:-45, y:-115}, 
                 {x:-46, y:-103}, 
                 {x:-96, y:-92}, 
                 {x:-98, y:-2}, 
                 {x:-156, y:62}, 
                 {x:-357, y:51}, 
                 {x:-396, y:-311}, 
                 {x:-195, y:-384}, 
                 {x:-73, y:-373}, 
                 {x:-45, y:-104} 
             ]
        },
        {
            // Zone Acte 3 (Fin Chapitre 1 Acte 2)
            condition_check: function() { return is_act_complete(1, 2); },
            points: [ 
                 {x:-417, y:45}, 
                 {x:-280, y:27}, 
                 {x:-131, y:18}, 
                 {x:-58, y:208}, 
                 {x:-50, y:291}, 
                 {x:-221, y:321}, 
                 {x:-418, y:361}, 
                 {x:-476, y:260}, 
                 {x:-417, y:45} 
             ]
        },
        {
            // Zone Acte 4 (Fin Chapitre 1 Acte 3)
            condition_check: function() { return is_act_complete(1, 3); },
            points: [ 
                 {x:-156, y:29}, 
                 {x:-104, y:286}, 
                 {x:210, y:289}, 
                 {x:138, y:67}, 
                 {x:-47, y:19}, 
                 {x:-156, y:29} 
             ]
        },
        {
            // Zone Fin Acte 4 (Fin Chapitre 1 Acte 4)
            condition_check: function() { return is_act_complete(1, 4); },
            points: [ 
                 {x:10, y:-134}, 
                 {x:234, y:68}, 
                 {x:464, y:73}, 
                 {x:446, y:-320}, 
                 {x:25, y:-416}, 
                 {x:10, y:-134} 
             ]
        }
    ];
}
