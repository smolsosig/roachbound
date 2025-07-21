extends Area2D
class_name CharlieTrigger

# DON'T FORGET TO EXTEND THIS SCRIPT RETARD

@export var anim_player: AnimationPlayer
@export var delay_before_playing: float
@export var repeatable: bool = false

var in_area: bool = false

func _ready() -> void:
	set_collision_layer(0)
	set_collision_mask(2)
	other_ready()
	
	self.connect("body_entered", _on_body_entered)
	
	if repeatable:
		self.connect("body_exited", _on_body_exited)
	
	if anim_player:
		anim_player.play("RESET")

# for when we also want to connect to another signal in extended script
func other_ready() -> void:
	pass

func reset() -> void:
	set_deferred("monitoring", true)
	if anim_player:
		anim_player.play("RESET")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Loki":
		if !repeatable:
			set_deferred("monitoring", false)
		else:
			in_area = true
		
		if delay_before_playing:
			do_shit_before()
			await get_tree().create_timer(delay_before_playing).timeout
		
		# this is non-negotiable. plus it helps to be convenient
		if anim_player:
			anim_player.play("init")
		
		do_shit()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Loki":
		do_shit_exit()
		in_area = false

# this is where you do custom shit. when extending the script, simply call
# do_shit() to do some extra shit that's not just playing an anim player
func do_shit() -> void:
	pass

# if there's a delay before the anim_player plays "init", and you want to do
# some custom shit like turning off weapon switching, etc., then this is the
# function for you.
#
# note that this is ONLY emitted if you have a delay. otherwise it's ignored.
# you have been warned.
func do_shit_before() -> void:
	pass

func do_shit_exit() -> void:
	pass
