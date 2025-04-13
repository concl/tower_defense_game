extends CanvasLayer

class_name MainUI

const MAIN_UI_SCENE = preload("res://scenes/ui/main_ui.tscn")

var player: Player
@onready var in_game_ui: Control = $InGameUI
@onready var health_bar: TextureProgressBar = $InGameUI/VBoxContainer/MarginContainer/HealthBar
@onready var label: Label = $InGameUI/VBoxContainer/MarginContainer/HealthBar/Label
@onready var stamina_bar: TextureProgressBar = $InGameUI/VBoxContainer/StaminaBar
@onready var weapon_icon: TextureRect = $InGameUI/WeaponIcon
@onready var ammo_count: Label = $InGameUI/AmmoCount

const SHOTGUN_ICON = preload("res://assets/images/ui/shotgun_icon.png")
const MG_ICON = preload("res://assets/images/ui/mg_icon.png")

static func create(player) -> MainUI:
    var instance = MAIN_UI_SCENE.instantiate()
    instance.player = player
    return instance



func _physics_process(delta: float) -> void:
    stamina_bar.value = float(player.stamina)
    
    if player.current_weapon == player.SHOTGUN:
        weapon_icon.texture = SHOTGUN_ICON
        ammo_count.text = str(player.ammo[player.SHOTGUN])
    elif player.current_weapon == player.MG:
        weapon_icon.texture = MG_ICON
        ammo_count.text = str(player.ammo[player.MG])

func _on_player_damage_taken():
    health_bar.value = float(player.health)
    label.text = str(player.health)

func _ready() -> void:
    
    player.damage_taken.connect(_on_player_damage_taken)
