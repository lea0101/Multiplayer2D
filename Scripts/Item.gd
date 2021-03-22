extends Node
class_name Item

#This defines the items that can be picked up by players
#Each item has a value and an image for it

export (int) var value
export (Image) var image
export (SpriteFrames) var anim_frames
export (String) var compartment #aka the type of compartment to base the player's animation off of
#this would be something like "glass_box" or "purse"

onready var sprite:=$AnimatedSprite
onready var letter_hint:=$Button

onready var loading_bar:=$LoadingBar
onready var fill_bar:=$Fill

#The items must be spawned randomly throughout the train, but they
#can only spawn within certain areas (the overhead bins, on chairs, NOT on windows etc)
var player_in_range:RigidBody2D

func _ready():
	letter_hint.hide()
	loading_bar.hide()
	sprite.scale=Vector2(.1,.1)

	

func _on_Item_body_entered(body):
	if "RigidBody2D" in body.get_class():
		letter_hint.show()
		player_in_range=body
		loading_bar.show()
		

				
func _process(delta):
	if player_in_range==null:
		return
	if Input.is_action_pressed("use"):
		if fill_bar.rect_size.x==100:
			player_in_range.add_point(value)
			queue_free()
			return
		fill_bar.rect_size.x+=.5 #maybe make this different for each item?
	
func player_add_pnt():
	return
	
			
func _on_Item_body_exited(body):
	if "RigidBody2D" in body.get_class():
		letter_hint.hide()
		fill_bar.rect_size.x=0
		loading_bar.hide()
		player_in_range=null
