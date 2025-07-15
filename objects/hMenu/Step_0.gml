// STEP EVENT

// Variables del botón en GUI
var x_gui = 10;
var y_gui = 10;
var ancho = sprite_width;
var alto  = sprite_height;

// Coordenadas del mouse en GUI
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Detectamos si el clic fue sobre el HUD
global.mouse_clicked_gui = false;

if mouse_check_button_pressed(mb_left) &&
   point_in_rectangle(mx, my, x_gui, y_gui, x_gui + ancho, y_gui + alto) or keyboard_check_pressed(vk_escape) {
    global.menuactive = true;
    global.mouse_clicked_gui = true;

    paused = !paused;
    update_pause();
global.mouse_clicked_gui = true;
global.mouse_gui_delay = 4; // unos 4 frames (~0.06s)
 
}