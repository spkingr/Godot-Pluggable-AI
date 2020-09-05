extends Resource
class_name EnemyStatus, 'res://assets/icons/enemy-states-icon.svg'


export var moveSpeed := 150              # movement, patrol, chase
export var moveSpeedRandom := 50         # moveSpeed = moveSpeed + random
export var lookRange := 500              # look sight length
export var lookAngle := 30               # look sight angle in degrees
export var attackRange := 450            # minimal distance attack range
export var attackRangeRandom := 150      # attackRange = attackRange + random
export var attackRate := 1.5             # fire cooldown timer
export var attackRateRandom := 1.0       # attackRate = attackRate + random

#export var attackForceMin := 0.5         # min attack force (missile move speed)
#export var attackForceMax := 1.0         # max attack force (missile move speed)
export var missileLaunchPrecision := 0.6 # max precision is 1.0

export var attackDamage := 10            # no usage (in explosion)
export var attackDamageRandom := 5       # attackDamage = attackDamage + random
export var searchDuration := 8.0         # search timer
export var searchTurnSpeed := 2.0        # rotate speed in radians

export var resourceName := 'EnemyStatus'    # Debug
