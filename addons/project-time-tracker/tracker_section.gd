@tool
extends Control

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
		
		# If enabled, memo actual ticks
		if value:
			_started_ticks_msec = Time.get_ticks_msec()
			
		# If not yet disabled, calculate and save elapsed time
		elif not value and enabled:
			_elapsed_time = _get_current_elapsed_time()	

		enabled = value



# #######################################
# Node references
# #######################################
@onready var background_color: ColorRect = %BackgroundColor
@onready var icon_texture: TextureRect = %IconTexture
@onready var name_label: Label = %NameLabel
@onready var elapsed_time_label: Label = %ElapsedTimeLabel
@onready var elapsed_hours_label: Label = %ElapsedHoursLabel
@onready var edit_button: Button = %EditButton
@onready var clear_button: Button = %ClearButton

@onready var edit_section_window: Window = %EditSectionWindow
@onready var title_label: Label = %TitleLabel
@onready var days_spin_box: SpinBox = %DaysSpinBox
@onready var hour_spin_box: SpinBox = %HourSpinBox
@onready var minutes_spin_box: SpinBox = %MinutesSpinBox
@onready var seconds_spin_box: SpinBox = %SecondsSpinBox

@onready var clear_section_confirm_dialog: ConfirmationDialog = $ClearSectionConfirmDialog



# #######################################
# Private properties
# #######################################
var _started_ticks_msec: float = 0.0
var _elapsed_time: float = 0.0


func _ready() -> void:
	# Unexpected _ready call with default name !?!
	if name == "TrackerSection":
		return
	
	# If project parameters have changed maybe they're ours.
	ProjectSettings.settings_changed.connect(
		func():
			icon_texture.modulate = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_COLOR + name)
	)
	
	_update_theme()
	_update_icon()
	_update_name()
	_update_ui(_elapsed_time)


func _process(delta: float) -> void:
	if (!is_inside_tree()):
		return
	
	if enabled:
		background_color.color.a = 0.075
		_update_ui(_get_current_elapsed_time())
	else:
		background_color.color.a = 0.0



# #######################################
# Public methods
# #######################################
func edit_buttons_visibility(status: bool) -> void:
	edit_button.visible = status
	clear_button.visible = status


func restore_elapsed_time(time: float) -> void:
	_elapsed_time = time

	
func get_elapsed_time() -> float:
	if enabled:
		return _get_current_elapsed_time()
	else:
		return _elapsed_time


func subtract_time(time: float) -> void:
	_started_ticks_msec += time * 1000
	_update_ui(_get_current_elapsed_time())



# #######################################
# Helpers
# #######################################
func _get_current_elapsed_time() -> float:
	return _elapsed_time + ( (Time.get_ticks_msec() - _started_ticks_msec) / 1000)


func _update_theme() -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	edit_button.icon = get_theme_icon("EditAddRemove", "EditorIcons")
	clear_button.icon = get_theme_icon("Remove", "EditorIcons")


func _update_icon() -> void:
	if (!is_inside_tree()):
		return
	
	icon_texture.texture = get_theme_icon(icon, "EditorIcons")
	icon_texture.modulate = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_COLOR + name)

func _update_name() -> void:
	if (!is_inside_tree()):
		return
	
	name_label.text = name
	title_label.text = name
	clear_section_confirm_dialog.dialog_text = "This action will clear " + name + " session from memory.\n Do you want to continue?"


func _update_ui(time: float) -> void:
	var days = floori(time) / 60 / 60 / 24
	elapsed_time_label.text = str(days) + "d - " + Time.get_time_string_from_unix_time(time)
	
	var hours = floori(time) / 60 / 60
	elapsed_hours_label.text = "(" + str(hours) + "h)"
	


# #######################################
# Signals
# #######################################
func _on_edit_button_pressed():
	var time = Time.get_time_dict_from_unix_time(_get_current_elapsed_time() )
	days_spin_box.value = floori(_get_current_elapsed_time() ) / 60 / 60 / 24
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
	_elapsed_time = time
	
	edit_section_window.hide()


func _on_edit_section_cancel_button_pressed() -> void:
	edit_section_window.hide()
	
	
func _on_clear_button_pressed():
	clear_section_confirm_dialog.popup_centered(clear_section_confirm_dialog.size)
	

func _on_clear_section_confirm_dialog_confirmed() -> void:
	on_clear_section.emit(name)
	queue_free()
