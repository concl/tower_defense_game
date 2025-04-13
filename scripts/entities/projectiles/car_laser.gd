extends RigidBody2D

var DAMAGE = 10

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(DAMAGE)
		queue_free()
