extends KinematicBody2D

onready var stats = $Stats

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
