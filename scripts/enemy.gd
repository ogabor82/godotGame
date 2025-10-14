extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var player: CharacterBody2D

func _ready() -> void:
	# Cache reference to the Player (assumes Player and Enemy share the same parent)
	var parent := get_parent()
	if parent and parent.has_node("Player"):
		player = parent.get_node("Player")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Face the player only while the player is moving horizontally
	if player.position.x < position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


	move_and_slide()
