if place_meeting(x,y,oPlayer) {
   with(oPlayer) {
	  max_hspeed      = 3;
            jump_speed = -11;
            move_accel   = 0.4;
            puede_dashear = false;
            puede_tp      = false;
			
	if max_hspeed > 3 {
	max_hspeed = 3;	
	}
	if hsp > 3 {
		hsp = 3
	}
   }   
   } else {
	   with(oPlayer) {
		  
	  originmaxaccel = max_hspeed;
            originfuerzasalto =  jump_speed
            originaccel   = accel
			puede_tp = true

   } }
       




     