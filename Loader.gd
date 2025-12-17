extends Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	create_folders()
	is_latest_version()

func create_folders():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://favorites"):
		dir.make_dir("user://favorites")
	if !dir.dir_exists("user://database"):
		dir.make_dir("user://database")
	if !dir.dir_exists("user://updates"):
		dir.make_dir("user://updates")

func is_latest_version() -> bool:
	var http = HTTPRequest.new()
	var headers = [
			"User-Agent: Pirulo/1.0 (Godot)",
			"Accept: */*"
		]
	add_child(http)
	http.request_completed.connect(on_latest_recieved)
	http.request("https://github.com/bflanagin/QAtalyst_distribution/releases/download/alpha/latest",headers,HTTPClient.METHOD_GET)
	return true
	
		
func load_program():
	$%Notification.text = "Loading"
	var loaded = ProjectSettings.load_resource_pack("user://updates/QAtalyst.pck",true)
	if loaded:
		var mw = ResourceLoader.load("res://main.tscn")
		get_tree().change_scene_to_packed(mw)
		

func get_update():
	$%Notification.text = "Downloading"
	$HTTPRequest.set_download_file("user://updates/QAtalyst.pck")
	var headers = [
			"User-Agent: Pirulo/1.0 (Godot)",
			"Accept: */*"
		]
	$HTTPRequest.request("https://github.com/bflanagin/QAtalyst_distribution/releases/download/alpha/QAtalyst.pck",headers,HTTPClient.METHOD_GET)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		load_program()


func on_latest_recieved(result, response_code, headers, body):
	var md5sum = ""
	if response_code == 200:
		md5sum = body.get_string_from_utf8().split(" ")[0]
	else:
		md5sum = ""
	if FileAccess.file_exists("user://updates/QAtalyst.pck"):
		if md5sum != FileAccess.get_md5("user://updates/QAtalyst.pck"):
			get_update()
		else:
			load_program()
	else:
		get_update()
