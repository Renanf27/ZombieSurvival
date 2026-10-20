extends CharacterBody3D

const VELOCIDADE = 5.0
const FORCA_PULO = 4.5
const GRAVIDADE = 9.8

@export var sensibilidade_mouse: float = 0.003

@onready var braco_camera: SpringArm3D = $SpringArm3D

var rotacao_vertical: float = deg_to_rad(-15.0)


func _ready() -> void:
	braco_camera.rotation.x = rotacao_vertical
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * sensibilidade_mouse)

			rotacao_vertical -= event.relative.y * sensibilidade_mouse
			rotacao_vertical = clamp(
				rotacao_vertical,
				deg_to_rad(-60.0),
				deg_to_rad(35.0)
			)

			braco_camera.rotation.x = rotacao_vertical

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y -= GRAVIDADE * delta

	# Pulo
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = FORCA_PULO

	# Entrada do teclado
	var entrada := Vector2.ZERO

	if Input.is_key_pressed(KEY_W):
		entrada.y -= 1.0
	if Input.is_key_pressed(KEY_S):
		entrada.y += 1.0
	if Input.is_key_pressed(KEY_A):
		entrada.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		entrada.x += 1.0

	entrada = entrada.normalized()

	# Direção baseada na rotação do jogador
	var direcao = transform.basis * Vector3(
		entrada.x,
		0.0,
		entrada.y
	)

	direcao.y = 0.0
	direcao = direcao.normalized()

	# Aplicar movimento
	velocity.x = direcao.x * VELOCIDADE
	velocity.z = direcao.z * VELOCIDADE

	move_and_slide()
