extends StaticBody2D

const sectionwidth = 1280.0
const screenbottom = 720

@export var width: float = 12800.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var polyarray = PackedVector2Array([Vector2(-1280,400),Vector2(3840,400), Vector2(3840,720),Vector2(-1280,720)])
	
	var coursepar = 5	
	# Start with tee-box (this is intentionally flat)
	var nextstart = generate_fairway(Vector2(-1280,400))
	
	for i in range((2*coursepar)-3):
		nextstart = generate_fairway(nextstart, randf_range(5.0,20.0))
		
	# End with flat sections for green
	nextstart = generate_fairway(nextstart)
	nextstart = generate_fairway(nextstart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_fairway(startloc: Vector2, roughness: float = 1.0):
	var polyarray = PackedVector2Array([startloc])
	var curlocation = startloc

	var deviations: Array[Vector2] = []
	var remainwidth = sectionwidth
	var piecewidth = sectionwidth / roughness
	var temp = 0.0
	for i in range(roughness):
		# Variating widths
		var curwidth = randf_range(-(piecewidth/roughness), (piecewidth/roughness)) + piecewidth
		remainwidth = remainwidth - curwidth
		if (remainwidth < piecewidth):
			curwidth = curwidth + remainwidth
		
		# Variating height of bumps
		var curheight = 0
		if (roughness != 1.0):
			curheight = 2 * randf_range(-roughness,roughness)
		deviations.append(Vector2(curwidth, curheight))
	
	var nextstart = Vector2(0,0)
	for dev in deviations:
		curlocation = curlocation + dev
		polyarray.append(curlocation)
		nextstart = curlocation
				
	polyarray.append(Vector2(nextstart.x, screenbottom))
	polyarray.append(Vector2(startloc.x, screenbottom))
		
	var visiblepoly = Polygon2D.new()
	visiblepoly.set_polygon(polyarray)
	visiblepoly.color = Color.MEDIUM_SEA_GREEN
	
	var collisionpoly = CollisionPolygon2D.new()
	collisionpoly.set_polygon(polyarray)
	
	add_child(visiblepoly)
	add_child(collisionpoly)
	
	return nextstart
