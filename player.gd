extends Area2D
signal pickup
signal hurt

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(420, 720)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	
	# Animation
	# If there is movement, change the animation to "run"
	# Uses the length of a vector, which is always positive if moving
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	# Animation
	# Flip the sprite if moving to the left x-axis
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	# Debuging Velocity and Position
	#print("vel: ", velocity, "pos: ", position)
	
	# Clamp your position.
	# You don't want your character to go beyond the window
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
func start():
	set_process(true)
	position = screensize/2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit()
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
