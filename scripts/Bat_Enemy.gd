extends KinematicBody2D

onready var stats = $Stats

# scenes are no real nodes
# preload instead of load to not eat up all ram in every frame
const enemy_death_effect_scene = preload("res://scenes/Enemy_Death_Effect.tscn")
const FRICTION = 20

var knockback = Vector2.ZERO

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 250

func _on_Stats_no_health():
	queue_free()
	# instances are real nodes, so I can pick and manipulate properties
	var enemy_death_effect_instance = enemy_death_effect_scene.instance()
	# gives access to target scene (here: ysort scene)
	get_parent().add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.position = self.position
