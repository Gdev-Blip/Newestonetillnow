// ===================
// CREATE EVENT (oPlayer)
// ===================
life = 120;
max_life = life;
/// @desc Inicialización del jugador con física, inercia, ataque, TP, wall slide, slopes y más

// === DIRECCIÓN DE INTENCIÓN ===
dir_intencion = 0; // -1 (izq), 1 (der), 0 (neutral)

// === SISTEMA DE FÍSICA Y MOVIMIENTO GENERAL ===
speed_factor        = 1;    // velocidad base del juego (ajustable)
hsp                 = 0;    // velocidad horizontal
vsp                 = 0;    // velocidad vertical

gravity             = 0.7  * speed_factor;
max_fall_speed      = 12   * speed_factor;

move_accel          = 0.5  * speed_factor;
air_accel           = move_accel;
friction            = 0.4  * speed_factor;
max_hspeed          = 5    * speed_factor;

jump_speed          = -12 * speed_factor;
double_jump_speed   = -12  * speed_factor;
coyote_time         = 6;
jump_grace          = 6;
max_jumps           = 3;

jumps_done          = 0;
coyote_timer        = 0;
jump_buffer         = 0;

on_wall_slide       = false;
wall_slide_speed    = 2    * speed_factor;
wall_slide_dir      = 0;

direction_input     = 0;
image_xscale        = 1;
previous_direction  = image_xscale;

en_suelo = place_meeting(x,y,oWall);

// === AJUSTES PARA SLOPES ===
slope_climb         = 8;      // altura máxima para escalar
LimiteA             = 2;      // límite de escalada pendiente (redundante pero usado por otros scripts)

// === SPRITE ALTURA (para correcciones de colisión) ===
sprite_h_original   = sprite_get_height(sprite_index);

// === ATAQUE Y COMBOS ===
combo              = 0;
combo_max          = 8;
ataque_cooldown    = 1.25;
ataque_anim_timer  = 1.6;
esta_atacando      = false;

atk_frame_speed    = 0.15;
ataque_duracion    = 0.15;
sprite_atk         = spr_ataque_completo;
ataque_frame_count = sprite_get_number(sprite_atk);

// === RETROCESO DE ATAQUES ===
retroceso_1        = 1;
retroceso_2        = 3;
retroceso_3        = 5;
retroceso_4        = 8;

// === DASH ===
puede_dashear      = true;
orig_puede_dashear = true;

dash_en_proceso    = false;
dash_timer         = 0;
dash_duracion      = room_speed * 0.33;
dash_cooldown      = 0;
dash_cooldown_max  = room_speed * 1;
dash_vel           = 15;
dash_sfx_played    = false;

orig_dash_timer      = dash_timer;
orig_dash_cooldown   = dash_cooldown_max;

// === SUPER ATAQUE / CLICK DERECHO / RÁFAGA ===
super_cooldown     = 0;

is_bursting        = false;
burst_shots        = 5;
burst_shots_fired  = 0;
burst_interval     = round(room_speed * 0.1);
burst_timer        = 0;
retroceso_burst    = 10;

// === MINI TELEPORT ===
puede_tp          = true;
saved_puede_tp    = puede_tp;
tp_active         = false;
tp_timer          = 0;
tp_duration       = room_speed * 2;
tp_target_x       = x;
tp_target_y       = y;
tp_filter_alpha   = 0.5;
tp_cooldown       = 0;
tp_cooldown_max   = room_speed * 10;

// === SALTO Y FÍSICA GUARDADAS ===
salto_fuerza       = jump_speed;
saved_salto_fuerza = salto_fuerza;
aceleracion        = move_accel;
saved_aceleracion  = aceleracion;
limite             = max_hspeed;
saved_limite       = limite;

// === EFECTOS VISUALES Y DAÑO ===
shake_time         = 10;
shake_intensity    = 2;
shake_offset_x     = 5;
shake_offset_y     = 5;
flash_alpha        = 0;

invul_timer        = 0;
dano_cooldown      = 0;
tinte_rojo         = 0;
dano_recibido      = 10;
invulnera          = false;
global.invulnera   = invulnera;

// === FOOTSTEPS / PASOS ===
footstep_timer     = room_speed * 0.5;
footstep_count     = 0;

// === SONIDOS ===
snd_ataque         = shooting;
snd_salto          = jump;
snd_footsteps      = footsteps;
snd_doble_salto    = jump;

// === CÁMARA ===
global.cam_x         = x;
global.cam_y         = y;
global.cam_target_x  = x;
global.cam_target_y  = y;
