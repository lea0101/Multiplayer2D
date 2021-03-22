extends Node2D

var player_prefab= preload("res://Scenes/Player.tscn")
var enemy_prefab = preload("res://Scenes/Enemy.tscn")
#Put the player spawn points here
onready var sp1:=$SP_Player
onready var sp2:=$SP_Player2
#Put player anims here
var anim_green = preload("res://Assets/PlayerAnim/Green/Player_Green.tres")
var index_cnt:=0
func _ready():
	#For now this will spawn 1 player. 
	#later it should be determined how many players there are
	#then it will go through and add them
	
# 	Keep this here for now (non-networking)
#	var player = player_prefab.instance()
#	Scorer.players.append(player) #should go through all players' indexes
#	player.anim_frames=anim_green
#	player.score_id=0
#	add_child(player)
#	player.global_position=sp1.global_position
#	Scorer.count_players()
#
#	var enemy = enemy_prefab.instance()
#	add_child(enemy)
#	enemy.global_position=sp2.global_position

	create_player(get_tree().get_network_unique_id(), sp1)
	create_player(Network.player2id, sp2)
	#$LblVersion.text="Version " +VERSION #Add version?
	
	
func create_player(id, spawn):
	var player = player_prefab.instance()
	Scorer.players.append(player)
	player.anim_frames=anim_green
	player.score_id=index_cnt
	player.set_name(str(id))
	player.set_network_master(id)
	player.global_transform = spawn.global_transform
	add_child(player)
	index_cnt+=1
