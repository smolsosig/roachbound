extends CharacterBody2D

@export var speed : float = 900.0
@export var anim_sprite: AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if GameManager.can_move:
		direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
		velocity = direction * speed
		
		if move_and_slide():
			resolve_collisions()
		update_facing_direction()

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)

func update_facing_direction() -> void:
	if direction.x > 0:
		anim_sprite.flip_h = true
	elif direction.x < 0:
		anim_sprite.flip_h = false
