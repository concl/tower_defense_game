extends Projectile
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        body.take_damage(10)
        collision_shape_2d.disabled = true
        fade_and_die()

func _on_timer_timeout() -> void:
    queue_free()
