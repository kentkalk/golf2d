extends StaticBody2D

@export var width: float = 2560.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var polyarray = PackedVector2Array([Vector2(-1280,400),Vector2(3840,400), Vector2(3840,720),Vector2(-1280,720)])
	width = 2560 * 2
	
	var visiblepoly = Polygon2D.new()
	visiblepoly.set_polygon(polyarray)
	visiblepoly.color = Color.WEB_GREEN
	
	var collisionpoly = CollisionPolygon2D.new()
	collisionpoly.set_polygon(polyarray)
	
	add_child(visiblepoly)
	add_child(collisionpoly)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
