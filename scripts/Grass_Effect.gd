extends Node2D

onready var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.play("Grass_Destroyed_Animation")
	yield(animated_sprite, "animation_finished")
	queue_free()
