// === oCancelButton - Mouse Left Pressed ===

if (!visible) exit;

// Cancellation Logic

// 1. Cancel Sacrifice Selector
var sacSel = instance_find(oSacrificeSelector, 0);
if (sacSel != noone && instance_exists(sacSel) && sacSel.visible) {
    with (sacSel) { cancel(); }
} 
else {
    // 2. Stop targeting indicator
    var ui = instance_find(oUIManager, 0);
    if (ui != noone && instance_exists(ui)) {
        if (variable_instance_exists(ui, "stopIndicator")) {
            ui.stopIndicator();
        }
    }
    
    // 3. Unselect All
    var sm = instance_find(oSelectManager, 0);
    if (sm != noone && instance_exists(sm)) {
        with (sm) {
            unSelectAll();
        }
    }
}
