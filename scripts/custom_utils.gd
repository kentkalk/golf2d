extends Node

# Takes two ends of a line and smooths them with a bezier curve
# in_pointA and in_pointB are the ends of the line
# in_directionA and in_directionB define the direction the curve should bend
# returns PackedVector2Array of points of the curve
func line_to_curve(in_pointA : Vector2, in_directionA : Vector2, in_pointB : Vector2, in_directionB : Vector2):
	var curve = Curve2D.new()
	curve.add_point(in_pointA, Vector2.ZERO, in_directionA)
	curve.add_point(in_pointB, in_directionB, Vector2.ZERO)
	return curve.tessellate()


# called to convert a line into a polygon with the y-input as the bottom bound
func closepoly_to_y(in_vects : PackedVector2Array, in_y : float):
	if in_vects.size() > 0:
		var bottomrightvector = in_vects[in_vects.size() - 1]
		var bottomleftvector = in_vects[0]
		bottomrightvector.y = in_y
		bottomleftvector.y = in_y
		in_vects.append(bottomrightvector)
		in_vects.append(bottomleftvector)
	return in_vects
