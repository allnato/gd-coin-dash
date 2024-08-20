extends Area2D

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(420, 720)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	
	
	# Debuging Velocity and Position
	#print("vel: ", velocity, "pos: ", position)
	# Clamp your position.
	# You don't want your character to go beyond the window
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
