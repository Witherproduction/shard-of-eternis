// === oFiltre - Create Event ===
show_debug_message("### oFiltre.create");

// Variables pour le filtrage
filterText = ""; // Texte de filtrage saisi par l'utilisateur
isTyping = false; // Indique si l'utilisateur est en train de taper

// Position et dimensions de la barre de filtre (fond avec sButton)
// Alignement visuel par rapport à la barre de tri (oTri) actuellement :
// oTri: barX=310, barY=room_height-130
var baseW = sprite_get_width(sButton);
var baseH = sprite_get_height(sButton);
filterBarHeight = round(baseH * (100.0 / 100.0));
filterBarY = room_height - 130;

// Position et taille de la zone de saisie (centrée dans la barre de filtre)
filterBoxWidth = 300;
filterBoxHeight = 40;

// Réduire la largeur du bouton filtre pour qu'il soit proche du cadre d'écriture
// Ajouter une petite marge latérale de 20 px
filterBarWidth = filterBoxWidth + 50;
filterBarX = 310 - filterBarWidth + 200; // Décale tout l'objet vers la droite de 200px au total

filterBoxX = filterBarX + (filterBarWidth - filterBoxWidth) / 2;
filterBoxY = filterBarY + (filterBarHeight - filterBoxHeight) / 2;

// Couleurs (thème assorti à la barre de tri)
boxColor = make_color_rgb(60, 45, 25);       // fond sombre du champ
borderColor = make_color_rgb(230, 200, 120); // crème dorée pour la bordure
textColor = make_color_rgb(230, 200, 120);   // texte crème dorée
activeColor = make_color_rgb(120, 90, 45);   // éclaircir en mode actif

// Police
filterFont = fontCardDisplay;

show_debug_message("### oFiltre initialisé");