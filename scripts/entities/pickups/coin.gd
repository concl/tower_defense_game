extends Pickup

@onready var area_2d: Area2D = $Area2D

const MONEY_GIVEN = 3

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        target = body
        area_2d.queue_free()
    
func consume():
    target.money += 3
    super()


func _on_timer_timeout() -> void:
    queue_free()
