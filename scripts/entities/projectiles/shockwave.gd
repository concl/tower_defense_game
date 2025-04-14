extends Node2D

const DAMAGE = 15
const expand_speed = 0.125
@onready var area_2d: Area2D = $Area2D

func _physics_process(delta: float) -> void:
    scale += delta * 60 * Vector2(1,1) * expand_speed


func fade_and_die(duration := 0.1):
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.0, duration)
    tween.connect("finished", Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished():
    queue_free()

func _on_timer_timeout() -> void:
    fade_and_die()


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        body.take_damage(DAMAGE)
