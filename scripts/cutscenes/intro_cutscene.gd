extends Control

const MAIN_MENU = preload("res://scenes/menus/main_menu.tscn")
const TEST_LEVEL = preload("res://scenes/levels/test_level.tscn")

func _on_video_stream_player_finished() -> void:
    get_tree().change_scene_to_packed(MAIN_MENU)


func _on_skip_button_pressed() -> void:
    get_tree().change_scene_to_packed(MAIN_MENU)
