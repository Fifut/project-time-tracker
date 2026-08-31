extends Node

signal on_focused_window(window_name: String)
signal on_playing_scene()
signal on_stopping_scene()

var _focused_window: bool = true
var _is_playing_scene: bool = false


func _process(delta: float) -> void:
	
	# Playing scene manager
	if EditorInterface.is_playing_scene() and not _is_playing_scene:
		_is_playing_scene = true
		on_playing_scene.emit()
		
	elif not EditorInterface.is_playing_scene() and _is_playing_scene:
		_is_playing_scene = false
		on_stopping_scene.emit()
		
		
	# Focused window manager
	var window = Window.get_focused_window()
	
	if window:
		if not window.window_input.is_connected(_window_event):
			window.window_input.connect(_window_event.bind(window.title) )
			
		if not window.focus_entered.is_connected(_window_focus):
			window.focus_entered.connect(_window_focus.bind(window.title) )
	
	if window and not _focused_window:
		_focused_window = true
		on_focused_window.emit(window.title)
						
	elif not window and _focused_window:
		_focused_window = false
		on_focused_window.emit("External")
				
	
	
# #######################################
# Signals
# #######################################
func _window_focus(windows_title):
	on_focused_window.emit(windows_title)
		
		
func _window_event(event, windows_title):
	
	# Mouse motion filter
	if event is InputEventMouseMotion:
		return
		
	on_focused_window.emit(windows_title)
