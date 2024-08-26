extends Control

const CardSize = Vector2(147.5, 206.5)
const CardBase = preload("res://Scences/card_base.tscn")
const PlayerHand = preload("res://Assets/Cards/PlayerHand.gd")
var CardSelecter
var DeckSize = PlayerHand.Deck.size()
enum {InHand, InPlay, InMouse, FocusInHand, MoveDrawnCardToHand, ReorganiseHand}

@onready var cards = $Cards
@onready var deck = $Deck

@onready var CentreCardOval = Vector2(get_viewport().size) * Vector2(0.7, 1.25)
@onready var Radius_H = get_viewport().size.x * 0.45
@onready var Radius_V = get_viewport().size.y * 0.42
var angle = deg_to_rad(90) - 0.51
var OvalAngleVector : Vector2

var Cards_InHand : int
var CardSpread = 0.25
var NumberCardsHand : float
var Card_Number

#var new_card
var new_card1
var new_card2
var new_card3
var new_card4
var new_card5
var new_card6
var new_card7
var new_card8
var new_card9


func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instantiate()
	CardSelecter = randi() % DeckSize
	new_card.CardName = PlayerHand.Deck[CardSelecter]
#	new_card.rect_position = get_global_mouse_position() 
	OvalAngleVector = Vector2(Radius_H * cos(angle), - Radius_V * sin(angle))
	new_card.startpos = $Deck.position - CardSize/2
	new_card.targetpos = CentreCardOval + OvalAngleVector - CardSize
	new_card.startrot = 0
	#new_card.targetrot = (90 - rad_to_deg(angle))/4
	new_card.scale *= CardSize/new_card.size
	new_card.state = MoveDrawnCardToHand
	Card_Number = 0
	for Card in $Cards.get_children(): # reorganise hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Number)
		OvalAngleVector = Vector2(Radius_H * cos(angle), - Radius_V * sin(angle))
		
		Card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		Card.startrot = Card.rotation
		Card.targetrot = (90 - rad_to_deg(angle))/4
		
		Card_Number += 1
		if Card.state == InHand:
			Card.state = ReorganiseHand
			Card.startpos = Card.position
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))
	$Cards.add_child(new_card)
	PlayerHand.Deck.erase(PlayerHand.Deck[CardSelecter])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
#	Card_Numb += 1
	return DeckSize

