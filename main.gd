extends Node

@export var coin_scene : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
func _process(_delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	# Reset HUD values
	$HUD.update_score(score)
	$HUD.update_time(time_left)
	
func spawn_coins():
	
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	
	# Show Level Message
	$HUD.show_game_level(level)
	# Sound
	$LevelSound.play()


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt() -> void:
	game_over()
	

func _on_player_pickup() -> void:
	score += 1
	$CoinSound.play()
	$HUD.update_score(score)
	
func game_over():
	playing = false
	$GameTimer.stop()
	$EndSound.play()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()


func _on_hud_start_game() -> void:
	new_game()
