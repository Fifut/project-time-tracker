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
@onready var log_label: Label = $Margin/Layout/LogLabel
@onready var clear_all_confirm_dialog : ConfirmationDialog = $ClearAllConfirmDialog


# #######################################
# Scene references
# #######################################
@onready var section_scene = preload("res://addons/project-time-tracker/tracker_section.tscn")


# #######################################
# Private properties
# #######################################
const SECTION_ICONS: Dictionary = {
	"2D": "2D",
	"3D": "3D",
	"Script": "Script",
	"Game": "Game",
	"Asset Store": "AssetStore",
	"External": "Window",
	"AFK": "ViewportSpeed",
	"Documentation" : "Help"
}

var _tracked_section: String = ""



func _ready() -> void:
	# If project parameters have changed maybe they're ours.
	ProjectSettings.settings_changed.connect(
		func():
			section_list.visible = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_UI_SHOW_SECTIONS)
			section_graph.visible = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_UI_SHOW_GRAPHS)
			h_separator.visible = section_list.visible or section_graph.visible
	)
	
	_update_theme()


func _process(delta: float) -> void:
	_update_ui()
	_update_graph()
	_update_script_editor()
	
	

# #######################################
# Helpers
# #######################################
func _resume_tracking() -> void:
	if resume_button.visible:
		pause_button.visible = true
		resume_button.visible = false
		
		if section_list.has_node(_tracked_section):
			section_list.get_node(_tracked_section).enabled = true


func _pause_tracking() -> void:
	if pause_button.visible:
		pause_button.visible = false
		resume_button.visible = true
		
		if section_list.has_node(_tracked_section):
			section_list.get_node(_tracked_section).enabled = false
			
			
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
		if section.name != "AFK":
			time += section.get_elapsed_time()
	
	var dhms = floori(time) / 60 / 60 / 24
	dhms_value.text = str(dhms) + "d - " + Time.get_time_string_from_unix_time(time)
	
	var hours = floori(time) / 60 / 60
	hours_value.text = "(" + str(hours) + "h)"


func _update_graph():
	var sections: Dictionary = {}
	for section in section_list.get_children():
		sections[str(section.name)] = section.get_elapsed_time()
	
	if not sections.is_empty():
		section_graph.sections = sections


func _update_script_editor():
	if _tracked_section == "Script" or _tracked_section == "Documentation":
		if _is_documentation():
			set_tracked_section("Documentation")
		else:
			set_tracked_section("Script")


func _create_section(section_name: String, time: float = 0.0) -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	if (section_name.is_empty()):
		return
	
	if section_list.has_node(section_name):
		return
		
	var new_section = section_scene.instantiate()
	new_section.name = section_name
	if SECTION_ICONS.has(section_name):
		new_section.icon = SECTION_ICONS[section_name]
	else:
		new_section.icon = "Node"
	new_section.restore_elapsed_time(time)
	new_section.on_clear_section.connect(_on_clear_section_requested)
	
	# Create project settings for this section if not exist (maybe an other add-on)
	var key = PTTSettingsManager.SECTIONS_ENABLED + section_name 
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
		ProjectSettings.add_property_info({
			"name": key,
			"type": TYPE_BOOL,
			"hint": PROPERTY_HINT_NONE,
			})
		ProjectSettings.set_initial_value(key, true)
	
	key = PTTSettingsManager.SECTIONS_COLOR + section_name
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.WHITE)
		ProjectSettings.add_property_info({
			"name": key,
			"type": TYPE_COLOR,
			"hint": PROPERTY_HINT_NONE,
			})
		ProjectSettings.set_initial_value(key, Color.WHITE)
	
	section_list.add_child(new_section)	


func _is_documentation() -> bool:
	var script_editor := EditorInterface.get_script_editor()
	var current_tab = _find_current_selected_tab(script_editor)
	if current_tab:
		return current_tab.get_class() == "EditorHelp"
	return false

func _find_current_selected_tab(node: Node) -> Control:
	for child in node.get_children():
		if child is TabContainer:
			var idx = child.current_tab
			if idx >= 0 and idx < child.get_tab_count():
				return child.get_tab_control(idx)
		var result = _find_current_selected_tab(child)
		if result:
			return result
	return null


func _sort_sections() -> void:
	# Alphabetical sections sorting
	var children = section_list.get_children()
	children.sort_custom(
		func(a, b):
			return a.name.to_lower() < b.name.to_lower())
	for i in children.size():
		section_list.move_child(children[i], i)



# #######################################
# Public methods
# #######################################
func set_tracked_section(section: String) -> void:
	if _tracked_section == section:
		return
	
	# If script maybe it's documentation
	if section == "Script":
		if _is_documentation():
			section = "Documentation"

	# Display section icon
	if SECTION_ICONS.has(section):
		icon_texture.texture = get_theme_icon(SECTION_ICONS[section], "EditorIcons")
		icon_texture.modulate = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_COLOR + section)
	else:
		icon_texture.texture = get_theme_icon("Node", "EditorIcons")
		icon_texture.modulate = Color.WHITE
	
	# Disable previous section
	if section_list.has_node(_tracked_section):
		section_list.get_node(_tracked_section).enabled = false
	
	# Memo new section
	_tracked_section = section
	
	# If tracking is suspended
	if resume_button.visible:
		_tracked_section = section
		return
		
	# Create project settings for this section if not exist (maybe an other add-on)
	var key = PTTSettingsManager.SECTIONS_ENABLED + section 
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, true)
		ProjectSettings.add_property_info({
			"name": key,
			"type": TYPE_BOOL,
			"hint": PROPERTY_HINT_NONE,
			})
		ProjectSettings.set_initial_value(key, true)
	
	key = PTTSettingsManager.SECTIONS_COLOR + section
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, Color.WHITE)
		ProjectSettings.add_property_info({
			"name": key,
			"type": TYPE_COLOR,
			"hint": PROPERTY_HINT_NONE,
			})
		ProjectSettings.set_initial_value(key, Color.WHITE)
	

	# Add / enabled new section if enabled
	if ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_ENABLED + section) :
		_create_section(section)
		_sort_sections()
		
		# Enabled new section
		section_list.get_node(section).enabled = true
		

func get_tracked_section() -> String:
	return _tracked_section


func restore_tracked_sections(sections : Dictionary) -> void:
	for section in sections:
		_create_section(section, sections[section])
	_sort_sections()


func get_tracked_sections() -> Dictionary:
	var sections: Dictionary = {}
	for section in section_list.get_children():
		sections[section.name] = section.get_elapsed_time()
		
	return sections


func subtract_to_current_section(time: float) -> void:
	section_list.get_node(_tracked_section).subtract_time(time)


func set_log_text(text: String) -> void:
	log_label.text = text



# #######################################
# Signals
# #######################################
func _on_resume_button_pressed() -> void:
	_resume_tracking()


func _on_pause_button_pressed() -> void:
	_pause_tracking()


func _on_clear_button_pressed() -> void:
	clear_all_confirm_dialog.popup_centered(clear_all_confirm_dialog.size)

		
func _on_edit_button_toggled(toggled_on: bool) -> void:
	clear_button.visible = toggled_on
	for section in section_list.get_children():
		section.edit_buttons_visibility(toggled_on)
	

func _on_clear_all_confirm_dialog_confirmed() -> void:
	clear_button.hide()
	edit_button.button_pressed = false
	for section in section_list.get_children():
		section_list.remove_child(section)
		section.queue_free()
	section_graph.clear()


func _on_clear_section_requested(section_name):
	clear_button.hide()
	edit_button.button_pressed = false
	section_graph.clear()
