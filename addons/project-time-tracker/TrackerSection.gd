@tool
extends VBoxContainer

# #######################################
# Signals
# #######################################
signal on_clear_section(section_name)



# #######################################
# Public properties
# #######################################
@export var icon : String = "" :
	set(value) :
		icon = value
		_update_icon()
	
@export var enabled: bool = false:
	set(value):
		enabled = value
		if enabled:
			_time = Time.get_ticks_msec()
		else:
			elapsed_time += _time - Time.get_ticks_msec()

@export var elapsed_time: float = 0.0:
	get():
		return elapsed_time + (_time - Time.get_ticks_msec() )



# #######################################
# Node references
# #######################################
@onready var icon_texture : TextureRect = $Information/IconContainer/IconTexture
@onready var name_label : Label = $Information/NameLabel
@onready var elapsed_time_label : Label = $Information/ElapsedTimeLabel
@onready var elapsed_hours_label: Label = $Information/ElapsedHoursLabel
@onready var edit_button: Button = $Information/EditButton
@onready var clear_button : Button = $Information/ClearButton

@onready var edit_section_window: Window = $EditSectionWindow
@onready var title_label: Label = $EditSectionWindow/PanelContainer/VBoxContainer/TitleLabel
@onready var days_spin_box: SpinBox = $EditSectionWindow/PanelContainer/VBoxContainer/SpinBoxHBoxContainer/DaysHBoxContainer/DaysSpinBox
@onready var hour_spin_box: SpinBox = $EditSectionWindow/PanelContainer/VBoxContainer/SpinBoxHBoxContainer/HoursHBoxContainer/HourSpinBox
@onready var minutes_spin_box: SpinBox = $EditSectionWindow/PanelContainer/VBoxContainer/SpinBoxHBoxContainer/MinutesHBoxContainer/MinutesSpinBox
@onready var seconds_spin_box: SpinBox = $EditSectionWindow/PanelContainer/VBoxContainer/SpinBoxHBoxContainer/SecondsHBoxContainer2/SecondsSpinBox

@onready var clear_section_confirm_dialog: ConfirmationDialog = $ClearSectionConfirmDialog



# #######################################
# Private properties
# #######################################
var _time: float = 0.0



func _ready() -> void:
	_update_theme()
	_update_icon()
	_update_name()



func _process(delta: float) -> void:
	if (!is_inside_tree()):
		return
	
	if enabled:
		_update_ui()



# #######################################
# Public methods
# #######################################
func edit_buttons_visibility(status: bool) -> void:
	edit_button.visible = status
	clear_button.visible = status



# #######################################
# Helpers
# #######################################
func _update_theme() -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	edit_button.icon = get_theme_icon("EditAddRemove", "EditorIcons")
	clear_button.icon = get_theme_icon("Remove", "EditorIcons")


func _update_icon() -> void:
	if (!is_inside_tree()):
		return
	
	icon_texture.texture = get_theme_icon(icon, "EditorIcons")
	icon_texture.modulate = ProjectSettings.get_setting("project_time_tracker/sections/colors/" + name, ProjectSettings.get_setting("project_time_tracker/sections/colors/other") )


func _update_name() -> void:
	if (!is_inside_tree()):
		return
	
	name_label.text = name
	title_label.text = name
	clear_section_confirm_dialog.dialog_text = "This action will clear" + name + "session from memory.\n Do you want to continue?"


func _update_ui() -> void:
	var time = elapsed_time + (_time - Time.get_ticks_msec() )
		
	var days = floori(time) / 60 / 60 / 24
	elapsed_time_label.text = str(days) + "d - " + Time.get_time_string_from_unix_time(time)
	
	var hours = floori(time) / 60 / 60
	elapsed_hours_label.text = "(" + str(hours) + "h)"
	
	

# #######################################
# Signals
# #######################################
func _on_edit_button_pressed():
	var time = Time.get_time_dict_from_unix_time(elapsed_time)
	days_spin_box.value = floori(elapsed_time) / 60 / 60 / 24
	hour_spin_box.value = floori(time["hour"] % 24)
	minutes_spin_box.value = time["minute"]
	seconds_spin_box.value = time["second"]
	
	edit_button.button_pressed = false
	edit_section_window.show()
	
	
func _on_edit_section_ok_button_pressed() -> void:
	var time = 0.0
	time += days_spin_box.value * 24 * 60 * 60
	time += hour_spin_box.value * 60 * 60
	time += minutes_spin_box.value * 60
	time += seconds_spin_box.value
	elapsed_time = time
	
	edit_section_window.hide()


func _on_edit_section_cancel_button_pressed() -> void:
	edit_section_window.hide()
	
	
func _on_clear_button_pressed():
	clear_section_confirm_dialog.popup_centered(clear_section_confirm_dialog.size)
	

func _on_clear_section_confirm_dialog_confirmed() -> void:
	on_clear_section.emit(name)
	queue_free()
