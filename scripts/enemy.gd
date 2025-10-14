extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var player: CharacterBody2D
var collision_shape: CollisionShape2D

func _ready() -> void:
	# Cache reference to the Player (assumes Player and Enemy share the same parent)
	var parent := get_parent()
	if parent and parent.has_node("Player"):
		player = parent.get_node("Player")
	collision_shape = $CollisionShape2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Face the player only while the player is moving horizontally
	if player.position.x < position.x:
		sprite.flip_h = true
		collision_shape.scale.x = -1
		flip_sprite(-1)
	else:
		sprite.flip_h = false
		collision_shape.scale.x = 1
		flip_sprite(1)

	# move towards the player
	var direction = (player.position - position).normalized()
	velocity.x = direction.x * SPEED


	move_and_slide()

func flip_sprite(direction: float) -> void:
	if direction > 0:
		sprite.flip_h = false
		collision_shape.scale.x = 1
	else:
		sprite.flip_h = true
		collision_shape.scale.x = -1
