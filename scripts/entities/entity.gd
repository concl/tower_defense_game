extends CharacterBody2D

class_name Entity

var health: int

func die():
    queue_free()

func take_damage(damage: int):
    health -= damage
