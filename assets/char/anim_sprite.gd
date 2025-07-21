extends AnimatedSprite2D

@onready var char: CharacterBody2D = get_parent()

func _ready() -> void:
	animation = "run_down"
	frame = 2

# I know this is really shitty.
# But I am a sidescroller dev. I don't know how ts works.
func _process(_delta) -> void:
	var dir: Vector2 = char.direction
	
	if !GameManager.can_move:
		pause()
		if frame != 1:
			frame = 1
	else:
		if dir.x == 0:
			if dir.y > 0:
				play("run_down")
			elif dir.y < 0:
				play("run_up")
			else:
				frame = 1
				pause()
		else:
			if dir.y > 0:
				play("run_34down")
			elif dir.y < 0:
				play("run_34up")
			else:
				play("run_side")
