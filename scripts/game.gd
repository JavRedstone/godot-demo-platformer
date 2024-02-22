extends Node2D

@export var floor_scene: PackedScene = null;
@export var player_scene: PackedScene = null;
@export var platform_scene: PackedScene = null;

const platform_increment = 5
const platform_y_increment = 15
const level_width = 250
const floor_space = 10
const door_space = 20
const player_death_y = 100

var floor = null
var player = null
var door = null
var platforms = []
var players_in_door = []

var num_platforms = 0

func _ready():
	self.create_floor()
	self.create_player()
	self.create_door()
	self.reset_game()

func reset_game():
	self.reset_player()
	for platform in platforms:
		if is_instance_valid(platform):
			platform.queue_free()
	self.next_level()
	
func create_floor():
	self.floor = floor_scene.instantiate()
	self.add_child(floor)

func create_player():
	self.player = player_scene.instantiate()
	self.add_child(player)

func create_door():
	self.door = get_node("Door")

func reset_player():
	self.player.position = Vector2(-floor_space - level_width / 2, -floor_space)
	self.player.linear_velocity = Vector2(0, 0)
	self.player.angular_velocity = 0

func next_level():
	self.num_platforms += platform_increment
	self.generate_platforms()
	
func generate_platforms():
	var prev_y = 0
	for i in self.num_platforms:
		var new_platform = platform_scene.instantiate()
		prev_y -= platform_y_increment
		new_platform.position = Vector2(randf_range(-level_width / 2, level_width / 2), prev_y)
		self.platforms.append(new_platform)
		self.add_child(new_platform)
		if i == self.num_platforms - 1:
			self.door.position.x = new_platform.position.x
			self.door.position.y = prev_y - self.door_space
		
func _physics_process(delta):
	if player != null and player.position.y >= player_death_y:
		self.reset_player()
	if players_in_door.size() >= 1:
		self.reset_game()

func _on_door_body_entered(body):
	if body.is_in_group("players"):
		self.players_in_door.append(body)

func _on_door_body_exited(body):
	self.players_in_door.erase(body)
