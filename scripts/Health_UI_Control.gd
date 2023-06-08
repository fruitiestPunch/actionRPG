extends Control

onready var heart_full_textture_rect = $Heart_Full_TextureRect
onready var heart_empty_textture_rect = $Heart_Empty_TextureRect

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var heart_size = 15

func _ready():
	# Player_Stats is autoloaded global singleton
	self.max_hearts = Player_Stats.max_health
	self.hearts = Player_Stats.health	
	# takes argument from Player_Stats.health_changed(value) and passes to set_hearts(value)
# warning-ignore:return_value_discarded
	Player_Stats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	Player_Stats.connect("max_health_changed", self, "set_max_hearts")

func set_hearts(value):
	hearts = clamp(value, 0 , max_hearts)
	if(heart_full_textture_rect):
		heart_full_textture_rect.rect_size.x = heart_size * hearts

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if(heart_empty_textture_rect):
		heart_empty_textture_rect.rect_size.x = heart_size * max_hearts
