@tool
extends EditorPlugin


var _settings_manager: Node
var _event_manager: Node

var _dock_instance: Control
var _timer_afk: Timer

var _main_screen_buttons: Array[Button] = []
var _is_playing_scene: bool = false
var _debug: bool = false


func _enter_tree():
	_settings_manager = preload("res://addons/project-time-tracker/settings_manager.gd").new()
	add_child(_settings_manager)	
	
	_debug = ProjectSettings.get_setting(PTTSettingsManager.DEBUG_ENABLED)
	
	_event_manager = preload("res://addons/project-time-tracker/events_manager.gd").new()
	add_child(_event_manager)	
	
	_timer_afk = Timer.new()
	_timer_afk.wait_time = ProjectSettings.get_setting(PTTSettingsManager.AFK_TIMER)
	_timer_afk.one_shot = true
	add_child(_timer_afk)	
	
	_dock_instance = preload("res://addons/project-time-tracker/tracker_dock.tscn").instantiate()
	_dock_instance.name = "Project Time Tracker"
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, _dock_instance)
	
	_load_sections()
	

func _exit_tree():
	_save_external_data()	# https://github.com/godotengine/godot/issues/118929
	remove_control_from_docks(_dock_instance)
	_dock_instance.queue_free()


func _ready() -> void:
	# Get main screen buttons (2D, 3D, Script, etc;)
	_get_main_screen_buttons()
	
	# If project parameters have changed maybe they're ours.
	ProjectSettings.settings_changed.connect(
	func():
		_timer_afk.wait_time = ProjectSettings.get_setting(PTTSettingsManager.AFK_TIMER)
	)
	
	# Signal from 2D, 3D, Script, Game, etc. workspace
	main_screen_changed.connect(
		func(screen_name):
			if _debug : print("Project time tracker:"," main_screen_changed ", screen_name)
			
			_dock_instance.set_tracked_section(screen_name)
	)
	
	# Signal from Godot focused windows
	_event_manager.on_focused_window.connect(
		func(window_name):
			if _debug : print("Project time tracker:"," on_focused_window ", window_name)
			
			# Main Godot window
			if window_name == ProjectSettings.get_setting("application/config/name"):
				_dock_instance.set_tracked_section(_get_main_screen_button_is_pressed() )
				_timer_afk.start()
				
			# Floating script editor
			elif window_name.begins_with("Script Editor"):
				_dock_instance.set_tracked_section("Script")
				_timer_afk.start()
			
			# The floating game window is outside the Godot windows scope
			elif window_name == "External" and _is_playing_scene:
				_dock_instance.set_tracked_section("Game")
				_timer_afk.stop()

			# Maybe an external editor
			elif window_name == "External" and not _is_playing_scene:
				_dock_instance.set_tracked_section("External")
				_timer_afk.stop()
	)
	
	# Signal from project or scene running
	_event_manager.on_playing_scene.connect(
		func():
			if _debug : print("Project time tracker:"," on_playing_scene ")
			
			_dock_instance.set_tracked_section("Game")
			_is_playing_scene = true
	)
	
	# Signal from project or scene stopping
	_event_manager.on_stopping_scene.connect(
		func():
			if _debug : print("Project time tracker:"," on_stopping_scene ")
			
			_is_playing_scene = false
	)
	
	# Signal from AFK timer
	_timer_afk.timeout.connect(
		func():
			if _debug : print("Project time tracker:"," timeout ")
			
			if ProjectSettings.get_setting(PTTSettingsManager.AFK_USE_AFK):
				_dock_instance.subtract_to_current_section(ProjectSettings.get_setting(PTTSettingsManager.AFK_TIMER))
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
	
	if ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_ENABLED):
		_store_log_journal()


func _get_plugin_icon():
	return preload("res://addons/project-time-tracker/icon.png")



# #######################################
# Private methods
# #######################################
func _load_sections() -> void:
	if _debug : print("Project time tracker:"," _load_sections()")
	
	var path = _save_file_path()
	
	if (!FileAccess.file_exists(path)):
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Project Time Tracker : Failed to open file '" + path + "' for reading (Error " + str(error) + ")")
		return
	
	var json = JSON.new()
	var parse_result:Dictionary = json.parse_string(file.get_as_text())
	var parse_error = json.get_error_message()
	file.close()
	
	if (parse_error != ""):
		printerr("Project Time Tracker : Failed to parse tracked sections (Error " + parse_error + ")")
		return
	
	# Update v2 -> v3
	parse_result.erase("Editor")
	if parse_result.has("AssetLib"):
		parse_result["Asset Store"] = parse_result["AssetLib"]
		parse_result.erase("AssetLib")
		
	_dock_instance.restore_tracked_sections(parse_result)


func _store_sections() -> void:
	if _debug : print("Project time tracker:"," _store_sections()")
		
	var tracked_sections = _dock_instance.get_tracked_sections()
	var stored_string = JSON.stringify(tracked_sections, "  ")
	
	var path = _save_file_path()
	
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


func _store_log_journal() -> void:
	if _debug : print("Project time tracker:"," _store_log_journal()")
	
	var tracked_sections: Dictionary = _dock_instance.get_tracked_sections()

	var log: String = Time.get_date_string_from_system()
	for section in tracked_sections:
		log += " - " + section + ": " + Time.get_time_string_from_unix_time(tracked_sections[section])
	
	var path = _log_journal_file_path()
	var lines: PackedStringArray = []

	#  If the file exists, reads all entries in the log
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		lines = file.get_as_text().split("\n")
		file.close()
		
		# Deletes the last line of the file if is ""
		if lines.size() > 0 and lines[-1] == "":
			lines.remove_at(lines.size() - 1)
	
	# Replaces the log entry if the date already exists, or adds it if it does not
	if lines.size() > 0 and lines[-1].begins_with(Time.get_date_string_from_system() ):
		lines[-1] = log
	else:
		lines.append(log)

	# Writes all log entries
	var file = FileAccess.open(path, FileAccess.WRITE)
	for line in lines:
		file.store_line(line)
	file.close()

	
func _save_file_path() -> String:
	var path: String
	match ProjectSettings.get_setting(PTTSettingsManager.SAVE_FILE_LOCATION):
		"Project (res://),":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting(PTTSettingsManager.SAVE_FILE_CUSTOM_LOCATION) + "/"
			
	path += ProjectSettings.get_setting(PTTSettingsManager.SAVE_FILE_NAME)
	path += ".json"
	
	if _debug : print("Project time tracker:"," _save_file_path() ", path)
	return path


func _log_journal_file_path() -> String:
	var path: String
	match ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_FILE_LOCATION):
		"Project (res://),":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_FILE_CUSTOM_LOCATION) + "/"
			
	path += ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_FILE_NAME)
	path += ".txt"
	
	if _debug : print("Project time tracker:"," _log_journal_file_path() ", path)
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
