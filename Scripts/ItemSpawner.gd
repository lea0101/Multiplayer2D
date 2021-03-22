extends Node2D

export (Array) var items
onready var spawnpoints:=[$Point1,$Point2,$Point3]
onready var spawn_timer:=$Timer
#This should spawn the items randomly throughout the specific area
#Add to the level scene, make unique, and move the points around

func _ready():
	randomize()
	
func spawn_item():
	var index = randi() % len(spawnpoints)
	if(spawnpoints[index].get_child_count()!=0):
		spawn_item()
	var item = items[randi()%len(items)].instance()
	item.global_position = spawnpoints[index].global_position
	spawnpoints[index].add_child(item)

func _on_Timer_timeout():
	spawn_item()
