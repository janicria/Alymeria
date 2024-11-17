class_name CardPileButton extends TextureButton

@export var counter: RichTextLabel
@export var card_pile: CardPile : set = set_card_pile

@onready var color_rect: ColorRect = $ColorRect

var deck_size := 0
var exhausts_in_deck := 0


func set_card_pile(new_value : CardPile) -> void:
	card_pile = new_value
	
	Events.update_deck_button_ui.connect(update_ui)
	
	if !card_pile.card_pile_size_changed.is_connected(_on_card_pile_size_changed):
		card_pile.card_pile_size_changed.connect(_on_card_pile_size_changed)
		_on_card_pile_size_changed(card_pile.cards.size())
	
	update_ui()
	_on_card_pile_size_changed(deck_size)


func _on_card_pile_size_changed(amount : int) -> void:
	deck_size = amount
	if name == "CachePileButton": counter.text = "[center][color=D9BB26]%s[/color] %s[/center]" % [Data.character.cache_tokens, deck_size]
	else: update_text("[center]%s[/center]" % deck_size)
	if Data.true_deck_size: update_ui()


func update_ui() -> void:
	match get_name():
		"DeckButton":
			if Data.true_deck_size: # Imagine putting this in a trenary
				update_text("%s(%s)" % [deck_size, (deck_size - Data.character.deck.cards.filter(
					func(card: Card)->bool: return card.has_status("exhaust")).size())])
			else: update_text(str(deck_size))
		
		"CachePileButton":
			counter.position.x = -1
			counter.text = "[center][color=D9BB26]%s[/color] %s[/center]" % [Data.character.cache_tokens, deck_size]


func update_text(text: String) -> void:
	if name == "DeckButton":
		counter.text = "[left][font_size=6]%s[/font_size][/left]" % text
		# Idk wy but this fixes the counter's position going haywire
		# TODO: Nope
		#counter.global_position.x = (
		#	37 if counter.get_screen_position().x < 40 else 54) + counter.get_canvas_transform().origin.x
	else: counter.text = text


func _on_mouse_entered() -> void:
	color_rect.color.a = 0.18


func _on_mouse_exited() -> void:
	color_rect.color.a = 0
