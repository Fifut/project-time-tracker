@tool
extends ColorRect

@onready var percent_label: Label = %Percent

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
		percent_label.text = str(percent) + "%"
	elif percent >= 5:
		percent_label.text = str(percent)
	else:
		percent_label.text = ""
