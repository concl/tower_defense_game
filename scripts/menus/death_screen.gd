extends Control

const MAIN_MENU = preload("res://scenes/menus/main_menu.tscn")

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    get_tree().paused = true

func _on_main_menu_pressed() -> void:
    Globals.remove_ui()
    get_tree().change_scene_to_packed(MAIN_MENU)
    get_tree().paused = false
    queue_free()
