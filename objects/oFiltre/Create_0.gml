// === oFiltre - Create Event ===
show_debug_message("### oFiltre.create");

// Variables pour le filtrage
filterText = ""; // Texte de filtrage saisi par l'utilisateur
isTyping = false; // Indique si l'utilisateur est en train de taper

var baseW = sprite_get_width(sButton);
var baseH = sprite_get_height(sButton);
filterBarHeight = round(baseH * (100.0 / 100.0)) * 0.8;
// Positionner en haut, à la suite du bouton Booster et du bouton Invocation
var top_y = 40;
var booster_w = 220;
var booster_h = 28;
if (instance_exists(oCardViewer)) {
    with (oCardViewer) {
        start_x = dropdown_x;
        booster_w = dropdown_w;
        booster_h = dropdown_h;
    }
}
filterBarY = top_y;


// Position et taille de la zone de saisie (centrée dans la barre de filtre)
filterBoxWidth = 300;
filterBoxHeight = 40;

// Réduire la largeur du bouton filtre pour qu'il soit proche du cadre d'écriture
// Ajouter une petite marge latérale de 20 px
filterBoxWidth = round(filterBoxWidth * 0.8);
filterBoxHeight = round(filterBoxHeight * 0.8);
filterBarWidth = filterBoxWidth + 50;
// Placer à la suite de la barre de tri avec 50px d'espacement
var spacing = 50;
var barWidthTri = round(baseW * (570.0 / 300.0));
filterBarX = 40 + 220 + spacing; // fallback si oCardViewer n'existe pas
if (instance_exists(oCardViewer)) {
    with (oCardViewer) {
        filterBarY = dropdown_y;
        filterBarX = dropdown_x + dropdown_w + spacing + barWidthTri + spacing;
    }
}

filterBoxX = filterBarX + (filterBarWidth - filterBoxWidth) / 2;
filterBoxY = filterBarY + (filterBarHeight - filterBoxHeight) / 2;

// Couleurs (thème assorti à la barre de tri)
boxColor = make_color_rgb(60, 45, 25);       // fond sombre du champ
borderColor = make_color_rgb(230, 200, 120); // crème dorée pour la bordure
textColor = make_color_rgb(230, 200, 120);   // texte crème dorée
activeColor = make_color_rgb(120, 90, 45);   // éclaircir en mode actif

// Police
filterFont = fontText;

show_debug_message("### oFiltre initialisé");
