
// --- Draw Event de oPlayer
if (tp_active) {
    draw_set_color(c_black);
    draw_set_alpha(tp_filter_alpha);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

draw_self();

// Barra de vida
var procent = clamp(vida / max_vida, 0, 1);
var bar_w = 40, bar_h = 6;
var x1 = x - bar_w * 0.5;
var y1 = y - (sprite_h_original * 0.5) - 10;

// Borde de la barra
draw_set_color(c_black);
draw_rectangle(x1 - 1, y1 - 1, x1 + bar_w + 1, y1 + bar_h + 1, false);

// Relleno proporcional
draw_set_color(c_white);
draw_rectangle(x1, y1, x1 + bar_w * procent, y1 + bar_h, true);

// Restablecer color
draw_set_color(c_white);

// Tinte rojo y sprite final
var color_final = merge_color(c_white, c_red, tinte_rojo);
draw_sprite_ext(sprite_index, image_index, x, y,
                image_xscale, image_yscale,
                image_angle, color_final, image_alpha);
