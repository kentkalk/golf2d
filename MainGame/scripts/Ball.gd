extends RigidBody2D

@export var ball_radius: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var collcircle = CircleShape2D.new()
	collcircle.radius = ball_radius
	var collshape = CollisionShape2D.new()
	collshape.shape = collcircle
	add_child(collshape)
	
	position = get_parent().get_node("Ground").teebox_start_pos
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Freezes ball if it moves too slow, play was continuing forever otherwise
	if self.linear_velocity.length() < 25:
		self.freeze = true

func _draw():
	draw_circle(Vector2(0,0),ball_radius,Color.WHITE)
	
# Called by user interface to strike the ball
func strike(angle: float, power: float):
	self.freeze = false
	var shotvector = Vector2(0,0)
	shotvector.x = power * cos(angle)
	shotvector.y = -(power * sin(angle))
	apply_central_impulse(shotvector)
