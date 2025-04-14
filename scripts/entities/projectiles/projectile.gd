extends RigidBody2D

class_name Projectile

func fade_and_die(duration := 0.05):
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.0, duration)
    tween.connect("finished", Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished():
    queue_free()
