extends Camera2D

# they are children of Node
# because Node has no transform, all its children also "lose" their transform
# with this, the camera can move with the player, and the children stay static
onready var top_left_position = $Node/Top_Left_Position2D
onready var bottom_right_position = $Node/Bottom_Right_Position2D2

func _ready():
	# after settign these, go into World and edit children of camera
	# move them to edge of playable area 
	limit_top = top_left_position.position.y
	limit_left = top_left_position.position.x
	limit_bottom = bottom_right_position.position.y
	limit_right = bottom_right_position.position.x
