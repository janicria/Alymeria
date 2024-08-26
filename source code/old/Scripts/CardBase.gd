extends MarginContainer


@onready var CardDatabase = preload("res://Assets/Cards/CardDatabase.gd")
static var CardName = 'Jynx'
@onready var CardInfo = CardDatabase.DATA[CardDatabase[CardName]]

@onready var card = $Card
@onready var CardLabelName = $Bars/TopBar/Name/CenterContainer/Name
@onready var CardLabelCost = $Cost/MarginContainer/Cost
@onready var CardLabelDescription = $Bars/Description/CenterContainer/Description
@onready var combat_screen = $"/root/Node2D/Combat_Screen/CombatScreen"

@onready var CardImage = 'res://Assets/Cards/' + CardInfo[0] + '_Cards/' + CardName + '.png'

var startpos = 0
var startrot = 0
var targetrot = 0
var targetpos = 0
var time = 0
var DrawTime = 0.6
enum {InHand, InPlay, InMouse, FocusInHand, MoveDrawnCardToHand, ReorganiseHand}

var state = InHand

var Type : String
var Name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	if CardInfo[1] == 0:
		Type = 'Physical'
	if CardInfo[1] == 1:
		Type = 'Burst'
	if CardInfo[1] == 2:
		if CardInfo[0] == 'Witch':
			Type = 'Aura'
		else:
			Type = 'Looped'
	if CardInfo[1] == 3:
		if CardInfo[0] == 'Witch':
			Type = 'Summon'
		else:
			Type = 'Overclocked'
	if CardInfo[1] == 4:
		if CardInfo[0] == 'Witch':
			Type = 'Injury'
		else:
			Type = 'Malware'
	if CardInfo[1] == 5:
		if CardInfo[0] == 'Witch':
			Type = 'Status'
		else:
			Type = 'Virus'

	if !CardInfo[6]:
		Name = CardName
	else:
		Name = CardInfo[6]
	if ResourceLoader.exists(CardImage):
		card.texture = load(CardImage)
	else:
		var ERROR = ERRORS.DATA[ERRORS.ERROR_MISSING_CARD_TEXTURE]
		ERROR[1] +=1
		ERROR[2] = CardName

	CardLabelName.text = Name + '
	' + Type + '
	' + str(CardInfo[4]) + '  Range'
	CardLabelCost.text = str(CardInfo[3])
	CardLabelDescription.text = CardInfo[5]







# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if combat_screen.Cards_InHand < 3:
		DrawTime = 0.5
	
	
	match state:
		InHand:
			pass
		InPlay:
			pass
		InMouse:
			pass
		FocusInHand:
			pass
		MoveDrawnCardToHand:
			if time <= 1:
				position = startpos.lerp(targetpos, time)
				rotation_degrees = startrot * (1-time) + targetrot * time
				time += delta/float(DrawTime)
			else:
				position = targetpos
				rotation_degrees = targetrot
				state = InHand
				time = 0
		ReorganiseHand:
			if time <= 1:
				position = position #- combat_screen.OvalAngleVector #(combat_screen.CentreCardOval + combat_screen.OvalAngleVector - size/2) - Vector2(50, 0)
				rotation_degrees = startrot * (1-time) + targetrot * time
				time += delta/float(DrawTime)
			else:
				#position = targetpos
				#rotation_degrees = targetrot
				state = InHand
				time = 0

