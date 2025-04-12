extends Control

const MAIN_MENU = preload("res://scenes/menus/main_menu.tscn")

func _on_continue_pressed() -> void:
    get_tree().paused = false
    queue_free()
    


func _on_main_menu_pressed() -> void:
    
    get_tree().change_scene_to_packed(MAIN_MENU)
    get_tree().paused = false
    queue_free()
