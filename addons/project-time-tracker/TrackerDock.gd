@tool
extends Control

# #######################################
# Node references
# #######################################
@onready var icon_texture: TextureRect = $Margin/Layout/Status/IconTexture
@onready var dhms_value: Label = $Margin/Layout/Status/DHMSValue
@onready var hours_value: Label = $Margin/Layout/Status/HoursValue
@onready var resume_button : Button = $Margin/Layout/Status/ResumeButton
@onready var pause_button : Button = $Margin/Layout/Status/PauseButton
@onready var clear_button : Button = $Margin/Layout/Status/ClearButton
@onready var edit_button: Button = $Margin/Layout/Status/EditButton
@onready var h_separator: HSeparator = $Margin/Layout/HSeparator
@onready var section_list : Control = $Margin/Layout/SectionList
@onready var section_graph : Control = $Margin/Layout/SectionGraph
@onready var clear_all_confirm_dialog : ConfirmationDialog = $ClearAllConfirmDialog


# #######################################
# Scene references
# #######################################
@onready var section_scene = preload("res://addons/project-time-tracker/TrackerSection.tscn")


# #######################################
# Private properties
# #######################################
const SECTION_ICONS: Dictionary = {
	"2D": "2D",
	"3D": "3D",
	"Script": "Script",
	"Game": "Game",
	"AssetLib": "AssetLib",
	"External": "Window",
	"AFK": "ViewportSpeed",
	"default": "Node" 
}

var _tracked_section: String = ""



func _ready() -> void:
	ProjectSettings.settings_changed.connect(
		func():
			section_list.visible = ProjectSettings.get_setting("project_time_tracker/sections/show_sections", true)
			section_graph.visible = ProjectSettings.get_setting("project_time_tracker/sections/show_graphs", true)
			h_separator.visible = section_list.visible or section_graph.visible
	)
	
	_update_theme()
	


# #######################################
# Helpers
# #######################################
func _update_theme() -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	pause_button.icon = get_theme_icon("Pause", "EditorIcons")
	resume_button.icon = get_theme_icon("Play", "EditorIcons")
	clear_button.icon = get_theme_icon("Remove", "EditorIcons")
	edit_button.icon = get_theme_icon("Modifiers", "EditorIcons")


func _update_ui():
	var time: float = 0.0
	for section in section_list.get_children():
		time += section.elapsed_time
		
	var dhms = floori(time) / 60 / 60 / 24
	dhms_value.text = str(dhms) + "d - " + Time.get_time_string_from_unix_time(time)
	
	var hours = floori(time) / 60 / 60
	hours_value.text = "(" + str(hours) + "h)"
	

func _create_section(section_name: String, time: float = 0.0) -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	if (section_name.is_empty()):
		return
	
	if section_list.has_node(section_name):
		return
	
	var new_section = section_scene.instantiate()
	new_section.name = section_name
	new_section.elapsed_time = time
	new_section.section_color = ProjectSettings.get_setting("project_time_tracker/sections/colors/" + section_name, ProjectSettings.get_setting("project_time_tracker/sections/color/other"))
	new_section.on_clear_section.connect(_on_clear_section_requested)
	
	if SECTION_ICONS.has(section_name):
		new_section.icon = SECTION_ICONS[section_name]
	else:
		new_section.icon = SECTION_ICONS["default"]
		
	section_list.add_child(new_section)	



# #######################################
# Tracker functions
# #######################################
func resume_tracking() -> void:
	pause_button.visible = true
	resume_button.visible = false
	section_list.get_node(_tracked_section).enabled = true


func pause_tracking() -> void:
	pause_button.visible = false
	resume_button.visible = true
	section_list.get_node(_tracked_section).enabled = true



# #######################################
# Public methods
# #######################################
func set_tracked_section(section: String) -> void:
	if (_tracked_section == section):
		return
		
	_create_section(_tracked_section)
	_tracked_section = section
	

func get_tracked_section() -> String:
	return _tracked_section


func restore_tracked_sections(sections : Dictionary) -> void:
	for section in sections:
		_create_section(section, sections[section])


func get_tracked_sections() -> Dictionary:
	var sections: Dictionary = {}
	for section in section_list.get_children():
		sections[section.name] = section.elapsed_time
		
	return sections



# #######################################
# Signals
# #######################################
func _on_resume_button_pressed() -> void:
	resume_tracking()


func _on_pause_button_pressed() -> void:
	pause_tracking()


func _on_clear_button_pressed() -> void:
	clear_button.button_pressed = false
	clear_all_confirm_dialog.popup_centered(clear_all_confirm_dialog.size)

		
func _on_edit_button_toggled(toggled_on: bool) -> void:
	clear_button.visible = toggled_on
	for section in section_list.get_children():
		section.edit_buttons_visibility(true)
	

func _on_clear_all_confirm_dialog_confirmed() -> void:
	clear_button.button_pressed = false
	for section in section_list.get_children():
		section_list.remove_child(section)
		section.queue_free()
	section_graph.clear()


func _on_clear_section_requested(section_name):
	section_graph.clear()
