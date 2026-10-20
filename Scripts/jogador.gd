
extends CharacterBody3D

const VELOCIDADE = 5.0
const FORCA_PULO = 4.5
const GRAVIDADE = 9.8

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVIDADE * delta

	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = FORCA_PULO

	var direcao := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direcao.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		direcao.z += 1.0
	if Input.is_key_pressed(KEY_A):
		direcao.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direcao.x += 1.0

	direcao = direcao.normalized()

	velocity.x = direcao.x * VELOCIDADE
	velocity.z = direcao.z * VELOCIDADE

	move_and_slide()
