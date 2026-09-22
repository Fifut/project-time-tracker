@tool
extends Window

@onready var back_start_button: Button = $PanelContainer/VBoxContainer/ButtonsContainer/BackStartButton
@onready var back_button: Button = $PanelContainer/VBoxContainer/ButtonsContainer/BackButton
@onready var date_button: Button = $PanelContainer/VBoxContainer/ButtonsContainer/DateButton
@onready var forward_button: Button = $PanelContainer/VBoxContainer/ButtonsContainer/ForwardButton
@onready var forward_end_button: Button = $PanelContainer/VBoxContainer/ButtonsContainer/ForwardEndButton


var _index: int = 0
var _journal_entries: Array[Dictionary] = []


func _ready() -> void:
	back_start_button.icon = get_theme_icon("BackStart", "EditorIcons")
	back_button.icon = get_theme_icon("Back", "EditorIcons")
	forward_button.icon = get_theme_icon("Forward", "EditorIcons")
	forward_end_button.icon = get_theme_icon("ForwardEnd", "EditorIcons")


func _process(delta: float) -> void:
	pass



# #######################################
# Private
# #######################################
func _load_log_journal() -> void:
	var path = _log_journal_file_path()
	
	if (!FileAccess.file_exists(path)):
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Project Time Tracker : Failed to open file '" + path + "' for reading (Error " + str(error) + ")")
		return
	
	var lines: PackedStringArray = []
	lines = file.get_as_text().split("\n")
	file.close()
	
	#2026-09-22 - 2D: 08:34:49 - 3D: 17:46:44 - AFK: 00:08:26 - Asset Store: 01:43:53 - External: 20:03:16 - Game: 06:26:16 - LimboAI: 00:00:17 - Script: 10:33:27
	for line in lines:
		var journal_entry: PackedStringArray = line.strip_edges().split("-")
		
		var dict: Dictionary = {}
		dict["Year"] = journal_entry[0]
		dict["Month"] = journal_entry[1]
		dict["Day"] = journal_entry[2]
		
		for i in range(3, journal_entry.size()):
			var section: PackedStringArray = journal_entry[i].split(":", true, 1)
			if section[0] == "AFK":
				continue
			dict[section[0]] = section[1]
			
		_journal_entries.append(dict)

		
func _log_journal_file_path() -> String:
	var path: String
	match ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_FILE_LOCATION):
		"Project (res://)":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_FILE_CUSTOM_LOCATION) + "/"
			
	path += ProjectSettings.get_setting(PTTSettingsManager.LOG_JOURNAL_FILE_NAME)
	path += ".txt"
	
	return path



# #######################################
# Signals
# #######################################
func _on_back_start_button_pressed() -> void:
	# LEcture 1er migne fichier
	pass


func _on_back_button_pressed() -> void:
	pass # Replace with function body.


func _on_date_button_pressed() -> void:
	pass # Replace with function body.


func _on_forward_button_pressed() -> void:
	pass # Replace with function body.


func _on_forward_end_button_pressed() -> void:
	# LEcture dernière ligne du fichier
	pass
