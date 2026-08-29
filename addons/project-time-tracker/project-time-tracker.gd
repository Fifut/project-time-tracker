@tool
extends EditorPlugin


var _dock_instance: Control
var _event_manager: Node
var _timer_afk: Timer

var _main_screen_buttons: Array[Button] = []


func _enter_tree():
	var key = "project_time_tracker/general/file/name"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, "project_time_tracker")
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, "project_time_tracker")
	
	key = "project_time_tracker/general/file/location"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, "Project (res://)")
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Project (res://),User data (user://),Custom"
	})
	ProjectSettings.set_initial_value(key, "Project (res://)")
	
	key = "project_time_tracker/general/file/custom"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, "")
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
	})
	ProjectSettings.set_initial_value(key, "")
	
	key = "project_time_tracker/sections/show_sections"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, true)
	
	key = "project_time_tracker/sections/show_graphs"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, true)
		
	key = "project_time_tracker/sections/use_external"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, false)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, false)
	
	key = "project_time_tracker/sections/colors/2D"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.DEEP_SKY_BLUE)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.DEEP_SKY_BLUE)
	
	key = "project_time_tracker/sections/colors/3D"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.CORAL)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.CORAL)
	
	key = "project_time_tracker/sections/colors/Script"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.YELLOW)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.YELLOW)
		
	key = "project_time_tracker/sections/colors/Game"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.FIREBRICK)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, Color.FIREBRICK)
	
	key = "project_time_tracker/sections/colors/Asset Store"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.MEDIUM_SEA_GREEN)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})		
	ProjectSettings.set_initial_value(key, Color.MEDIUM_SEA_GREEN)
	
	key = "project_time_tracker/sections/colors/External"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.MEDIUM_PURPLE)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.MEDIUM_PURPLE)
		
	key = "project_time_tracker/sections/colors/AFK"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.SLATE_GRAY)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.SLATE_GRAY)
	
		
	key = "project_time_tracker/sections/colors/Documentation"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.LIGHT_PINK)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.LIGHT_PINK)
	
	key = "project_time_tracker/sections/colors/Other"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.WHITE)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, Color.WHITE)
		
	key = "project_time_tracker/afk/afk_timer"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, 300)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, 300)
			
	key = "project_time_tracker/afk/use_afk"
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, true)
	
	_event_manager = preload("res://addons/project-time-tracker/events_manager.gd").new()
	add_child(_event_manager)	
	
	_timer_afk = Timer.new()
	_timer_afk.wait_time = ProjectSettings.get_setting("project_time_tracker/afk/afk_timer", 300)
	_timer_afk.one_shot = true
	add_child(_timer_afk)	
	
	_dock_instance = preload("res://addons/project-time-tracker/TrackerDock.tscn").instantiate()
	_dock_instance.name = "Project Time Tracker"
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, _dock_instance)
	
	_load_sections()
	

func _exit_tree():
	_store_sections()	# https://github.com/godotengine/godot/issues/118929
	remove_control_from_docks(_dock_instance)
	_dock_instance.queue_free()


func _ready() -> void:
	# Get main screen buttons (2D, 3D, Script, etc;)
	_get_main_screen_buttons()
	
	# If project parameters have changed maybe they're ours.
	ProjectSettings.settings_changed.connect(
	func():
		_timer_afk.wait_time = ProjectSettings.get_setting("project_time_tracker/afk/afk_timer", 300)
	)
	
	# Signal from 2D, 3D, Script, Game, etc. workspace
	main_screen_changed.connect(
		func(screen_name):
			_dock_instance.set_tracked_section(screen_name)
	)
	
	# Signal from Godot focused windows
	_event_manager.on_focused_window.connect(
		func(window_name):
			
			# Main Godot window
			if window_name == ProjectSettings.get_setting("application/config/name"):
				_dock_instance.set_tracked_section(_get_main_screen_button_is_pressed() )
				
			# Floating script editor
			elif window_name.begins_with("Script Editor"):
				_dock_instance.set_tracked_section("Script")
			
			# Maybe an external editor
			elif window_name == "External":
				_timer_afk.stop()
				if ProjectSettings.get_setting("project_time_tracker/sections/use_external", false):
					_dock_instance.set_tracked_section("External")
				else:
					_dock_instance.pause_tracking()
	)
	
	# Signal from any input in any Godot windows
	_event_manager.on_input_event.connect(
		func():
			# In case of input come after "AFK"
			if _dock_instance.get_tracked_section() == "AFK":
				_dock_instance.set_tracked_section(_get_main_screen_button_is_pressed() )
			
			# In case of input come after "External"
			_timer_afk.start()
			_dock_instance.resume_tracking()
	)
	
	# Signal from project or scene running
	_event_manager.on_playing_scene.connect(
		func():
			_dock_instance.set_tracked_section("Game")
	)
	
	# Signal from project or scene stopping
	_event_manager.on_stopping_scene.connect(
		func():
			pass
	)
	
	# Signal from AFK timer
	_timer_afk.timeout.connect(
		func():
			if ProjectSettings.get_setting("project_time_tracker/afk/use_afk", true):
				_dock_instance.subtract_to_current_section(ProjectSettings.get_setting("project_time_tracker/afk/afk_timer", 300) )
				_dock_instance.set_tracked_section("AFK")
	)
	
	_timer_afk.start()



# #######################################
# Editor pluging methods
# #######################################
func _make_visible(visible):
	if _dock_instance:
		_dock_instance.visible = visible


func _save_external_data():
	_store_sections()


func _get_plugin_icon():
	return preload("res://addons/project-time-tracker/icon.png")



# #######################################
# Private methods
# #######################################
func _load_sections() -> void:
	var path = _file_path()
	
	if (!FileAccess.file_exists(path)):
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Project Time Tracker : Failed to open file '" + path + "' for reading (Error " + str(error) + ")")
		return
	
	var json = JSON.new()
	var parse_result = json.parse_string(file.get_as_text())
	var parse_error = json.get_error_message()
	file.close()
	
	if (parse_error != ""):
		printerr("Project Time Tracker : Failed to parse tracked sections (Error " + parse_error + ")")
		return
		
	_dock_instance.restore_tracked_sections(parse_result)



func _store_sections() -> void:
	var tracked_sections = _dock_instance.get_tracked_sections()
	var stored_string = JSON.stringify(tracked_sections, "  ")
	
	var path = _file_path()
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Failed to open file '" + path + "' for writing (Error " + str(error) + ")")
		return
	
	file.store_string(stored_string)
	error = file.get_error()
	if (error != OK):
		printerr("Failed to store tracked sections (Error " + str(error) + ")")
	
	file.close()

		
func _file_path() -> String:
	var path: String
	match ProjectSettings.get_setting("project_time_tracker/general/file/location", "Project (res://)"):
		"Project (res://),":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting("project_time_tracker/general/file/custom", "") + "/"
			
	path += ProjectSettings.get_setting("project_time_tracker/general/file/name", "project_time_tracker")
	path += ".json"
	return path


# Which button on the main screen (2D, 3D, script, etc.) is being pressed
func _get_main_screen_button_is_pressed() -> String:
	for button in _main_screen_buttons:
		if button.button_pressed:
			return button.name
	return ""


# Originally, it was: _on_editor_base_ready() in Godot-Time-Tracker
# I had to make some changes and corrections
func _get_main_screen_buttons() -> void:
	var editor_base = EditorInterface.get_base_control()
	if (!editor_base.is_inside_tree() || editor_base.get_child_count() == 0):
		return

	# Find the main VBoxContainer node.
	var editor_main_vbox
	for child_node in editor_base.get_children():
		if (child_node.get_class() == "VBoxContainer"):
			editor_main_vbox = child_node
			break
	if (!editor_main_vbox || !is_instance_valid(editor_main_vbox)):
		return
	if (editor_main_vbox.get_child_count() == 0):
		return

	# Find the top menu bar.
	var editor_menu_hb
	for child_node in editor_main_vbox.get_children():
		if (child_node.get_class() == "EditorTitleBar"):
			editor_menu_hb = child_node
			break
	if (!editor_menu_hb || !is_instance_valid(editor_menu_hb)):
		return
	if (editor_menu_hb.get_child_count() == 0):
		return

	# Find the main screen bar with main screen buttons.
	var editor_main_button_hb
	for child_node in editor_menu_hb.get_children():
		if (child_node.get_child_count() == 0):
			continue
		if (!(child_node is HBoxContainer)):
			continue

		var potential_button = child_node.get_child(0)
		if (!(potential_button is Button)):
			continue
		# 2D or 3D is pretty much guaranteed to be there. We have to check it
		# this way because there may be other HBoxContainers or another number
		# of them. Namely on macOS.
		if (potential_button.text != "2D" && potential_button.text != "3D"):
			continue

		editor_main_button_hb = child_node
		break
	if (!editor_main_button_hb || !is_instance_valid(editor_main_button_hb)):
		return
	var main_screen_buttons = editor_main_button_hb.get_children()

	_main_screen_buttons.clear()
	for button_node in main_screen_buttons:
		if (button_node is Button):
			_main_screen_buttons.append(button_node)
