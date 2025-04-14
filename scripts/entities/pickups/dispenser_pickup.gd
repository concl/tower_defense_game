extends Pickup

@onready var area_2d: Area2D = $Area2D

var health_given = 15
var ammo_given = Vector3i(1, 5, 1)


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        target = body
        area_2d.queue_free()
    
func consume():
    target.health += health_given
    target.health = min(target.health, target.MAX_HEALTH)
    target.ammo += ammo_given
    target.ammo = target.ammo.min(target.MAX_AMMO)
    super()


func _on_timer_timeout() -> void:
    queue_free()
