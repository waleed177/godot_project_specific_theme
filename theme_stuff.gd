tool
extends EditorPlugin

var dock

var settings_to_save = [
	"interface/theme/preset",
	"interface/theme/icon_and_font_color",
	"interface/theme/base_color",
	"interface/theme/accent_color",
	"interface/theme/contrast", 
	"interface/theme/relationship_line_opacity", 
	"interface/theme/border_size", 
	"interface/theme/use_graph_node_headers", 
	"interface/theme/additional_spacing"
]

var theme: ThemeClass

func _enter_tree():
	
	if ResourceLoader.exists("res://project_theme.tres"):
		theme = load("res://project_theme.tres") as ThemeClass
	else:
		theme = ThemeClass.new()
	
	if not theme or theme.dock_enabled:
		dock = preload("./dock.tscn").instance()
		add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
		dock.get_node("Save").connect("pressed", self, "_on_save_btn_clicked")
		dock.get_node("RemoveDock").connect("pressed", self, "_on_remove_dock_btn_clicked")
	
	if theme and not theme.theme.empty():
		var settings = get_editor_interface().get_editor_settings()
		
		for name in settings_to_save:
			settings.set_setting(name, theme.theme[name])
	

func _on_save_btn_clicked():
	var settings = get_editor_interface().get_editor_settings()
	for name in settings_to_save:
		theme.theme[name] = settings.get_setting(name)
	ResourceSaver.save("res://project_theme.tres", theme)

func _on_remove_dock_btn_clicked():
	if theme.dock_enabled:
		theme.dock_enabled = false
		remove_control_from_docks(dock)
		dock.queue_free()
		ResourceSaver.save("res://project_theme.tres", theme)


func _exit_tree():
	if theme.dock_enabled:
		remove_control_from_docks(dock)
		dock.queue_free()
