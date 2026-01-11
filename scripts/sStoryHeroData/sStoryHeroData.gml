/// @function get_story_heroes()
/// @description Retourne la liste des héros disponibles pour le mode Histoire
function get_story_heroes() {
    return [
        {
            id: "tuto_hero",
            name: "Introduction",
            description: "",
            portrait: "sPortraitIntro",
            chapters: [0] // Chapitre 0 : Initiation
        },
        {
            id: "kaelen",
            name: "Kaelen",
            description: "",
            portrait: "sPortraitKaelen",
            chapters: [1, 2, 3, 4, 5] // Chapitres de l'histoire principale
        }
        // Ajoutez d'autres héros ici...
    ];
}

/// @function get_chapter_data(chapter_id)
/// @description Retourne les données (titre, actes) d'un chapitre
function get_chapter_data(chapter_id) {
    var all_chapters = [
        {
            id: 0,
            title: "Initiation",
            acts: ["Les bases du duel"]
        },
        {
            id: 1,
            title: "La forêt des voleurs",
            acts: ["L'arrivée du héros", "En route vers l'aventure", "Le récolteur", "La fin de la Terreur"]
        },
        {
            id: 2,
            title: "Les plaines gelées",
            acts: ["Le froid mordant", "Traces dans la neige", "Le gardien de glace", "Coeur gelé"]
        },
        {
            id: 3,
            title: "Le volcan endormi",
            acts: ["Chaleur montante", "Chemin de lave", "L'esprit du feu", "Eruption"]
        },
        {
            id: 4,
            title: "La cité des nuages",
            acts: ["Ascension", "Parmi les cieux", "Le palais céleste", "Chute libre"]
        },
        {
            id: 5,
            title: "Le néant",
            acts: ["Obscurité", "Murmures", "Confrontation", "Eternité"]
        }
    ];
    
    if (chapter_id >= 0 && chapter_id < array_length(all_chapters)) {
        return all_chapters[chapter_id];
    }
    
    return { title: "Inconnu", acts: [] };
}
