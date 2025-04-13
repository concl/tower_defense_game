extends Node

const MAIN_UI = preload("res://scenes/ui/main_ui.tscn")
const MAIN_MENU = preload("res://scenes/menus/main_menu.tscn")
const PAUSE_MENU = preload("res://scenes/menus/pause_menu.tscn")
const DEATH_SCREEN = preload("res://scenes/ui/death_screen.tscn")

var ui = null

var _resolution = Vector2(1280, 720)

func _unhandled_input(event: InputEvent) -> void:
    
    if event.is_action_pressed("pause"):
        if !get_tree().current_scene.scene_file_path == MAIN_MENU.resource_path and ui != null:
            var pause_menu = PAUSE_MENU.instantiate()
            pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
            get_tree().paused = true
            ui.add_child(pause_menu)

func _ready() -> void:
    
    DisplayServer.window_set_position(Vector2(100, 100))
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    DisplayServer.window_set_size(Globals._resolution)
    

func add_ui():
    ui = MAIN_UI.instantiate()
    add_child(ui)


func remove_ui():
    ui.queue_free()

func trigger_death():
    
    var death_screen = DEATH_SCREEN.instantiate()
    ui.add_child(death_screen)
    
    
    
