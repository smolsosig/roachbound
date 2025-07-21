extends CanvasLayer
class_name ChoiceMenu

@export var choice1: Button
@export var choice2: Button

func _ready() -> void:
	choice1.connect("pressed", pressed_1)
	choice2.connect("pressed", pressed_2)
	SignalBus.connect("choice_show", reveal)
	hide()

func reveal(choice1_text: String, choice2_text: String, big_one: bool) -> void:
	show()
	SoundManager.play_ui_sound(load("res://assets/sounds/important.ogg"))
	choice1.text = choice1_text.to_upper()
	choice2.text = choice2_text.to_upper()
	
	if big_one:
		choice1.size = Vector2(800, 200)
		choice2.size = Vector2(200, 50)
	else:
		choice1.size = Vector2(300, 100)
		choice2.size = Vector2(300, 100)

func pressed_1() -> void:
	hide()
	SignalBus.emit_signal("choice_chosen", true)

func pressed_2() -> void:
	hide()
	SignalBus.emit_signal("choice_chosen", false)
