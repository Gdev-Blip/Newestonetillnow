global.hover_id = noone;


if (global.mouse_gui_delay > 0) {
    global.mouse_gui_delay--;
}
if (room = selecChar1) {
    layer_set_visible("menu", false);
}
if (window_get_width() != winw || window_get_height() != winh)
{
    display_set_gui_maximize();
}
