if (!ya_cambie && place_meeting(x, y, oPlayer) && !instance_exists(cFade)) {
    ya_cambie = true;
    with (oPlayer) {
        hsp = 0;
        vspeed = 0;
    }
    var _targetRoom = room_next(room);
    fadetoroom(_targetRoom, 60, c_black);
}
