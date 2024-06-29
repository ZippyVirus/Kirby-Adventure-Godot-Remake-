extends CharacterBody2D
class_name Player

enum States {IDLE, WALK, JUMP, HURT, SUCK, DUCK, FALL}

@export var health = 8

var _state: States = States.JUMP 

@onready var _sprite = $AnimatedSprite2D
@onready var _movementController = $MovementController

func _ready():
	add_to_group("Player")
	_movementController.set_controlled_owner(self)
	
func _physics_process(delta):
	print(_state)
	_do_animation()
	move_and_slide()
	_set_states()

func _set_states() -> void:
	if velocity.x == 0 and is_on_floor():
		_state = States.IDLE
	if velocity.x != 0 and is_on_floor():
		_state = States.WALK

func _do_animation() -> void:
	if velocity.x > 0: 
		_sprite.flip_h = false
	if velocity.x < 0: 
		_sprite.flip_h = true
	if _state == States.JUMP:
		if velocity.y < 0:
			_sprite.play("jump_up")
		elif velocity.y > 0:
			_sprite.play("jump_down")
	if _state == States.WALK:
		_sprite.play("walk")
	if _state == States.IDLE:
		_sprite.play("idle")

func on_hit() -> void:
	pass

func _on_movement_controller_hit_ground():
	pass

func _on_movement_controller_jumped():
	_state = States.JUMP