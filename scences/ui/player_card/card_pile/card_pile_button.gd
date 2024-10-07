class_name CardPileButton
extends TextureButton

@export var counter : RichTextLabel
@export var card_pile : CardPile : set = set_card_pile

@onready var color_rect: ColorRect = $ColorRect

var deck_size := 0
var exhausts_in_deck := 0


func set_card_pile(new_value : CardPile) -> void:
	card_pile = new_value
	
	Events.update_deck_buttons.connect(update_ui)
	Events.update_deck_counter.connect(func()->void: update_ui(exhausts_in_deck, true))
	
	if !card_pile.card_pile_size_changed.is_connected(_on_card_pile_size_changed):
		card_pile.card_pile_size_changed.connect(_on_card_pile_size_changed)
		_on_card_pile_size_changed(card_pile.cards.size())
	
	update_ui(deck_size, true)
	_on_card_pile_size_changed(deck_size)


func _on_card_pile_size_changed(amount : int) -> void:
	deck_size = amount
	if get_name() == "CachePileButton": counter.text = "[center][color=D9BB26]%s[/color] %s[/center]" % [GameManager.character.cache_tokens, deck_size]
	else: counter.text = "[center]%s[/center]" % deck_size
	if GameManager.true_deck_size: Events.update_deck_buttons.emit(0, false)


func update_ui(amount : int, returning : bool) -> void:
	if returning: exhausts_in_deck = amount
	
	if GameManager.true_deck_size && get_name() == "DeckButton":
		counter.text = "%s(%s)" % [deck_size, (deck_size - exhausts_in_deck)]
	else: counter.text = str(deck_size)
	
	match get_name():
		"DrawPileButton":
			if GameManager.card_pile_above_mana: position = Vector2(58, 145)
			else: position = Vector2(80, 170)
		
		"DiscardPileButton":
			if GameManager.card_pile_above_mana: position = Vector2(42, 145)
			else: position = Vector2(317, 170)
		
		"ExhaustPileButton":
			if GameManager.card_pile_above_mana: position = Vector2(26, 145)
			else: position = Vector2(317, 145)
		
		"CachePileButton":
			counter.position.x = -1
			counter.text = "[center][color=D9BB26]%s[/color] %s[/center]" % [GameManager.character.cache_tokens, deck_size]
			if GameManager.card_pile_above_mana: position = Vector2(10, 145)
			else: position = Vector2(80, 145)
	

func _on_mouse_entered() -> void:
	color_rect.color.a = 0.18


func _on_mouse_exited() -> void:
	color_rect.color.a = 0
