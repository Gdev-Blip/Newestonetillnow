/// @description Logic

// === INPUT ===
var izq = keyboard_check(ord("A"));
var der = keyboard_check(ord("D"));
var saltar = keyboard_check_pressed(vk_space);

if (keyboard_check_pressed(ord("D"))) dir_intencion = 1;
if (keyboard_check_pressed(ord("A"))) dir_intencion = -1;

// --- Step Event ---
/// 1) Leer input de movimiento y salto

direction_input = der - izq;

// Buffer de salto (teclas W, flecha arriba o espacio)
if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_space)) {
    jump_buffer = jump_grace;
} else if (jump_buffer > 0) {
    jump_buffer -= 1;
}


/// 2) Gestionar coyote time y reset de saltos al tocar suelo
var on_ground = place_meeting(x, y + 1, oWall);
if (on_ground) {
    coyote_timer = coyote_time;
    jumps_done = 0;
} else if (coyote_timer > 0) {
    coyote_timer -= 1;
}


/// 3) Movimiento horizontal con inercia y fricción en suelo
if (direction_input != 0) {
    var accel = on_ground ? move_accel : air_accel;
    hsp += accel * direction_input;
} else if (on_ground) {
    if (abs(hsp) < friction) hsp = 0;
    else hsp -= friction * sign(hsp);
}
hsp = clamp(hsp, -max_hspeed, max_hspeed);


/// 4) Aplicar gravedad y limitar caída
vsp += gravity


/// 5) Saltar y doble salto con coyote time y buffer
if (jump_buffer > 0 && (coyote_timer > 0 || jumps_done < max_jumps)) {
    if (jumps_done == 0) vsp = jump_speed;
    else vsp = double_jump_speed;
    jump_buffer = 0;
    jumps_done += 1;
    coyote_timer = 0;
}

/// 6) Detectar entrada/salida de wall slide con empuje de salida
// Salir de wall slide si tocando suelo, no hay pared adyacente en dir actual, o no presionando hacia la pared
if (on_wall_slide) {
    var exit_wall = (on_ground || !place_meeting(x + wall_slide_dir, y, oWall) || direction_input != wall_slide_dir && direction_input != 0);
    if (exit_wall) {
        // Empujar ligeramente en dirección de input para liberar posición
        hsp = direction_input * (max_hspeed * 0.5);
        on_wall_slide = false;
        wall_slide_dir = 0;
    }
}
// Entrar en wall slide si en aire, pared adyacente y presionando hacia la pared
if (!on_ground && direction_input != 0 && place_meeting(x + direction_input, y, oWall)) {
    on_wall_slide = true;
    wall_slide_dir = direction_input;
}
// Si en wall slide, forzar caída controlada y anular inercia horizontal
if (on_wall_slide) {
    vsp = wall_slide_speed;
    hsp = 0;
}

/// 7) Resolver colisiones y slopes
function MoveHorizontal() {
    if (hsp == 0) return;
    var step = sign(hsp);
    for (var i = 0; i < abs(hsp); i++) {
        if (!place_meeting(x + step, y, oWall)) {
            x += step;
        } else {
            var climbed = false;
            for (var j = 1; j <= slope_climb; j++) {
                if (!place_meeting(x + step, y - j, oWall)) {
                    x += step;
                    y -= j;
                    climbed = true;
                    break;
                }
            }
            if (!climbed) {
                hsp = 0;
                break;
            }
        }
    }
}
/// 8) Animación y escala del sprite según movimiento
if (vsp < 0) sprite_index = sRunG;
//else if (vsp > 0) sprite_index = sFallG;
else if (abs(hsp) > 0.2) sprite_index = sRunG;
else sprite_index = sIdleG;

function MoveVertical() {
    if (vsp == 0) return;
    var step = sign(vsp);
    for (var i = 0; i < abs(vsp); i++) {
        if (!place_meeting(x, y + step, oWall)) {
            y += step;
        } else {
            if (vsp > 0) jumps_done = 0;
            vsp = 0;
            break;
        }
    }
}

MoveHorizontal();
MoveVertical();



if (keyboard_check_pressed(ord("R")) && !tp_active && tp_cooldown <= 0 && puede_tp) {
    tp_active  = true;
    tp_timer   = tp_duration;
}

if (tp_active) {
    var mx = mouse_x;
    var my = mouse_y;

    image_angle  = point_direction(x, y, mx, my);
    tp_target_x  = mx;
    tp_target_y  = my;

    if (mouse_check_button_pressed(mb_left) && !global.mouse_clicked_gui) {
        var nf = searchFree2(tp_target_x, tp_target_y);
        x = nf[0];
        y = nf[1];
        tp_active   = false;
        image_angle = 0;
        tp_cooldown = tp_cooldown_max;
        exit;
    }

    tp_timer--;
    if (tp_timer <= 0) {
        var nf = searchFree2(tp_target_x, tp_target_y);
        x = nf[0];
        y = nf[1];
        tp_active   = false;
        image_angle = 0;
        tp_cooldown = tp_cooldown_max;
        exit;
    }
    exit;
}
if (tp_cooldown > 0) tp_cooldown--;

// === DASH ===
if (puede_dashear && !dash_en_proceso && keyboard_check_pressed(ord("Q"))) {
    dash_en_proceso = true;
    puede_dashear   = false;
    dash_timer      = dash_duracion;
}
if (dash_en_proceso) {
    var ddir = image_xscale;
    sprite_index = spr_dash;
    image_speed  = 1.4;
    if (!dash_sfx_played) {
        dash_sfx_played = true;
        audio_play_sound(dash, 1, false);
    }
    if (place_free(x + dash_vel * ddir, y)) {
        x += dash_vel * ddir;
    }
    dash_timer--;
    if (dash_timer <= 0) {
        dash_en_proceso = false;
        dash_cooldown   = dash_cooldown_max;
        dash_sfx_played = false;
    }
}
if (!puede_dashear && !dash_en_proceso) {
    dash_cooldown--;
    if (dash_cooldown <= 0) puede_dashear = true;
}

// === SISTEMA DE DAÑO CON TINTE ROJO ===
if (dano_cooldown <= 0) {
    if (place_meeting(x, y, oEnemy)) and invulnera = false{
        invulnera = true;
        VX -= 17 * image_xscale;
        alarm[0] = 50;
        vida -= dano_recibido;
        xspd += 8 * -image_xscale;
        yspd  = -10;
        tinte_rojo = 1;
        dano_cooldown = room_speed * 0.4;
        shake_time = 7;
        shake_intensity = 130;
    }
    else if (place_meeting(x, y, oEnemyPhy)) and invulnera = false{
        vida -= (dano_recibido / 4);
        invulnera = true;
        VX -= 17 * image_xscale;
        xspd += 13 * -image_xscale;
        yspd  = -13;
        tinte_rojo = 1;
        dano_cooldown = room_speed * 0.4;
        shake_time = 7;
        shake_intensity = 10;
    }
}
if (dano_cooldown > 0) dano_cooldown--;
if (tinte_rojo > 0) {
    tinte_rojo -= 0.05;
    if (tinte_rojo < 0) tinte_rojo = 0;
}

// === CÁMARA SHAKE ===
if (shake_time > 0) {
    shake_time--;
    global.shake_offset_x = irandom_range(-shake_intensity, shake_intensity);
    global.shake_offset_y = irandom_range(-shake_intensity, shake_intensity);
} else {
    global.shake_offset_x = 0;
    global.shake_offset_y = 0;
}

// === FLASHEO ===
if (flash_alpha > 0) {
    flash_alpha -= 0.1;
    if (flash_alpha < 0) flash_alpha = 0;
}

// === ATAQUE ===
if (!esta_atacando && VX == 0 && VY == 0 && !dash_en_proceso) {
    sprite_index = sIdleG;
}

if (mouse_check_button_pressed(mb_left) && !global.mouse_clicked_gui && ataque_cooldown <= 0 && !esta_atacando && !dash_en_proceso) {
    alarm[1] = 1;
}
if (mouse_check_button_pressed(mb_right) && super_cooldown <= 0 && !dash_en_proceso) {
    super_cooldown    = room_speed * 5;
    flash_alpha       = 1;
    shake_time        = 18;
    shake_intensity   = 22;
    is_bursting       = true;
    burst_shots_fired = 0;
    burst_timer       = 0;
    sprite_index      = spr_gerruzi;
}
if (is_bursting) {
    if (burst_timer <= 0 && burst_shots_fired < burst_shots) {
        var dir2 = (image_xscale == -1) ? 180 : 0;
        var bb = instance_create_layer(x, y, "Instances", oBullet);
        bb._direccion = dir2;
        bb.image_angle = dir2;
        audio_play_sound(shooting, 1, false);
        xspd -= retroceso_burst * image_xscale;
        burst_shots_fired++;
        burst_timer = burst_interval;
    } else if (burst_shots_fired >= burst_shots) {
        is_bursting = false;
    }
    burst_timer--;
}
if (esta_atacando) {
    ataque_anim_timer--;
    if (ataque_anim_timer <= 0) {
        esta_atacando = false;
        image_speed   = 0;
        image_index   = 1;
    }
}
if (ataque_cooldown > 0) ataque_cooldown--;
if (super_cooldown > 0) super_cooldown--;

// === PARALLAX Y CÁMARA ===
function parallax_layer(layer_name, factor) {
    if (layer_exists(layer_name)) {
        layer_x(layer_name, global.cam_x * factor);
        layer_y(layer_name, global.cam_y * factor);
    }
}

if (!variable_global_exists("cam_x")) {
    global.cam_x = x;
    global.cam_y = y;
}
var follow_x = x - (camera_get_view_width(view_camera[0]) / 2) + shake_offset_x;
var follow_y = y - (camera_get_view_height(view_camera[0]) / 2) + shake_offset_y;

// Lerp hacia el objetivo, entre 0 (no se mueve) y 1 (se mueve instantáneo)
global.cam_x = lerp(global.cam_x, follow_x, 0.1);
global.cam_y = lerp(global.cam_y, follow_y, 0.1);

camera_set_view_pos(view_camera[0], global.cam_x, global.cam_y);global.vidaplayer = vida;
