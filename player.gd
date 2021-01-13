extends KinematicBody2D

#variable
var moveSpeed = 500
var bulletSpeed = 2000
var magazine = 30
var bullet = preload("res://bullet.tscn")

func _ready():
	pass
	
func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("up"):
		motion.y -=1
	if Input.is_action_pressed("down"):
		motion.y +=1
	if Input.is_action_pressed("left"):
		motion.x -=1
	if Input.is_action_pressed("right"):
		motion.x +=1
	
	motion = motion.normalized()
	motion = move_and_slide(motion * moveSpeed)
	
	#shoot mechanic
	if magazine > 0:
		if Input.is_action_just_pressed("LeftMouseButton"):
			magazine -=1
			fire()
	if Input.is_action_just_pressed("reload"):
		magazine = 30
		
	#mendapatkan posisi cursor
	look_at(get_global_mouse_position())
	
func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bullet_instance)


func kill():
	get_tree().reload_current_scene()

func _on_Area2D_body_entered(body):
	if "enemy" in body.name:
		kill()
