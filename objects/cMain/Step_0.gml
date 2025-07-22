global.hover_id = noone;
if (!layer_exists("Light")) {
    layer_create(-1000000, "Light");
}


if (global.mouse_gui_delay > 0) {
    global.mouse_gui_delay--;
}
if (room = selecChar1) {
    layer_set_visible("menu", false);
}
if !instance_exists(oLight) {
    instance_create_layer(x,y,"Light",oLight)    

}
