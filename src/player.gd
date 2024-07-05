extends CharacterBody2D
class_name Player

enum States {IDLE, WALK, JUMP, HURT, SUCK, DUCK, FALL} #does not hold any information. just a way for us to understand names and to label stuff. The information is in the variable

@export var SPEED = 100.0
@export var JUMP_VELOCITY = -320.0
@export var friction = 10
@export var health = 8
var state: States = States.JUMP #The same as writing 0. By defining the variable as an enum, it makes it as a integer
var is_player_being_hurt: bool = false
var direction: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
@onready var hit_shape = $HitArea/HitShape
@onready var hurt_shape = $HurtArea/HurtShape
@onready var _movement_controller = $MovementController as MovementController #as class. Gives suggestions for autocompletion thats in the class's script


func _ready():
	add_to_group("Player")
	_movement_controller.set_owners(self)
	
func _physics_process(delta):
	#
	#if direction > 0: 
		#sprite.flip_h = false
	#
	#if direction < 0: 
		#sprite.flip_h = true
	#
	#if direction != 0:
		#velocity.x = move_toward(velocity.x, direction * SPEED, 35) #first: start. second argument: is what move_toward is moving towards. third argument: how fast we are getting to the destination
	#else:
		#velocity.x = move_toward(velocity.x, 0, friction)


	#if is_on_floor():
		#var current_y_velocity = velocity.y
	#
	#if not is_on_floor(): 
		#velocity.y += gravity * delta
		#state = States.FALL

	_do_animation()
	move_and_slide()

	

func _do_animation():
	if state == States.JUMP:
		if velocity.y < 0:
			sprite.play("jump_up")
		elif velocity.y > 0:
			sprite.play("jump_down")
			
	
	if state == States.WALK and is_on_floor():
		sprite.play("walk")
	elif state == States.IDLE and is_on_floor():
		sprite.play("idle")
	



func _on_hit_area_area_entered(area):
	is_player_being_hurt = true
	$BeingHit.start()
	var hit_vector = Vector2(0,0)
	if area.global_position.x > position.x: #position = player position. If the enemies global_position is more to the right than the player, do this
		hit_vector.x = -200
		
	else:
		hit_vector.x = 200
		
	velocity += hit_vector
	health -= 1
	on_hit()
	


func on_hit():
	
	#hit_shape.set_deferred("disabled", true)
	hurt_shape.set_deferred("disabled", false)
	$IFrames.start()
	print("hit by enemy")
	print(health)

func _on_i_frames_timeout():
	#hit_shape.set_deferred("disabled", false)
	hurt_shape.set_deferred("disabled", true)
	print("timer stop")


func _on_being_hit_timeout():
	is_player_being_hurt = false
