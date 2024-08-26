extends Node


func play(audio : AudioStream, single := false) -> void:
	if !audio:
		return
	
	if single:
		stop()
	
	for player in get_children():
		player = player
		
		if !player.playing:
			player.stream = audio
			player.play()
			break


func stop() -> void:
	for player in get_children():
		player = player
		player.stop()
