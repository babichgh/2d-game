extends ParallaxBackground

var SPEED = 100

func _process(delta: float) -> void:
	scroll_offset.x -= SPEED * delta
