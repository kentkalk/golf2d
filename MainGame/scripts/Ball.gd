extends RigidBody2D

var _is_repositioning : bool = false
var _new_position : Vector2 = Vector2.ZERO

func _ready():
	# Position the ball on the tee
	reposition_ball(GameManager.currentlevel.get_ballstartposition())
	
func _draw():
	var ballradius = get_node("CollisionShape2D").shape.radius
	draw_circle(Vector2(0,0),ballradius,Color.WHITE)
	
func _integrate_forces(state):
	if _is_repositioning:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		state.transform.origin = _new_position
		set_position(_new_position)
		_is_repositioning = false
		sleeping = true
	
# Called by user interface to strike the ball
func strike(angle: float, power: float):
	var shotvector = Vector2.ZERO
	shotvector.x = power * cos(deg_to_rad(angle))
	shotvector.y = -(power * sin(deg_to_rad(angle)))
	apply_central_impulse(shotvector)

# Called to reposition ball, this also removes all impulses
func reposition_ball(in_position : Vector2):
	sleeping = false
	_new_position = in_position
	_is_repositioning = true

