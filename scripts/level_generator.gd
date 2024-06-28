# 2D Golf Level Generator
# =======================
# Procedurally level generator

extends Node

# LEVEL GENERATION CONFIGURATION CONSTANTS
#-----------------------------------------
# Teebox
const teebox_leadin_width = 512.0
const teebox_width = 643.0
const teebox_leadout_width = 128.0
const teebox_yoffset = 5.0

# Fairway
const fairway_width = 1280.0
const fairway_sections = 16
const fairway_roughness = 5.0

# Green
const green_leadin_width = 128.0
const green_width_lbound = 700.0
const green_width_ubound = 1900.0
const green_leadout_width = 480.0
const green_section_width = 240.0
const green_roughness = 2
const green_yoffset = 5.0

# Water
const water_width = 1120.0
const water_yoffset = 30.0
#-----------------------------------------

enum HazardType {FAIRWAY, TEEBOX, GREEN, WATER}

# stores attributes of a single section of a level for drawing purposes
class levelsection:
	var type : HazardType
	var line : PackedVector2Array
	var clutter : Array[clutteridentifier]

# stores information on clutter for a section
class clutteridentifier:
	var resource : String
	var position : Vector2
	var collides : bool = true

# Called to generate a new level
#   startlocation is the Vector2 of where the level should begin
#   holelayout is an array of HazardType with the order to generate the hazards
func generate_level(startlocation, holelayout):
	var outputlevel : Array[levelsection]
	var nextlocation = startlocation
	
	for currenthazard in holelayout:
		var currentpolygon : levelsection
		match currenthazard:
	
			HazardType.FAIRWAY:
				var piecewidth = fairway_width / fairway_sections
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.FAIRWAY
				currentpolygon.line.append(nextlocation)  #start location
				
				#randomized pieces
				for i in range(fairway_sections):
					nextlocation.x += piecewidth
					nextlocation.y += randf_range(-fairway_roughness, fairway_roughness)
					currentpolygon.line.append(nextlocation)
					
				outputlevel.append(currentpolygon)
					
			HazardType.TEEBOX:
				# Fairway section as lead-in
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.FAIRWAY
				currentpolygon.line.append(nextlocation)
				nextlocation.x += teebox_leadin_width
				currentpolygon.line.append(nextlocation)
				outputlevel.append(currentpolygon)
				
				# Teebox section
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.TEEBOX
				nextlocation.y += teebox_yoffset
				currentpolygon.line.append(nextlocation)
				nextlocation.x += teebox_width
				currentpolygon.line.append(nextlocation)
				
				# Clutter
				var ball = clutteridentifier.new()
				ball.resource = "BALL_START_POSITION"
				ball.position = Vector2(nextlocation.x - (teebox_width / 2), nextlocation.y - 50)
				currentpolygon.clutter.append(ball)
				
				var tee = clutteridentifier.new()
				tee.resource = "Clutter/Tee"
				tee.position = Vector2(nextlocation.x - (teebox_width / 2), nextlocation.y - 10)
				currentpolygon.clutter.append(tee)
				
				outputlevel.append(currentpolygon)
				nextlocation.y -= teebox_yoffset
				
				# Fairway section as lead-out
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.FAIRWAY
				currentpolygon.line.append(nextlocation)
				nextlocation.x += teebox_leadout_width
				currentpolygon.line.append(nextlocation)
				outputlevel.append(currentpolygon)
				
			HazardType.GREEN:
				# Fairway section as lead-in
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.FAIRWAY
				currentpolygon.line.append(nextlocation)
				nextlocation.x += green_leadin_width
				currentpolygon.line.append(nextlocation)
				outputlevel.append(currentpolygon)
				
				# Green section
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.GREEN
				nextlocation.y += green_yoffset
				currentpolygon.line.append(nextlocation)
				
				var green_width = randf_range(green_width_lbound, green_width_ubound)
				var green_sections = int(green_width / green_section_width)
				var piecewidth = green_width / green_sections
				
				#randomized pieces
				for i in range(green_sections):
					nextlocation.x += piecewidth
					nextlocation.y += randf_range(-green_roughness, green_roughness)
					currentpolygon.line.append(nextlocation)
												
				outputlevel.append(currentpolygon)
				nextlocation.y -= green_yoffset
				
				# Fairway section as lead-out
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.FAIRWAY
				currentpolygon.line.append(nextlocation)
				nextlocation.x += green_leadout_width
				currentpolygon.line.append(nextlocation)
				outputlevel.append(currentpolygon)

			HazardType.WATER:
				currentpolygon = levelsection.new()
				currentpolygon.type = HazardType.WATER
				nextlocation.y += water_yoffset
				currentpolygon.line.append(nextlocation)  #start location
				nextlocation.x += water_width
				currentpolygon.line.append(nextlocation)					
				outputlevel.append(currentpolygon)
				nextlocation.y -= water_yoffset

	return outputlevel

# stores attributes of a single hole for a course to be generated
class coursehole:
	var par : int
	var sections : Array[HazardType]
	

func generate_course(holes = 1):
	var outputcourse : Array[coursehole]
	
	for i in range(holes):
		var currenthole = coursehole.new()
		currenthole.par = randi_range(3,5)
		currenthole.sections.append(HazardType.TEEBOX)		
		outputcourse.append(currenthole)
		
	return outputcourse
		
