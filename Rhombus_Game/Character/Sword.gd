extends Sprite2D

const ANIM_DUR = 45;
const SWING_DUR = 60;
const SWING_GRACE = 105;
const SCALE_DUR = 15;
const BUFF_PAUSE = 25;
const LIGHT_CONST = 2.5;

var swingNum;
var swingTime;
var swingGrace;
var swingBuff;
@onready var light = $SwordLight


# Called when the node enters the scene tree for the first time.
func _ready():
	swingNum = 0;
	swingTime = 0;
	swingGrace = 0;
	swingBuff = false;
	
	set_meta("active", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(swingGrace > 0): set_meta("active", true);
	else: set_meta("active", false);
	
	if(get_meta("active")):
		z_index = -1;
	else:
		z_index = 1;
	
	#which swing to do
	if(Input.is_action_pressed("swing")):
		if(swingTime > 0):
			if(swingTime < SWING_DUR - BUFF_PAUSE):
				swingBuff = true;
			else: pass
		else:
			swingNum = (swingNum + 1) % 4;
			swingTime = SWING_DUR;
			swingGrace = SWING_GRACE;
			swingBuff = false;
			#get_parent(set_meta("Rotation Lock", true));
	else:
		if(swingTime > 0):
			pass
		elif(swingNum == 0 && swingBuff == false):
			pass
		elif(swingBuff == true):
			swingNum = (swingNum + 1) % 4;
			swingTime = SWING_DUR;
			swingGrace = SWING_GRACE;
			swingBuff = false;
			#get_parent(set_meta("Rotation Lock", true));
		elif(swingGrace > 0):
			pass
		else:
			swingNum = 0;
			swingTime = SWING_DUR;
			swingGrace = SWING_GRACE;
			swingBuff = false;
		pass
	
	#move sword
	match(swingNum):
		0:
			if(swingTime > 0):
				if(swingTime > SWING_DUR - ANIM_DUR):
					light.energy = LIGHT_CONST
					rotate(-1 * (3.66519143 / ANIM_DUR));
				else: light.energy = 0;
				swingTime -= 1;
				swingGrace -= 1;
				if(swingTime < SCALE_DUR):
					scale += Vector2(-0.05, -0.05);
			elif(swingGrace > 0):
				swingGrace -= 1;
			else:
				pass
		1:
			if(swingTime > 0):
				if(swingTime > SWING_DUR - ANIM_DUR):
					light.energy = LIGHT_CONST
					rotate(3.66519143 / ANIM_DUR);
				else: light.energy = 0;
				swingTime -= 1;
				swingGrace -= 1;
				if(swingTime >= SWING_DUR - SCALE_DUR):
					scale += Vector2(0.05, 0.05);
			elif(swingGrace > 0):
				swingGrace -= 1;
			else:
				pass
			
		2:
			if(swingTime > 0):
				if(swingTime > SWING_DUR - ANIM_DUR):
					light.energy = LIGHT_CONST
					rotate( (2 * 3.14159265358) / ANIM_DUR)
				else: light.energy = 0;
				swingTime -= 1;
				swingGrace -= 1;
			elif(swingGrace > 0):
				swingGrace -= 1;
			else:
				pass
		3:
			if(swingTime > 0):
				if(swingTime > SWING_DUR - ANIM_DUR):
					light.energy = LIGHT_CONST
					rotate( -1 * (2 * 3.14159265358) / ANIM_DUR)
				else: light.energy = 0;
				swingTime -= 1;
				swingGrace -= 1;
			elif(swingGrace > 0):
				swingGrace -= 1;
			else:
				pass
	visible = get_meta("active");
	pass
