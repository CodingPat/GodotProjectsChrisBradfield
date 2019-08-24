extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screensize:Vector2
var radius
var height
var extent:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	radius=get_node("CollisionShape2D").shape.radius
	height=get_node("CollisionShape2D").shape.height
	extent=Vector2(radius,height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func random_position():
	position=Vector2(rand_range(0+extent.x,screensize.x-extent.x),
		rand_range(0+extent.y,screensize.y-extent.y))

#detect at creation time if obstacle collides coins or powerup or excluded area (player start position) 
# and if this is the case, move elsewhere
func _on_Obstacle_area_entered(area):
	if area.is_in_group("coins") or area.is_in_group("powerups") or area.is_in_group("excludedarea") or area.is_in_group("obstacles"):
		random_position()
		
		
