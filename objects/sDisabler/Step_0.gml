if place_meeting(x,y,oPlayer) {
   with(oPlayer) {
	  accel_max        = 3;
            salto_fuerza  = -11;
            accel   = 0.4;
            puede_dashear = false;
            puede_tp      = false;
			
	if accel_max > 3 {
	accel_max = 3;	
	}
	if hsp > 3 {
		hsp = 3
	}
   }   
   } else {
	   with(oPlayer) {
		  
	  accel_max = max_hspeed;
            salto_fuerza =  originfuerzasalto
            accel   = originaccel
			puede_tp = true

   } }
       




     