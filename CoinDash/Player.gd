extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed:int=350
var velocity=Vector2() 
var screensize:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	screensize=get_viewport().size
	#print("screen size: "+str(screensize))
	

func get_input():
	#velocity=Vector2()
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x=-1
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x=1
	if Input.is_key_pressed(KEY_DOWN):
		velocity.y=1
	if Input.is_key_pressed(KEY_UP):
		velocity.y=-1
	#if velocity.length()>0:
	#	velocity=velocity.normalized()*speed
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position+=velocity*delta
	position.x=clamp(position.x,0,screensize.x)
	position.y=clamp(position.y,0,screensize.y)
	
		
