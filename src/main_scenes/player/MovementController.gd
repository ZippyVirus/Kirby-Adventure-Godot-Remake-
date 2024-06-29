class_name MovementController
extends Node

signal jumped()
signal hit_ground()

enum JumpStates {NULL, JUMP}

@export var max_jump_height: float = 40: 
	set(value):
		max_jump_height = value
		_default_gravity = _calculate_gravity(max_jump_height, jump_duration)
		_jump_velocity = _calculate_jump_velocity(max_jump_height, jump_duration)
		_release_gravity_multiplier = _calculate_release_gravity_multiplier(
				_jump_velocity, min_jump_height, _default_gravity)
@export var min_jump_height: float = 15: 
	set(value):
		min_jump_height = value
		_release_gravity_multiplier = _calculate_release_gravity_multiplier(
				_jump_velocity, min_jump_height, _default_gravity)
@export var jump_duration: float = 0.3:
	set(value):
		jump_duration = value
		_default_gravity = _calculate_gravity(max_jump_height, jump_duration)
		_jump_velocity = _calculate_jump_velocity(max_jump_height, jump_duration)
		_release_gravity_multiplier = _calculate_release_gravity_multiplier(
				_jump_velocity, min_jump_height, _default_gravity)
@export var falling_gravity_multiplier = 1.5
@export var max_acceleration = 10000
@export var friction = 20

const INPUT_LEFT : String = "left"
const INPUT_RIGHT : String = "right"
const INPUT_JUMP : String = "jump"

var _owner : CharacterBody2D
var _jump_state : JumpStates
var _was_on_ground: bool
var _holding_jump := false
var _acceleration = Vector2()
var _default_gravity : float
var _jump_velocity : float
var _release_gravity_multiplier : float


func _init():
	_default_gravity = _calculate_gravity(max_jump_height, jump_duration)
	_jump_velocity = _calculate_jump_velocity(max_jump_height, jump_duration)
	_release_gravity_multiplier = _calculate_release_gravity_multiplier(
			_jump_velocity, min_jump_height, _default_gravity)

func _unhandled_input(event):
	_acceleration.x = 0
	if Input.is_action_pressed(INPUT_LEFT):
		_acceleration.x = -max_acceleration
	if Input.is_action_pressed(INPUT_RIGHT):
		_acceleration.x = max_acceleration
	if Input.is_action_just_pressed(INPUT_JUMP):
		_holding_jump = true
		_try_jump()
	if Input.is_action_just_released(INPUT_JUMP):
		_holding_jump = false

func _physics_process(delta):
	_on_hit_ground()
	var gravity = _get_modified_gravity(_default_gravity)
	_acceleration.y = gravity
	_owner.velocity.x *= 1 / (1 + (delta * friction))
	_owner.velocity += _acceleration * delta
	_was_on_ground = _is_on_ground()

func _on_hit_ground() -> void:
	if not _was_on_ground and _is_on_ground():
		_jump_state = JumpStates.NULL
		hit_ground.emit()

func _try_jump() -> void:
	if not _can_jump():
		return
	_jump()

func _can_jump() -> bool:
	if _jump_state == JumpStates.NULL:
		return true
	return false

func _is_on_ground() -> bool:
	if _owner.is_on_floor() :
		return true
	return false

func _jump():
	_owner.velocity.y = - _jump_velocity
	_jump_state = JumpStates.JUMP
	jumped.emit()

func _get_modified_gravity(gravity: float) -> float:
	# falling
	if _owner.velocity.y * sign(_default_gravity) > 0: 
		gravity *= falling_gravity_multiplier
	
	# if we released jump and are still rising
	elif _owner.velocity.y * sign(_default_gravity) < 0:
		if not _holding_jump: 
			gravity *= _release_gravity_multiplier 
			
	return gravity

func _calculate_gravity(p_max_jump_height, p_jump_duration) -> float:
	return (2 * p_max_jump_height) / pow(p_jump_duration, 2)

func _calculate_jump_velocity(p_max_jump_height, p_jump_duration) -> float:
	return (2 * p_max_jump_height) / (p_jump_duration)

func _calculate_jump_velocity2(p_max_jump_height, p_gravity):
	return sqrt(abs(2 * p_gravity * p_max_jump_height)) * sign(p_max_jump_height)

func _calculate_release_gravity_multiplier(p_jump_velocity, p_min_jump_height, p_gravity) -> float:
	var release_gravity = pow(p_jump_velocity, 2) / (2 * p_min_jump_height)
	return release_gravity / p_gravity

func _calculate_friction(time_to_max) -> float:
	return 1 - (2.30259 / time_to_max)

func _calculate_speed(p_max_speed, p_friction) -> float:
	return (p_max_speed / p_friction) - p_max_speed


func set_controlled_owner(owner: CharacterBody2D) -> void:
		_owner = owner
