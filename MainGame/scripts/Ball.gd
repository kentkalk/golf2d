extends RigidBody2D

@export var ball_radius: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var collcircle = CircleShape2D.new()
	collcircle.radius = ball_radius
	var collshape = CollisionShape2D.new()
	collshape.shape = collcircle
	add_child(collshape)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_circle(Vector2(0,0),ball_radius,Color.WHITE)
