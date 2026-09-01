@tool
extends ColorRect


func _ready() -> void:
	
	# If project parameters have changed maybe they're ours.
	ProjectSettings.settings_changed.connect(
		func():
			color = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_COLOR + name)
	)


func _process(delta: float) -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
		
	var percent = floori(size_flags_stretch_ratio * 100)
	
	if percent >= 10:
		$Percent.text = str(percent) + "%"
	elif percent >= 5:
		$Percent.text = str(percent)
	else:
		$Percent.text = ""
