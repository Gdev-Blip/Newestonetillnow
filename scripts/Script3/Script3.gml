// structs.gml

Vec2 = function(_x, _y) constructor {
    x = _x;
    y = _y;
};

Line = function(_a, _b) constructor {
    a = _a;
    b = _b;

    Hit = function() {
        var closest_Wall = undefined;
        var closest_t = -1;
        var closest_u = -1;

        for (var i = 0; i < ds_list_size(global.Walls); i++) {
            var Wall = global.Walls[| i];

            var Wall_dx = Wall.b.x - Wall.a.x;
            var Wall_dy = Wall.b.y - Wall.a.y;
            var ray_dx = b.x - a.x;
            var ray_dy = b.y - a.y;

            var den = Wall_dx * ray_dy - Wall_dy * ray_dx;
            if (den == 0) return b;

            var t = ((a.x - Wall.a.x) * ray_dy - (a.y - Wall.a.y) * ray_dx) / den;
            var u = -((Wall_dx) * (a.y - Wall.a.y) - (Wall_dy) * (a.x - Wall.a.x)) / den;

            if (t >= 0 && t <= 1 && u >= 0) {
                if (closest_u == -1 || u < closest_u) {
                    closest_u = u;
                    closest_t = t;
                    closest_Wall = Wall;
                }
            }
        }

        if (closest_Wall != undefined) {
            return new Vec2(
                closest_Wall.a.x + closest_t * (closest_Wall.b.x - closest_Wall.a.x),
                closest_Wall.a.y + closest_t * (closest_Wall.b.y - closest_Wall.a.y)
            );
        }
        return b;
    };
};
