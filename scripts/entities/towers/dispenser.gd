extends Node2D

const DISPENSER_PICKUP = preload("res://scenes/entities/pickups/dispenser_pickup.tscn")

const DISPENSE_SPEED = 200

func _on_animated_sprite_2d_animation_looped() -> void:
    var pickup = DISPENSER_PICKUP.instantiate()
    pickup.global_position = global_position
    pickup.velocity = Vector2(1,0).rotated(randf_range(0,2 * PI)) * 200
    get_tree().current_scene.add_child(pickup)
