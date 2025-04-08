extends Node


var _resolution = Vector2(1280, 720)

func _ready() -> void:
    DisplayServer.window_set_position(Vector2(100, 100))
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    DisplayServer.window_set_size(Globals._resolution)
