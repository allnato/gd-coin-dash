extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
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
		$PowerUpTimer.wait_time = randf_range(5, 10)
		$PowerUpTimer.start()

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
	
	# Reset Player Position
	$Player.position = screensize/2
	# Show Level Message
	$HUD.show_game_level(level)
	# Play Level Sound
	$LevelSound.play()
	$LevelNameTimer.start()
	await $LevelNameTimer.timeout


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt() -> void:
	game_over()
	

func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerUpSound.play()
			time_left += 5
			$HUD.update_time(time_left)


func game_over():
	playing = false
	$GameTimer.stop()
	$EndSound.play()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()


func _on_hud_start_game() -> void:
	new_game()


func _on_power_up_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
