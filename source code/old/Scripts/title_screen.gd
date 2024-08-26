extends TextureRect

@onready var begin_option_timer = $begin_option_timer
@onready var title_text = $"../title_text"
@onready var run_selector = $"../run_selector"
@onready var settings_cog = $"../settings_cog"
@onready var achievment_box = $"../Achievment_Box"
@onready var achievment_text = $"../Achievment_Box/Achievment_Text"
@onready var achievment_timer = $"../Achievment_Box/Achievment_Timer"
@onready var save_1_option = $"../Save_1_option"
@onready var combat_screen = $/root/Node2D/Combat_Screen



func _ready():
	run_selector.visibility_layer = 0
	title_text.visibility_layer = 0
	settings_cog.visibility_layer = 0
	achievment_box.visibility_layer = 0
	achievment_text.visibility_layer = 0
	save_1_option.visibility_layer = 0
	achievment_box.get_parent().show()
	visibility_layer = 1
	combat_screen.combat_checker = 'ON' # SKIPS SELECT SAVE SCREEN DELETE LATER
	
var clicking : String
var cog_speed_boost : int
var mouse_coords : Vector2


func _input(event):
	if event is InputEventMouseMotion:
		mouse_coords = event.position

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.position.x > 945 and event.position.x < 995:
			if event.position.y > 150 and event.position.y < 200:
				if !clicking and event.pressed:
					clicking = 'ON'
				if clicking and !event.pressed:
					clicking = ''
					cog_speed_boost = 0
		mouse_coords = event.position


	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.position.x > 175 and event.position.x < 355:
			if event.position.y > 435 and event.position.y < 490:
				combat_screen.combat_checker = 'ON'
				


var can_press_enter : String
var show_run_selector : String

func _process(delta):
	if mouse_coords.x > 945 and mouse_coords.x < 995:
		if mouse_coords.y > 150 and mouse_coords.y < 200:
			settings_cog.rotation_degrees += 3
			cog_speed_boost +=1
	else:
		cog_speed_boost = 0
		clicking = ''


	if clicking:
		settings_cog.rotation_degrees += (4 + (cog_speed_boost / 50))


	if cog_speed_boost > 4000: #Make this into an achievement
		pass

	title_screen_menu()
	if show_run_selector == 'ON':
		run_selector_menu()

func title_screen_menu():

	if int(begin_option_timer.time_left== 0) and !can_press_enter:
		title_text.visibility_layer = 2
		can_press_enter = 'ON'

	if Input.is_action_just_pressed("enter_pressed") and can_press_enter == 'ON':
		show_run_selector = 'ON'
		can_press_enter = 'BANNED'

func run_selector_menu():
	run_selector.visibility_layer = 3
	settings_cog.visibility_layer = 4
	save_1_option.visibility_layer = 4


