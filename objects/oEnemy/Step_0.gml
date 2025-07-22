/// STEP EVENT de obj_daño
if global.invulnera != true {
// --- COLISIÓN CON PLAYER ---
if (place_meeting(x, y, oPlayer)) {
	global.invulnera = true;
	// En cualquier evento (por ejemplo, Create o Step)
alarm[0] = 20; // 60 steps = 1 segundo si estás a 60 FPS

    var p = instance_place(x, y, oPlayer);


        // Si esta instancia tiene una variable "daño_personalizado", la usamos
        var dmg = 0;
        if (variable_instance_exists(id, "daño_personalizado")) {
            dmg = danio_personalizado;
        } else if (variable_global_exists("dano_recibido")) {
            dmg = global.dano_recibido;
        } else {
            dmg = 1; // fallback
        }
// Knockback mejorado: empuja al player opuesto al image_xscale del obj_daño
var knockback_strength_x = 9;
var knockback_strength_y = -6;

p.hsp += -oPlayer.image_xscale * knockback_strength_x;
p.yspd = knockback_strength_y;

        p.life -= dmg;
        p.invul_timer = room_speed * 0.3; // frames de invul



        // Cámara temblor
        p.shake_time = 6;
        p.shake_intensity = 6;



    }

}
