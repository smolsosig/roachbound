extends Node2D
class_name LevelInit

@export_group("Fading In", "fade_")
@export var fade_in: bool = true
@export var fade_in_duration: float = 1.0
@export var fade_in_pattern: String = ""
@export_group("Music", "music_")
@export var music_on_start: bool = false
@export var music_filename: String = ""
@export var music_fadein: float = 0.0

var hud: PackedScene = preload("res://assets/ui/hud/hud.tscn")

func _ready() -> void:
	if fade_in:
		Fade.fade_in(fade_in_duration, Color.BLACK, fade_in_pattern)
	
	if music_on_start:
		SoundManager.play_music(load("res://assets/music/%s.ogg" % music_filename), music_fadein)
	
	var hud_inst = hud.instantiate()
	add_child(hud_inst)
	SignalBus.emit_signal("dialogue_register", self.name)
	
	do_shit()

func do_shit() -> void:
	pass
