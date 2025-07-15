/// SCRIPT global o dentro de oPlayer (llámalo searchFree2)
/// searchFree2(x0, y0) → [xLibre, yLibre]
/// Busca un lugar cercano donde el oPlayer (su máscara) no choque nada.
show_debug_message("auoihuofjfaio")
function searchFree2(x0, y0) {
    // --- Parámetros de búsqueda ---
    var maxRadius   = 200;                // cuántos píxeles máximo polichar (ajustalo)
    var stepSize    = 8;                  // en cuántos píxeles se desplaza cada iteración
    var maskW       = sprite_get_width(sprite_index);
    var maskH       = sprite_get_height(sprite_index);

    // --- Si en x0,y0 no hay colisión, devolvemos enseguida ---
    if (!collision_rectangle(
            x0 - maskW/2, y0 - maskH/2,
            x0 + maskW/2, y0 + maskH/2,
            oWall, true, true))
    {
        return [x0, y0];
    }

    // --- Búsqueda en “rejilla” alrededor, en radios crecientes ---
    // Hacemos anillos de radio “r” que avanzan de “stepSize”
    for (var r = stepSize; r <= maxRadius; r += stepSize) {
        // Recorremos ángulos 0, 45, 90, … 315 (cada 45°)
        // y calculamos la posición candidata:
        for (var ang = 0; ang < 360; ang += 45) {
            var xr = x0 + lengthdir_x(r, ang);
            var yr = y0 + lengthdir_y(r, ang);

            // Chequeamos límites de la room (0..room_width, 0..room_height)
            if (xr < 0 || xr > room_width || yr < 0 || yr > room_height) {
                continue;
            }

            // Chequeo de colisión con un rect del tamaño de la máscara del jugador:
            if (!collision_rectangle(
                    xr - maskW/2, yr - maskH/2,
                    xr + maskW/2, yr + maskH/2,
                    oWall, true, true))
            {
                return [xr, yr];
            }
        }
    }

    // --- Si no encontró nada, devolvemos la posición original sin mover ---
    return [x0, y0];
}
