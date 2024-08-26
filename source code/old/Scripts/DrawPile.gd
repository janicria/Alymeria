extends TextureButton

var DeckSize = INF
var StartDraw = ''

@onready var combat_screen = $"../.."
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= (combat_screen.CardSize/size)/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if StartDraw:
		#DeckSize = combat_screen.draw_card(5)
		pass
	if !DeckSize:
		StartDraw = ''
		DeckSize = INF


func _gui_input(event):
	if Input.is_action_just_released("left_mouse_pressed"):
		if DeckSize > 0: #and !StartDraw:
			StartDraw = 'ON'
			DeckSize = combat_screen.drawcard()
			if !DeckSize:
				disabled = true

