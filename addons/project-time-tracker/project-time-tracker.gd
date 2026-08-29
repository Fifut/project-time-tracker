@tool
extends EditorPlugin


var _dock_instance: Control
var _event_manager: Node
var _settings_manager: Node
var _timer_afk: Timer

var _main_screen_buttons: Array[Button] = []


func _enter_tree():
	_settings_manager = preload("res://addons/project-time-tracker/settings_manager.gd").new()
	add_child(_settings_manager)	
	
	_event_manager = preload("res://addons/project-time-tracker/events_manager.gd").new()
	add_child(_event_manager)	
	
	_timer_afk = Timer.new()
	_timer_afk.wait_time = ProjectSettings.get_setting(
		ProjectTimeTrackerSettingsManager.AFK_TIMER,
		ProjectTimeTrackerSettingsManager.AFK_TIMER_DEFAULT
		)
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
		_timer_afk.wait_time = ProjectSettings.get_setting(
			ProjectTimeTrackerSettingsManager.AFK_TIMER,
			ProjectTimeTrackerSettingsManager.AFK_TIMER_DEFAULT
			)
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
				if ProjectSettings.get_setting(
					ProjectTimeTrackerSettingsManager.SECTIONS_USE_EXTERNAL,
					ProjectTimeTrackerSettingsManager.SECTIONS_USE_EXTERNAL_DEFAULT
					):
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
			if ProjectSettings.get_setting(
				ProjectTimeTrackerSettingsManager.AFK_USE_AFK,
				ProjectTimeTrackerSettingsManager.AFK_USE_AFK_DEFAULT
				):
				_dock_instance.subtract_to_current_section(
					ProjectSettings.get_setting(
						ProjectTimeTrackerSettingsManager.AFK_TIMER,
						ProjectTimeTrackerSettingsManager.AFK_TIMER_DEFAULT
						)
					)
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
	match ProjectSettings.get_setting(
		ProjectTimeTrackerSettingsManager.SAVE_FILE_LOCATION,
		ProjectTimeTrackerSettingsManager.SAVE_FILE_LOCATION_DEFAULT
		):
		"Project (res://),":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting(
				ProjectTimeTrackerSettingsManager.SAVE_FILE_CUSTOM_LOCATION,
				ProjectTimeTrackerSettingsManager.SAVE_FILE_CUSTOM_LOCATION_DEFAULT
				) + "/"
			
	path += ProjectSettings.get_setting(
		ProjectTimeTrackerSettingsManager.SAVE_FILE_NAME,
		ProjectTimeTrackerSettingsManager.SAVE_FILE_NAME_DEFAULT
		)
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
