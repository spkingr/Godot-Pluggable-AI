extends Resource
class_name EnemyStatus, 'res://assets/icons/enemy-states-icon.svg'


export var moveSpeed := 120              # movement, patrol, chase
export var lookRange := 500              # look sight length
export var lookAngle := 30               # look sight angle in degrees
export var attackRange := 350            # minimal distance attack range
export var attackRate := 2.5             # fire cooldown timer
export var attackForce := 1.0            # no usage (in tank)
export var attackDamage := 10            # no usage (in explosion)
export var searchDuration := 8.0         # search timer
export var searchTurnSpeed := 2.0        # rotate speed in radians

export var resourceName := 'EnemyStatus'    # Debug
