extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		velocity.x = direction_x * SPEED
		$AnimatedSprite2D.play("walk")
		flip_sprite(direction_x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x == 0 and direction_y == 0:
			$AnimatedSprite2D.play("idle")
	
	if direction_y:
		velocity.y = direction_y * SPEED
		if direction_x == 0:
			$AnimatedSprite2D.play("walk")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func flip_sprite(direction: float) -> void:
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
