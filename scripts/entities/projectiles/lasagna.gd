extends Projectile
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
    #var texture0 = load("res://assets/images/projectiles/lasagna1.png")
    #var texture1 = load("res://assets/images/projectiles/lasagna2.png")
    var textures = [preload("res://assets/images/projectiles/lasagna1.png"), preload("res://assets/images/projectiles/lasagna2.png")]
    var rng = RandomNumberGenerator.new()
    $Sprite2D.texture = textures[rng.randi_range(0, 1)]

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        body.take_damage(10)
        fade_and_die()

func _on_timer_timeout() -> void:
    queue_free()
