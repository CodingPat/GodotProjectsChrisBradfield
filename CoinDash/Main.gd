extends Node

# member variables
export (PackedScene) var Coin
export (PackedScene) var Powerup
export (PackedScene) var Obstacle
const maximumObstacles=6

export (int) var playtime
var level:int=0
var score
var time_left
var screensize
var playing=false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	screensize=get_viewport().get_visible_rect().size
	$Player.screensize=screensize
	$PlayerStart.position=Vector2(screensize.x/2,screensize.y/2)
	$Player.hide()

func new_game():
	level+=1
	playing=true
	score=0
	time_left=playtime+level*5
	
	$GameTimer.start()
	spawn_coins()
	
	$Player.start($PlayerStart.position)
	
	#disable collision detection for player while creating obstacles
	$Player/CollisionShape2D.disabled=true
	delete_all_obstacles()
	spawn_obstacles()
	#give obstacles enough time to detect collision with excluded area (player starting position)
	yield(get_tree().create_timer(0.1),'timeout')
	# player collision detection is back
	$Player/CollisionShape2D.disabled=false
	$Player.show()
	
	$PowerUpTimer.wait_time=rand_range(5,10)
	$PowerUpTimer.start()
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
	for i in range(min(1+level,maximumObstacles)):
		var o=Obstacle.instance()
		$ObstacleContainer.add_child(o)
		o.screensize=screensize
		o.position=Vector2(rand_range(0,screensize.x),
		rand_range(0,screensize.y))
		


		
func delete_all_obstacles():
	for i in $ObstacleContainer.get_children():
		i.queue_free()
				
func _process(delta):
	if playing and $CoinContainer.get_child_count()==0:
		level+=1
		new_game()

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
	#reset level
	level=0
	

func _on_PowerUpTimer_timeout():
	var p=Powerup.instance()
	add_child(p)
	p.screensize=screensize
	p.position=Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
	






