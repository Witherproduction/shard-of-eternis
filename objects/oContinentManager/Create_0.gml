/// @description Init Continent Manager
// Variables Masque
surf_mask = -1;
mask_sprite = -1; // À définir dans l'enfant (ex: sMasqueContinentOuest)
reveal_scale = 1;

// Liste des régions/pochoirs
regions = [];

// Ajouter Foret des Voleurs (Chap 0, Act 1)
// Note: Les coordonnées et l'échelle devront être ajustées car sMasqueForetDesVoleur (868px) est plus grand que le continent (350px)
array_push(regions, {
    name: "ForetDesVoleur",
    sprite: sMasqueForetDesVoleur,
    x: 102.60,       // Offset X par rapport au centre du continent
    y: 129.70,       // Offset Y par rapport au centre du continent
    scale_x: 0.16, // Échelle ajustée
    scale_y: 0.16,
    chap: 0,
    act: 1
});


// Initialisation générique
image_speed = 0;

// S'assurer que le MapManager est présent pour gérer les régions (et donc le pochoir)
if (!instance_exists(oMapManager)) {
    instance_create_depth(0, 0, depth, oMapManager);
}
