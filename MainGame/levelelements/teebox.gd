extends Node2D

var _points

func _ready():
	translate(_points[0])

func set_points(in_points):
	_points = in_points
