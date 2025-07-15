// easy_state()

/// @desc Used to create or define states || It has (Start, BeginStep, Step, EndStep, End) Events to control the created states
/// @param {function} [__start]		This event will only works once when state is first summoned
/// @param {function} [__beginstep] This event will work after Start and then will always be summoned before Step event
/// @param {function} [__step]		This event will always be summoned between BeginStep and EndStep
/// @param {function} [__endstep]	This event will be summoned after the Step is done
/// @param {function} [__end]		This event will only be summoned if the current state ends its use
function kState(__start = undefined, __beginstep = undefined, __step = undefined, __endstep = undefined, __end = undefined) constructor {
	Start		= __start;
	BeginStep	= __beginstep;
	Step		= __step;
	EndStep		= __endstep;
	End			= __end;
}

/// @desc The Machine every event and every system can and are controlled by this construct
/// @param {bool} [_open_debug_panel] Allow to see local debug inside the output window
function kStateMachine(_open_debug_panel = false) constructor {
	enum kTransition {_kNo_sprite, _kInstant, _kFinished, _kAsync};

	__LocalDebug = _open_debug_panel; // For writing analytics and datas of the states and events to output panel

	kBank	  = [];
	kPrevious = undefined;
	kCurrent  = undefined;
	kPaused	  = false;
	kTimer	  = 0;

	kSpriteIndex  = "sprite_index";
	kImageIndex	  = "image_index";
	kImageSpeed   = "image_speed";
	kObjectIndex  = other.object_index;
	kObjectId	  = other.id;
	kCurrentIndex = variable_instance_get(kObjectId, kImageIndex);

	/// @desc This function is local so you should not use this outside of this script 
	/// @returns {real}
	/// @ignore
	GetIndex = function(__StateName) {
		var _return = undefined;
		for (var i = 0; i < array_length(kBank); ++i) {_return = kBank[i][0] == __StateName ? i : _return;}

		return _return;
	}

	/// @desc This event should be redefined by self || This event is the starter setup of the machine its like an alternative Create event || This event will be summoned by the Update event
	/// @returns {undefined}
	static Initialize	  = function() {
		if (__LocalDebug) 
			{show_debug_message("|--| Machine START |" + object_get_name(kObjectIndex) + " |--|");}

		return undefined;
	}

	/// @desc This event should be redefined by self || This event will work before the target event's Start event || This event will be summoned by the Update event
	/// @returns {undefined}
	static BeforeStart = function() {
		return undefined;	
	}

	/// @desc This event should be redefined by self || This event will work before the target event's Begin Step event || This event will be summoned by the Update event
	/// @returns {undefined}
	static BeforeBeginStep = function() {
		return undefined;	
	}

	/// @desc This event should be redefined by self || This event will work before the target event's Step event || This event will be summoned by the Update event
	/// @returns {undefined}
	static BeforeStep = function() {
		return undefined;	
	}

	/// @desc This event should be redefined by self || This event will work before the target event's End Step event || This event will be summoned by the Update event
	/// @returns {undefined}
	static BeforeEndStep = function() {
		return undefined;	
	}

	/// @desc This event should be redefined by self || This event will work before the target event's End event || This event will be summoned by the Update event
	/// @returns {undefined}
	static BeforeEnd   = function() {
		return undefined;	
	}

	/// @desc This event is the heart of the system anything is setuped in here || This event should be placed in a Step or Draw event
	/// @returns {bool}
	static Update		  = function() {
			
		// (Auto) Debug Pause
		if (__LocalDebug && keyboard_check_pressed(vk_pause)) {AutoPause();}

		if (!kPaused && kCurrent != undefined) {
			kTimer += 1/60; // Event Timer

			if (BeforeBeginStep()			 != undefined)	{BeforeBeginStep();}
			if (kBank[kCurrent][1].BeginStep != undefined)	{kBank[kCurrent][1].BeginStep();}
			if (!instance_exists(other.id))					{return false;}

			if (BeforeStep()				 != undefined)	{BeforeStep();}
			if (kBank[kCurrent][1].Step		 != undefined)	{kBank[kCurrent][1].Step();}
			if (!instance_exists(other.id))					{return false;}

			if (BeforeEndStep()				 != undefined)	{BeforeEndStep();}
			if (kBank[kCurrent][1].EndStep	 != undefined)	{kBank[kCurrent][1].EndStep();}
			if (!instance_exists(other.id))					{return false;}

			return true;
		}

		// When machine is (Paused) This event will work
		Pause();

		return false;
	}

	/// @desc DEPRECIATED!!! || This event should be redefined by the user || This event is like a customizable empty event || This event should be placed in a Step or Draw event, below or above of the summoned .Update(); Event
	/// @returns {undefined}
	static Addition		  = function() {
		return undefined;
	}

	/// @desc This event should be redefined by self || This event will work when the State Machine is set to Pause
	/// @returns {undefined}
	static Pause		  = function() {
		return undefined;
	}

	/// @desc  This event is used to add states created by kState() to the kStateMachine() State bank so we can use them
	/// @param	 {string} __StateName State string name that created by kState()
	/// @param	 {struct} __StateToAdd State instance/constructor name that created by kState()
	/// @returns {bool}
	static AddState		  = function(__StateName, __StateToAdd) {
		kBank[array_length(kBank)] = [__StateName, __StateToAdd]; // (0) - (1)

		if (__LocalDebug)
			{show_debug_message("-Added State : " + string(__StateName) + " | " + object_get_name(kObjectIndex) + " | ");}
	}

	/// @desc This event is used to delete states created by kState() from the kStateMachine() State bank so we can erase them
	/// @param	 {string} __StateName State string name that created by kState()
	/// @returns {bool}
	static DeleteState	  = function(__StateName) {
		array_delete(kBank, GetIndex(__StateName), 1);
		array_sort(kBank, true);

		if (__LocalDebug)
			{show_debug_message("-Deleted State : " + string(__StateName) + " | " + object_get_name(kObjectIndex) + " | ");}
	}

	/// @desc This event when summoned will change kStateMachine() Pause status
	/// @returns {bool}
	static AutoPause	  = function() {
		kPaused = !GetPause();

		if (__LocalDebug)
			{show_debug_message("|--| Is Machine PAUSED | " + string(GetPause()) + " |--| " + object_get_name(kObjectIndex) + " |");}

		return kPaused;
	}

	/// @desc This event when summoned will change the currently used state to the targeted one
	/// @param   {string}	[__StateName] Target state's name
	/// @param	 {real}		[__StateTransition] Which transition type will it be || Default is kTransition._kInstant
	/// @returns {bool}
	static SetCurrent	  = function(__StateName, __StateTransition = kTransition._kInstant) {
		if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

		// (Local) Function to change states accordingly
		var __changeState	= function(__EnterStateNameAgain) {
			if (GetIndex(__EnterStateNameAgain) != undefined) {
				kPrevious = kCurrent;
				kCurrent  = GetIndex(__EnterStateNameAgain);
				kTimer	  = 0;

				// If All States have a common "END" Event Summon this (Global) "END" Event
				if (BeforeEnd() != undefined) {BeforeEnd();}

				// First Summon (Previous) States (End) Event Once
				if (kPrevious != undefined && kBank[kPrevious][1].End != undefined) {kBank[kPrevious][1].End();}

				// If All States have a common "START" Event Summon this (Global) "START" Event
				if (BeforeStart() != undefined) {BeforeStart();}

				// Then Summon (Current) States (Start) Event Once
				if (kCurrent != undefined && kBank[kCurrent][1].Start != undefined) {kBank[kCurrent][1].Start();}

				if (__LocalDebug)
					{show_debug_message("-Change to '" + string(kBank[kCurrent][0]) + "' state | " + object_get_name(kObjectIndex) + " |");}
			}
		}

		// (Shortcut)
		var __S_index = variable_instance_get(kObjectId, kSpriteIndex);
		var __I_index = variable_instance_get(kObjectId, kImageIndex);
		var __I_Spd	  = variable_instance_get(kObjectId, kImageSpeed);

		// (Change) States accordingly to their (Enum) Paramaters
		if		(GetIndex(__StateName) != undefined && !GetCurrent(__StateName)) {
			switch (__StateTransition) {
				case kTransition._kFinished :
					if (__I_index >= sprite_get_number(__S_index) - (sprite_get_speed(__S_index)/game_get_speed(gamespeed_fps)) * __I_Spd) {
						__changeState(__StateName);

						// (Reset) The index number
						kCurrentIndex = 0;
						variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);

						return true;
					}

					// (Add) To index number automaticly so animation can reach its end no matter where change state is summoned from
					variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);
					kCurrentIndex += (sprite_get_speed(__S_index)/game_get_speed(gamespeed_fps)) * __I_Spd;
				break;

				case kTransition._kInstant :
					__changeState(__StateName);

					// (Reset) The index number
					kCurrentIndex = 0;
					variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);
				return true;

				case kTransition._kAsync :
					__changeState(__StateName);

					// (Set) Next state sprite's index number to current one so it will be (Asynced)
					variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);
				return true;

				default :
					if (__LocalDebug)
						{show_debug_message("|--| NO SPRITE | " + object_get_name(kObjectIndex) + " | |--|");}

					// (Change) The state without touching the sprite stuff
					__changeState(__StateName);
				return true;
			}
		}
		else if (__LocalDebug) {
			show_debug_message("-Machine cannot find a state named | " + string(__StateName) + " | " + object_get_name(kObjectIndex) + " |");
		}

		return false;
	}

	/// @desc  This event is used to change the built-in kStateMachine() Variables
	/// @param {any} __varChanged Write the built-in variable that will change
	/// @param {any} [__varChangedTo] Write the built-in variable that will be changed to
	/// @returns {bool}
	static SetVariable    = function(__varChanged, __varChangedTo = undefined) {
		if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

		if (__varChangedTo != undefined) {
			switch(__varChanged) {
				case "kImageIndex"  : case "kimageindex"  : case "image_index"  : kImageIndex  = __varChangedTo; break;
				case "kSpriteIndex" : case "kspriteindex" : case "sprite_index" : kSpriteIndex = __varChangedTo; break;
				case "kImageSpeed"  : case "kimagespeed"  : case "image_speed"  : kImageSpeed  = __varChangedTo; break;
				case "kObjectIndex" : case "kobjectindex" : case "object_index" : kObjectIndex = __varChangedTo; break;
				case "kObjectId"    : case "kobjectid"    : case "id"			: kObjectId	   = __varChangedTo; break;
			}

			if (__LocalDebug)
				{show_debug_message("-New variable type names | " + object_get_name(kObjectIndex) + " |\n| Sprite - " + string(kSpriteIndex) + " | Index - " + string(kImageIndex) + " | Speed - " + string(kImageSpeed) + " | Obj Index - " + string(kObjectIndex) + " | Obj ID - " + string(kObjectId))}

			return true;
		}

		return false;
	}

	/// @desc  This event is used to get the built-in kStateMachine() Variables
	/// @param	 {string} __varChanged Write the built-in variable name you want to get in string form
	/// @returns {any}
	static GetVariable    = function(__varChanged) {
		if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

		switch(__varChanged) {
			case "kImageIndex"  : case "kimageindex"  : case "image_index"  : return kImageIndex;
			case "kSpriteIndex" : case "kspriteindex" : case "sprite_index" : return kSpriteIndex;
			case "kImageSpeed"  : case "kimagespeed"  : case "image_speed"  : return kImageSpeed;
			case "kObjectIndex" : case "kobjectindex" : case "object_index" : return kObjectIndex;
			case "kObjectId"    : case "kobjectid"    : case "id"			: return kObjectId;
		}
	}

	/// @desc This event is to determine the Pause status of the kStateMachine()
	/// @param	 {bool} __boolean True for Pause || False for UnPause
	/// @returns {bool}
	static SetPause		  = function(__boolean) {
		kPaused = __boolean;

		return __boolean;
	}

	/// @desc This event lets us determine how much time has been passed since the state is started working as seconds
	/// @returns {real}
	static GetTimer		  = function() {
		//if (__LocalDebug) {show_debug_message("-State Timer : " + string(kTimer));}
		return kTimer;
	}

	/// @desc This event lets us get the Pause status of the kStateMachine()
	/// @returns {bool}
	static GetPause		  = function() {
		if (__LocalDebug)
			{show_debug_message("|--| Is Machine PAUSED | " + string(kPaused) + " |--| " + object_get_name(kObjectIndex) + " |");}

		return kPaused;
	}

	/// @desc This event lets us get the Previously used state's name
	/// @param	 {string} [__StateName] There is two ways of this one is string like GetPrevious("idle") and one is true/false for GetPrevious() == "idle" situations
	/// @returns {any}
	static GetPrevious	  = function(__StateName = undefined) {
		if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

		if (__StateName != undefined) {if (kPrevious == GetIndex(__StateName)) {return true;} else {return false}} // (Alternative) Outcome

		// (Undefined) Outcome
		if (kPrevious == undefined) {
			if (__LocalDebug) {show_debug_message("-Previous | UNDEFINED | " + object_get_name(kObjectIndex) + " |");} 
			return undefined;
		}

		return kBank[kPrevious][0]; // (Main) Outcome
	}

	/// @desc This event lets us get the Currently used state's name
	/// @param	 {string} [__StateName] There is two ways of this one is string like GetCurrent("idle") and one is true/false for GetCurrent() == "idle" situations
	/// @returns {any}
	static GetCurrent	  = function(__StateName = undefined) {
		if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

		if (__StateName != undefined) {if (kCurrent == GetIndex(__StateName)) {return true;} else {return false}} // (Alternative) Outcome

		// (Undefined) Outcome
		if (kCurrent == undefined) {
			if (__LocalDebug) {show_debug_message("-Current | UNDEFINED | " + object_get_name(kObjectIndex) + " |");} 
			return undefined;
		}

		return kBank[kCurrent][0]; // (Main) Outcome
	}

	/// @desc Gets the object's kStateMachine(); State bank's data
	/// @param	 {real} [__type] If you want state name's as a string then it should be (0) || (1) Returns state function itself
	/// @returns {any}
	static GetStateBank	  = function(__type = 1) {
		if (!instance_exists(other.id)) {return [];} // If the summoner object dont exist then exit

		var __values = [];
		for (var i = 0; i < array_length(kBank); ++i) {__values[array_length(__values)] = kBank[i][__type];}

		return __values;
	}

	/// @desc This event is for debug purpose || Shows all from the object's kStateMachine(); Data to output log
	static GetDebug		  = function(_show_events = false)  {
		if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

		show_debug_message($"|-----------({object_get_name(kObjectIndex)})-----------|");
			//show_debug_message("-How Many Machines Created : "	  + string(kAmountOfMachinesCreated));
			show_debug_message($"-Is Machine Paused | {string(GetPause())} |");
			show_debug_message($"-State Timer		| {string(GetTimer())} |");
			show_debug_message($"-Previous			| {(kPrevious != undefined ? kBank[kPrevious][0] : "No previous defined")} |");
			show_debug_message($"-Current			| {(kCurrent  != undefined ?  kBank[kCurrent][0] :  "No current defined")} |");

			for (var i  = 0; i < array_length(kBank); ++i) {
				var _names = kBank[i][0], _events = kBank[i][1]; 
				if (!_show_events) {_events = "log closed";}

				show_debug_message($"-{i + 1}.State name : {string(_names)}\n-{i + 1}.Event list : {string(_events)}");
			}
	}

	// These are debug purposes only || Lets you keep track of how many kStateMachine(); Is created inside the project
	static kAmountOfMachinesCreated = 0;
	kAmountOfMachinesCreated++;
}

/// State Version 1.4.1