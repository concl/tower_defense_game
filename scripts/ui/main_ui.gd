extends CanvasLayer

class_name MainUI

const MAIN_UI_SCENE = preload("res://scenes/ui/main_ui.tscn")

var player: Player
var level

const CURSOR_NORMAL = preload("res://assets/images/cursors/cursor_normal.png")
const DISPENSER_CURSOR = preload("res://assets/images/cursors/dispenser_cursor.png")
const SHOOTER_CURSOR = preload("res://assets/images/cursors/shooter_cursor.png")
const SHOTGUN_TOWER_CURSOR = preload("res://assets/images/cursors/shotgun_tower_cursor.png")

@onready var in_game_ui: Control = $InGameUI
@onready var health_bar: TextureProgressBar = $InGameUI/VBoxContainer/MarginContainer/HealthBar
@onready var label: Label = $InGameUI/VBoxContainer/MarginContainer/HealthBar/Label
@onready var stamina_bar: TextureProgressBar = $InGameUI/VBoxContainer/StaminaBar
@onready var weapon_icon: TextureRect = $InGameUI/WeaponIcon
@onready var ammo_count: Label = $InGameUI/AmmoCount
@onready var coin_label: Label = $InGameUI/RightSide/RightPanel/HBoxContainer/CoinLabel
@onready var boss_bar: TextureProgressBar = $InGameUI/BossBar

@onready var start_wave: Button = $InGameUI/RightSide/StartWave
@onready var tower_info: PanelContainer = $InGameUI/RightSide/RightPanel/TowerInfo

const SHOTGUN_ICON = preload("res://assets/images/ui/shotgun_icon.png")
const MG_ICON = preload("res://assets/images/ui/mg_icon.png")

var boss = null

static func create(player, level) -> MainUI:
    var instance = MAIN_UI_SCENE.instantiate()
    instance.player = player
    instance.level = level
    
    return instance

func boss_battle(boss):
    boss = boss
    boss_bar.show()


func _physics_process(delta: float) -> void:
    stamina_bar.value = float(player.stamina)
    coin_label.text = str(player.money)
    if boss:
        boss_bar.value = boss.health
    
    if player.current_weapon == player.SHOTGUN:
        weapon_icon.texture = SHOTGUN_ICON
        ammo_count.text = str(player.ammo[player.SHOTGUN])
    elif player.current_weapon == player.MG:
        weapon_icon.texture = MG_ICON
        ammo_count.text = str(player.ammo[player.MG])
    
    

func _on_player_health_changed():
    health_bar.value = float(player.health)
    label.text = str(player.health)

func _on_wave_start():
    start_wave.disabled = true

func _on_wave_end():
    start_wave.disabled = false

func _ready() -> void:
    player.health_changed.connect(_on_player_health_changed)
    level.wave_started.connect(_on_wave_start)
    level.wave_ended.connect(_on_wave_end)


func _on_start_wave_pressed() -> void:
    level.start_wave()

func tower_mode():
    tower_info.show()

func normal_mode():
    tower_info.hide()


func _on_dispenser_pressed() -> void:
    Input.set_custom_mouse_cursor(DISPENSER_CURSOR)
    player.holding_tower = 0


func _on_shooter_pressed() -> void:
    Input.set_custom_mouse_cursor(SHOOTER_CURSOR)
    player.holding_tower = 1


func _on_shotgun_pressed() -> void:
    Input.set_custom_mouse_cursor(SHOTGUN_TOWER_CURSOR)
    player.holding_tower = 2


func _on_trash_pressed() -> void:
    Input.set_custom_mouse_cursor(CURSOR_NORMAL)
    player.holding_tower = -1
