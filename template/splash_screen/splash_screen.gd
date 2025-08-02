extends Control


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	DisplayServer.window_set_mode(GameManager.display)
	DisplayServer.window_set_vsync_mode(GameManager.v_sync)


func _on_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://template/menus/title_screen/title_screen.tscn")
