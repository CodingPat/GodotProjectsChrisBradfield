extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var Coin
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
	
	
func spawn_coins():
	for i in range(4+level):
		var c=Coin.instance()
		$CoinContainer.addchild(c)
		c.screensize=screensize
		c.position=Vector2(rand_range(0,screensize.x),
		rand_range(0,screensize.y))
		
func _process(delta):
	if playing and $CoinContainer.get_child_count()==0:
		level+=1
		time_left+=5
		spawn_coins()
		