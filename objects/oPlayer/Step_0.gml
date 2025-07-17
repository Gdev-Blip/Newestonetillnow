/// @description Logic

// === INPUT ===
var izq = keyboard_check(ord("A"));
var der = keyboard_check(ord("D"));
var saltar = keyboard_check_pressed(vk_space);

if (keyboard_check_pressed(ord("D"))) dir_intencion = 1;
if (keyboard_check_pressed(ord("A"))) dir_intencion = -1;

// === VARIABLES AUXILIARES ===
if (!variable_instance_exists(self, "en_wall_slide")) en_wall_slide = false;
if (!variable_instance_exists(self, "wall_slide_timer")) wall_slide_timer = 0;
if (!variable_instance_exists(self, "saltando_de_pared")) saltando_de_pared = 0;

// === DETECCIÓN DE COLISIONES ===
var en_suelo = place_meeting(x, y + 1, oWall) || place_meeting(x, y + 1, oWallDestroyable);
var tocando_izquierda = place_meeting(x - 1, y - 1, oWall) || place_meeting(x - 1, y, oWall) || place_meeting(x - 1, y + 1, oWall) ||
                        place_meeting(x - 1, y - 1, oWallDestroyable) || place_meeting(x - 1, y, oWallDestroyable) || place_meeting(x - 1, y + 1, oWallDestroyable);
var tocando_derecha  = place_meeting(x + 1, y - 1, oWall) || place_meeting(x + 1, y, oWall) || place_meeting(x + 1, y + 1, oWall) ||
                        place_meeting(x + 1, y - 1, oWallDestroyable) || place_meeting(x + 1, y, oWallDestroyable) || place_meeting(x + 1, y + 1, oWallDestroyable);
var tocando_pared = (tocando_izquierda || tocando_derecha);

// === SISTEMA WALL SLIDE ROBUSTO ===
if (saltando_de_pared > 0) {
    saltando_de_pared--;
    en_wall_slide = false;
} else if (!en_suelo && tocando_pared && VY > 0 && (izq || der)) {
    wall_slide_timer = 10;
    en_wall_slide = true;
} else if (wall_slide_timer > 0) {
    wall_slide_timer--;
    en_wall_slide = true;
} else {
    en_wall_slide = false;
}

// === SALTO ===
if (saltar && jumps > 0) {
    VY = -Salto;
    jumps -= 1;
}


if (en_suelo or tocando_derecha or tocando_izquierda) {
    jumps = max_jumps;
}


// === GRAVEDAD ===
if (!en_suelo) {
    if (en_wall_slide) {
        if (VY < limiteG) VY += FuerzaG * 0.2;
    } else {
        if (VY < limiteG) VY += FuerzaG;
    }
}

// === MOVIMIENTO HORIZONTAL ===

// Corrección: si presiona A y D al mismo tiempo, se ignoran ambos para evitar atrapamiento
if (izq && der) {
    izq = false;
    der = false;
}
if (izq && VX > -limiteV) VX -= velocidad;
if (der && VX < limiteV) VX += velocidad;

if (VX != 0) {
    var Adelante = sign(VX);
    if (Adelante == 0 && dir_intencion != 0) Adelante = dir_intencion;
    if (Adelante == 0) { VX = 0; exit; }

    var x_inicial = x;

    repeat(abs(VX)) {
        if (place_free(x + Adelante, y)) {
            for (var i = 1; i <= LimiteA + 1; i++) {
                if (place_free(x, y + 1)) break;
                if (!place_free(x + Adelante, y + i)) {
                    y += i - 1;
                    break;
                }
            }
            x += Adelante;
        } else {
            var pudo_escalar = false;
            for (var i = 0; i <= LimiteA; i++) {
                if (place_free(x, y + 1)) {
                    VX = 0;
                    break;
                }
                if (place_free(x + Adelante, y - i)) {
                    x += Adelante;
                    y -= i;
                    pudo_escalar = true;
                    break;
                }
            }
            if (!pudo_escalar) {
                if (place_free(x, y + 1)) y += 1;
                VX = 0;
            }
        }
    }

    if (x == x_inicial) {
        var intento_liberado = false;
        if (place_free(x, y + 1)) {
            y += 1;
            intento_liberado = true;
        }
        if (!intento_liberado) {
            if (place_free(x - Adelante * 2, y)) {
                x -= Adelante * 2;
                intento_liberado = true;
            }
        }
        if (!intento_liberado) {
            if (place_free(x - Adelante * 2, y - 1)) {
                x -= Adelante * 2;
                y -= 1;
                intento_liberado = true;
            }
        }
        if (!intento_liberado) {
            show_debug_message("🚨 HARD ESCAPE ACTIVADO");
            if (place_free(x - 4, y)) x -= 4;
            else if (place_free(x + 4, y)) x += 4;
            else if (place_free(x, y - 4)) y -= 4;
            else if (place_free(x, y + 4)) y += 4;
            else show_debug_message("❌ Sin salida.");
            VX = 0;
        }
    }

    if (!der && !izq) {
        VX += (-Adelante) * FuerzaI;
    }
}

// === MOVIMIENTO VERTICAL ===
if (VY != 0) {
    repeat(abs(VY)) {
        if (place_free(x, y + sign(VY))) {
            y += sign(VY);
        } else {
            VY = 0;
        }
    }
}

// === FLIP DE SPRITE ===
if (der) image_xscale = 1;
if (izq) image_xscale = -1;

// === RESTO DEL CÓDIGO ===
// TP, Dash, Daño, Cámara... se mantienen tal como estaban
// (no fueron modificados en esta versión del Step)

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
    sprite_index = spr_idle;
}
if (!esta_atacando && !dash_en_proceso) {
    if (der) image_xscale = 1;
    if (izq) image_xscale = -1;
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
