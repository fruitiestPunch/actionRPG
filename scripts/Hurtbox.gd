extends Area2D

export(bool) var show_hitbox_effect = true
export(Vector2) var hitbox_effect_offset = (Vector2.ZERO) 

# scenes are no real nodes
# preload instead of load to not eat up all ram in every frame
const hit_effect_scene = preload("res://scenes/share/Hit_Effect.tscn")

func _on_Hurtbox_area_entered(_area):
	if(show_hitbox_effect):
		# instances are real nodes, so I can pick and manipulate properties
		var hit_effect_instance = hit_effect_scene.instance()
		# gives access to target scene (here: main scene)
		var main_scene = get_tree().current_scene
		main_scene.add_child(hit_effect_instance)
		hit_effect_instance.position = global_position - hitbox_effect_offset
