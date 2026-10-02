@tool
extends Control

# #######################################
# Node references
# #######################################
@onready var icon_texture: TextureRect = %IconTexture
@onready var dhms_value: Label = %DHMSValue
@onready var hours_value: Label = %HoursValue
@onready var sections_button: Button = %SectionsButton
@onready var graphs_button: Button = %GraphsButton
@onready var resume_button: Button = %ResumeButton
@onready var pause_button: Button = %PauseButton
@onready var clear_button: Button = %ClearButton
@onready var day_value: Label = %DayValue
#@onready var calendar_button: Button = %CalendarButton
@onready var edit_button: Button = %EditButton
@onready var h_separator_1: HSeparator = %HSeparator1
@onready var h_separator_2: HSeparator = %HSeparator2
@onready var section_list: VBoxContainer = %SectionList
@onready var section_graph: HBoxContainer = %SectionGraph
@onready var section_day_list: VBoxContainer = %SectionDayList
@onready var section_day_graph: HBoxContainer = %SectionDayGraph
@onready var log_label: Label = %LogLabel
@onready var clear_all_confirm_dialog: ConfirmationDialog = %ClearAllConfirmDialog
@onready var tracker_calendar: Window = %TrackerCalendar



# #######################################
# Scene references
# #######################################
const TRACKER_SECTION = preload("res://addons/project-time-tracker/tracker_section.tscn")
const TRACKER_DAY_SECTION = preload("res://addons/project-time-tracker/tracker_day_section.tscn")


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
			sections_button.button_pressed = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_UI_SHOW_SECTIONS)
			graphs_button.button_pressed  = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_UI_SHOW_GRAPHS)
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
		
		if section_day_list.has_node(_tracked_section):
			section_day_list.get_node(_tracked_section).enabled = true


func _pause_tracking() -> void:
	if pause_button.visible:
		pause_button.visible = false
		resume_button.visible = true
		
		if section_list.has_node(_tracked_section):
			section_list.get_node(_tracked_section).enabled = false
			
		if section_day_list.has_node(_tracked_section):
			section_day_list.get_node(_tracked_section).enabled = false
			
			
func _update_theme() -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	pause_button.icon = get_theme_icon("Pause", "EditorIcons")
	resume_button.icon = get_theme_icon("Play", "EditorIcons")
	clear_button.icon = get_theme_icon("Remove", "EditorIcons")
	edit_button.icon = get_theme_icon("Modifiers", "EditorIcons")
	
	sections_button.button_pressed = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_UI_SHOW_SECTIONS)
	graphs_button.button_pressed  = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_UI_SHOW_GRAPHS)


func _update_ui():
	var time: float = 0.0
	
	# Global
	for section in section_list.get_children():
		if section.name != "AFK":
			time += section.get_elapsed_time()
	
	var dhms = floori(time) / 60 / 60 / 24
	dhms_value.text = str(dhms) + "d - " + Time.get_time_string_from_unix_time(time)
	
	var hours = floori(time) / 60 / 60
	#hours_value.text = "(" + str(hours) + "h)"
	hours_value.text = str(hours) + "h"
	
	# Day
	time = 0.0
	for section in section_day_list.get_children():
		if section.name != "AFK":
			time += section.get_elapsed_time()
	
	day_value.text = Time.get_time_string_from_unix_time(time)


func _update_graph():
	var sections: Dictionary = {}
	
	# Global
	for section in section_list.get_children():
		sections[str(section.name)] = section.get_elapsed_time()
	
	if not sections.is_empty():
		section_graph.sections = sections

	# Day
	sections.clear()
	for section in section_day_list.get_children():
		sections[str(section.name)] = section.get_elapsed_time()
	
	if not sections.is_empty():
		section_day_graph.sections = sections


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
	
	# Global
	if not section_list.has_node(section_name):
		var new_section = TRACKER_SECTION.instantiate()
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


func _create_day_section(section_name: String, time: float = 0.0) -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	if (section_name.is_empty()):
		return
			
	if not section_day_list.has_node(section_name):
		var new_section = TRACKER_DAY_SECTION.instantiate()
		new_section.name = section_name
		if SECTION_ICONS.has(section_name):
			new_section.icon = SECTION_ICONS[section_name]
		else:
			new_section.icon = "Node"
		new_section.restore_elapsed_time(time)
		new_section.on_clear_section.connect(_on_clear_section_requested)
		
		section_day_list.add_child(new_section)	
		


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

	children = section_day_list.get_children()
	children.sort_custom(
		func(a, b):
			return a.name.to_lower() < b.name.to_lower())
	for i in children.size():
		section_day_list.move_child(children[i], i)



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
		
	if section_day_list.has_node(_tracked_section):
		section_day_list.get_node(_tracked_section).enabled = false
		
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
		_create_day_section(section)
		_sort_sections()
		
		# Enabled new section
		section_list.get_node(section).enabled = true
		section_day_list.get_node(section).enabled = true
		

func get_tracked_section() -> String:
	return _tracked_section


func restore_tracked_sections(global_sections : Dictionary, day_sections : Dictionary = {}) -> void:
	for section in global_sections:
		_create_section(section, global_sections[section])
	
	for section in day_sections:
		_create_day_section(section, day_sections[section])
		
	_sort_sections()


func get_tracked_sections() -> Dictionary:
	var global: Dictionary = {}
	for section in section_list.get_children():
		global[section.name] = section.get_elapsed_time()
		
	var day: Dictionary = {}
	for section in section_day_list.get_children():
		day[section.name] = section.get_elapsed_time()
	
	var sections: Dictionary = {
		"Global": global,
		"Today": day
	}
	
	return sections


func subtract_to_current_section(time: float) -> void:
	if section_list.has_node(_tracked_section):
		section_list.get_node(_tracked_section).subtract_time(time)
		
	if section_day_list.has_node(_tracked_section):
		section_day_list.get_node(_tracked_section).subtract_time(time)


func set_log_text(text: String) -> void:
	log_label.text = text



# #######################################
# Signals
# #######################################
func _on_resume_button_pressed() -> void:
	_resume_tracking()


func _on_pause_button_pressed() -> void:
	_pause_tracking()

		
func _on_calendar_button_toggled(toggled_on: bool) -> void:
	tracker_calendar.show()
	

func _on_clear_button_pressed() -> void:
	clear_all_confirm_dialog.popup_centered(clear_all_confirm_dialog.size)


func _on_edit_button_toggled(toggled_on: bool) -> void:
	clear_button.visible = toggled_on
	for section in section_list.get_children():
		section.edit_buttons_visibility(toggled_on)
	for section in section_day_list.get_children():
		section.edit_buttons_visibility(toggled_on)
	

func _on_clear_all_confirm_dialog_confirmed() -> void:
	clear_button.hide()
	edit_button.button_pressed = false
	for section in section_list.get_children():
		section_list.remove_child(section)
		section.queue_free()
	
	section_graph.clear()
	
	for section in section_day_list.get_children():
		section_day_list.remove_child(section)
		section.queue_free()	
		
	section_day_graph.clear()


func _on_clear_section_requested(section_name):
	clear_button.hide()
	edit_button.button_pressed = false
	section_graph.clear()
	section_day_graph.clear()


func _on_sections_button_toggled(toggled_on: bool) -> void:
	section_list.visible = toggled_on
	section_day_list.visible = toggled_on
	
	h_separator_1.visible = section_list.visible or section_graph.visible
	h_separator_2.visible = section_list.visible or section_graph.visible
			

func _on_graphs_button_toggled(toggled_on: bool) -> void:
	section_graph.visible = toggled_on
	section_day_graph.visible = toggled_on
	
	h_separator_1.visible = section_list.visible or section_graph.visible
	h_separator_2.visible = section_list.visible or section_graph.visible
