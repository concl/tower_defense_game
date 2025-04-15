extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var main_path: Path2D = $Paths/MainPath
@onready var flank_path: Path2D = $Paths/FlankPath
@onready var tower_holders: Node2D = $TowerHolders

signal wave_started
signal wave_ended

var current_wave = -1

var wave_in_progress = false
var subwave = 0
var subwave_number = 0

var queue_progress = 0
var queued_spawn: String = ""
var queued_spawnpoint = 0

const TRACK_FOLLOWER = preload("res://scenes/entities/track_follower.tscn")
const ENEMY_TYPES = {
    "test_enemy": preload("res://scenes/entities/enemies/test_enemy.tscn"),
    "yarn": preload("res://scenes/entities/enemies/yarn.tscn"),
    "mouse_bomber": preload("res://scenes/entities/enemies/mouse_bomber.tscn"),
    "fast_mouse": preload("res://scenes/entities/enemies/fast_enemy.tscn"),
    "fat_enemy": preload("res://scripts/entities/enemies/fat_enemy.gd")
}

# Each element of waves is a list which contains dictionaries that describes subwaves
# A subwave dictionary contains the type of the enemy, the amount of the enemy,
# the spacing (in frames) between each enemy, and the spawnpoint (0 for the main 
# spawnpoint and 1 for the flank spawnpoint)

var waves: Array = [
    [
        {"enemy": "yarn", "amount": 5, "spacing": 80, "spawnpoint": 0},
    ],
    [
        {"enemy": "yarn", "amount": 10, "spacing": 40, "spawnpoint": 0},
    ],
    [
        {"enemy": "yarn", "amount": 12, "spacing": 20, "spawnpoint": 0},
        {"enemy": "yarn", "amount": 12, "spacing": 20, "spawnpoint": 1}
    ],
    [
        {"enemy": "mouse_bomber", "amount": 2, "spacing": 80, "spawnpoint": 0},
        {"enemy": "yarn", "amount": 20, "spacing": 20, "spawnpoint": 0},
    ],
    [
        {"enemy": "mouse_bomber", "amount": 5, "spacing": 40, "spawnpoint": 0},
        {"enemy": "yarn", "amount": 12, "spacing": 20, "spawnpoint": 1},
        {"enemy": "mouse_bomber", "amount": 10, "spacing": 40, "spawnpoint": 0},
    ],
    [
        {"enemy": "fast_mouse", "amount": 5, "spacing": 40, "spawnpoint": 0},
    ]
]


func handle_spawns():
    if current_wave >= waves.size():
        wave_in_progress = false
        return

    var current_subwaves = waves[current_wave]

    if queued_spawn == "":
        if subwave >= current_subwaves.size():
            # Wave ended
            wave_ended.emit()
            wave_in_progress = false
            subwave = 0
            return

        var current_subwave = current_subwaves[subwave]

        queued_spawn = current_subwave["enemy"]
        queue_progress = current_subwave["spacing"]
        queued_spawnpoint = current_subwave["spawnpoint"]
        subwave_number = current_subwave["amount"]

    if queue_progress > 0:
        queue_progress -= 1
    else:
        var enemy_scene = ENEMY_TYPES.get(queued_spawn)
        if enemy_scene:
            var enemy_instance = enemy_scene.instantiate()

            var spawn_path = main_path if queued_spawnpoint == 0 else flank_path

            if enemy_instance.TRACK:
                var path_follow = TRACK_FOLLOWER.instantiate()
                spawn_path.add_child(path_follow)
                path_follow.add_child(enemy_instance)
                path_follow.payload = enemy_instance
                path_follow.progress = 0
            else:
                add_child(enemy_instance)
                enemy_instance.global_position = spawn_path.curve.get_point_position(0)

        subwave_number -= 1

        if subwave_number > 0:
            queue_progress = current_subwaves[subwave]["spacing"]
        else:
            queued_spawn = ""
            subwave += 1

func start_wave():
    wave_in_progress = true
    current_wave += 1
    if current_wave < waves.size():
        wave_started.emit()

    
func _ready():
    Globals.add_ui(player, self)

func _physics_process(delta: float) -> void:
    
    if wave_in_progress:
        handle_spawns()
    
