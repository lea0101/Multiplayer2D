extends Area2D

#Has a range of view that will determine if they see the player
#one timer for random movement
#one timer for how long they can be looking at the player before player is caught
#Later add actual animations
#if standing still, vision is lowered to the floor, easier for player to get through

onready var move_timer:=$MoveTimer
onready var kill_timer:=$KillTimer

var target:float
var velocity:=10

func _ready():
	kill_timer.wait_time=3 #change with difficulty?
	kill_timer.one_shot=true
	move_timer.wait_time=6 
	randomize()
	move_timer.start()
	
func _process(delta):
	if target==0:
		return
	elif velocity<0 and global_position.x<target:
		target=0
		return
	elif velocity>0 and global_position.x>target:
		target=0
		return

	global_position.x+=8 *delta *velocity


func _on_MoveTimer_timeout():
	target=global_position.x + randi()%10 -10
	move_timer.wait_time=randi()%15 + 5 #random from 5 to 15
	move_timer.start()
	if target<global_position.x:
		velocity=-10
		return
	velocity=10
	


func _on_KillTimer_timeout():
	print("You are dead!")


func _on_Area2D_body_entered(body):
	if "RigidBody2D" in body.get_class(): #This should be done with masks later
		kill_timer.start()

func _on_Area2D_body_exited(body):
	if "RigidBody2D" in body.get_class():
		kill_timer.stop()
