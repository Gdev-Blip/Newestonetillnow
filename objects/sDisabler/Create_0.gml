
// 2) Variables para “guardar” el estado del jugador
saved_limite        = 0;
saved_salto_fuerza  = 0;
saved_aceleracion   = 0;
saved_puede_dashear = false;
saved_puede_tp      = false;

// 3) Referencias y sprites
player_ref      = instance_find(oPlayer, 0);
portrait_sprite = spr_imagegerr;
portrait_w      = sprite_get_width(portrait_sprite);
portrait_h      = sprite_get_height(portrait_sprite);
portrait_x      = 50;
portrait_y      = 50;
box_x           = portrait_x;
box_y           = portrait_y + portrait_h + 10;
box_w           = 600;
box_h           = 150;
text_margin_x   = 16;
text_margin_y   = 16;
font_dialog     = font_futurista;
