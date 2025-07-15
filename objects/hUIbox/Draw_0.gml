var final_scale_x = base_scale_x * (1 + hover_effect);
var final_scale_y = base_scale_y * (1 + hover_effect);

draw_sprite_ext(sprite_index, image_index, x, y, final_scale_x, final_scale_y, image_angle, c_white, 1);
