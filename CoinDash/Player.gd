extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export (int) var speed=350 #speed has no direction
var velocity=Vector2()  # normalized velocity = a magnitude bewteen 0 and 1, and a direction
var screensize=Vector2()
var extent:Vector2

signal pickup
signal hurt


# Called when the node enters the scene tree for the first time.
func _ready():
	extent=$CollisionShape2D.shape.extents
	#print("extent player: "+str(extent))
	screensize=get_viewport().size
	#print("screen size: "+str(screensize))
	$AnimatedSprite.play()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position+=velocity*speed*delta
	position.x=clamp(position.x,0+extent.x,screensize.x-extent.x)
	position.y=clamp(position.y,0+extent.y,screensize.y-extent.y)
	
		
func get_input():
	#if no key pressed, velocity=0
	velocity.x=0
	velocity.y=0
	#check key pressed
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x=-1
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x=1
	if Input.is_key_pressed(KEY_DOWN):
		velocity.y=1
	if Input.is_key_pressed(KEY_UP):
		velocity.y=-1
	
	if velocity.length()>0:
		#normalize vector : magnitude between 0 and 1
		velocity=velocity.normalized()
		#select animation
		$AnimatedSprite.animation="run"
		$AnimatedSprite.flip_h=velocity.x<0
	else:
		#select animation
		$AnimatedSprite.animation="idle"
	
	
func start(pos):
	set_process(true)
	position=pos
	$AnimatedSprite.animation="idle"
	$AnimatedSprite.play()
	
func die():
	$AnimatedSprite.play("hurt")
	$AnimatedSprite.stop()
	set_process(false)
	

func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup","coin")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup","powerup")
		
		
	
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	

