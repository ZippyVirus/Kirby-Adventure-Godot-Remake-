extends Area2D

var velocity:Vector2
@export var speed:float = 5

func _process(delta):
	position.x += speed
	
	
#func shoot(direction):
	#velocity = direction * speed

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		print("hit enemy")
		emit_signal("area_entered")
		queue_free()
	if body is Player:
		pass
		
