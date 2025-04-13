extends PathFollow2D

@onready var path = $"../"

var previous_position = Vector2()
var x_direction = 0
var payload

func _physics_process(delta: float) -> void:
    if payload:
        
        if progress + delta * payload.SPEED < path.curve.get_baked_length():
            progress += delta * payload.SPEED
        else:
            progress = path.curve.get_baked_length()
    else:
        queue_free()

func _ready() -> void:
    previous_position = global_position
