///////////////////////////////
/// obj_hud — Draw GUI Event
///////////////////////////////

/// 1) Tomar combo desde oPlayer
var player_inst   = instance_find(oPlayer, 0);
var current_combo = 0;
if (player_inst != noone) {
    current_combo = player_inst.combo;
}

/// 2) Fondo semitransparente (relleno)
draw_set_font(fnt_hud);
draw_set_color(make_color_rgb(0, 255, 255));
draw_set_alpha(0.2);
draw_roundrect(hud_x, hud_y, hud_x + hud_w, hud_y + hud_h, false);
draw_set_alpha(1);

/// 3) Borde neón (outline)
draw_set_color(make_color_rgb(0, 255, 255));
draw_roundrect(hud_x, hud_y, hud_x + hud_w, hud_y + hud_h, true);

/// 4) Dibujar el ASCII como sprite (sin recalcular width/height)
draw_set_color(c_white);
draw_sprite_ext(
    spr_gun_ascii,
    0,
    hud_x + ascii_xoffs,
    hud_y + ascii_yoffs,
    ascii_scale,
    ascii_scale,
    0,
    c_white,
    1
);


/// 6) Barra de balas (que EMPIEZA llena y se VACÍA con menos combo)
var perc = clamp(current_combo / max_balas, 0, 1); // combo real
var inv_perc = 1 - perc; // porcentaje invertido

// Fondo gris
draw_set_color(c_gray);
draw_roundrect(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

// Barra verde neón (disminuye de derecha a izquierda)
draw_set_color(make_color_rgb(0, 255, 0));
draw_roundrect(bar_x, bar_y, bar_x + bar_w * inv_perc, bar_y + bar_h, false);

// Borde blanco
draw_set_color(c_white);
draw_roundrect(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);
