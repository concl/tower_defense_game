extends Control

const TEST_LEVEL = preload("res://scenes/levels/test_level.tscn")

@onready var main: Control = $Main
@onready var settings: Control = $Settings
@onready var how_to_play: Control = $HowToPlay
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
    animation_player.play("fade_out")

func _on_how_to_play_pressed() -> void:
    main.hide()
    how_to_play.show()


func _on_back_2_pressed() -> void:
    how_to_play.hide()
    main.show()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "fade_out":
        get_tree().change_scene_to_packed(TEST_LEVEL)
