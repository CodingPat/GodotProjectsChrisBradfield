extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screensize=Vector2()
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func pickup():
	queue_free() 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
