
 var dir = (image_xscale == -1) ? 180 : 0;
    var b = instance_create_layer(x, y, "Instances", oBullet);

 var ida = audio_play_sound(snd_footsteps, 1, false);
        audio_sound_pitch(ida, random_range(1.0, 1.4));
        audio_sound_gain(ida, random_range(0.5, 0.6), 0);
    b._direccion = dir;
    b.image_angle = dir;

    esta_atacando     = true;
    ataque_anim_timer = round(room_speed * ataque_duracion);
    ataque_cooldown   = room_speed * 0.15;

    sprite_index = sprite_atk;
    image_speed  = atk_frame_speed;
    image_index  = combo;

    if (en_suelo) {
        switch(combo) {
            case 0: xspd -= retroceso_1 * image_xscale; break;
            case 1: xspd -= retroceso_2 * image_xscale; break;
            case 2: xspd -= retroceso_3 * image_xscale; break;
            case 3: xspd -= retroceso_4 * image_xscale; break;
        }
    }



    shake_time      = 4;
    shake_intensity = 6;

    combo += 1;
    if (combo >= combo_max) {
        combo = 0;
        ataque_cooldown += room_speed * 1;
    }

