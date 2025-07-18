dir_intencion = 0; // Dirección intencionada: -1 (izq), 1 (der), 0 (neutral)
// ===================
// CREATE EVENT (oPlayer)
// ===================
// --- FÍSICA & MOVIMIENTO ---
accel = 0.5
accel_final = 0
accel_max = 50
xspd               = 0;
yspd               = 0;
limite             = 9;
aceleracion        = 1;
originaccel = aceleracion;
frenado            = 0.4;
originlimite = limite;
gravedad           = 2
salto_fuerza       = -14;
anti_trap_cd = 4;

puede_doble_salto  = true;
originfuerzasalto = salto_fuerza;
vida               = 120;
max_vida = vida;
global.cam_x = x;
global.cam_y = y;
global.cam_target_x = x;
global.cam_target_y = y;
saltoEnWall = 25;
// --- COMBO & ATAQUE ---
combo              = 0;
combo_max          = 8;
ataque_cooldown    = 1.25;
ataque_anim_timer  = 1.6;
esta_atacando      = false;


sprite_atk         = spr_ataque_completo;


// --- RETROCESO DE ATAQUE ---
retroceso_1        = 1;
retroceso_2        = 3;
retroceso_3        = 5;
retroceso_4        = 8;

// --- DASH ---
puede_dashear      = true;

dash_en_proceso    = false;
dash_timer         = 0;
dash_cooldown      = 0;
dash_vel           = 15;
dash_duracion      = room_speed * 0.33;  // 0.25 segundos de dash
dash_cooldown_max  = room_speed * 1;
dash_sfx_played    = false; // inicializamos la flag para el audio
orig_puede_dashear   = puede_dashear;
orig_dash_cooldown   = dash_cooldown_max;
orig_dash_timer      = dash_timer;

// --- FOOTSTEPS ---
footstep_timer     = 0;

// --- SONIDOS ---
snd_ataque         = shooting;
snd_salto          = jump;
snd_footsteps      = footsteps;
snd_doble_salto    = jump;

// --- ECO (activar en Room Start) ---
echo_enabled       = false;

// --- SHAKE & FLASH ---
shake_time         = 10;
shake_intensity    = 2;
shake_offset_x     = 5;
shake_offset_y     = 5;
flash_alpha        = 0;

// --- SUPER ATAQUE (click derecho) ---
super_cooldown     = 0;

// --- INVULNERABILIDAD & DAÑO ---
invul_timer        = 0;
dano_recibido      = 10;
invulnera = false;
// --- CONTROL DE FRAME-ATTACK ---
atk_frame_speed    = 0.15;                // sub-imágenes por step
ataque_duracion    = 0.15;                // duración total del ataque en segundos
ataque_frame_count = sprite_get_number(sprite_atk);

// --- MANTENER CÓDIGO ORIGINAL PARA CREAR BALAS CON TECLA J (izq) ---
// (no hace falta declarar nada extra aquí)

// === BLOQUE NUEVO: VARIABLES DE RÁFAGA CLICK DERECHO ===
is_bursting        = false;                       // flag para saber si estamos disparando ráfaga
burst_shots        = 5;                           // cuántas balas suelta la ráfaga
burst_shots_fired  = 0;                           // contador interno
burst_interval     = round(room_speed * 0.1);      // intervalo (en steps) entre cada bala
burst_timer        = 0;                           // timer para controlar cuándo disparar la próxima
retroceso_burst    = 10;                          // magnitud del retroceso de la ráfaga

// --- VARIABLES DE TP (Mini Teleport) ---
puede_tp = true;
tp_active       = false;                 // ¿Estás en “modo aim”? (false = no)
tp_timer        = 0;                     // Contador interno de 2 s mientras apuntas
tp_duration     = room_speed * 2;        // 2 s = 2 * room_speed (steps)
tp_target_x     = x;                     // Destino X (inicial = tu posición)
tp_target_y     = y;                     // Destino Y (inicial = tu posición)
tp_filter_alpha = 0.5;                   // Opacidad del filtro gris

// --- COOLDOWN DE TP ---
tp_cooldown      = 0;                    // Contador que irá bajando
tp_cooldown_max  = room_speed * 10;      // 10 s = 10 * room_speed (steps)
saved_limite = limite;
saved_salto_fuerza  = salto_fuerza;
saved_aceleracion   = aceleracion;
saved_puede_dashear = puede_dashear;
saved_puede_tp      = puede_tp;
tinte_rojo = 0; // 0 = sin tinte, 1 = completamente rojo
dano_cooldown = 0;
dano_recibido = 10; // o lo que uses vos
tinte_rojo = 0;

// Variables del shake por pasos
footstep_count = 0;
footstep_timer = room_speed * 0.5; // o el valor que quieras usar como intervalo
global.invulnera = invulnera
en_suelo = place_meeting(x,y,oWall);
dano_cooldown = 0;
tinte_rojo = 0;
/// @description Variables

//Movimiento
VX = 0

velocidad = 1
limiteV = 6
FuerzaI = 1

//Gravedad

VY = 0
FuerzaGWall = 0.3
FuerzaG = 1
limiteG = 16
Salto = 12

//Slope

LimiteA = 2 //Limite de altura para subir escalera
/// @desc Lists, structs and functions
/// oPlayer: Movimiento con inercia, slopes, wall slide y doble salto mejorado

/// oPlayer: Movimiento con inercia, slopes, wall slide y doble salto mejorado
// --- Create Event de oPlayer
// Guardamos alto del sprite para no recalcular cada frame
sprite_h_original = sprite_get_height(sprite_index);
// --- Create Event ---
/// Inicialización de variables de movimiento
hsp = 0;                     // velocidad horizontal actual
vsp = 0;                     // velocidad vertical actual

// Configuración de físicas
gravity         = 0.685;       // aceleración de la gravedad

move_accel      = 0.75;       // aceleración al andar
air_accel       = 0.1;       // aceleración en el aire
friction        = 0.85;       // fricción al soltar tecla en suelo (mayor para mejor detención)
max_hspeed      = 4.5;         // velocidad horizontal máxima

// Salto y doble salto
jump_speed         = -9.5;    // velocidad inicial de salto principal
double_jump_speed  = -10;    // velocidad de salto secundario (doble salto)
coyote_time        = 10;      // cuadros de coyote para saltar tras salir de suelo
jump_grace         = 6;      // cuadros de gracia para buffer de salto
max_jumps          = 2;      // número total de saltos disponibles

// Estados internos
direction_input = 0;         // -1=izquierda, 1=derecha, 0=sin input
coyote_timer     = 0;         // contador de coyote
jump_buffer      = 0;         // buffer de input de salto
jumps_done       = 0;         // saltos realizados en aire
on_wall_slide    = false;     // flag de wall slide
wall_slide_dir   = 0;         // dirección de pared actual (1=derecha, -1=izquierda)
wall_slide_speed = 2;         // velocidad de deslizado en pared

// Slope handling
slope_climb      = 8;         // altura máxima para escalar pendiente (píxeles)
