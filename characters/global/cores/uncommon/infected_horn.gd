extends Core

const INFECTION = preload("res://characters/global/cards/status/infection.tres")
const TEMPORARY = preload("res://effects/card_status/temporary.tres")

func activate() -> void:
	var player := coreui.get_tree().get_first_node_in_group("player")as Player
	if !player: return
	player.handler.draw_cards(3)
	if coreui.slotted: player.stats.mana += 1
	var infection := INFECTION.duplicate()
	if coreui.slotted: infection.add_status(TEMPORARY.duplicate())
	player.handler.add_card(infection, "draw_pile" if coreui.slotted else "discard_pile")
