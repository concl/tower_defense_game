extends Node2D

var current_wave = 0

var wave_in_progress = false

var queue_progress = 0
var queued_spawn: String = ""

const enemy_types = {
    "test_enemy": preload("res://scenes/entities/enemies/test_enemy.tscn")
}

@export var waves = [[{"enemy": "test_enemy", "amount": 10}]]



func handle_spawns():
    pass
    

func start_wave():
    pass
    
    
func _ready():
    start_wave()

func _physics_process(delta: float) -> void:
    
    if wave_in_progress:
        handle_spawns()
