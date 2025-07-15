var ang = round(image_angle) mod 360;

switch (ang) {
    case 0:
    case 90:
    case 180:
    case 270:
    case 360:
        mask_index = sWallRect;
        break;

    default:
        mask_index = sWallPrecise;
        break;
}
alarm[0] = 20; // arranca pronto
