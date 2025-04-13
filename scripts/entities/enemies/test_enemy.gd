extends Enemy

@onready var area_2d: Area2D = $Area2D

const TRACK = true
const SPEED = 200

func _ready() -> void:
    health = 16


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        body.take_damage(10)
