@tool
extends EditorPlugin


#const STORED_SECTIONS_PATH : String = "res://project_time_traker.json"

var _dock_instance : Control
var _timer_afk : Timer

var _main_screen : String = "3D"
var _window : Window = null


func _enter_tree():
	var key = "project_time_traker/general/file/name"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, "project_time_traker")
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, "project_time_traker")
	
	key = "project_time_traker/general/file/location"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, "Project (res://)")
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Project (res://),User data (user://),Custom"
	})
	ProjectSettings.set_initial_value(key, "Project (res://)")
	
	key = "project_time_traker/general/file/custom"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, "")
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
	})
	ProjectSettings.set_initial_value(key, "")
	
	key = "project_time_traker/sections/show_sections"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, true)
	
	key = "project_time_traker/sections/show_graphs"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, true)
		
	key = "project_time_traker/sections/use_external"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, false)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, false)
	
	key = "project_time_traker/sections/colors/2D"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.DEEP_SKY_BLUE)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.DEEP_SKY_BLUE)
	
	key = "project_time_traker/sections/colors/3D"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.CORAL)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.CORAL)
	
	key = "project_time_traker/sections/colors/Script"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.YELLOW)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.YELLOW)
		
	key = "project_time_traker/sections/colors/Game"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.FIREBRICK)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.FIREBRICK)
	
	key = "project_time_traker/sections/colors/AssetLib"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.MEDIUM_SEA_GREEN)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})		
	ProjectSettings.set_initial_value(key, Color.MEDIUM_SEA_GREEN)
	
	key = "project_time_traker/sections/colors/External"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.MEDIUM_PURPLE)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.MEDIUM_PURPLE)
		
	key = "project_time_traker/sections/colors/AFK"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.GRAY)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.GRAY)
	
	key = "project_time_traker/sections/colors/Other"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.WHITE)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.WHITE)
		
	key = "project_time_traker/afk/afk_timer"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, 300)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, 300)
			
	key = "project_time_traker/afk/use_afk"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, true)
		
	_timer_afk = Timer.new()
	_timer_afk.wait_time = ProjectSettings.get_setting("project_time_traker/afk/afk_timer", 300)
	_timer_afk.one_shot = true
	_timer_afk.timeout.connect(_on_timer_afk_timeout)
	add_child(_timer_afk)	
	
	_dock_instance = preload("res://addons/project-time-tracker/TrackerDock.tscn").instantiate()
	_dock_instance.name = "Project Time Tracker"
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, _dock_instance)
	
	_load_sections()
	
	main_screen_changed.connect(_on_main_screen_changed)
	get_editor_interface().set_main_screen_editor("3D")


func _ready() -> void:
	ProjectSettings.settings_changed.connect(
	func():
		_timer_afk.wait_time = ProjectSettings.get_setting("project_time_traker/afk/afk_timer", 300)
		_set_afk_timer(true)
	)
	
	_set_afk_timer(true)
	

func _exit_tree():
	_store_sections()
	remove_control_from_docks(_dock_instance)
	_dock_instance.queue_free()


func _make_visible(visible):
	if _dock_instance:
		_dock_instance.visible = visible


func _save_external_data():
	_store_sections()


func _get_plugin_icon():
	return preload("res://addons/project-time-tracker/icon.png")


func _load_sections() -> void:
	var path = _file_path()
	
	if (!FileAccess.file_exists(path)):
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Failed to open file '" + path + "' for reading: Error code " + str(error))
		return
	
	var json = JSON.new()
	var parse_result = json.parse_string(file.get_as_text())
	var parse_error = json.get_error_message()
	if (parse_error != ""):
		printerr("Failed to parse tracked sections: Error code " + parse_error)
	else:
		_dock_instance.restore_tracked_sections(parse_result)
	
	file.close()


func _store_sections() -> void:
	var tracked_sections = _dock_instance.get_tracked_sections()
	var stored_string = JSON.stringify(tracked_sections, "  ")
	
	var path = _file_path()
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Failed to open file '" + path + "' for writing: Error code " + str(error))
		return
	
	file.store_string(stored_string)
	error = file.get_error()
	if (error != OK):
		printerr("Failed to store tracked sections: Error code " + str(error))
	
	file.close()


func _on_main_screen_changed(main_screen: String) -> void:
	if (_dock_instance && is_instance_valid(_dock_instance)):
		_dock_instance.set_main_view(main_screen)
		_main_screen = main_screen


func _set_afk_timer(status: bool):
	if status and ProjectSettings.get_setting("project_time_traker/afk/use_afk", true):
		_timer_afk.start()
	else:
		_timer_afk.stop()
		
func _on_timer_afk_timeout() -> void:
	if (_dock_instance && is_instance_valid(_dock_instance)):
		_dock_instance.set_main_view("AFK")


func _file_path() -> String:
	var path: String
	match ProjectSettings.get_setting("project_time_traker/general/file/location", "Project (res://)"):
		"Project (res://),":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting("project_time_traker/general/file/custom", "") + "/"
			
	path += ProjectSettings.get_setting("project_time_traker/general/file/name", "project_time_traker")
	path += ".json"
	return path


func _connected_window_input(event: InputEvent):
	if not _window:
		return
		
	if EditorInterface.is_playing_scene():
		return
		
	if _window.title.begins_with("Script Editor"):
		_dock_instance.set_main_view("Script")
	else:
		_dock_instance.set_main_view(_main_screen)	
		
	_set_afk_timer(true)


func _process(delta):
	if (_dock_instance && is_instance_valid(_dock_instance)):
		
		if EditorInterface.is_playing_scene():
			_dock_instance.set_main_view("Game")
			_set_afk_timer(true)
			return


		_window = Window.get_focused_window()
		if not _window:
			if ProjectSettings.get_setting("project_time_traker/sections/use_external", true):
				_dock_instance.set_main_view("External")
			else:
				_dock_instance.pause_tracking()
			_set_afk_timer(false)
		
		else:
			_dock_instance.resume_tracking()

			if not _window.window_input.is_connected(_connected_window_input):
				_window.window_input.connect(_connected_window_input)
		
