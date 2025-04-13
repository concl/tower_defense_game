extends Entity

# Attack cooldown in frames
var cooldown = 120

# Cooldown progress, when it hits 0, the tower will check for targets
var progress = 0


func attack():
    pass
    

func _physics_process(delta: float) -> void:
    if progress == 0:
        pass
        
