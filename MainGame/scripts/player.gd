extends Node2D

@export var shot_angle : float = 0
@export var shot_power : float = 0

@onready var _sprite = get_node("Sprite")
@onready var _ball = get_node("Ball")

func _ready():
	# Connect to ball sleeping signal, moves player to ball when ball is stopped
	_ball.sleeping_state_changed.connect(_on_ball_sleeping)
	
	get_node("Sprite/Button").pressed.connect(_swing_pressed)
	
func _on_ball_sleeping():
	move_to_ball()
	
func _swing_pressed():
	_ball.strike(shot_angle,shot_power)
	
func move_to_ball():
	var playerstartposition = _ball.get_position()
	playerstartposition.x -= _sprite.texture.get_width() * _sprite.scale.x
	playerstartposition.y -= _sprite.texture.get_height() * _sprite.scale.y - (2 * _ball.get_node("CollisionShape2D").shape.radius)
	_sprite.set_position(playerstartposition)
