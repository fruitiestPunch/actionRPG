extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $Sword_Hitbox_Position2D/Sword_Hitbox

const ACCELERATION = 20
const MAX_SPEED = 150
const ROLL_SPEED = 190
const FRICTION = 50

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.LEFT

func _ready():
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(_delta):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().quit()
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if(input_vector != Vector2.ZERO):
		input_vector = input_vector.normalized()
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle_BlendSpace/blend_position", input_vector)
		animation_tree.set("parameters/Run_BlendSpace/blend_position", input_vector)
		animation_tree.set("parameters/Attack_BlendSpace/blend_position", input_vector)
		animation_tree.set("parameters/Roll_BlendSpace/blend_position", input_vector)
		animation_state.travel("Run_BlendSpace")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel("Idle_BlendSpace")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	move()
	
	if(Input.is_action_just_pressed("roll_action")):
		state = ROLL
	if(Input.is_action_just_pressed("attack_action")):
		state = ATTACK
	
func roll_state():
	animation_state.travel("Roll_BlendSpace")
	velocity = roll_vector * ROLL_SPEED
	move()
	
func attack_state():
	animation_state.travel("Attack_BlendSpace")
	# makes the player slide a little bit while attacking, if they were moving before
# warning-ignore:integer_division
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/4)
	move()

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	# might introduce check
	# if roll_vector == velocity, keep velocity
	# else, velocity = 0
	if(roll_vector != velocity.normalized()):
		velocity *= .7
	state = MOVE

func attack_animation_finished():
	state = MOVE
