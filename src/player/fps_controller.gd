extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var _look_dir: Vector2
var _camera_sens = 50

@onready var _eye_position = $EyePosition
@onready var _forward_raycast
@onready var _mouse_sensitivity = GameInput.Settings["MouseSensitivity"]


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Game.focus_state == Globals.FocusState.UIOnly:
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("MoveBackward", "MoveForward", "MoveLeft", "MoveRight")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_rotate_view(delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Game.focus_state == Globals.FocusState.UIOnly:
		return
		
	if event is InputEventMouseMotion:  _look_dir = event.relative * 0.01

func _rotate_view(delta: float): 
	var input = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	_look_dir += input
	
	rotation.y -= _look_dir.x * _camera_sens * delta
	_eye_position.rotation.x = (_inverted_look()) * clamp(_eye_position.rotation.x - _look_dir.y * _camera_sens * _mouse_sensitivity * delta, -1.5, 1.5)
	_look_dir = Vector2.ZERO

func _inverted_look() -> float:
	if GameInput.Settings["InvertLook"]:
		return -1.0
	return 1.0
