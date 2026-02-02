extends Node

enum Phase {OUTBOUND, RETURN, FINISHED}
var phase = Phase.OUTBOUND

var time: float = 0.0
var recorded_time: float = 0.0
var running: bool = false
var game_over := false


func _ready() -> void:
	outbound()
	print("GameTimer outoloaded")

func _process(delta: float) -> void:
	if not running:
		return
	
	# Update timer
	if phase == Phase.OUTBOUND:
		time += delta
	elif phase == Phase.RETURN:
		time -= delta
		time = max(time, 0)
		
	# Debug key - Space, Timer starts to go downwards
	#if Input.is_action_just_pressed("ui_accept"):
		#if phase == Phase.OUTBOUND:
			#reach_dest()
	
	# Debug key - R, We reach the start before the time runs out
	#if Input.is_action_just_pressed("debug_reach_start"):
		#if phase == Phase.RETURN:
			#reach_start()
			
	if time_up() and not game_over:
		fail_game()
		
			
func outbound():
	phase = Phase.OUTBOUND
	time = 0.0
	running = true
	
func reach_dest():
	recorded_time = time
	phase = Phase.RETURN
	time = recorded_time
	print("Reached destination in ", format_time(recorded_time))
		
func reach_start() -> void:
	end_game("SUCCESS")
	
func fail_game() -> void:
	game_over = true
	get_tree().paused = false
	end_game("FAILED")
	get_tree().change_scene_to_file("res://deathscreen 2/death_screen.tscn")
	
func end_game(result: String) -> void:
	running = false
	phase = Phase.FINISHED
	print("Game over: ", result)
	
func time_up() -> bool:
	return phase == Phase.RETURN and time <= 0		
	
func format_time(seconds_float: float) -> String:
	var total := int(seconds_float)
	var minutes := total / 60
	var seconds := total % 60
	return "%02d:%02d" % [minutes, seconds]
	
	
