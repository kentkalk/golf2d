# 2D Golf Level Generator
# =======================
# Procedural level generator

extends Node

enum HazardType {FAIRWAY, TEEBOX, GREEN, WATER}

# LEVEL GENERATION CONFIGURATION CONSTANTS
#-----------------------------------------
# General
const xcoord_start = -1280
const ycoord_mean = 400
const ycoord_stddev = 100

# Level layout
const hazard_chance = 0.25

# Fairway config
const fairway_width = 1280.0
const fairway_sections = 16
const fairway_roughness = 10.0

# Teebox config
# this is a fixed width by design, if changed here the element scene needs to be changed as well
const teebox_width = 1280

# Green config
const green_mean_width = 1300
const green_stddev = 300
const green_roughness = 8.0

# Water config
# most of the water element design is done in the scene, but width of the water hazard is randomly assigned
const water_mean_width = 1280
const water_stddev = 200
#-----------------------------------------



# Level class contains all information needed to draw a level
class level:
	var _ballstartposition : Vector2
	var _holestartposition : Vector2
	var _par : int
	var _width : int
	var sections : Array[_section]
	var clutter : Array[_clutterparams]
	
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
		
	func generate(in_par : int):
		_par = in_par
		
		# number of sections and hazards per hole
		var sections = 2 * _par
		var hazardbudget = round(sections / 3)
		sections -= 2  # every hole has a teebox and a green
		
		var holelayout = [HazardType.TEEBOX]	# every hole starts with a teebox
		
		# add hazards if chance met
		for i in range(sections):
			if hazardbudget > 0 and randf() <= hazard_chance:
				holelayout.append(HazardType.WATER)
				hazardbudget -= 1
			else:
				holelayout.append(HazardType.FAIRWAY)
		
		holelayout.append(HazardType.GREEN)     # every hole ends with a green

		#set starting location
		var nextlocation = Vector2(xcoord_start,randfn(ycoord_mean, ycoord_stddev))  #Set starting location		
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
					nextlocation.y = randfn(ycoord_mean, ycoord_stddev)
					
					#randomized pieces
					for i in range(fairway_sections):
						nextlocation.x += piecewidth
						nextlocation.y += randf_range(-fairway_roughness, fairway_roughness)
						currentline.append(nextlocation)
						
					_add_section(HazardType.FAIRWAY, currentline)	
					
				HazardType.TEEBOX:
					# Teebox section
					currentline = PackedVector2Array()
					currentline.append(nextlocation)
					nextlocation.x += teebox_width
					currentline.append(nextlocation)
					_add_section(HazardType.TEEBOX, currentline)
					
					# Ball starting position
					_ballstartposition = Vector2(nextlocation.x - (teebox_width / 2), nextlocation.y - 50)
					
					# Clutter
					var teeposition = Vector2(nextlocation.x - (teebox_width / 2), nextlocation.y - 10)
					_add_clutter("tee.tscn", teeposition)
					
				HazardType.GREEN:
					# Green section
					currentline = PackedVector2Array()
					currentline.append(nextlocation)
					
					var green_width = randfn(green_mean_width, green_stddev)
					var green_section_width = (green_width / (2 * green_roughness * randf()))
					var green_sections = int(green_width / green_section_width)
					var piecewidth = green_width / green_sections
					
					#randomized pieces
					for i in range(green_sections):
						nextlocation.x += piecewidth
						nextlocation.y += randf_range(-green_roughness, green_roughness)
						currentline.append(nextlocation)
						
					_add_section(HazardType.GREEN, currentline)

					
				HazardType.WATER:
					currentline = PackedVector2Array()
					currentline.append(nextlocation)
					nextlocation.x += randfn(water_mean_width, water_stddev)
					currentline.append(nextlocation)
					_add_section(HazardType.WATER, currentline)
		
		# Finish calculating level width from final x coordinate
		_width += nextlocation.x
