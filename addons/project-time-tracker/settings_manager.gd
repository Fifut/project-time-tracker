class_name ProjectTimeTrackerSettingsManager extends Node

# #######################################
# Settings keys
# #######################################
const SAVE_FILE_NAME: String = "project_time_tracker/general/save_file/name"
const SAVE_FILE_LOCATION: String = "project_time_tracker/general/save_file/location"
const SAVE_FILE_CUSTOM_LOCATION: String = "project_time_tracker/general/save_file/custom_location"

const SECTIONS_SHOW_SECTIONS: String = "project_time_tracker/sections/sections/show_sections"
const SECTIONS_SHOW_GRAPHS: String = "project_time_tracker/sections/sections/show_graphs"
const SECTIONS_USE_EXTERNAL: String = "project_time_tracker/sections/sections/use_external"

const SECTIONS_COLOR: String = "project_time_tracker/sections/colors/"
const SECTIONS_COLOR_2D: String = "project_time_tracker/sections/colors/2D"
const SECTIONS_COLOR_3D: String = "project_time_tracker/sections/colors/3D"
const SECTIONS_COLOR_SCRIPT: String = "project_time_tracker/sections/colors/Script"
const SECTIONS_COLOR_GAME: String = "project_time_tracker/sections/colors/Game"
const SECTIONS_COLOR_ASSET_STORE: String = "project_time_tracker/sections/colors/Asset Store"
const SECTIONS_COLOR_EXTERNAL: String = "project_time_tracker/sections/colors/External"
const SECTIONS_COLOR_AFK: String = "project_time_tracker/sections/colors/AFK"
const SECTIONS_COLOR_DOCUMENTATION: String = "project_time_tracker/sections/colors/Documentation"
const SECTIONS_COLOR_OTHER: String = "project_time_tracker/sections/colors/Other"

const AFK_TIMER: String = "project_time_tracker/afk/afk_timer"
const AFK_USE_AFK: String = "project_time_tracker/afk/use_afk"

# #######################################
# Settings default values
# #######################################
const SAVE_FILE_NAME_DEFAULT: String = "project_time_tracker"
const SAVE_FILE_LOCATION_DEFAULT: String = "Project (res://)"
const SAVE_FILE_CUSTOM_LOCATION_DEFAULT: String = ""

const SECTIONS_SHOW_SECTIONS_DEFAULT: bool = true
const SECTIONS_SHOW_GRAPHS_DEFAULT: bool = true
const SECTIONS_USE_EXTERNAL_DEFAULT: bool = false

const SECTIONS_COLOR_2D_DEFAULT: Color = Color.DEEP_SKY_BLUE
const SECTIONS_COLOR_3D_DEFAULT: Color = Color.CORAL
const SECTIONS_COLOR_SCRIPT_DEFAULT: Color = Color.YELLOW
const SECTIONS_COLOR_GAME_DEFAULT: Color = Color.FIREBRICK
const SECTIONS_COLOR_ASSET_STORE_DEFAULT: Color = Color.MEDIUM_SEA_GREEN
const SECTIONS_COLOR_EXTERNAL_DEFAULT: Color = Color.MEDIUM_PURPLE
const SECTIONS_COLOR_AFK_DEFAULT: Color = Color.SLATE_GRAY
const SECTIONS_COLOR_DOCUMENTATION_DEFAULT: Color = Color.LIGHT_PINK
const SECTIONS_COLOR_OTHER_DEFAULT: Color = Color.WHITE

const AFK_TIMER_DEFAULT: float = 300.0
const AFK_USE_AFK_DEFAULT: bool = true



func _enter_tree():
	
	# #######################################
	# Save file
	# #######################################
	var key = SAVE_FILE_NAME
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SAVE_FILE_NAME_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SAVE_FILE_NAME_DEFAULT)
	
	key = SAVE_FILE_LOCATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SAVE_FILE_LOCATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Project (res://),User data (user://),Custom"
	})
	ProjectSettings.set_initial_value(key, SAVE_FILE_LOCATION_DEFAULT)
	
	key = SAVE_FILE_CUSTOM_LOCATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SAVE_FILE_CUSTOM_LOCATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_DIR,
	})
	ProjectSettings.set_initial_value(key, SAVE_FILE_CUSTOM_LOCATION_DEFAULT)
	
	# #######################################
	# Sections
	# #######################################
	key = SECTIONS_SHOW_SECTIONS
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_SHOW_SECTIONS_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_SHOW_SECTIONS_DEFAULT)
	
	key = SECTIONS_SHOW_GRAPHS
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_SHOW_GRAPHS_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_SHOW_GRAPHS_DEFAULT)
		
	key = SECTIONS_USE_EXTERNAL
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_USE_EXTERNAL_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_USE_EXTERNAL_DEFAULT)
	
	# #######################################
	# Colors
	# #######################################
	key = SECTIONS_COLOR_2D
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_2D_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_2D_DEFAULT)
	
	key = SECTIONS_COLOR_3D
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_3D_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_3D_DEFAULT)
	
	key = SECTIONS_COLOR_SCRIPT
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_SCRIPT_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_SCRIPT_DEFAULT)
		
	key = SECTIONS_COLOR_GAME
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_GAME_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})	
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_GAME_DEFAULT)
	
	key = SECTIONS_COLOR_ASSET_STORE
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_ASSET_STORE_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})		
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_ASSET_STORE_DEFAULT)
	
	key = SECTIONS_COLOR_EXTERNAL
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_EXTERNAL_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_EXTERNAL_DEFAULT)
		
	key = SECTIONS_COLOR_AFK
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_AFK_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_AFK_DEFAULT)
	
		
	key = SECTIONS_COLOR_DOCUMENTATION
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_DOCUMENTATION_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_DOCUMENTATION_DEFAULT)
	
	key = SECTIONS_COLOR_OTHER
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, SECTIONS_COLOR_OTHER_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, SECTIONS_COLOR_OTHER_DEFAULT)
		
	# #######################################
	# AFK
	# #######################################
	key = AFK_TIMER
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, AFK_TIMER_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, AFK_TIMER_DEFAULT)
			
	key = AFK_USE_AFK
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting(key, AFK_USE_AFK_DEFAULT)
	ProjectSettings.add_property_info({
		"name": key,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
	})
	ProjectSettings.set_initial_value(key, AFK_USE_AFK_DEFAULT)


func get_setting(setting: String) -> Variant:
	return ProjectSettings.get_setting(setting)
