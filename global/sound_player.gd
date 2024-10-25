extends Node

const PIPE = preload("res://assets/sfx/pipe.mp3")
var pipe := false

func play(audio : AudioStream, single := false) -> void:
	if !audio: return
	if single: stop()
	
	for player: AudioStreamPlayer in get_children():
		player = player
		
		if !player.playing:
			player.stream = audio
			if pipe: player.stream = PIPE
			player.play()
			break


func stop() -> void:
	for player in get_children():
		player = player
		player.stop()
