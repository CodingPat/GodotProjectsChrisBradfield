extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var Coin
export (PackedScene) var Powerup
export (PackedScene) var Obstacle


export (int) var playtime
var level
var score
var time_left
var screensize
var playing=false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize=get_viewport().get_visible_rect().size
	$Player.screensize=screensize
	$Player.hide()

func new_game():
	playing=true
	level=1
	score=0
	time_left=playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_obstacles()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
	
func spawn_coins():
	$LevelSound.play()
	for i in range(4+level):
		var c=Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize=screensize
		c.position=Vector2(rand_range(0,screensize.x),
		rand_range(0,screensize.y))
		
func spawn_obstacles():
	for i in rand_range(1,1+level):
		var o=Obstacle.instance()
		$ObstacleContainer.add_child(o)
		o.screensize=screensize
		o.position=Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
		
		
		
func delete_all_obstacles():
	for i in $ObstacleContainer.get_children():
		i.queue_free()
				
func _process(delta):
	if playing and $CoinContainer.get_child_count()==0:
		level+=1
		time_left+=5
		spawn_coins()
		delete_all_obstacles()
		spawn_obstacles()
		$PowerUpTimer.wait_time=rand_range(5,10)
		$PowerUpTimer.start()
		

func _on_GameTimer_timeout():
	time_left-=1
	$HUD.update_timer(time_left)
	if time_left<=0:
		game_over()

func _on_Player_pickup(type):
	match type:
		"coin":
			score+=1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			time_left+=5
			$PowerUpSound.play()
			$HUD.update_timer(time_left)
		
			
	
func _on_Player_hurt():
	game_over()
	
func game_over():
	playing=false
	$EndSound.play()
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	for obstacle in $ObstacleContainer.get_children():
		obstacle.queue_free()
	$HUD.show_game_over()
	$Player.die()
	

func _on_PowerUpTimer_timeout():
	var p=Powerup.instance()
	add_child(p)
	p.screensize=screensize
	p.position=Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
	






