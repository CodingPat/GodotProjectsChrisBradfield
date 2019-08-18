extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var screensize:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#detect if obstacle collides coins or powerup at creation
#and if it is so, move obstacle elsewhere
#OBSOLETE because checked at creation to also avoid collision with player at creation time
func _on_Obstacle_area_entered(area):
	pass
#	if area.is_in_group("coins") or area.is_in_group("powerups"):
#		position=Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
#
