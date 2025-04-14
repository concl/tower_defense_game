extends Projectile

@onready var area_2d: Area2D = $Area2D

var DAMAGE = 5

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Enemy:
        body.take_damage(DAMAGE)
        area_2d.queue_free()
        fade_and_die()
        
func _on_timer_timeout() -> void:
    queue_free()
