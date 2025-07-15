/// STEP EVENT de obj_oBullet
// Movimiento real
var vel = 25;
x += lengthdir_x(vel, _direccion);
y += lengthdir_y(vel, _direccion);

// Colisión con enemigo

// Para propósitos de debug (opcional), muestra la dirección
draw_text(x, y - 20, "DIR: " + string(_direccion));

image_angle = 90;