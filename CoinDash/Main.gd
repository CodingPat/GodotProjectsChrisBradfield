extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var Coin
export (PackedScene) var Powerup
export (PackedScene) var Obstacle
const maximumObstacles=6

#defining sizes, to exclude areas when creating obstacles
# getting size in the code on basis of texture is *complicated* (scale factor and all this kind of things)

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
	var rectsExcludedForObstacles:Array
	playing=true
	score=0
	time_left=playtime+level*5
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	rectsExcludedForObstacles=get_rects_excluded_for_obstacles()
	
	delete_all_obstacles()
	spawn_obstacles(rectsExcludedForObstacles)
	
	$PowerUpTimer.wait_time=rand_range(5,10)
	$PowerUpTimer.start()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
	
func get_rects_excluded_for_obstacles():
	var rectsExcludedForObstacles:Array
	var position:Vector2
	var size=Vector2(0,0)
		#get all coins rects
	
	for c in $CoinContainer.get_children():
		size.x=c.get_node("CollisionShape2D").shape.radius*2
		size.y=size.x
		#print("coin size: "+str(size))
		position=c.position
		#print("coin position"+str(position))
		rectsExcludedForObstacles.append(Rect2(Vector2(position.x-size.x/2,position.y-size.y/2),size))
		
	#get player rect
	#print("player rect")
	size.x=$Player.get_node("CollisionShape2D").shape.extents.x*2	
	size.y=$Player.get_node("CollisionShape2D").shape.extents.y*2
	position=$Player.position
	#print("Player size: "+str(size))
	#print("Player position"+str(position))
	rectsExcludedForObstacles.append(Rect2(Vector2(position.x-size.x/2,position.y-size.y/2),size))
	
	#print("excluded rects for obstacles : "+str(rectsExcludedForObstacles))
	
	return rectsExcludedForObstacles
	
func spawn_coins():
	$LevelSound.play()
	for i in range(4+level):
		var c=Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize=screensize
		c.position=Vector2(rand_range(0,screensize.x),
		rand_range(0,screensize.y))
		
		
func spawn_obstacles(rectsExcludedForObstacles):
	var obstacle
	var size=Vector2(0,0)
	var rectObstacle:Rect2
	
	#debus excluded rects
	#print("rects exclude: "+str(rectsExcludedForObstacles))
	
	#get size of obstacle
	obstacle=Obstacle.instance()
	size.x=obstacle.get_node("CollisionShape2D").shape.radius*2
	size.y=obstacle.get_node("CollisionShape2D").shape.height*2
	
		
	for i in rand_range(1,max(1+level,maximumObstacles)):
		var coordinatesOK=false
		obstacle=Obstacle.instance()
		while(not coordinatesOK):
			coordinatesOK=true
			obstacle.position=Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
			rectObstacle=Rect2(Vector2(obstacle.position.x-size.x/2,obstacle.position.y-size.y/2),size)
			for rect in rectsExcludedForObstacles:
				if rect.intersects(rectObstacle):
					#print("intersects ! :" +"excl. rect :"+ str(rect)+"obst. rect"+str(rectObstacle))
					coordinatesOK=false
					continue
		
		#print("rect obstacle :"+str(rectObstacle))
		$ObstacleContainer.add_child(obstacle)
		
		
		

		
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
	






