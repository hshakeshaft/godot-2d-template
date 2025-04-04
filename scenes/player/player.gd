extends CharacterBody2D

enum MovementState {
	WALKING,
	SPRINTING,
}

const WALK_SPEED: float = 300
const SPRINT_SPEED: float = 700
@onready var movement_state := MovementState.WALKING
@onready var animated_sprite := $AnimatedSprite2D

func _ready() -> void:
	position = get_viewport_rect().size / 2
	return

func _physics_process(delta: float) -> void:
	var x_direction := get_x_axis()
	var y_direction := get_y_axis()
	set_character_direction(x_direction, y_direction)
	set_movement_state()
	set_player_velocity(delta, x_direction, y_direction)
	move_and_slide()
	return

func get_x_axis() -> float:
	return Input.get_axis("move_left", "move_right")

func get_y_axis() -> float:
	return Input.get_axis("move_up", "move_down")

func set_character_direction(x_dir: float, y_dir: float) -> void:
	if x_dir < 0:
		animated_sprite.play("left")
	elif x_dir > 0:
		animated_sprite.play("right")

	if y_dir < 0:
		animated_sprite.play("up")
	elif y_dir > 0:
		animated_sprite.play("down")
	
	if y_dir == 0 and x_dir == 0:
		animated_sprite.play("neutral")

	return

func set_player_velocity(delta: float, x_dir: float, y_dir: float) -> void:
	var speed := WALK_SPEED if movement_state == MovementState.WALKING else SPRINT_SPEED
	if x_dir:
		velocity.x = x_dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if y_dir:
		velocity.y = y_dir * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	return

func set_movement_state() -> void:
	if Input.is_action_just_pressed("sprint") or Input.is_action_pressed("sprint"):
		movement_state = MovementState.SPRINTING
	else:
		movement_state = MovementState.WALKING
	return
