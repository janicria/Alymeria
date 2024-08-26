extends CanvasLayer

@onready var news = $/root/Node2D/main_menu/News
@onready var _and = $"/root/Node2D/main_menu/&"
@onready var run_selector_line = $/root/Node2D/main_menu/Run_Selector_Line
@onready var canvas_layer = $CanvasLayer
@onready var splash_text = $/root/Node2D/main_menu/Splash_Text
@onready var background_images = $"/root/Node2D/background_images"
@onready var backrgound = $"/root/Node2D/Backrgound"
@onready var alymeria = $Alymeria
@onready var run_selector_line_a = $Run_Selector_Line_A
@onready var run_selector_line_b = $Run_Selector_Line_B
@onready var run_selector_line_c = $Run_Selector_Line_C
@onready var run_selector_line_d = $Run_Selector_Line_D
@onready var run_box_a = $Run_Box_A
@onready var run_box_b = $Run_Box_B
@onready var run_modifer = $run_modifer
@onready var settings_cog = $settings_cog





var number_generator
var number_granter
var news_source

# Called when the node enters the scene tree for the first time.
func _ready():
	splash_decider()
	canvas_layer.show()
	RenderingServer.set_default_clear_color(Color.BLACK)
	number_generator = RandomNumberGenerator.new()
	number_granter = number_generator.randi_range(0, 3)
	if number_granter == 0:
		news_source = 'Alymeria Daily Mail'
	if number_granter == 1:
		news_source = 'Starfield Industries News Services'
	if number_granter == 2:
		news_source = "Phil & Co. Pigeon Mailing"
		_and.append_text('&')
	if number_granter == 3:
		news_source = 'The Blessed Parchment'
	news.add_text(news_source)
	news.append_text(':
Demo 0.1 released! - Welcome playtester!
New acts "the facility" and "the forest"
Support contact email: email[img]res:///Assets/Text/@^5.png[/img]proton.me')




func splash_decider():
	number_generator = RandomNumberGenerator.new()
	number_granter = number_generator.randi_range(1, 34)
	var who_said_generator = RandomNumberGenerator.new()
	var who_said_granter = who_said_generator.randi_range(1, 7)
	var who_said = ' - '
	var d2
	var d
	
	var congrats_genereator = RandomNumberGenerator.new()
	var congrats_granter = congrats_genereator.randi_range(0, 100)
	#congrats_granter = 90
	if congrats_granter == 90:
		number_granter = 999999999
		splash_text.append_text('Yay! 
You have a 1/100 chance of seeing this splash text!

')
		splash_text.push_font_size(20)
		print("Achievment: Yay! (See the rare spash text with a 1/100 chance)")


	d2 = '                                                                                                                                                       ' ; d = 'lukas'
	if !congrats_granter == 90:
		splash_text.append_text('"')
	if who_said_granter == 1:
		who_said = who_said + 'janicria'
	if who_said_granter == 2:
		if OS.get_name() == 'Windows' and !OS.get_environment("USERNAME") == d:
			who_said = who_said + str(OS.get_environment("USERNAME"))
		elif OS.get_name() == 'Linux':
			who_said = who_said + str(OS.get_environment("LOGNAME"))
		elif OS.get_name() == 'Windows':
			who_said = who_said + 'skye'
		else:
			who_said = who_said + 'you'
	if who_said_granter == 3:
		who_said = who_said + 'the core infector'
	if who_said_granter == 4:
		who_said = who_said + 'snal'
	if who_said_granter == 5:
		who_said = who_said + 'jerry the slime'
	if who_said_granter == 6:
		who_said = who_said + 'Your name here! (If you upload a playtest)'
	if who_said_granter == 7:
		who_said = who_said + 'Starfield Industries commercial game review construct'
	if who_said_granter == 8:
		who_said = who_said + ''
	if who_said_granter == 9:
		who_said = who_said + ''
	if who_said_granter == 10:
		who_said = who_said + ''
	if who_said_granter == 11:
		who_said = who_said + ''
	

	if number_granter == 1:
		splash_text.append_text('Better than Minecraft"' + who_said)
	if number_granter == 2:
		splash_text.append_text('Horrible worldbuilding"' + who_said)
	if number_granter == 3:
		splash_text.append_text('Probally not even worth playing"' + who_said)
	if number_granter == 4:
		splash_text.append_text('I like Jerry the Slime"' + who_said)
	if number_granter == 5:
		splash_text.append_text('Ruined my life 10/10"' + who_said)
	if number_granter == 6:
		splash_text.append_text('0/10 would not play again"' + who_said)
	if number_granter == 7:
		splash_text.append_text("It's alright I guess" + '"' + who_said)
	if number_granter == 8:
		splash_text.append_text('Obvious minesweeper clone"' + who_said)
	if number_granter == 9:
		splash_text.append_text('Insanely high quality artstyle "' + who_said)
	if number_granter == 10:
		splash_text.append_text('The enemies are too hard"' + who_said)
	if number_granter == 11:
		splash_text.append_text('Insanely buggy mess, crashes every 5 minutes"' + who_said)
	if number_granter == 12:
		splash_text.append_text('Crashes after at least more than 4 minutes or get 100% of your money back guaranteed!' + who_said)
	if number_granter == 13:
		splash_text.append_text('Remember to submit your playtests!"' + who_said)
	if number_granter == 14:
		splash_text.append_text('I would rate it zero stars if I could"' + who_said)
	if number_granter == 15:
		splash_text.append_text('Lifechanging"' + who_said)
	if number_granter == 16:
		splash_text.append_text("Won't even launch" + '"' + who_said)
	if number_granter == 17:
		splash_text.append_text('The debug console ' + "doesn't" + ' make any sense"' + who_said)
	if number_granter == 18:
		splash_text.append_text('I was told this game would be fun..."' + who_said)
	if number_granter == 19:
		splash_text.append_text('Why didn' + "'" + 't my Potion of self revival trigger???"' + who_said)
	if number_granter == 20:
		splash_text.append_text('OMG this game is so fun!"' + who_said)
	if number_granter == 21:
		splash_text.append_text('Not as good as Terraria"' + who_said)
	if number_granter == 22:
		splash_text.append_text('I don' + "'" + 't like Jerry the Slime"' + who_said)
	if number_granter == 23:
		splash_text.append_text('Still fun to play 8 years after release"' + who_said)
	if number_granter == 24:
		splash_text.append_text('A classic"' + who_said)
	if number_granter == 25:
		splash_text.append_text('It' + "'" + 's basically just Portal 2 but with guns' + who_said)
	if number_granter == 26:
		splash_text.append_text('It crashed after 4 minutes and I didn' + "'" + 't get my money back"' + who_said)
	if number_granter == 27:
		splash_text.append_text('Installed spyware on my computer"' + who_said)
	if number_granter == 28:
		splash_text.append_text('Still no cloud saving"' + who_said)
	if number_granter == 29:
		splash_text.append_text('I would rather eat an echidna than play this game"' + who_said)
	if number_granter == 30:
		splash_text.append_text('Pay-to-win scam, cost me all my life savings and I still can' + "'t" + ' beat the Sentient Goop"' + who_said)
	if number_granter == 31:
		splash_text.append_text('Tried to contact support, got met with a stupid AI "Assistant" instead"' + who_said)
	if number_granter == 32:
		splash_text.append_text('Installed mods off the internet and got a virus"' + who_said)
	if number_granter == 33:
		splash_text.append_text('The multiplayer mode is super fun"' + who_said)
	if number_granter == 34:
		splash_text.append_text('Imagine using ' + str(OS.get_name()) + '"' + who_said)

var show_run_modifer_lock : int

func _process(delta):
	if Input.is_action_just_pressed("enter_pressed") and show_run_modifer_lock == 0:
		show_run_modifer_lock +=1
	if show_run_modifer_lock == 1:
		news.hide()
		splash_text.hide()
		_and.hide()
		alymeria.hide()
		run_selector_line_a.hide()
		run_selector_line_b.hide()
		run_selector_line_c.hide()
		run_selector_line_d.hide()
		run_box_a.hide()
		run_box_b.hide()
		run_modifer.show()

		get_tree().paused = false
		#hide()
		#queue_free()
