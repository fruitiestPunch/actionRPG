extends KinematicBody2D

onready var stats = $Stats
onready var player_detection_area = $Player_Detection_Area
onready var animated_sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var soft_collisions = $Soft_Collision_Area2D
onready var wander_controller = $Wander_Controller
onready var animation_player = $AnimationPlayer

export var ACCELERATION = 20
export var MAX_SPEED = 100
export var FRICTION = 50
export var KNOCKBACK = 500
# there might be an issue, if max_speed and velocity are too high and 
# the enemy then alway overshoots the start_position
# this might cause a jiggle in the wander state
export var WANDER_TOLERANCE = 5
export var INVINCIBILITY_DURATION = 0.3

# scenes are no real nodes
# preload instead of load to not eat up all ram in every frame
const enemy_death_effect_scene = preload("res://scenes/Enemy_Death_Effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE
var numOfFrames = 5


func _ready():
	animated_sprite.frame = randi() % numOfFrames

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
			seek_player()
			if(wander_controller.get_time_left() == 0):
				random_state_transition([IDLE, WANDER], 3)
				
		WANDER:
			seek_player()
			if(wander_controller.get_time_left() == 0):
				random_state_transition([IDLE, WANDER], 3)
			move_towards_point(wander_controller.target_position)
			if(global_position.distance_to(wander_controller.target_position) <= WANDER_TOLERANCE):
				random_state_transition([IDLE, WANDER], 3)
				
		CHASE:
			var player = player_detection_area.player
			if(player):
				move_towards_point(player.global_position)
			else:
				# only quick fix
				# TODO add more natural slow down
				state = IDLE
	if(soft_collisions.is_colliding()):
		velocity += soft_collisions.get_push_vector() * 50
	velocity = move_and_slide(velocity)
	
func random_state_transition(list, duration):
	state = pick_random_state(list)
	wander_controller.start_wander_timer(rand_range(1, duration))

func move_towards_point(point):
	# getting direction to move towards and the normalizing
	# actual movement done by MAX_SPEED and ACCELERATION
	#var movement_vector = (player.global_position - global_position).normalized()
	var movement_vector = global_position.direction_to(point)
	velocity = velocity.move_toward(movement_vector * MAX_SPEED, ACCELERATION)
	animated_sprite.flip_h = velocity.x < 0

func seek_player():
	if(player_detection_area.can_see_player()):
		state = CHASE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	knockback = area.knockback_vector * KNOCKBACK
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_Stats_no_health():
	queue_free()
	# instances are real nodes, so I can pick and manipulate properties
	var enemy_death_effect_instance = enemy_death_effect_scene.instance()
	# gives access to target scene (here: ysort scene)
	get_parent().add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.position = self.position

func _on_Hurtbox_invincibility_ended():
	animation_player.play("Stop_Animation")

func _on_Hurtbox_invincibility_started():
	animation_player.play("Start_Animation")
