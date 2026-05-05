// Garde globale pour les boutons: bloque les clics si le panneau d'options est présent
if (instance_exists(oPanelOptions) || instance_exists(oQuestPanel)) return;

// Ne pas appeler event_inherited ici (nous sommes le parent)
