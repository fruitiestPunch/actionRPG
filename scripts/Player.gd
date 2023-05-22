extends KinematicBody2D

const ACCELERATION = 20
const MAX_SPEED = 200
const FRICTION = 20

var velocity = Vector2.ZERO

func _physics_process(_delta):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().quit()
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if(input_vector != Vector2.ZERO):
		input_vector = input_vector.normalized()
		velocity += input_vector * ACCELERATION
		velocity = velocity.limit_length(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
