extends Control

const MAIN_MENU = preload("res://scenes/menus/main_menu.tscn")

func _on_video_stream_player_finished() -> void:
    get_tree().change_scene_to_packed(MAIN_MENU)
