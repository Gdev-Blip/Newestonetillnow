if (flash_alpha > 0) {
    draw_set_alpha(flash_alpha);
    draw_set_color(c_white);
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1);
}
/// DRAW GUI EVENT

// Posición inicial en pantalla
var gui_x = 20;
var gui_y = 20;
var line_h = 20; // altura entre líneas

// (Opcional) cambiar fuente/color si querés:
// draw_set_font(fnt_hud);
// draw_set_color(c_white);

draw_text(x,y,fps)
draw_text(16, 16, "Wall Slide: " + string(en_wall_slide) + " | Timer: " + string(wall_slide_timer));
