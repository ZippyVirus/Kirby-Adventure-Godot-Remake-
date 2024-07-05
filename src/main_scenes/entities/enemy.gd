extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction:int = -1
var _is_moving_towards_mouth:bool = false
var suck_vector:Vector2

@export var speed = 25
@onready var ray_cast_2d = $RayCast2D
@onready var sprite = $AnimatedSprite2D



func _ready():
	add_to_group("Enemies")
	

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if _is_moving_towards_mouth == true:
		velocity = suck_vector
	else:
		velocity.x = direction * speed
		$AnimatedSprite2D.play("walk")
	
	if ray_cast_2d.is_colliding():
		sprite.flip_h = not sprite.flip_h
		direction *= -1
		ray_cast_2d.target_position.x *= -1
		
	
	
	
	move_and_slide()


func _on_hurt_area_body_entered(body):
	if body.is_in_group("Player"):
		#body.on_hit()
		pass

#func _on_suck(mouth_position):
	#print("suck")
	#print(mouth_position)
	#_move_towards_mouth(mouth_position)

func _move_towards_mouth(mouth_position):
	
	suck_vector = mouth_position - self.global_position
	_is_moving_towards_mouth = true
	print(suck_vector)
	return suck_vector
	
	
func _on_hit():
	queue_free()




