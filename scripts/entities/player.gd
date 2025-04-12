extends Entity

@onready var sprites: Node2D = $Sprites

var SPEED = 400
var ACCELERATION = 40

func handle_input(delta: float):
    # Handle looking
    var mouse_pos = get_global_mouse_position()
    if mouse_pos.x > self.global_position.x:
        sprites.scale.x = -abs(sprites.scale.x)  # Flip horizontally if on the left side
    else:
        sprites.scale.x = abs(sprites.scale.x)  # No flip if on the right side

    if mouse_pos.y < self.global_position.y:
        sprites.scale.y = abs(sprites.scale.y)  # Flip vertically if on the top side
    else:
        sprites.scale.y = -abs(sprites.scale.y)  # No flip if on the bottom side
    
    # Handle running
    var move_direc = Vector2(0,0)
    if Input.is_action_pressed("move_right"):
        move_direc += Vector2(1,0)
        
    if Input.is_action_pressed("move_left"):
        move_direc += Vector2(-1,0)
        
    if Input.is_action_pressed("move_up"):
        move_direc += Vector2(0,-1)
    
    if Input.is_action_pressed("move_down"):
        move_direc += Vector2(0,1)
    
    var final_direc = move_direc.normalized() * SPEED
    velocity = velocity.move_toward(final_direc, ACCELERATION * delta * 60)
    
    
    
    

func _physics_process(delta: float) -> void:
    handle_input(delta)
    
    move_and_slide()
    
