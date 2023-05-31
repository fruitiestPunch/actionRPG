extends Node2D

# instancing scenes is really important
# shooting guns, spawning enemies, spawning object, etc
# 1. load scene
# 2. instance scene
# 3. get access to target scene and add child scene 
# 4. set position of new instance

func _process(_delta):
	if(Input.is_action_just_pressed("attack_action")):
		# scenes are no real nodes
		# preload instead of load to not eat up all ram in every frame
		var grass_effect_scene = preload("res://scenes/Grass_Effect.tscn")
		# instances are real nodes, so I can pick and manipulate properties
		var grass_effect_instance = grass_effect_scene.instance()
		# gives access to target scene (here: ysort scene)
		get_parent().add_child(grass_effect_instance)
		grass_effect_instance.position = self.position
		queue_free()
