extends RigidBody2D

const running_speed = 125
const jumping_impulse = 600
const jumping_cooldown = 0.5

var sprite: AnimatedSprite2D;

var platforms_touching = []
var jumping_time = 0

func _ready():
	self.sprite = self.get_node("AnimatedSprite2D")
	self.sprite.animation = "running"
	self.sprite.play()

func _physics_process(delta):
	if jumping_time < jumping_cooldown:
		jumping_time += delta
	else:
		jumping_time = jumping_cooldown
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		self.linear_velocity.x = running_speed
	elif Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		self.linear_velocity.x = -running_speed
	if self.platforms_touching.size() >= 1 and jumping_time == jumping_cooldown:
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			self.apply_impulse(Vector2(0, -jumping_impulse))
			jumping_time = 0

func _on_area_2d_body_entered(body):
	if !platforms_touching.has(body) and (body.is_in_group("platforms") or body.is_in_group("floors")) and body.position.y > self.position.y:
		self.platforms_touching.append(body)

func _on_area_2d_body_exited(body):
	self.platforms_touching.erase(body)
