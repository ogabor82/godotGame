extends CanvasLayer

var survived_time: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_survived_time_timer_timeout() -> void:
	survived_time += 1
	$SurvivedTimeLabel.text = "Survived Time: %s" % survived_time
