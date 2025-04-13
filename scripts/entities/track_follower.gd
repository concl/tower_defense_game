extends PathFollow2D

@onready var path = $"../"

var previous_position = Vector2()
var x_direction = 0
var payload

func get_path_direction(lookahead_distance: float = 1.0) -> Vector2:
    var curve = self.get_parent().curve
    var offset = self.offset
    var pos_now = curve.sample_offset(offset)
    var pos_next = curve.sample_offset(offset + lookahead_distance)
    return (pos_next - pos_now).normalized()

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
