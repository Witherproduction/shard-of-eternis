// === oCollectionCardDisplay - Create Event ===

// Variables d'affichage de base
selectedCard = noone;

select_card_instance = function(cardInstance) {
    if (cardInstance != noone && instance_exists(cardInstance)) {
        selectedCard = cardInstance;
        return true;
    }
    selectedCard = noone;
    return false;
}

// FORCE DEPTH: Ensure this object is drawn on top of others
depth = -100000;
