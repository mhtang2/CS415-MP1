extends Node
@export var enemy_scene: PackedScene
@export var health_scene: PackedScene
@export var star_scene: PackedScene

var speed = 10
var health
var score
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hit():
	health-=1
	health = clamp(health,0,100)
	$HUD.update_health(health)
	if health <=0:
		game_over()
		$Player.hide()

func game_over():
	$ScoreTimer.stop()
	$EnemySpawn.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	speed = 0
	health =5
	$Player.start($SpawnPosition.position)
	$GameStart.start()
	$HUD.update_score(score)
	$HUD.update_health(health)
	$HUD.show_message("Get Ready")
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("healths", "queue_free")
	get_tree().call_group("stars", "queue_free")


func _on_enemy_spawn_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = $ObjectSpawnPosition.position
	enemy.position.x = randf_range(50,480)
	add_child(enemy)
	
	await get_tree().create_timer(randf_range(1,3)).timeout
	var r = randf()
	if r <= 0.3333:
		var hp = health_scene.instantiate()
		hp.position = $ObjectSpawnPosition.position
		hp.position.x = randf_range(50,480)
		add_child(hp)
	elif r <= 0.5:
		var star = star_scene.instantiate()
		star.position = $ObjectSpawnPosition.position
		star.position.x = randf_range(50,480)
		add_child(star)		



func _on_score_timer_timeout():
	score += 1
	speed += 10
	for member in get_tree().get_nodes_in_group("enemies"):
		member.linear_velocity.y=speed
	for member in get_tree().get_nodes_in_group("healths"):
		member.linear_velocity.y=speed
	for member in get_tree().get_nodes_in_group("stars"):
		member.linear_velocity.y=speed
	$HUD.update_score(score)


func _on_game_start_timeout():
	$EnemySpawn.start()
	$ScoreTimer.start()


func _on_hud_start_game():
	new_game()


func _on_player_heal():
	health += 1
	$HUD.update_health(health)
