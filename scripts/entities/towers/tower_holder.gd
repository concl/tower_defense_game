extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

const TOWERS = [
    preload("res://scenes/entities/towers/dispenser.tscn"),
    preload("res://scenes/entities/towers/shooter_tower.tscn"),
]

const PRICES = [50, 50, 50]

func _physics_process(delta: float) -> void:
    pass


func _on_area_2d_mouse_entered() -> void:
    sprite_2d.material.set_shader_parameter("flash_amount", 0.5)


func _on_area_2d_mouse_exited() -> void:
    sprite_2d.material.set_shader_parameter("flash_amount", 0)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
        var player = get_tree().get_first_node_in_group("Player")
        var tower = player.holding_tower
        if tower == -1:
            return
        if player.money >= PRICES[tower]:
            player.normal_mode()
            player.money -= PRICES[tower]
            var new_tower = TOWERS[tower].instantiate()
            new_tower.global_position = global_position
            get_tree().current_scene.add_child(new_tower)
            queue_free()
