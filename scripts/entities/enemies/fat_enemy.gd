extends Enemy


const TRACK = true

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
    health = 150
