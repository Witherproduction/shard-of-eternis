// === oCancelButton - Step Event ===

// 1. Position and Scale Update
if (instance_exists(anchor)) {
    // Match Width of the anchor (End Turn Button)
    var target_width = anchor.sprite_width;
    var base_width = sprite_get_width(sButton);
    
    // Calculate scale to match width
    var scale = target_width / base_width;
    
    image_xscale = scale;
    image_yscale = scale; // Keep aspect ratio
    
    // Anchor origin is Top-Left (0,0) based on sNextStep
    // Self origin is Center (Middle-Center) based on sButton
    
    // Center horizontally relative to anchor
    x = anchor.x + (anchor.sprite_width / 2);
    
    // Position below anchor
    // anchor.y + anchor.height + padding + half_self_height
    y = anchor.y + anchor.sprite_height + 10 + (sprite_height / 2);
} else {
    // Try to find anchor if missing
    anchor = instance_find(oNextStep, 0);
}

// 2. Visibility Logic
var show = false;

// Check if we are in Duel room
if (room == rDuel) {
    // Condition A: Sacrifice Selector is active
    var sacSel = instance_find(oSacrificeSelector, 0);
    if (sacSel != noone && instance_exists(sacSel) && sacSel.visible) {
        show = true;
    } 
    // Condition B: Targeting Indicator is active
    else if (instance_exists(oIndicatorParent)) {
        show = true;
    }
    // Condition C: Card is selected (and it's our turn)
    else if (instance_exists(oSelectManager)) {
        var sm = instance_find(oSelectManager, 0);
        if (sm != noone && sm.selected != noone) {
             if (instance_exists(oGame) && oGame.is_local_turn) {
                show = true;
             }
        }
    }
}

visible = show;
