extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screensize=Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($AnimatedSprite,'scale',$AnimatedSprite.scale,$AnimatedSprite.scale*1.5,0.2,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.2,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)

func pickup():
	monitoring=false
	$Tween.start() 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_completed(object, key):
	queue_free()
	

func _on_Powerup_area_entered(area):
	pass # Replace with function body.


func _on_LifeTime_timeout():
	queue_free()
	
