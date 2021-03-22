extends RigidBody2D


var speed:float=7.5
var velocity = Vector2()

var anim:AnimatedSprite 
export (SpriteFrames) var anim_frames

export (int) var score_id

func _ready():
	anim = AnimatedSprite.new()
	add_child(anim)
	anim.scale= Vector2(.25,.25)
	if anim_frames==null:
		print("Needs animation frames!")
		return
	anim.frames=anim_frames

func get_input():
	velocity = Vector2()
	velocity.x= Input.get_action_strength("move_right") -Input.get_action_strength("move_left")
	velocity = velocity.normalized() * speed
	
	match abs(velocity.x):
		0.0:
			anim.play("still")
		speed:
			anim.play("walking")
			if velocity.x>0:
				anim.flip_h=true
				return
			anim.flip_h=false

remote func _set_position(pos):
	pass

func _physics_process(delta):
	get_input()
	if velocity!=Vector2():
		if is_network_master():
			global_position+=velocity
		#rpc_unreliable("_set_position", global_transform.origin)
	
	
func add_point(val):
	print("adding " + str(val) + " points")
	Scorer.scores[score_id]+=val
	
func _on_RigidBody2D_body_entered(body):
	print(body.get_class())
