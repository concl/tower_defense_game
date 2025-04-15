extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

const TRACK = true
const SPEED = 600

func _ready() -> void:
    health = 16


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        body.take_damage(10)

func _physics_process(delta: float) -> void:
    var path_direc = get_parent().get_path_direction()
    if path_direc.x >= 0.1:
        animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
    elif path_direc.x <= -0.1:
        animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)
