extends CharacterBody2D


const AVGSPD = 340
const SPEED = 35.0
const DASH_FOLLOWTHROUGH = 45.0
const DASH_SPD = 700.0
const DASH_SCALAR = 1.7
const SPD_CAP = 340.0
const EXCESS_SPD_DECAY_RATE = 0.955
const DASH_DURATION = 24

#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	
	
	#rotation
	if(get_meta("RotationLock")):
		look_at(get_global_mouse_position() )
		rotate(1.57079633) #this is pi/2 radians.  hard-coded because the diamond needs to be facing mouse cursor + 90 degrees
	#WASD
	var kickstartMultiplier = 1.0
	var spdToUse = SPEED
	
	if(velocity.length() > SPD_CAP):
		velocity *= EXCESS_SPD_DECAY_RATE
	else:
		velocity = Vector2()
		spdToUse = AVGSPD
		
	var diagonal_Scalar = 1.0
	
	if( (Input.is_action_pressed("up") || Input.is_action_pressed("down")) && 
	(Input.is_action_pressed("left") || Input.is_action_pressed("right"))):
		diagonal_Scalar = 0.7071
		
	if(Input.is_action_pressed("up")):
		velocity.y -= spdToUse * diagonal_Scalar
	if(Input.is_action_pressed("down")):
		velocity.y += spdToUse * diagonal_Scalar
	if(Input.is_action_pressed("left")):
		velocity.x -= spdToUse * diagonal_Scalar
	if(Input.is_action_pressed("right")):
		velocity.x += spdToUse * diagonal_Scalar
	
	#dash
	var dashTime = get_meta("DashTime")
	if(get_meta("DashTime") > 0):
		dashTime -= 1
		velocity += (DASH_FOLLOWTHROUGH * get_meta("DashDir"))
		set_meta("DashTime", dashTime) 
	
	if(Input.is_action_just_pressed("dash")):
		
		var dashDir = Vector2(get_global_mouse_position() - position).normalized()
		set_meta("DashDir", dashDir)
		set_meta("DashTime", DASH_DURATION)

		velocity = Vector2()
		velocity.x += DASH_SPD * dashDir.x
		velocity.x *= DASH_SCALAR
		velocity.y += DASH_SPD * dashDir.y
		velocity.y *= DASH_SCALAR
	
	
	move_and_slide()
