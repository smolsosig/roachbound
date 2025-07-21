extends CanvasLayer

# most of ts is copypasted from AWoT because it works LOL

#region dialogue getters
@export var dialogue_node: Node
const dialogue_location: String = "res://scenes/game/levels/"
var current_dialogue_location: String = ""
var current_stage_filename: String = ""
var even_has_dialogue: bool = false

var dialogue_script: Script
var dialogue: String = ""
var end_dialogue_signal: String = "!@#" # used to detect if dialogue is finished
#endregion

@export var dialogue_text: RichTextLabel
@export var dialogue_cont: Button
@export var typing_sound: AudioStreamPlayer

var is_displaying_text: bool = false
var is_paused: bool = false
var dialogue_progression: int = 1
var current_key: String = ""
var dialoguing: bool = false

func _ready() -> void:
	hide()
	
	SignalBus.connect("dialogue_show", show_dialogue)
	SignalBus.connect("dialogue_register", add_dialogue)
	
#region get dialogue funcs
func add_dialogue(stage_name: String) -> void:
	current_dialogue_location = "%s%s_dialog.gd" % [dialogue_location, stage_name.to_lower()]
	
	if ResourceLoader.exists(current_dialogue_location):
		dialogue_script = load(current_dialogue_location)
		dialogue_node.set_script(dialogue_script)
		print("%s_dialog.gd found!" % stage_name)
		current_stage_filename = stage_name
		even_has_dialogue = true
	else:
		# we allow the game to continue as usual
		print_debug("%s_dialog.gd does not appear to exist. Unless intentional, please fix ASAP." % stage_name)
		even_has_dialogue = false

func return_dialogue(key: String) -> String:
	if even_has_dialogue:
		# so turns out you have to use has(). because I am dumb and retarded
		if dialogue_node.dialogue.has(key):
			dialogue = dialogue_node.dialogue[key]
		else:
			dialogue = end_dialogue_signal
	else:
		dialogue = end_dialogue_signal
	
	return dialogue
#endregion

func show_dialogue(key: String) -> void:
	show()
	dialogue_cont.hide()
	dialogue_text.text = ""
	dialogue_progression = 1
	current_key = key
	progress_text()
	dialoguing = true

func _process(_delta: float) -> void:
	if is_displaying_text:
		if dialogue_text.visible_ratio != 1:
			if !is_paused:
				dialogue_text.visible_characters += 1
				last_two_displayed_chars()
		else:
			is_displaying_text = false
			dialogue_cont.show()
			typing_sound.stop()

func last_two_displayed_chars() -> void:
	if dialogue_text.visible_characters > 1:
		var orig_text: String = dialogue_text.text
		var visible_text: String = orig_text.left(dialogue_text.visible_characters)
		var text_check:String = visible_text.right(2)
		var param: int = 0
		
		match text_check:
			". ":
				param = 1
			", ":
				param = 2
			"? ":
				param = 1
			"! ":
				param = 1
			"; ":
				param = 2
			"- ":
				param = 2
			") ":
				param = 2
		
		if param:
			pause_text(param, visible_text)

func pause_text(end: int, _debug: String) -> void:
	is_paused = true
	typing_sound.stream_paused = true
	var teemer: float
	
	if end == 1:
		teemer = 0.35 # 0.35
	else:
		teemer = 0.15 # 0.15
	
	await get_tree().create_timer(teemer).timeout
	is_paused = false
	typing_sound.stream_paused = false

func progress_text() -> void:
	dialogue_text.visible_ratio = 0
	dialogue_cont.hide()
	
	var texty: String = return_dialogue("%s%s" % [current_key, dialogue_progression])
	if texty != end_dialogue_signal:
		dialogue_text.text = texty
		is_displaying_text = true
		dialogue_progression += 1
		typing_sound.play()
	else:
		hide()
		dialoguing = false
		SignalBus.emit_signal("dialogue_ended", current_key) # shit. I should put this in AWoT


func _on_continue_pressed() -> void:
	progress_text()

func _input(event: InputEvent) -> void:
	if dialoguing:
		if event.is_action_pressed("player_something"):
			skip_or_dip()

# actually skips dialogue
func skip_or_dip() -> void:
	if is_displaying_text:
		dialogue_text.visible_ratio = 1
	else:
		progress_text()
