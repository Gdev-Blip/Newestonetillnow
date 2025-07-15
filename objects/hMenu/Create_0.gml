paused = false;
layer_name = "menu"
update_pause = function() {
if	paused {
	instance_deactivate_all(true)	
	layer_set_visible(layer_name, true)
} else {
		instance_activate_all()	
	layer_set_visible(layer_name, false)
}
	
}

update_pause()