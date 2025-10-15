extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

var is_attacking: bool = false


func _ready() -> void:
	# Connect signals
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.frame_changed.connect(_on_frame_changed)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	
	# Disable attack area monitoring by default
	attack_area.monitoring = false


func _physics_process(delta: float) -> void:
	# Handle attack input
	if Input.is_action_just_pressed("ui_select") and not is_attacking:
		is_attacking = true
		animated_sprite.play("attack")
		return
	
	# Don't allow movement while attacking
	if is_attacking:
		move_and_slide()
		return
	
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
		animated_sprite.play("walk")
		flip_sprite(direction_x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x == 0 and direction_y == 0:
			animated_sprite.play("idle")
	
	if direction_y:
		velocity.y = direction_y * SPEED
		if direction_x == 0:
			animated_sprite.play("walk")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func flip_sprite(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true


func _on_frame_changed() -> void:
	# Only enable attack area monitoring on frame 3 of the attack animation
	if animated_sprite.animation == "attack":
		if animated_sprite.frame == 3:
			attack_area.monitoring = true
		else:
			attack_area.monitoring = false


func _on_animation_finished() -> void:
	# Reset attack state when attack animation finishes
	if animated_sprite.animation == "attack":
		is_attacking = false
		attack_area.monitoring = false
		animated_sprite.play("idle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	# Check if the body is an enemy and make it disappear
	if body.is_in_group("enemy") or body.name.begins_with("CharacterBody2D"):
		body.queue_free()
