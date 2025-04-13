extends CanvasLayer

var player = null
@onready var in_game_ui: Control = $InGameUI
@onready var health_bar: TextureProgressBar = $InGameUI/VBoxContainer/MarginContainer/HealthBar
@onready var label: Label = $InGameUI/VBoxContainer/MarginContainer/HealthBar/Label
@onready var stamina_bar: TextureProgressBar = $InGameUI/VBoxContainer/StaminaBar
@onready var weapon_icon: TextureRect = $InGameUI/WeaponIcon

const SHOTGUN_ICON = preload("res://assets/images/ui/shotgun_icon.png")
const MG_ICON = preload("res://assets/images/ui/mg_icon.png")

func _physics_process(delta: float) -> void:
    health_bar.value = float(player.health)
    label.text = str(player.health)
    stamina_bar.value = float(player.stamina)
    
    if player.current_weapon == player.SHOTGUN:
        weapon_icon.texture = SHOTGUN_ICON
    elif player.current_weapon == player.MG:
        weapon_icon.texture = MG_ICON
    
