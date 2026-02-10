// === oCancelButton - Create Event ===
// Initialize properties
image_speed = 0;
image_index = 0;
text = "Annuler";

// Find anchor (End Turn button)
anchor = instance_find(oNextStep, 0);

// Set initial position if anchor exists
if (instance_exists(anchor)) {
    x = anchor.x;
    y = anchor.y + (anchor.sprite_height / 2) + (sprite_height / 2) + 10;
    depth = anchor.depth - 10; // Ensure it's above
}

// Initial visibility
visible = false;
