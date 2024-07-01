# 2D Golf Level Generator
# =======================
# Procedural level generator

extends Node

# LEVEL GENERATION CONFIGURATION CONSTANTS
#-----------------------------------------
# General
const xcoord_start = -1280
const ycoord_lbound = 0
const ycoord_ubound = 500

# Teebox config
const teebox_leadin_width = 512.0
const teebox_width = 643.0
const teebox_leadout_width = 128.0
const teebox_yoffset = 10.0

# Fairway config
const fairway_width = 1280.0
const fairway_sections = 16
const fairway_roughness = 5.0

# Green config
const green_leadin_width = 128.0
const green_width_lbound = 700.0
const green_width_ubound = 1900.0
const green_leadout_width = 480.0
const green_section_width = 240.0
const green_roughness = 2
const green_yoffset = 5.0

# Water config
const water_width = 1120.0
const water_yoffset = 0.0
#-----------------------------------------

enum HazardType {FAIRWAY, TEEBOX, GREEN, WATER}

# class contains all information needed on a single generated level
class level:
	var _ballstartposition : Vector2
	var _par : int
	var _width : int
	var sections : Array[_section]
	var clutter : Array[_clutterparams]
	var _previoustype : HazardType
	
	class _section:
		var type : HazardType
		var line : PackedVector2Array
		
	class _clutterparams:
		var resource : String
		var position : Vector2
		var collides : bool
	
	func _add_section(in_type : HazardType, in_line : PackedVector2Array):
		var newsection = _section.new()
		newsection.type = in_type
		newsection.line = in_line
		sections.append(newsection)
		_previoustype = in_type
	
	func _add_clutter(in_resource : String, in_position : Vector2, in_collides : bool = true):
		var newclutter = _clutterparams.new()
		newclutter.resource = in_resource
		newclutter.position = in_position
		newclutter.collides = in_collides
		clutter.append(newclutter)
		
	func get_ballstartposition():
		return _ballstartposition
		
	func get_width():
		return _width
		
	func generate():
		# random par
		_par = randi_range(3,5)
		
		# hole layout
		var holelayout = [HazardType.TEEBOX, HazardType.FAIRWAY, HazardType.WATER, HazardType.FAIRWAY, HazardType.FAIRWAY, HazardType.FAIRWAY, HazardType.FAIRWAY, HazardType.FAIRWAY, HazardType.FAIRWAY, HazardType.FAIRWAY, HazardType.WATER, HazardType.GREEN]
		
		#set starting location
		var nextlocation = Vector2(xcoord_start,randf_range(ycoord_lbound, ycoord_ubound))  #Set starting location		
		# Start calculating level width
		_width = abs(nextlocation.x)
	
		# Generate actual level elements in this loop
		for currenthazard in holelayout:
			var currentline
			match currenthazard:
				
				HazardType.FAIRWAY:
					var piecewidth = fairway_width / fairway_sections
					currentline = PackedVector2Array()
					currentline.append(nextlocation)  #start location
					if _previoustype != HazardType.WATER:
						nextlocation.y = randf_range(ycoord_lbound, ycoord_ubound)
					
					#randomized pieces
					for i in range(fairway_sections):
						nextlocation.x += piecewidth
						nextlocation.y += randf_range(-fairway_roughness, fairway_roughness)
						currentline.append(nextlocation)
						
					_add_section(HazardType.FAIRWAY, currentline)	
					
				HazardType.TEEBOX:
					### Fairway section as lead-in
					#currentline = PackedVector2Array()
					#currentline.append(nextlocation)
					#nextlocation.x += teebox_leadin_width
					#currentline.append(nextlocation)
					#_add_section(HazardType.FAIRWAY, currentline)
					
					# Teebox section
					currentline = PackedVector2Array()
					nextlocation.y += teebox_yoffset
					currentline.append(nextlocation)
					nextlocation.x += teebox_width
					currentline.append(nextlocation)
					_add_section(HazardType.TEEBOX, currentline)
					
					# Ball starting position
					_ballstartposition = Vector2(nextlocation.x - (teebox_width / 2), nextlocation.y - 50)
					
					# Clutter
					var teeposition = Vector2(nextlocation.x - (teebox_width / 2), nextlocation.y - 10)
					_add_clutter("tee.tscn", teeposition)

					nextlocation.y -= teebox_yoffset  # undo the offset of y for next section
					
					## Fairway section as lead-out
					#currentline = PackedVector2Array()
					#currentline.append(nextlocation)
					#nextlocation.x += teebox_leadout_width
					#currentline.append(nextlocation)
					#_add_section(HazardType.FAIRWAY, currentline)
					
				HazardType.GREEN:
					# Fairway section as lead-in
					currentline = PackedVector2Array()
					currentline.append(nextlocation)
					nextlocation.x += green_leadin_width
					if _previoustype != HazardType.WATER:
						nextlocation.y = randf_range(ycoord_lbound, ycoord_ubound)
					currentline.append(nextlocation)
					_add_section(HazardType.FAIRWAY, currentline)
					
					# Green section
					currentline = PackedVector2Array()
					nextlocation.y += green_yoffset
					currentline.append(nextlocation)
					
					var green_width = randf_range(green_width_lbound, green_width_ubound)
					var green_sections = int(green_width / green_section_width)
					var piecewidth = green_width / green_sections
					
					#randomized pieces
					for i in range(green_sections):
						nextlocation.x += piecewidth
						nextlocation.y += randf_range(-green_roughness, green_roughness)
						currentline.append(nextlocation)
						
					_add_section(HazardType.GREEN, currentline)
					nextlocation.y -= green_yoffset
					
					# Fairway section as lead-out
					currentline = PackedVector2Array()
					currentline.append(nextlocation)
					nextlocation.x += green_leadout_width
					currentline.append(nextlocation)
					_add_section(HazardType.FAIRWAY, currentline)
					
				HazardType.WATER:
					currentline = PackedVector2Array()
					nextlocation.y += water_yoffset
					currentline.append(nextlocation)
					nextlocation.x += water_width
					currentline.append(nextlocation)
					_add_section(HazardType.WATER, currentline)
					nextlocation.y -= water_yoffset
		
		# Finish calculating level width from final x coordinate
		_width += nextlocation.x
