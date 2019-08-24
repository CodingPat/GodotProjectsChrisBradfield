extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screensize=Vector2()
var radius

# Called when the node enters the scene tree for the first time.
func _ready():
	radius=get_node("CollisionShape2D").shape.radius
	$Tween.interpolate_property($AnimatedSprite,'scale',$AnimatedSprite.scale,$AnimatedSprite.scale*1.5,0.2,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.2,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$ResetAnimatedFrameTimer.wait_time=rand_range(1,5)
	$ResetAnimatedFrameTimer.start()
	
func pickup():
	monitoring=false
	$Tween.start() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func random_position():
	position=Vector2(rand_range(0+radius,screensize.x-radius),
		rand_range(0+radius,screensize.y-radius))

func _on_Tween_tween_completed(object, key):
	queue_free()
	

func _on_ResetAnimatedFrameTimer_timeout():
	$AnimatedSprite.frame=0
	$AnimatedSprite.play()


func _on_Coin_area_entered(area):
	if area.is_in_group("coins") or area.is_in_group("powerups") or area.is_in_group("excludedarea") or area.is_in_group("obstacles"):
		random_position()
