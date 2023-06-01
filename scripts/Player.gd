extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

const ACCELERATION = 20
const MAX_SPEED = 150
const FRICTION = 50

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var state = MOVE

func _ready():
	animation_tree.active = true

func _physics_process(_delta):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().quit()
	match state:
		MOVE:
			move_state()
		ROLL:
			pass
		ATTACK:
			attack_state()

func move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if(input_vector != Vector2.ZERO):
		input_vector = input_vector.normalized()
		animation_tree.set("parameters/Idle_BlendSpace/blend_position", input_vector)
		animation_tree.set("parameters/Run_BlendSpace/blend_position", input_vector)
		animation_tree.set("parameters/Attack_BlendSpace/blend_position", input_vector)
		animation_state.travel("Run_BlendSpace")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel("Idle_BlendSpace")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	velocity = move_and_slide(velocity)
	if(Input.is_action_just_pressed("attack_action")):
		state = ATTACK
	
func attack_state():
	animation_state.travel("Attack_BlendSpace")
	# makes the player slide a little bit while attacking, if they were moving before
# warning-ignore:integer_division
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/4)
	velocity = move_and_slide(velocity)

func roll_state():
	pass

func attack_animation_finished():
	state = MOVE
