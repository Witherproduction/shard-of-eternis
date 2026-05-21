depth = -10000;

width = min(720, room_width - 80);
height = min(420, room_height - 120);
x = (room_width - width) * 0.5;
y = (room_height - height) * 0.5;

btn_width = 220;
btn_height = 48;
btn_x = x + (width - btn_width) * 0.5;
btn_y = y + height - btn_height - 28;

title_text = "Règles du duel";
rule_lines = [];
if (is_callable(chap2_bot_grande_pretresse_rules_lines)) {
    rule_lines = chap2_bot_grande_pretresse_rules_lines();
}
