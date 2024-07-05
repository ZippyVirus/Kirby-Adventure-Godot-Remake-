extends Node
class_name MovementController

enum JumpState {GROUND, AIR}
var jump_state: JumpState = 0

var _owner: CharacterBody2D

var _acceleration: Vector2
var _gravity = 100
var _friction = 5

func set_owners(owner):
	_owner = owner

func _physics_process(delta):
	
	_acceleration.y = _gravity
	print("incoming acceleration ", _acceleration.x, " Multiply by: ", 1/(1+ (delta * _friction)))
	_owner.velocity.x *= 1 / (1 + (delta * _friction))
	print("resulting acceleration: ", _acceleration.x)
	_owner.velocity += _acceleration * delta
	if _owner.is_on_floor():
		jump_state = JumpState.GROUND

func _unhandled_input(event):
	_acceleration.x = 0
	if Input.is_action_pressed("left"):
		_acceleration.x = -200
	if Input.is_action_pressed("right"):
		_acceleration.x = 200
	if Input.is_action_just_pressed("jump"):
		try_jump()
	
func try_jump():
	if jump_state == JumpState.GROUND:
		_owner.velocity.y = -100
		jump_state = JumpState.AIR
	
