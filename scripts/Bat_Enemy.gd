extends KinematicBody2D

onready var stats = $Stats
onready var player_detection_area = $Player_Detection_Area
onready var animated_sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox

export var ACCELERATION = 20
export var MAX_SPEED = 100
export var FRICTION = 50
export var KNOCKBACK = 500

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
		WANDER:
			pass
		CHASE:
			var player = player_detection_area.player
			if(player):
				# getting direction to move towards and the normalizing
				# actual movement done by MAX_SPEED and ACCELERATION
				#var movement_vector = (player.global_position - global_position).normalized()
				var movement_vector = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(movement_vector * MAX_SPEED, ACCELERATION)
			else:
				# only quick fix
				# TODO add more natural slow down
				state = IDLE
	animated_sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if(player_detection_area.can_see_player()):
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	knockback = area.knockback_vector * KNOCKBACK

func _on_Stats_no_health():
	queue_free()
	# instances are real nodes, so I can pick and manipulate properties
	var enemy_death_effect_instance = enemy_death_effect_scene.instance()
	# gives access to target scene (here: ysort scene)
	get_parent().add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.position = self.position
