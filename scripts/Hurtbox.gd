extends Area2D

onready var invincibility_timer = $Invincibility_Timer

#export(bool) var show_hitbox_effect = true
export(Vector2) var hitbox_effect_offset = (Vector2.ZERO)

var invincible = false setget set_invincible

# scenes are no real nodes
# preload instead of load to not eat up all ram in every frame
const hit_effect_scene = preload("res://scenes/share/Hit_Effect.tscn")

signal invincibility_started
signal invincibility_ended

func create_hit_effect():
	#if(show_hitbox_effect):
	
	# instances are real nodes, so I can pick and manipulate properties
	var hit_effect_instance = hit_effect_scene.instance()
	# gives access to target scene (here: main scene)
	var main_scene = get_tree().current_scene
	main_scene.add_child(hit_effect_instance)
	hit_effect_instance.position = global_position - hitbox_effect_offset

func set_invincible(value):
	invincible = value
	if(invincible):
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	invincibility_timer.start(duration)

func _on_Invincibility_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_ended():
	monitoring = true

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)
