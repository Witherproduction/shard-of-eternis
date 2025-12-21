/// oRoomContour Draw - sContour largement plus grand que la room (origine centrée)
var W = room_width;
var H = room_height;

// Marges pour faire largement déborder le sprite au-delà de la room
var extra = 60;

// Dimensions du sprite de contour
var spr = sContour;
var baseW = sprite_get_width(spr);
var baseH = sprite_get_height(spr);

// Échelle pour couvrir la room + marge
var scaleX = (W + extra) / baseW;
var scaleY = (H + extra) / baseH;

// Origine centrée : dessiner au centre de la room
var drawX = W * 0.5;
var drawY = H * 0.5;

draw_sprite_ext(spr, 0, drawX, drawY, scaleX, scaleY, 0, c_white, 1);