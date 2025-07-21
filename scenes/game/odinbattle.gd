extends CanvasLayer

@export var anim_player: AnimationPlayer

func _ready() -> void:
	hide()
	anim_player.play("RESET")

func battle() -> void:
	show()
	await get_tree().create_timer(1).timeout
	anim_player.play("init")
	SoundManager.play_music(load("res://assets/music/boss.mp3"))

func play_cloak() -> void:
	SoundManager.play_sound(load("res://assets/sounds/cloak.ogg"))

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flee":
		SoundManager.stop_music()
		SoundManager.play_sound(load("res://assets/sounds/victoree.ogg"))
		await get_tree().create_timer(5.42).timeout
		SignalBus.emit_signal("battle_done")
		GameManager.can_move = true
		SoundManager.play_music(load("res://assets/music/room.ogg"))
		queue_free()


func _on_button_4_pressed() -> void:
	anim_player.play("flee")
