extends Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	create_folders()
	get_update()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_folders():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://favorites"):
		dir.make_dir("user://favorites")
	if !dir.dir_exists("user://database"):
		dir.make_dir("user://database")
	if !dir.dir_exists("user://updates"):
		dir.make_dir("user://updates")
		
func load_program():
	var loaded = ProjectSettings.load_resource_pack("user://updates/Qatalyst.pck",true)
	if loaded:
		var mw = ResourceLoader.load("res://main.tscn")
		get_tree().change_scene_to_packed(mw)
		

func get_update():
	$HTTPRequest.set_download_file("user://updates/Qatalyst.pck")
	var headers = [
			"User-Agent: Pirulo/1.0 (Godot)",
			"Accept: */*"
		]
	$HTTPRequest.request("https://github.com/bflanagin/QAtalyst_distribution/releases/download/alpha/QAtalyst.pck",headers,HTTPClient.METHOD_GET)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		load_program()
