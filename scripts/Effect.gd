extends AnimatedSprite

# there are 2 ways to auto-connect the animation finished with the animated sprite
# One ist to yield(self, "animation_finished") inside the _ready func and then queue_free()
# Another is to manually connect("animation_finished", self, "_on_animation_finished") a signal 
# to the host object in the _ready func and then create 
# an _on_animation_finished(): func with queue_free()

func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	play("Animate")

func _on_animation_finished():
	queue_free()
