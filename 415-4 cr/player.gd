extends Area2D

signal hit
signal heal
@export var player_speed = 500
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "walk"
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = 0
	if Input.is_action_pressed("move_right"):
		velocity = player_speed
	if Input.is_action_pressed("move_left"):
		velocity = - player_speed
	if abs(velocity) > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position.x += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		hit.emit()
		body.queue_free()
	if body.is_in_group("healths"):
		heal.emit()
		body.queue_free()
	if body.is_in_group("stars"):
		body.queue_free()
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.animation = "ghost"
		#hide()
		await get_tree().create_timer(5).timeout
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.animation = "walk"
		#show()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled=false
