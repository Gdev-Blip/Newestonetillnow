/// SCRIPT o FUNCIÓN dentro de oPlayer: searchFree(x0, y0)
// Retorna [xLibre, yLibre] buscando en un radio alrededor de (x0, y0)

function searchFree(x0, y0) {
    // 1) Si el punto original ya es libre, devolvemos ese mismo
    if (place_free(x0, y0)) {
        return [x0, y0];
    }

    var maxRadius = 100; // Máximo desplazamiento en píxeles para buscar posición libre
    // 2) Escaneo “en capas” (radio 1, 2, 3, … hasta maxRadius)
    for (var r = 1; r <= maxRadius; r++) {
        // a) Barrido vertical hacia arriba y abajo (manteniendo x0 fijo)
        var yUp   = y0 - r;
        var yDown = y0 + r;

        //   a.1) Subida
        if (yUp >= 0 && place_free(x0, yUp)) {
            return [x0, yUp];
        }
        //   a.2) Bajada
        if (yDown <= room_height && place_free(x0, yDown)) {
            return [x0, yDown];
        }

        // b) Barrido horizontal (manteniendo y0 fijo)
        var xLeft  = x0 - r;
        var xRight = x0 + r;

        //   b.1) Izquierda
        if (xLeft >= 0 && place_free(xLeft, y0)) {
            return [xLeft, y0];
        }
        //   b.2) Derecha
        if (xRight <= room_width && place_free(xRight, y0)) {
            return [xRight, y0];
        }

        // c) Y por último, las combinaciones diagonales de la “capa” r:
        //    (x0 ± k, y0 ± (r - k)) para k = 1..r-1
        for (var k = 1; k < r; k++) {
            var x1 = x0 - k;
            var y1 = y0 - (r - k);
            if (x1 >= 0 && y1 >= 0 && place_free(x1, y1)) {
                return [x1, y1];
            }
            var x2 = x0 + k;
            var y2 = y0 - (r - k);
            if (x2 <= room_width && y2 >= 0 && place_free(x2, y2)) {
                return [x2, y2];
            }
            var x3 = x0 - k;
            var y3 = y0 + (r - k);
            if (x3 >= 0 && y3 <= room_height && place_free(x3, y3)) {
                return [x3, y3];
            }
            var x4 = x0 + k;
            var y4 = y0 + (r - k);
            if (x4 <= room_width && y4 <= room_height && place_free(x4, y4)) {
                return [x4, y4];
            }
        }
    }

    // 3) Si no encontró nada dentro del radio, devolvemos la misma original
    return [x0, y0];
}
