var esta_hover = point_in_rectangle(mouse_x, mouse_y, x - sprite_width / 2, y - sprite_height / 2, x + sprite_width / 2, y + sprite_height / 2);
hovered = esta_hover;

// Hover effect: 0 = sin hover, 0.1 = +10% de escala
var target_hover = hovered ? 0.1 : 0;
hover_effect = lerp(hover_effect, target_hover, 0.2);
