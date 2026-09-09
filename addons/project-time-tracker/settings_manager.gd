class_name PTTSettingsManager extends Node

# #######################################
# Settings keys
# #######################################
const SAVE_FILE_NAME: String = "project_time_tracker/general/save_file/file_name"
const SAVE_FILE_LOCATION: String = "project_time_tracker/general/save_file/file_location"
const SAVE_FILE_CUSTOM_LOCATION: String = "project_time_tracker/general/save_file/file_custom_location"

const LOG_JOURNAL_FILE_NAME: String = "project_time_tracker/general/log_journal/file_name"
const LOG_JOURNAL_FILE_LOCATION: String = "project_time_tracker/general/log_journal/file_location"
const LOG_JOURNAL_FILE_CUSTOM_LOCATION: String = "project_time_tracker/general/log_journal/file_custom_location"
const LOG_JOURNAL_ENABLED: String = "project_time_tracker/general/log_journal/enabled"

const DEBUG_ENABLED: String = "project_time_tracker/general/debug/print_debug"

const SECTIONS_UI_SHOW_SECTIONS: String = "project_time_tracker/sections/ui/show_sections"
const SECTIONS_UI_SHOW_GRAPHS: String = "project_time_tracker/sections/ui/show_graphs"

const SECTIONS_2D_ENABLED: String = "project_time_tracker/sections/enabled/2D"
const SECTIONS_3D_ENABLED: String = "project_time_tracker/sections/enabled/3D"
const SECTIONS_SCRIPT_ENABLED: String = "project_time_tracker/sections/enabled/Script"
const SECTIONS_GAME_ENABLED: String = "project_time_tracker/sections/enabled/Game"
const SECTIONS_ASSET_STORE_ENABLED: String = "project_time_tracker/sections/enabled/Asset Store"
const SECTIONS_EXTERNAL_ENABLED: String = "project_time_tracker/sections/enabled/External"
const SECTIONS_AFK_ENABLED: String = "project_time_tracker/sections/enabled/AFK"
const SECTIONS_DOCUMENTATION_ENABLED: String = "project_time_tracker/sections/enabled/Documentation"
const SECTIONS_ENABLED: String = "project_time_tracker/sections/enabled/"

const SECTIONS_COLOR: String = "project_time_tracker/sections/colors/"
const SECTIONS_COLOR_2D: String = "project_time_tracker/sections/colors/2D"
const SECTIONS_COLOR_3D: String = "project_time_tracker/sections/colors/3D"
const SECTIONS_COLOR_SCRIPT: String = "project_time_tracker/sections/colors/Script"
const SECTIONS_COLOR_GAME: String = "project_time_tracker/sections/colors/Game"
const SECTIONS_COLOR_ASSET_STORE: String = "project_time_tracker/sections/colors/Asset Store"
const SECTIONS_COLOR_EXTERNAL: String = "project_time_tracker/sections/colors/External"
const SECTIONS_COLOR_AFK: String = "project_time_tracker/sections/colors/AFK"
const SECTIONS_COLOR_DOCUMENTATION: String = "project_time_tracker/sections/colors/Documentation"

const AFK_TIMER: String = "project_time_tracker/afk/afk_timer"
const AFK_USE_AFK: String = "project_time_tracker/afk/use_afk"

# #######################################
# Settings default values
# #######################################
const _SAVE_FILE_NAME_DEFAULT: String = "project_time_tracker"
const _SAVE_FILE_LOCATION_DEFAULT: String = "Project (res://)"
const _SAVE_FILE_CUSTOM_LOCATION_DEFAULT: String = ""

const _LOG_JOURNAL_FILE_NAME_DEFAULT: String = "log_journal"
const _LOG_JOURNAL_FILE_LOCATION_DEFAULT: String = "Project (res://)"
const _LOG_JOURNAL_FILE_CUSTOM_LOCATION_DEFAULT: String = ""
const _LOG_JOURNAL_ENABLED_DEFAULT: bool = false

const _DEBUG_ENABLED_DEFAULT: bool = false

const _SECTIONS_UI_SHOW_SECTIONS_DEFAULT: bool = true
const _SECTIONS_UI_SHOW_GRAPHS_DEFAULT: bool = true

const _SECTIONS_2D_ENABLED_DEFAULT: bool = true
const _SECTIONS_3D_ENABLED_DEFAULT: bool = true
const _SECTIONS_SCRIPT_ENABLED_DEFAULT: bool = true
const _SECTIONS_GAME_ENABLED_DEFAULT: bool = true
const _SECTIONS_ASSET_STORE_ENABLED_DEFAULT: bool = true
const _SECTIONS_EXTERNAL_ENABLED_DEFAULT: bool = false
const _SECTIONS_AFK_ENABLED_DEFAULT: bool = true
const _SECTIONS_DOCUMENTATION_ENABLED_DEFAULT: bool = true

const _SECTIONS_COLOR_2D_DEFAULT: Color = Color.DEEP_SKY_BLUE
const _SECTIONS_COLOR_3D_DEFAULT: Color = Color.CORAL
const _SECTIONS_COLOR_SCRIPT_DEFAULT: Color = Color.YELLOW
const _SECTIONS_COLOR_GAME_DEFAULT: Color = Color.FIREBRICK
const _SECTIONS_COLOR_ASSET_STORE_DEFAULT: Color = Color.MEDIUM_SEA_GREEN
const _SECTIONS_COLOR_EXTERNAL_DEFAULT: Color = Color.MEDIUM_PURPLE
const _SECTIONS_COLOR_AFK_DEFAULT: Color = Color.SLATE_GRAY
const _SECTIONS_COLOR_DOCUMENTATION_DEFAULT: Color = Color.LIGHT_PINK

const _AFK_TIMER_DEFAULT: float = 300.0
const _AFK_USE_AFK_DEFAULT: bool = true

const _FILE_LOCATION_HINT_STRING: String = "Project (res://),User data (user://),Custom"


func _enter_tree() -> void:
	# #######################################
	# Save file
	# #######################################
	_register_setting(SAVE_FILE_NAME, _SAVE_FILE_NAME_DEFAULT, TYPE_STRING)
	_register_setting(SAVE_FILE_LOCATION, _SAVE_FILE_LOCATION_DEFAULT, TYPE_STRING, PROPERTY_HINT_ENUM, _FILE_LOCATION_HINT_STRING)
	_register_setting(SAVE_FILE_CUSTOM_LOCATION, _SAVE_FILE_CUSTOM_LOCATION_DEFAULT, TYPE_STRING, PROPERTY_HINT_GLOBAL_DIR)

	# #######################################
	# Log journal file
	# #######################################
	_register_setting(LOG_JOURNAL_ENABLED, _LOG_JOURNAL_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(LOG_JOURNAL_FILE_NAME, _LOG_JOURNAL_FILE_NAME_DEFAULT, TYPE_STRING)
	_register_setting(LOG_JOURNAL_FILE_LOCATION, _LOG_JOURNAL_FILE_LOCATION_DEFAULT, TYPE_STRING, PROPERTY_HINT_ENUM, _FILE_LOCATION_HINT_STRING)
	_register_setting(LOG_JOURNAL_FILE_CUSTOM_LOCATION, _LOG_JOURNAL_FILE_CUSTOM_LOCATION_DEFAULT, TYPE_STRING, PROPERTY_HINT_GLOBAL_DIR)

	# #######################################
	# Debug
	# #######################################
	_register_setting(DEBUG_ENABLED, _DEBUG_ENABLED_DEFAULT, TYPE_BOOL)

	# #######################################
	# Sections
	# #######################################
	_register_setting(SECTIONS_UI_SHOW_SECTIONS, _SECTIONS_UI_SHOW_SECTIONS_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_UI_SHOW_GRAPHS, _SECTIONS_UI_SHOW_GRAPHS_DEFAULT, TYPE_BOOL)

	_register_setting(SECTIONS_2D_ENABLED, _SECTIONS_2D_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_3D_ENABLED, _SECTIONS_3D_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_SCRIPT_ENABLED, _SECTIONS_SCRIPT_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_GAME_ENABLED, _SECTIONS_GAME_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_ASSET_STORE_ENABLED, _SECTIONS_ASSET_STORE_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_EXTERNAL_ENABLED, _SECTIONS_EXTERNAL_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_AFK_ENABLED, _SECTIONS_AFK_ENABLED_DEFAULT, TYPE_BOOL)
	_register_setting(SECTIONS_DOCUMENTATION_ENABLED, _SECTIONS_DOCUMENTATION_ENABLED_DEFAULT, TYPE_BOOL)

	# #######################################
	# Colors
	# #######################################
	_register_setting(SECTIONS_COLOR_2D, _SECTIONS_COLOR_2D_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_3D, _SECTIONS_COLOR_3D_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_SCRIPT, _SECTIONS_COLOR_SCRIPT_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_GAME, _SECTIONS_COLOR_GAME_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_ASSET_STORE, _SECTIONS_COLOR_ASSET_STORE_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_EXTERNAL, _SECTIONS_COLOR_EXTERNAL_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_AFK, _SECTIONS_COLOR_AFK_DEFAULT, TYPE_COLOR)
	_register_setting(SECTIONS_COLOR_DOCUMENTATION, _SECTIONS_COLOR_DOCUMENTATION_DEFAULT, TYPE_COLOR)

	# #######################################
	# AFK
	# #######################################
	_register_setting(AFK_TIMER, _AFK_TIMER_DEFAULT, TYPE_INT)
	_register_setting(AFK_USE_AFK, _AFK_USE_AFK_DEFAULT, TYPE_BOOL)



# #######################################
# Helpers
# #######################################
func _register_setting(key: String, default_value, type: int, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> void:
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, default_value)

	ProjectSettings.add_property_info({
		"name": key,
		"type": type,
		"hint": hint,
		"hint_string": hint_string,
	})

	ProjectSettings.set_initial_value(key, default_value)
