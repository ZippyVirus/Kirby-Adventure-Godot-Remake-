extends CharacterBody2D
class_name Player

enum States {IDLE, WALK, JUMP, HURT, SUCK, DUCK, FALL, FULL}

@export var health = 8

var _state: States = States.JUMP 
var _shouldSuck: bool = false
var _currentlySucking: bool = false

@onready var _sprite = $AnimatedSprite2D
@onready var _movementController = $MovementController #module
@onready var _mouthPosition = $MouthArea/Mouth

func _ready():
	add_to_group("Player")
	_movementController.set_controlled_owner(self)
	
func _physics_process(delta):
	#print($SuckRadius.monitorable)
	if _state == States.SUCK:
		velocity.x = 0
	_do_animation()
	move_and_slide()
	_set_states()

func _unhandled_input(event):
	if Input.is_action_just_pressed("attack"):
		_state = States.SUCK
		_shouldSuck = true
		$SuckRadius.monitoring = true
		$SuckRadius.monitorable = true
	if Input.is_action_just_released("attack") and _currentlySucking == false:
		_shouldSuck = false
		_sprite.play_backwards("suck")
		$SuckRadius.monitoring = true
		$SuckRadius.monitorable = false


func _set_states() -> void:
	if _shouldSuck == true:
		_state = States.SUCK
		
	
	if velocity.x == 0 and is_on_floor():
		if _shouldSuck == false:
			_state = States.IDLE
		else:
			pass
		
	if velocity.x != 0 and is_on_floor():
		if _shouldSuck == false:
			_state = States.WALK
		else:
			pass

func _do_animation() -> void:
	if velocity.x > 0: 
		_sprite.flip_h = false
		$SuckRadius.scale = Vector2(1,1)
	if velocity.x < 0: 
		_sprite.flip_h = true
		$SuckRadius.scale = Vector2(-1, 1)
	if _state == States.JUMP:
		if velocity.y < 0:
			_sprite.play("jump_up")
		elif velocity.y > 0:
			_sprite.play("jump_down")
	if _state == States.WALK:
		_sprite.play("walk")
	if _state == States.IDLE:
		_sprite.play("idle")
	if _state == States.SUCK:
		_sprite.play("suck")
		$AnimatedSprite2D.offset.y = -3
	else:
		$AnimatedSprite2D.offset.y = 0

func on_hit() -> void:
	pass

func _on_movement_controller_hit_ground():
	pass

func _on_movement_controller_jumped():
	_state = States.JUMP

func _on_suck_radius_body_entered(body):
	print("go")
	_currentlySucking = true
	body._move_towards_mouth(_mouthPosition.global_position)


func _on_suck_radius_body_exited(body):
	_currentlySucking = false
