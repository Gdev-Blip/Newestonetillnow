// === obj_setup: Script global “DrawWallEdge” ===

/// @function DrawWallEdge(_vb, _x1, _y1, _x2, _y2)
/// Dibuja un segmento como un quad (2 triángulos) para el shader de sombras
function DrawWallEdge(_vb, _x1, _y1, _x2, _y2) {
    // Triángulo 1
    vertex_position_3d(_vb, _x1, _y1, 0);
    vertex_position_3d(_vb, _x1, _y1, 1);
    vertex_position_3d(_vb, _x2, _y2, 0);
    // Triángulo 2
    vertex_position_3d(_vb, _x1, _y1, 1);
    vertex_position_3d(_vb, _x2, _y2, 0);
    vertex_position_3d(_vb, _x2, _y2, 1);
}
