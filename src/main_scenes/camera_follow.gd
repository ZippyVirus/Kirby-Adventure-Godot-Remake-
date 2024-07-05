extends Camera2D


@export var target:CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = target.position.x
	
