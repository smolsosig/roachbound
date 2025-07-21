extends Area2D

@export var red: bool = false

signal pressed
signal not_pressed

var present_body: Node2D

func _ready() -> void:
	connect("body_entered", body_entered)
	connect("body_exited", body_exited)

func body_entered(body: Node2D) -> void:
	if body is MovableObject:
		present_body = body
		if body.name == "RedBox" && red:
			emit_signal("pressed")
			SoundManager.play_sound(load("res://assets/sounds/sequence_partially_finished.ogg"))
		elif body.name == "BlueBox" && !red:
			emit_signal("pressed")
			SoundManager.play_sound(load("res://assets/sounds/sequence_partially_finished.ogg"))

func body_exited(body: Node2D) -> void:
	if body == present_body:
		emit_signal("not_pressed")
