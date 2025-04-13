extends CharacterBody2D

class_name Entity

signal damage_taken

var health: int
var is_enemy: bool

func die():
    queue_free()

func take_damage(damage: int):
    health -= damage
    if health <= 0:
        die()
    damage_taken.emit()
