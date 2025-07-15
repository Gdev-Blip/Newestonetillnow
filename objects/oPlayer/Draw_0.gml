// DRAW EVENT de oPlayer

// 1) Si estamos en modo TP, dibujamos un rectángulo gris semitransparente sobre toda la room
if (tp_active) {
    draw_set_color(c_black);
    draw_set_alpha(tp_filter_alpha); // p. ej. 0.5 = 50% gris
    // Dibuja un rect que cubra toda la pantalla (en room-space):
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

// 2) Después, dibujás tu jugador normalmente. Por ejemplo:
draw_self();



// 2) Calculamos el porcentaje de vida (entre 0 y 1):
var procent = clamp(vida / max_vida, 0, 1);

// 3) Definimos el tamaño (en px) de la barra:
var bar_w = 40;   // ancho total de la barra cuando está al 100%
var bar_h = 6;    // grosor de la barra

// 4) Calculamos la posición “sobre la cabeza” del player:
//    - x1 es la esquina izquierda de la barra.
//    - y1 es un poco arriba de la mitad vertical del sprite.
var sprite_h = sprite_get_height(sprite_index);
var x1 = x - bar_w/2;
var y1 = y - (sprite_h/2) - 10; 
//         ↑ mitad del sprite hacia arriba  ↑ y le sumamos 10px para dejar hueco

// 5) Dibujamos el marco (borde negro) un px más grande que la barra:
draw_set_color(c_green);
draw_rectangle(x1 - 1, y1 - 1, x1 + bar_w + 1, y1 + bar_h + 1, false);

// 6) Dibujamos el interior verde, solo hasta el ancho proporcional:
draw_set_color(c_white); 
draw_rectangle(x1, y1, x1 + (bar_w * procent), y1 + bar_h, true);
draw_text(x+50,y,limite)
draw_text(x-80,y,xspd)
// 7) Volvemos el color a blanco por si hay más draw después:
draw_set_color(c_white);
var color_final = merge_color(c_white, c_red, tinte_rojo);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, color_final, image_alpha);

// DRAW EVENT de oPlayer
draw_text(x+200,y,VX)

// 1) Si estamos en modo TP, dibujamos un rectángulo gris semitransparente sobre toda la room
if (tp_active) {
    draw_set_color(c_black);
    draw_set_alpha(tp_filter_alpha); // p. ej. 0.5 = 50% gris
    // Dibuja un rect que cubra toda la pantalla (en room-space):
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

// 2) Después, dibujás tu jugador normalmente. Por ejemplo:
draw_self();

// 3) Opcional: si tenés un HUD o UI, asegurate de dibujarlo después de pintar el fondo gris
//    para que no quede cubierto.
/// DRAW EVENT de oPlayer

// 1) Primero dibujás el sprite (o tu código normal de drawing)
draw_self();

// 2) Calculamos el porcentaje de vida (entre 0 y 1):
var procent = clamp(vida / max_vida, 0, 1);

// 3) Definimos el tamaño (en px) de la barra:
var bar_w = 40;   // ancho total de la barra cuando está al 100%
var bar_h = 6;    // grosor de la barra

// 4) Calculamos la posición “sobre la cabeza” del player:
//    - x1 es la esquina izquierda de la barra.
//    - y1 es un poco arriba de la mitad vertical del sprite.
var sprite_h = sprite_get_height(sprite_index);
var x1 = x - bar_w/2;
var y1 = y - (sprite_h/2) - 10; 
//         ↑ mitad del sprite hacia arriba  ↑ y le sumamos 10px para dejar hueco

// 5) Dibujamos el marco (borde negro) un px más grande que la barra:
draw_set_color(c_green);
draw_rectangle(x1 - 1, y1 - 1, x1 + bar_w + 1, y1 + bar_h + 1, false);

// 6) Dibujamos el interior verde, solo hasta el ancho proporcional:
draw_set_color(c_white); 
draw_rectangle(x1, y1, x1 + (bar_w * procent), y1 + bar_h, true);
draw_text(x+50,y,limite)
draw_text(x-80,y,xspd)
// 7) Volvemos el color a blanco por si hay más draw después:
draw_set_color(c_white);
var color_final = merge_color(c_white, c_red, tinte_rojo);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, color_final, image_alpha);
