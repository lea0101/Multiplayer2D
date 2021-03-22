extends Control

export var port:int=6500
export var max_players:=3
export var ip:="127.0.0.1"
export var player_cnt:=0

onready var start_button:=$BtnStart


var player_info = {}
var my_info = { color = "green" }


func _ready():
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	start_button.disabled=true

func _on_BtnHost_button_up():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(port, max_players)
	get_tree().set_network_peer(net)
	
	player_cnt+=1
	$BtnHost.disabled=true

func _on_BtnJoin_button_up():
	var net = NetworkedMultiplayerENet.new()
	net.create_client(ip, port)
	get_tree().set_network_peer(net)
	player_cnt+=1
	
	if(player_cnt==2):
		start_button.disabled=false
	
func _player_connected(id):
	rpc_id(id, "register_player", my_info)
#	Network.player2id=id
#	var game = preload("res://Scenes/Level.tscn").instance()
#	get_tree().get_root().add_child(game)
#	hide()
#
####



func _player_disconnected(id):
	player_info.erase(id)
	

func _connected_ok():
	pass 
func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = info

	

######
remote func pre_configure_game():
	get_tree().set_pause(true)
	var selfPeerID = get_tree().get_network_unique_id()

	# Load world
	var world = load("res://Scenes/Level.tscn").instance()
	get_node("/root").add_child(world)

	# Load my player
	var my_player = preload("res://Scenes/Player.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	get_node("/root/world/players").add_child(my_player)

	# Load other players
	for p in player_info:
		var player = preload("res://Scenes/Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p) # Will be explained later
		get_node("/root/world/players").add_child(player)

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
	rpc_id(1, "done_preconfiguring")

var players_done = []
remote func done_preconfiguring():
	var who = get_tree().get_rpc_sender_id()
	# Here are some checks you can do, for example
	assert(get_tree().is_network_server())
	assert(who in player_info) # Exists
	assert(not who in players_done) # Was not added yet

	players_done.append(who)

	if players_done.size() == player_info.size():
		rpc("post_configure_game")

remote func post_configure_game():
	# Only the server is allowed to tell a client to unpause
	if 1 == get_tree().get_rpc_sender_id():
		get_tree().set_pause(false)
		# Game starts now!

func _on_BtnStart_button_down():
	pre_configure_game()
