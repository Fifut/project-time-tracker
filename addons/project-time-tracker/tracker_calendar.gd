@tool
extends Window


@onready var day_container: GridContainer = %DayContainer
@onready var sections_container: VBoxContainer = %SectionsContainer

@onready var back_year_button: Button = %BackYearButton
@onready var back_month_button: Button = %BackMonthButton
@onready var forward_month_button: Button = %ForwardMonthButton
@onready var forward_year_button: Button = %ForwardYearButton
@onready var month_label: Label = %MonthLabel
@onready var year_label: Label = %YearLabel
@onready var date_label: Label = %DateLabel
@onready var total_label: Label = %TotalLabel

const TRACKER_DAY_SECTION = preload("res://addons/project-time-tracker/tracker_day_section.tscn")
const MONTH: Array[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

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

var _month: int = 1
var _year: int = 1970
var _sections: Dictionary = {}


func _ready() -> void:
	hide()
		
	back_year_button.icon = get_theme_icon("BackStart", "EditorIcons")
	back_month_button.icon = get_theme_icon("Back", "EditorIcons")
	forward_month_button.icon = get_theme_icon("Forward", "EditorIcons")
	forward_year_button.icon = get_theme_icon("ForwardEnd", "EditorIcons")
	
	var day = Time.get_date_dict_from_system()["day"]
	_month = Time.get_date_dict_from_system()["month"]
	_year = Time.get_date_dict_from_system()["year"]
	
	_load_sections()
	_build_calendar(_year,_month, day)
	_build_sections(_year, _month, day)
	

func _process(delta: float) -> void:
	if _year >= Time.get_date_dict_from_system()["year"] and _month > Time.get_date_dict_from_system()["month"]:
		_month = Time.get_date_dict_from_system()["month"]
		_build_calendar(_year,_month, Time.get_date_dict_from_system()["day"])
		
	if _year >= Time.get_date_dict_from_system()["year"]:
		forward_year_button.disabled = true
		
		if _month >= Time.get_date_dict_from_system()["month"]:
			forward_month_button.disabled = true
		else:
			forward_month_button.disabled = false
	else:
		forward_year_button.disabled = false
		forward_month_button.disabled = false
	
	

# #######################################
# Private
# #######################################
func _build_sections(year: int, month: int, day: int):
	for child in sections_container.get_children():
		sections_container.remove_child(child)
		child.queue_free()
	
	var string_date: String = str(day) if day >= 10 else "0" + str(day)
	string_date +=  "-"
	string_date += str(month) if month >= 10 else "0" + str(month)
	string_date +=  "-"
	string_date += str(year)
	date_label.text = string_date
	
	string_date = str(year) + "-"
	string_date += str(month) if month >= 10 else "0" + str(month)
	string_date +=  "-"
	string_date += str(day) if day >= 10 else "0" + str(day)
		
	if not _sections.has(string_date):
		return
		
	var total: float = 0.0
	
	for section in _sections[string_date]:
		var day_section = TRACKER_DAY_SECTION.instantiate()
		day_section.name = section
		if SECTION_ICONS.has(section):
			day_section.icon = SECTION_ICONS[section]
		else:
			day_section.icon = "Node"
		day_section.restore_elapsed_time(_sections[string_date][section])
		sections_container.add_child(day_section)
		
		total += _sections[string_date][section]
		total_label.text = Time.get_time_string_from_unix_time(total)
	

	
func _build_calendar(year: int, month: int, day: int = -1):
	month_label.text = MONTH[_month - 1]
	year_label.text = str(_year)
	
	# Clear calendar
	for child in day_container.get_children():
		day_container.remove_child(child)
		child.queue_free()
		
	# Empty before first weekend
	var first_weekday = _get_first_weekday_of_month(year, month)
	for i in first_weekday:
		var control: Control = Control.new()
		day_container.add_child(control)

	var days_in_month = _get_days_in_month(year, month)
	for d in range(1, days_in_month + 1):
		var button: Button = Button.new()
		button.name = "Day" + str(d)
		button.toggle_mode = true
		button.text = str(d)
		button.pressed.connect(_day_selected.bind(d))
		
		var	string_date = str(year) + "-"
		string_date += str(month) if month >= 10 else "0" + str(month)
		string_date += "-"
		string_date += str(d) if d >= 10 else "0" + str(d)
		button.disabled = not _sections.has(string_date)
			
		if d == day:
			button.set_pressed_no_signal(true)
			
		day_container.add_child(button, true)

	
func _is_leap_year(year: int) -> bool:
	if year % 4 == 0 and year % 100 != 0:
		return true
	
	if year % 400 == 0:
		return true
	
	return false


func _get_days_in_month(year: int, month: int) -> int:
	var days_by_month := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	if month == 2 and _is_leap_year(year):
		return 29
		
	return days_by_month[month - 1]


func _get_first_weekday_of_month(year: int, month: int) -> int:
	var unix_time: int = Time.get_unix_time_from_datetime_dict({
		"year": year,
		"month": month,
		"day": 1,
		"hour": 0,
		"minute": 0,
		"second": 0
	})
	
	# 0 for Sunday, 1 for Monday, ..., 6 for Saturday
	var dt: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	var weekday: int = dt["weekday"]  # 0 = Sunday, ..., 6 = Saturday
	return (weekday + 6) % 7 # 0 = Monday, ..., 6 = Sunday


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
	_sections = json.parse_string(file.get_as_text())
	var parse_error = json.get_error_message()
	file.close()
	
	if (parse_error != ""):
		printerr("Project Time Tracker : Failed to parse tracked sections (Error " + parse_error + ")")
		return
	
	_sections.erase("Global")


func _file_path() -> String:
	var path: String
	match ProjectSettings.get_setting(PTTSettingsManager.SAVE_FILE_LOCATION):
		"Project (res://)":
			path = "res://"
		"User data (user://)":
			path = "user://"
		"Custom":
			path = ProjectSettings.get_setting(PTTSettingsManager.SAVE_FILE_CUSTOM_LOCATION) + "/"
			
	path += ProjectSettings.get_setting(PTTSettingsManager.SAVE_FILE_NAME)
	path += ".json"

	return path


# #######################################
# Signals
# #######################################
func _day_selected(day: int):
	for child in day_container.get_children():
		if not child is Button:
			continue
		
		if int(child.name) != day:
			child.button_pressed = false
						
	_build_sections(_year, _month, day)
	
	
func _on_back_year_button_pressed() -> void:
	_year -= 1
	_build_calendar(_year, _month)


func _on_forward_year_button_pressed() -> void:
	_year += 1
	_build_calendar(_year, _month)


func _on_back_month_button_pressed() -> void:
	_month -= 1
	if _month < 1:
		_month = 12
		_on_back_year_button_pressed()
	else:
		_build_calendar(_year, _month)

	
func _on_forward_month_button_pressed() -> void:
	_month += 1
	if _month > 12:
		_month = 1
		_on_forward_year_button_pressed()
	else:
		_build_calendar(_year, _month)
	

func _on_close_requested() -> void:
	hide()
