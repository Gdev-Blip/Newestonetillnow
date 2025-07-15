/// =============================
/// obj_hud — Create Event
/// =============================

// Fuente y límites
fnt_hud     = font_futurista;
max_balas   = 8;
hud_margin  = 20;
hud_w       = 300;
hud_h       = 100;

// Posición fija en GUI
hud_x = 100;
hud_y = hud_margin;

// Escala del ASCII (ajustá según tu sprite)
ascii_scale  = 1;

// CACHEAMOS el ancho y alto del sprite escalados
ascii_w = sprite_get_width(spr_gun_ascii) * ascii_scale;
ascii_h = sprite_get_height(spr_gun_ascii) * ascii_scale;

// Offset interno
ascii_xoffs = 0;
ascii_yoffs = 0;

// Ya podemos calcular el TXT_X base (colocamos el texto justo a la derecha del sprite)
txt_x_base = hud_x + ascii_xoffs + ascii_w + 10;

// Opcional: si la barra de balas es fija de ancho, cacheamos bar_w/bar_x/bar_y
bar_x = hud_x + ascii_xoffs;
bar_y = hud_y + hud_h - 24;
bar_w = hud_w - 2 * ascii_xoffs;
bar_h = 10;