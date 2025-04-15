extends Enemy


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const BALL_SPEED = 800
const SPEED = 100
const ENEMY_BALL = preload("res://scenes/entities/projectiles/enemy_ball.tscn")
const TRACK = true

var attack_cooldown = 240
var cooldown_progress = 90

func attack():
    var player = get_tree().get_first_node_in_group("Player")
    
    var direction = player.global_position - global_position
    if direction.length() >= 500:
        return
    
    cooldown_progress = attack_cooldown
    
    if direction.length() != 0:
        direction = direction.normalized()
    else:
        direction = Vector2(1,0)
    
    animated_sprite_2d.play("fire")
    for x in range(5):
        var ball = ENEMY_BALL.instantiate()
        var new_direc = direction.rotated(randf_range(-0.1, 0.1))
        ball.linear_velocity = BALL_SPEED * new_direc
        ball.global_position = self.global_position
        get_tree().current_scene.add_child(ball)

        

func _physics_process(delta: float) -> void:
    var path_direc = get_parent().get_path_direction()
    if path_direc.x >= 0.1:
        animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
    elif path_direc.x <= -0.1:
        animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)
        
    if cooldown_progress == 0:
        attack()
    else:
        cooldown_progress -= 1

func _ready() -> void:
    health = 150
    money_dropped = 4


func _on_animated_sprite_2d_animation_finished() -> void:
    animated_sprite_2d.play("default")
