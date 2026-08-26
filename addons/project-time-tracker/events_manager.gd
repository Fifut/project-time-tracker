extends Node

signal on_focused_window(window_name: String)
signal on_input_event()
signal on_playing_scene()
signal on_stopping_scene()

var _focused_window: String = ""
var _is_playing_scene: bool = false


func _process(delta: float) -> void:
	
	# Focused window manager
	var window = Window.get_focused_window()
	
	if not window and _focused_window != "External":
		_focused_window = "External"
		on_focused_window.emit(_focused_window)
	
	elif not window:
		pass
	
	elif window.title != _focused_window:
		_focused_window = window.title
		on_focused_window.emit(_focused_window)
	
	if window:
		if not window.window_input.is_connected(_windows_event):
			window.window_input.connect(_windows_event)
	
	
	# Playing scene manager
	if EditorInterface.is_playing_scene() and not _is_playing_scene:
		_is_playing_scene = true
		on_playing_scene.emit()
		
	elif not EditorInterface.is_playing_scene() and _is_playing_scene:
		_is_playing_scene = false
		on_stopping_scene.emit()


func _windows_event(event):
	on_input_event.emit()
