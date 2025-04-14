extends CharacterBody2D

class_name Entity

signal health_changed

var health: int:
    set(new_health):
        health = new_health
        health_changed.emit()
    get:
        return health
var is_enemy: bool

func die():
    queue_free()

func take_damage(damage: int):
    health -= damage
    if health <= 0:
        die()
