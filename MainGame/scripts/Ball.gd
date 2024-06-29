extends RigidBody2D

func _ready():
	# Position the ball on the tee
	position = GameManager.currentlevel.ballstartposition
	
func _draw():
	var ballradius = get_node("CollisionShape2D").shape.radius
	draw_circle(Vector2(0,0),ballradius,Color.WHITE)
	
# Called by user interface to strike the ball
func strike(angle: float, power: float):
	self.freeze = false
	var shotvector = Vector2(0,0)
	shotvector.x = power * cos(angle)
	shotvector.y = -(power * sin(angle))
	apply_central_impulse(shotvector)
