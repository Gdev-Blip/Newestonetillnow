attribute vec3 in_Position; // (x, y, z)
uniform vec2 u_pos;         // posición de la luz
uniform float u_z;          // profundidad Z para orden en pantalla

void main() {
    vec2 pos = in_Position.xy;

    if (in_Position.z > 0.0) {
        vec2 dir = normalize(pos - u_pos);
        pos += dir * 300.0; // distancia máxima de proyección (ajustable)
    }

    vec4 object_space_pos = vec4(pos.x, pos.y, u_z - 0.5, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
