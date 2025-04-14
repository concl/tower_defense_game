extends Node2D

class_name Pickup

var velocity = Vector2()
var target = null
var follow_speed = 8

const SLOW = 300

func consume():
    queue_free()

func _physics_process(delta: float) -> void:
    if target != null:
        follow_speed += 30 * delta
        global_position = global_position.lerp(target.global_position, follow_speed * delta)
        if (global_position - target.global_position).length() < 10:
            consume()
    else:
        global_position += velocity * delta
        velocity = velocity.move_toward(Vector2(), SLOW * delta)
