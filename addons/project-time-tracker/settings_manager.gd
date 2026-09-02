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



func _enter_tree():
	
	# #######################################
	# Save file
	# #######################################
	var key = SAVE_FILE_NAME
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SAVE_FILE_NAME_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SAVE_FILE_NAME_DEFAULT)
	
	key = SAVE_FILE_LOCATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SAVE_FILE_LOCATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Project (res://),User data (user://),Custom"
	})
	ProjectSettings.set_initial_value(key, _SAVE_FILE_LOCATION_DEFAULT)
	
	key = SAVE_FILE_CUSTOM_LOCATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SAVE_FILE_CUSTOM_LOCATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
	})
	ProjectSettings.set_initial_value(key, _SAVE_FILE_CUSTOM_LOCATION_DEFAULT)
	
	# #######################################
	# Log journal file
	# #######################################
	key = LOG_JOURNAL_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _LOG_JOURNAL_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _LOG_JOURNAL_ENABLED_DEFAULT)
	
	key = LOG_JOURNAL_FILE_NAME
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _LOG_JOURNAL_FILE_NAME_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _LOG_JOURNAL_FILE_NAME_DEFAULT)
	
	key = LOG_JOURNAL_FILE_LOCATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _LOG_JOURNAL_FILE_LOCATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Project (res://),User data (user://),Custom"
	})
	ProjectSettings.set_initial_value(key, _LOG_JOURNAL_FILE_LOCATION_DEFAULT)
	
	key = LOG_JOURNAL_FILE_CUSTOM_LOCATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _LOG_JOURNAL_FILE_CUSTOM_LOCATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
	})
	ProjectSettings.set_initial_value(key, _LOG_JOURNAL_FILE_CUSTOM_LOCATION_DEFAULT)
	
	# #######################################
	# Debug
	# #######################################
	key = DEBUG_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _DEBUG_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _DEBUG_ENABLED_DEFAULT)
	
	# #######################################
	# Sections
	# #######################################
	key = SECTIONS_UI_SHOW_SECTIONS
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_UI_SHOW_SECTIONS_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_UI_SHOW_SECTIONS_DEFAULT)
	
	key = SECTIONS_UI_SHOW_GRAPHS
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_UI_SHOW_GRAPHS_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_UI_SHOW_GRAPHS_DEFAULT)
		
	key = SECTIONS_2D_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_2D_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_2D_ENABLED_DEFAULT)
	
	key = SECTIONS_3D_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_3D_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_3D_ENABLED_DEFAULT)
	
	key = SECTIONS_SCRIPT_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_SCRIPT_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_SCRIPT_ENABLED_DEFAULT)

	key = SECTIONS_GAME_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_GAME_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_GAME_ENABLED_DEFAULT)

	key = SECTIONS_ASSET_STORE_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_ASSET_STORE_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_ASSET_STORE_ENABLED_DEFAULT)

	key = SECTIONS_EXTERNAL_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_EXTERNAL_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_EXTERNAL_ENABLED_DEFAULT)

	key = SECTIONS_AFK_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_AFK_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_AFK_ENABLED_DEFAULT)	
		
	key = SECTIONS_DOCUMENTATION_ENABLED
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_DOCUMENTATION_ENABLED_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_DOCUMENTATION_ENABLED_DEFAULT)	
	
	
	# #######################################
	# Colors
	# #######################################
	key = SECTIONS_COLOR_2D
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_2D_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_2D_DEFAULT)
	
	key = SECTIONS_COLOR_3D
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_3D_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_3D_DEFAULT)
	
	key = SECTIONS_COLOR_SCRIPT
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_SCRIPT_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_SCRIPT_DEFAULT)
		
	key = SECTIONS_COLOR_GAME
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_GAME_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_GAME_DEFAULT)
	
	key = SECTIONS_COLOR_ASSET_STORE
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_ASSET_STORE_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})		
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_ASSET_STORE_DEFAULT)
	
	key = SECTIONS_COLOR_EXTERNAL
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_EXTERNAL_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_EXTERNAL_DEFAULT)
		
	key = SECTIONS_COLOR_AFK
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_AFK_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_AFK_DEFAULT)
	
		
	key = SECTIONS_COLOR_DOCUMENTATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _SECTIONS_COLOR_DOCUMENTATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _SECTIONS_COLOR_DOCUMENTATION_DEFAULT)
	
		
	# #######################################
	# AFK
	# #######################################
	key = AFK_TIMER
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _AFK_TIMER_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _AFK_TIMER_DEFAULT)
			
	key = AFK_USE_AFK
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, _AFK_USE_AFK_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, _AFK_USE_AFK_DEFAULT)
