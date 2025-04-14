extends Enemy

@onready var sprites: Node2D = $Sprites
@onready var yarn_tail: Sprite2D = $Sprites/YarnTail

const ENEMY_BALL = preload("res://scenes/entities/projectiles/enemy_ball.tscn")

const BALL_SPEED = 400
const TRACK = true
const SPEED = 200

var attack_cooldown = 240
var cooldown_progress = 90

func attack():
    var player = get_tree().get_nodes_in_group("Player")[0]
    
    var direction = player.global_position - global_position
    if direction.length() != 0:
        direction = direction.normalized()
    else:
        direction = Vector2(1,0)
    
    var ball = ENEMY_BALL.instantiate()
    ball.linear_velocity = BALL_SPEED * direction
    ball.global_position = self.global_position
    get_tree().current_scene.add_child(ball)
    
    

func _ready() -> void:
    health = 32

func _physics_process(delta: float) -> void:
    var path_direc = get_parent().get_path_direction()
    if path_direc.x >= 0.1:
        sprites.scale.x = -abs(sprites.scale.x)
    elif path_direc.x <= -0.1:
        sprites.scale.x = abs(sprites.scale.x)
    
    if path_direc.y > 0.1:
        yarn_tail.hide()
        
    elif path_direc.y < -0.1:
        yarn_tail.show()
        yarn_tail.rotation_degrees = 90
        
    else:
        yarn_tail.show()
        yarn_tail.rotation_degrees = 0
        
    
    if cooldown_progress == 0:
        cooldown_progress = 60
        attack()
    else:
        cooldown_progress -= 1
