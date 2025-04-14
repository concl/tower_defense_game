extends Node2D

const TOWER_BALL = preload("res://scenes/entities/projectiles/tower_ball.tscn")
@onready var range: Area2D = $Range
@onready var cooldown: Timer = $Cooldown
@onready var spawnpoint: Node2D = $Spawnpoint
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var can_shoot = false
var BALL_SPEED = 2400

func _on_cooldown_timeout() -> void:
    can_shoot = true


func attack():
    var target = null
    var best = INF
    for candidate in range.get_overlapping_bodies():
        if candidate is Enemy:
            var dist =  (candidate.global_position - spawnpoint.global_position).length()
            if dist < best:
                target = candidate
                best = dist
        
    if target:
        can_shoot = false
        cooldown.start()
    
        var direc = (target.global_position - spawnpoint.global_position)
        direc = direc.normalized() if direc.length() > 0 else Vector2(1,0)
        
        if direc.x >= 0:
            animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)
        else:
            animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
        
        var proj = TOWER_BALL.instantiate()
        proj.global_position = spawnpoint.global_position
        proj.linear_velocity = direc * BALL_SPEED
        get_tree().current_scene.add_child(proj)

func _physics_process(delta: float) -> void:
    if can_shoot:
        attack()
    
