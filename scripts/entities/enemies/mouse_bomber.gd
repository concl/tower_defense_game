extends Enemy

enum {
    CHASING = 0,
    PRIMING = 1,
    BOMBING = 2
}

var state = CHASING

const TRACK = false
const SPEED = 300
const DIVE_SPEED = 900
const PRIME_DISTANCE = 300

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var explosion_hitbox: Area2D = $ExplosionHitbox
@onready var trigger_hitbox: Area2D = $TriggerHitbox

var player: Player

func _physics_process(delta: float) -> void:
    if player == null:
        player = get_tree().get_first_node_in_group("Player")
    
    var direction = player.global_position - global_position
    var dist = direction.length()
    
    if dist <= PRIME_DISTANCE and state == CHASING:
        velocity = Vector2(0,0)
        state = PRIMING
        var new_timer = Timer.new()
        new_timer.one_shot = true
        new_timer.wait_time = 0.5
        new_timer.timeout.connect(dive)
        add_child(new_timer)
        new_timer.start()
        
    
    if state == CHASING:

        if dist > 0:
            direction = direction.normalized()
        else:
            direction = Vector2(1,0)
        
        if direction.x > 0:
            animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
        else:
            animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)

        velocity = SPEED * direction
    move_and_slide()

func _ready():
    health = 10

func dive():
    state = BOMBING
    var direction = player.global_position - global_position
    if direction.length() > 0:
        direction = direction.normalized()
    else:
        direction = Vector2(1,0)
    
    velocity = DIVE_SPEED * direction
    trigger_hitbox.collision_mask = 2
    
    var new_timer = Timer.new()
    new_timer.one_shot = true
    new_timer.wait_time = 0.5
    new_timer.timeout.connect(explode)
    add_child(new_timer)
    new_timer.start()


func explode():
    state = BOMBING
    velocity = Vector2()
    animated_sprite_2d.scale = Vector2(4.0,4.0)
    if animated_sprite_2d.animation != "explode":
        animated_sprite_2d.play("explode")
        check_hits()

func die():
    explode()


func _on_animated_sprite_2d_animation_finished() -> void:
    queue_free()


func _on_trigger_hitbox_body_entered(body: Node2D) -> void:
    if body is Player:
        explode()

func check_hits() -> void:
    for body in explosion_hitbox.get_overlapping_bodies():
        if body is Player:
            body.take_damage(35)
            break
