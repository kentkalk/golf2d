extends CanvasLayer

enum ClubType {DRIVER, WOOD, IRON, WEDGE, PUTTER}

@export var club_selection_group : ButtonGroup

func _ready():
	# connect buttons to actions
	get_node("ClubSelection/DriverButton").pressed.connect(_club_selected.bind(ClubType.DRIVER))
	get_node("ClubSelection/WoodButton").pressed.connect(_club_selected.bind(ClubType.WOOD))
	get_node("ClubSelection/IronButton").pressed.connect(_club_selected.bind(ClubType.IRON))
	get_node("ClubSelection/WedgeButton").pressed.connect(_club_selected.bind(ClubType.WEDGE))
	get_node("ClubSelection/PutterButton").pressed.connect(_club_selected.bind(ClubType.PUTTER))
	
func _club_selected(in_clubtype):
	get_parent().get_node("Player").current_club_type = in_clubtype
