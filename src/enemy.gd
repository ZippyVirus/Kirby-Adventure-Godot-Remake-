extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction:int = -1
@export var speed = 25
@onready var ray_cast_2d = $RayCast2D
@onready var sprite = $AnimatedSprite2D



func _ready():
	add_to_group("Enemies")
	

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction * speed
	$AnimatedSprite2D.play("walk")
	
	if ray_cast_2d.is_colliding():
		sprite.flip_h = not sprite.flip_h
		direction *= -1
		ray_cast_2d.target_position.x *= -1
		
	move_and_slide()


func _on_hurt_area_body_entered(body):
	if body.is_in_group("Player"):
		body.on_hit()
		
