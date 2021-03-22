extends Node

export (Array) var players
export(Array) var scores

func _ready():
	pass

func count_players():
	for i in range(len(players)):
		if players[i]==null:
			print(str(i) + " is nul")
			continue
		print("THere is one player!")
		scores.append(0)
		players[i].score_id=i
	print("There are " + str(len(scores)) + " players.")
	

