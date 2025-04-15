extends Entity

class_name Enemy


const COIN = preload("res://scenes/entities/pickups/coin.tscn")
const DROP_SPEED = 100
var money_dropped = 2


func take_damage(damage):
    
    self.material.set_shader_parameter("flash_amount", 1.0)
    for frame in range(10):
        await get_tree().process_frame
    self.material.set_shader_parameter("flash_amount", 0.0)
    
    super(damage)

func die():
    
    for coin in range(money_dropped):
        var pickup = COIN.instantiate()
        pickup.global_position = global_position
        pickup.velocity = Vector2(1,0).rotated(randf_range(0,2 * PI)) * DROP_SPEED
        get_tree().current_scene.add_child(pickup)
    
    super()
