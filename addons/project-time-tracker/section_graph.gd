@tool
extends HBoxContainer


var sections : Dictionary = {}:
	set(value):
		sections = value
		_update_sections()


func _update_sections() -> void:
	if (!is_inside_tree()):
		return
	
	var total = 0.0
	var section_count = 0
	for section in sections:
		if section == "AFK":
			continue
		section_count += 1
		total += sections[section]
	
	for section in sections:
		if section == "AFK":
			continue	
			
		if (get_node_or_null(section)):
			get_node(section).size_flags_stretch_ratio = sections[section] / total
		else:
			var new_section = preload("res://addons/project-time-tracker/tracker_section_color.tscn").instantiate()
			new_section.name = section
			new_section.color = ProjectSettings.get_setting(PTTSettingsManager.SECTIONS_COLOR + section)
			new_section.size_flags_stretch_ratio = floor(sections[section]) / floor(total)
			add_child(new_section)


func clear():
	for child_node in get_children():
		remove_child(child_node)
		child_node.queue_free()
