extends Control

const LEVEL = preload("res://scenes/levels/test_level.tscn")

@onready var main: Control = $Main
@onready var settings: Control = $Settings

func _on_quit_pressed() -> void:
    get_tree().quit()

func _on_check_button_toggled(toggled_on: bool) -> void:
    if toggled_on:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        DisplayServer.window_set_size(Globals._resolution)
        
func _on_settings_pressed() -> void:
    main.hide()
    settings.show()


func _on_back_pressed() -> void:
    settings.hide()
    main.show()


func _on_new_game_pressed() -> void:
    get_tree().change_scene_to_packed(LEVEL)
    
