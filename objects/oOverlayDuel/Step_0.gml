if (!isClosing && variable_global_exists("isActionMenuOpen")) { global.isActionMenuOpen = true; }
overlayAlpha = clamp(overlayAlpha + fadeDir * fadeSpeed, 0, 1);
if (isClosing && overlayAlpha <= 0) { instance_destroy(id); exit; }

if (mouse_check_button_pressed(mb_left)) {
    var n = array_length(cards);
    var scale = scaleView;
    var totalW = 0;
    for (var i = 0; i < n; i++) {
        var spr = cards[i].sprite_index;
        totalW += sprite_get_width(spr) * scale;
    }
    var gap = 40;
    var allW = totalW + max(0, (n - 1)) * gap;
    var startX = (room_width - allW) / 2;
    var overlayY = room_height * 0.35;
    var clickedIndex = -1;
    var btnX = overlayBtnX; var btnY = overlayBtnY; var btnW = overlayBtnW; var btnH = overlayBtnH;
    var clickedValidate = mouse_x >= btnX && mouse_x <= btnX + btnW && mouse_y >= btnY && mouse_y <= btnY + btnH;
    if (clickedValidate) {
        var complete = true;
        for (var k = 0; k < n; k++) { if (selections[k] <= 0) { complete = false; break; } }
        if (!complete) exit;
        var sz = ds_list_size(deckInst.cards);
        if (sz <= 0) { instance_destroy(id); exit; }
        var count = min(n, sz);
        ds_list_delete(deckInst.cards, sz - 1);
        if (count >= 2) ds_list_delete(deckInst.cards, sz - 2);
        if (count >= 3) ds_list_delete(deckInst.cards, sz - 3);
        for (var num = count; num >= 1; num--) {
            var idx = -1;
            for (var m = 0; m < n; m++) { if (selections[m] == num) { idx = m; break; } }
            if (idx != -1) { ds_list_add(deckInst.cards, cards[idx]); }
        }
        if (!is_undefined(markEffectAsUsed) && effectCard != noone && effectStruct != noone) { markEffectAsUsed(effectCard, effectStruct); }
        if (!is_undefined(consumeSpellIfNeeded) && effectCard != noone && effectStruct != noone) { consumeSpellIfNeeded(effectCard, effectStruct); }
        if (variable_global_exists("isActionMenuOpen")) { global.isActionMenuOpen = false; }
        isClosing = true; fadeDir = -1; didApply = true;
        exit;
    }
    for (var j = 0; j < n; j++) {
        var c = cards[j];
        var sprj = c.sprite_index;
        var wj = sprite_get_width(sprj) * scale;
        var hj = sprite_get_height(sprj) * scale;
        var xj = startX + j * (wj + gap) + wj / 2;
        var left = xj - wj / 2;
        var right = xj + wj / 2;
        var top = overlayY - hj / 2;
        var bottom = overlayY + hj / 2;
        if (mouse_x >= left && mouse_x <= right && mouse_y >= top && mouse_y <= bottom) { clickedIndex = j; break; }
    }
    if (clickedIndex != -1) {
        var used = [];
        for (var u = 0; u < n; u++) { if (selections[u] > 0) array_push(used, selections[u]); }
        var nextNum = 1; var okNext = false;
        while (nextNum <= n) {
            okNext = true;
            for (var t = 0; t < array_length(used); t++) { if (used[t] == nextNum) { okNext = false; break; } }
            if (okNext) break; nextNum++;
        }
        if (nextNum <= n) { selections[clickedIndex] = nextNum; } else { for (var r = 0; r < n; r++) { selections[r] = 0; } selections[clickedIndex] = 1; }
    }
}
if (mouse_check_button_pressed(mb_right)) {
    var n2 = array_length(cards);
    var scale2 = scaleView;
    var totalW2 = 0;
    for (var i2 = 0; i2 < n2; i2++) { var spr2 = cards[i2].sprite_index; totalW2 += sprite_get_width(spr2) * scale2; }
    var gap2 = 40;
    var allW2 = totalW2 + max(0, (n2 - 1)) * gap2;
    var startX2 = (room_width - allW2) / 2;
    var overlayY2 = room_height * 0.35;
    var clickedIndex2 = -1;
    for (var j2 = 0; j2 < n2; j2++) {
        var c2 = cards[j2]; var sprj2 = c2.sprite_index; var wj2 = sprite_get_width(sprj2) * scale2; var hj2 = sprite_get_height(sprj2) * scale2;
        var xj2 = startX2 + j2 * (wj2 + gap2) + wj2 / 2;
        var left2 = xj2 - wj2 / 2; var right2 = xj2 + wj2 / 2; var top2 = overlayY2 - hj2 / 2; var bottom2 = overlayY2 + hj2 / 2;
        if (mouse_x >= left2 && mouse_x <= right2 && mouse_y >= top2 && mouse_y <= bottom2) { clickedIndex2 = j2; break; }
    }
    if (clickedIndex2 != -1) { selections[clickedIndex2] = 0; }
}