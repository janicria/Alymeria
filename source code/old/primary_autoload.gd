extends Node


@onready var rich_text_label = $"/root/Node2D/Text_Interface/main_box/outerBox"
@onready var timer_2_5s = $/root/Node2D/Text_Interface/main_box/Timer2_5s
@onready var bottom_l_text_box_3 = $/root/Node2D/Text_Interface/main_box/BottomLTextBox3
@onready var bottom_l_text_box_2 = $/root/Node2D/Text_Interface/main_box/BottomLTextBox2
@onready var health_stats_box = $/root/Node2D/Text_Interface/main_box/health_stats_box
#@onready var test = $"../../Camera2D"
@onready var misc_stats_box = $/root/Node2D/Text_Interface/main_box/misc_stats_box
@onready var deck_box = $/root/Node2D/Text_Interface/main_box/deck_box
@onready var menu_box = $/root/Node2D/Text_Interface/main_box/menu_box
@onready var hovering_selector_1 = $"/root/Node2D/Hovering Selector/hovering_selector_1"
@onready var hovering_selector_2 = $"/root/Node2D/Hovering Selector/hovering_selector_2"
@onready var hovering_selector_3 = $"/root/Node2D/Hovering Selector/hovering_selector_3"
@onready var hovering_selector_4 = $"/root/Node2D/Hovering Selector/hovering_selector_4"
#@onready var hovering_selector_5 = $"../../../Hovering Selector/hovering_selector_5"
@onready var menu_box_deck = $/root/Node2D/Text_Interface/main_box/menu_box_deck
@onready var menu_box_settings = $/root/Node2D/Text_Interface/main_box/menu_box_settings
@onready var power_box = $/root/Node2D/Text_Interface/main_box/power_box
@onready var hovering_selector_6 = $"/root/Node2D/Hovering Selector/hovering_selector_6"
@onready var timer_with_script = $/root/Node2D/Text_Interface/main_box/timer_with_script
@onready var achivment_timer = $/root/Node2D/Text_Interface/achievement_timer
@onready var hovering_selector_7 = $"/root/Node2D/Hovering Selector/hovering_selector_7"
@onready var hovering_selector_8 = $"/root/Node2D/Hovering Selector/hovering_selector_8"


#   °

# In order of apperence (probally)
var versionNumber:String = ProjectSettings.get_setting("application/config/version")
var endOfPlaytestHelper:bool = true
var startBoot:bool = false
var lockPowerOnMsg = false
var lockYNMsg = false
var canShutdown:bool = false
var lockShutdownDot:bool = false
var shutdownExtraDot:bool = false
var shutdownWait:bool = false
var shutdownDotStart:bool = false
var lockShutdownDotHelper:bool = false
var fullShutdownLock:bool = false
var lockYInput:bool = true
var lockDot:bool = false
var lockLoaded:bool = false
var timeElapsed:int = 0
var bootingTextFinished:bool = false
var lockSystemOnlineMsg:bool = false
var unlockCreatingUserMsg:bool = false
var showUserCreatedMsg:bool = false
var lockEnterUserNameMsg:bool = false
var boxLoadingTimer:int = 0
var boxLoadingTimerPoints:int = 0
var lockTimeLeft: bool = false
var canStartBootFunc:bool = false
var waitForPowerOnMsg:bool = false
var lockPowerSourceMsg:bool = false
var canType:bool = false
var userName:String = ''
var welcomeUSERMsg:bool = false
var welcomeUSERMsgHelper:bool = false
var driverLoad:bool = false
var driverLoadHelper:bool = false
var driverLoadHelperTheSecond:int = 0
var driverLoadHelperTheThird:int = 0
var driverLoadHelperTheFourth:int = 0
var driverLoadHelperTheFifth:int = 0
var driverLoadHelperTheSixth:int = 0
var autorunFUNCloadDots:bool = false
var NOTloadDots1:bool = false
var NOTloadDots2:bool = true
var NOTloadDots3:bool = true
var loadedDotsCounter:int = 0
var OSload:bool = 0
var showUserCreateProtocol:bool = false
var lockUserCreateProtocolMsg:bool = false
var lockDot2:bool = true
var lockCreatingUserMsg:bool = false
var lockEnterUserNameMsg2:bool = true
var lockDot2Helper:bool = false
var lockDot2HelperHelper:bool = false
var lockDot2HelperHelperHelper:bool = false
var showSystemOnlineMsg:bool = false
var addDot:bool = false
var addDotCounter:int = 0
var lockaddDot:bool = false
var finalPowerOnMsg:bool =false
var lockCFCCFEPOprotocolMsgs:bool = false
var currentLine:int = 1
var currentUpScroll:int
var powerOffCounter:int = 0
var lock:bool = false
var locktimeout1:bool =false
var locktimeout2:bool =false
var locktimeout3:bool =false
var finallock:bool = false
var finallocksquared:bool = false
var runTime1:bool = false
var runTime2:bool = false
var runSpace1:bool = false
var runSpace2:bool = false
var shutDownNumberLock:int = 0
var createStatBoxes:bool = false
var maxHp = 0
var hp:float = maxHp
var maxBattery:float
var battery:int
var batteryPerctange:float
var totalHealth:int
var lockStatsInStatBoxes:bool = false
var secondHypenLine:bool = false
var statBoxHypenCount:int = 0
var makeNewlineForHypens:int = 0
var lockHypenSpeed:bool = false
var unlockHypenSpeed:bool = false
var resetBoxLoadingTimerPoints:bool = false
var loadingTimerVar:int = 0
var lockStatsInStatBoxes2:bool = false
var start_second_text_box:bool = false
var secondBox_hypen_count:int = 0
var secondBox_lock_hypens:bool = false
var secondBox_unlock_hypens:bool = false
var firstBox_create:bool = false
var firstBox_create_second_line:bool = false
var gold:int = 0
var time_minutes:int = 0
var time_hours:int = 0
var days:int = 0
var floor:int = 0
var biome:String = 'Demo'
var maxMemory:int = 4
var memory:int = maxMemory
var core_temp:int = 60
var game_start_enabler:bool = false
var number_of_failed_name_msgs:int = 0
var turn_number:int = 0
var turn_letter:String = 'A'
var hovering_selector_number:int = 0
var stay_on_hovering_5:bool = false
var stay_on_hovering_5_timer:int = 0
var hovering_selector_counter:int = 0
var hovering_selector_hider:bool = false
var timea:int = 0

func _process(delta):
	formulas()
#	startBootFunc()
	mouseScrolling()
#	stats_boxes()
#	stats_boxes()
	settings()
	seed_granter()
	room_selector()
	if game_start_enabler:
		hovering_selector()
		game_stats()
		menu_box_settings.show()
		menu_box_deck.show()
		menu_box.show()
		power_box.show()
		achievments()

	if not hovering_selector_hider:
		print("New debug session started! Hope it works this time skye <3")
		print('System: ' +str(OS.get_distribution_name()) + ' ' + str(OS.get_version()) +' (' +str(OS.get_name()) + ')')
		print('Version: ' + versionNumber)
		hovering_selector_1.hide()
		hovering_selector_2.hide()
		hovering_selector_3.hide()
		hovering_selector_4.hide()
		#hovering_selector_5.hide()
		hovering_selector_6.hide()
		hovering_selector_7.hide()
		hovering_selector_8.hide()
		hovering_selector_hider = true
		menu_box_deck.hide()
		menu_box_settings.hide()
		menu_box.hide()
		power_box.hide()
		AutoLOadDupeTest.add_additional_program_to_deck()
		AutoLOadDupeTest.duplicate()
#	tedst()
#	print(loadedDotsCounter)
#	print(userName)
#	print(str(timeElapsed) + str(int(timer_with_script.time_left)))
#	print(int(timer_with_script.time_left))
#	print(str(currentUpScroll))
#	print()
#	print(powerOffCounter)
#	print(loadingTimerVar)
#	print(addDotCounter)

func mouseScrolling():
	currentLine = rich_text_label.get_line_count()
	rich_text_label.mouse_force_pass_scroll_events = true
	if Input.is_action_just_pressed("scroll_up") and currentLine > 14:
		rich_text_label.scroll_to_line(currentUpScroll -1)
		currentUpScroll -=1
	
		print('Hiya <3')
	if Input.is_action_just_pressed("scroll_down") and currentLine > 14:
		print('Hiya :3')
		rich_text_label.scroll_to_line(currentUpScroll +1)
		currentUpScroll += 1
	if currentUpScroll < 2:
		currentUpScroll = 1
	if currentUpScroll > currentLine:
		currentUpScroll = currentLine
func startBootFunc():
	boxLoadingTimer = timer_2_5s.time_left + 0.95
	if boxLoadingTimer == 0 and not lockTimeLeft:
		boxLoadingTimerPoints += 1
		lockTimeLeft = true
	if boxLoadingTimer == 1 and lockTimeLeft:
		lockTimeLeft = false
	if boxLoadingTimerPoints > 70:
		canStartBootFunc = true

	if canShutdown == true:
		shutDownTimer()
	if startBoot == true:
		loadingTimer()

	if canStartBootFunc and not lockPowerSourceMsg:
		rich_text_label.add_text('Power source connected')
		lockPowerSourceMsg = true
	if int(timer_with_script.time_left) == 1 and not lockPowerOnMsg and canStartBootFunc:
		lockPowerOnMsg = true
		rich_text_label.newline()
		rich_text_label.add_text('Continue with power on?')
		waitForPowerOnMsg = true
	if int(timer_with_script.time_left) == 0 and not lockYNMsg and canStartBootFunc and waitForPowerOnMsg:
		lockYNMsg = true
		rich_text_label.newline()
		rich_text_label.newline()
		rich_text_label.add_text('y/n')
		lockYInput = false
	if Input.is_action_just_pressed('y_pressed') and not lockYInput and canStartBootFunc:
			startBoot = true
			rich_text_label.newline()
			rich_text_label.add_text('Y')
			rich_text_label.newline()
			rich_text_label.newline()
			rich_text_label.add_text('Booting')
			lockYInput = true
	elif Input.is_action_just_pressed("n_pressed") and not lockYInput and canStartBootFunc:
		lockYInput = true
		canShutdown = true
func loadingTimer():
	if lockDot2Helper and int(timer_with_script.time_left) == 0:
		lockDot2 = false
	if not lockDot2 and int(timer_with_script.time_left) == 1:
		timeElapsed +=1
		lockDot2 = true
		if lockDot2HelperHelperHelper and timeElapsed < 5:
			rich_text_label.add_text('.')
		if lockDot2HelperHelper:
			lockDot2Helper = true
	if int(timer_with_script.time_left) == 0 and not lockDot:
			lockDot = true
			if not timeElapsed > 2 and not lockSystemOnlineMsg:
				rich_text_label.add_text(".")
			timeElapsed += 1
	if int(timer_with_script.time_left) == 1:
		lockDot = false
	if timeElapsed > 3:
		lockDot = true
		if lockLoaded == false:
			lockLoaded = true
			rich_text_label.newline()
			rich_text_label.add_text('Running system check')
			bootingTextFinished = true
			lockDot = false
			timeElapsed = 0
			timer_with_script.wait_time = 1.5
	if bootingTextFinished == true and timeElapsed > 3 and lockSystemOnlineMsg == false:
			lockSystemOnlineMsg = true
			rich_text_label.newline()
			rich_text_label.add_text('Warning: Facility is in emergency power mode. Unable to charge battery past 60% power')
			timeElapsed = 0
			lockDot = false
			showSystemOnlineMsg = true
			#unlockCreatingUserMsg = true
	if showSystemOnlineMsg:
		rich_text_label.newline()
		rich_text_label.add_text('All systems fully operational with one exception')
		unlockCreatingUserMsg = true
		showSystemOnlineMsg = false
		timeElapsed = 0
	if unlockCreatingUserMsg == true and timeElapsed > 1:
		rich_text_label.newline()
		rich_text_label.add_text('Warning: Unable to continue to next stage of system wakeup. No active user detected in facility premises')
		unlockCreatingUserMsg = false
		timeElapsed = 4
		#showUserCreatedMsg = true
		showUserCreateProtocol = true
		lockDot2 = false
		lockUserCreateProtocolMsg = false
	if showUserCreateProtocol and timeElapsed == 5 and not lockUserCreateProtocolMsg:
		rich_text_label.newline()
		#if int(timer_with_script.time_left) == 0:
		rich_text_label.add_text('Initiating emergency user creation protocol')
		timeElapsed = 3
		showUserCreatedMsg = true
		lockUserCreateProtocolMsg = true
		lockDot = false
		lockCreatingUserMsg = true
	if showUserCreatedMsg and timeElapsed == 4 and lockCreatingUserMsg:
		rich_text_label.newline()
		rich_text_label.add_text('Creating new user')
		timeElapsed = 0
		lockCreatingUserMsg = false
		lockEnterUserNameMsg2 = false
		lockDot2 = false
		lockDot2HelperHelper = true
		lockDot2HelperHelperHelper = true
	if showUserCreatedMsg == true and timeElapsed > 3 and lockEnterUserNameMsg == false and not lockEnterUserNameMsg2:
		lockEnterUserNameMsg = true
		rich_text_label.add_text('.')
		rich_text_label.newline()
		rich_text_label.add_text('Please enter name for new user:')
		rich_text_label.newline()
		canType = true
	if canType:
		if Input.is_action_just_pressed('1_pressed'):
			rich_text_label.add_text('1')
			userName += str('1')
		if Input.is_action_just_pressed('2_pressed'):
			rich_text_label.add_text('2')
			userName += str('2')
		if Input.is_action_just_pressed('3_pressed'):
			userName += str('3')
			rich_text_label.add_text('3')
		if Input.is_action_just_pressed('4_pressed'):
			rich_text_label.add_text('4')
			userName += str('4')
		if Input.is_action_just_pressed('5_pressed'):
			rich_text_label.add_text('5')
			userName += str('5')
		if Input.is_action_just_pressed('6_pressed'):
			rich_text_label.add_text('6')
			userName += str('6')
		if Input.is_action_just_pressed('7_pressed'):
			rich_text_label.add_text('7')
			userName += str('7')
		if Input.is_action_just_pressed('8_pressed'):
			rich_text_label.add_text('8')
			userName += str('8')
		if Input.is_action_just_pressed('9_pressed'):
			rich_text_label.add_text('9')
			userName += str('9')
		if Input.is_action_just_pressed('q_pressed'):
			rich_text_label.add_text('q')
			userName += str('q')
		if Input.is_action_just_pressed('w_pressed'):
			rich_text_label.add_text('w')
			userName += str('w')
		if Input.is_action_just_pressed('e_pressed'):
			rich_text_label.add_text('e')
			userName += str('e')
		if Input.is_action_just_pressed('r_pressed'):
			rich_text_label.add_text('r')
			userName += str('r')
		if Input.is_action_just_pressed('t_pressed'):
			rich_text_label.add_text('t')
			userName += str('t')
		if Input.is_action_just_pressed('y_pressed'):
			rich_text_label.add_text('y')
			userName += str('y')
		if Input.is_action_just_pressed('u_pressed'):
			rich_text_label.add_text('u')
			userName += str('u')
		if Input.is_action_just_pressed('i_pressed'):
			rich_text_label.add_text('i')
			userName += str('i')
		if Input.is_action_just_pressed('o_pressed'):
			rich_text_label.add_text('o')
			userName += str('o')
		if Input.is_action_just_pressed('p_pressed'):
			rich_text_label.add_text('p')
			userName += str('p')
		if Input.is_action_just_pressed('a_pressed'):
			rich_text_label.add_text('a')
			userName += str('a')
		if Input.is_action_just_pressed('s_pressed'):
			rich_text_label.add_text('s')
			userName += str('s')
		if Input.is_action_just_pressed('d_pressed'):
			rich_text_label.add_text('d')
			userName += str('d')
		if Input.is_action_just_pressed('f_pressed'):
			rich_text_label.add_text('f')
			userName += str('f')
		if Input.is_action_just_pressed('g_pressed'):
			rich_text_label.add_text('g')
			userName += str('g')
		if Input.is_action_just_pressed('h_pressed'):
			rich_text_label.add_text('h')
			userName += str('h')
		if Input.is_action_just_pressed('j_pressed'):
			rich_text_label.add_text('j')
			userName += str('j')
		if Input.is_action_just_pressed('k_pressed'):
			rich_text_label.add_text('k')
			userName += str('k')
		if Input.is_action_just_pressed('l_pressed'):
			rich_text_label.add_text('l')
			userName += str('l')
		if Input.is_action_just_pressed('z_pressed'):
			rich_text_label.add_text('z')
			userName += str('z')
		if Input.is_action_just_pressed('x_pressed'):
			rich_text_label.add_text('x')
			userName += str('x')
		if Input.is_action_just_pressed('c_pressed'):
			rich_text_label.add_text('c')
			userName += str('c')
		if Input.is_action_just_pressed('v_pressed'):
			rich_text_label.add_text('v')
			userName += str('v')
		if Input.is_action_just_pressed('b_pressed'):
			rich_text_label.add_text('b')
			userName += str('b')
		if Input.is_action_just_pressed('n_pressed'):
			rich_text_label.add_text('n')
			userName += str('n')
		if Input.is_action_just_pressed('m_pressed'):
			rich_text_label.add_text('m')
			userName += str('m')
		if Input.is_action_just_pressed('space_pressed'):
			rich_text_label.add_text(' ')
			userName += str(' ')
		if Input.is_action_just_pressed('enter_pressed') and not userName == '':
			rich_text_label.newline()
			canType = false
			rich_text_label.add_text('New user created!')
			welcomeUSERMsg = true
		elif Input.is_action_just_pressed("enter_pressed"):
			if number_of_failed_name_msgs == 3:
				#rich_text_label.newline()
				number_of_failed_name_msgs +=1
				rich_text_label.add_text('Honestly mate just enter a proper name')
				rich_text_label.newline()
			elif number_of_failed_name_msgs < 3:
				rich_text_label.newline()
				rich_text_label.add_text('ERROR: Name must contain at least one character')
				rich_text_label.newline()
				rich_text_label.add_text('Please enter name for new user:')
				rich_text_label.newline()
				number_of_failed_name_msgs +=1
	if welcomeUSERMsg:
		if int(timer_with_script.time_left) == 0:
			welcomeUSERMsgHelper = true
		if welcomeUSERMsgHelper and int(timer_with_script.time_left) == 1:
			rich_text_label.newline()
			rich_text_label.add_text(str('Welcome user ') + userName + str('!'))
			welcomeUSERMsg = false
			welcomeUSERMsgHelper = false
			driverLoad = true
	if driverLoad:

		if int(timer_with_script.time_left) == 0 and not driverLoadHelperTheThird:
			rich_text_label.newline()
			rich_text_label.add_text('Loading drivers')
			driverLoadHelper = true
			driverLoadHelperTheThird = true
		if driverLoadHelper:
			if int(timer_with_script.time_left) == 0 and driverLoadHelperTheSecond < 4 and not driverLoadHelperTheFourth:
				rich_text_label.add_text('')
				driverLoadHelperTheSecond += 1
				driverLoadHelperTheFourth = true
				driverLoadHelperTheSixth = true
			if int(timer_with_script.time_left) == 1 and driverLoadHelperTheSecond < 4 and not driverLoadHelperTheFifth:
				rich_text_label.add_text('.')
				driverLoadHelperTheSecond += 1
				driverLoadHelperTheFifth = true
			if driverLoadHelperTheSixth and int(timer_with_script.time_left) == 0:
				rich_text_label.add_text('.')
				driverLoadHelperTheSecond += 1
				driverLoadHelperTheSixth = false
			if driverLoadHelperTheSecond > 2:
				if int(timer_with_script.time_left) == 1:
					rich_text_label.add_text('.')
					rich_text_label.newline()
					rich_text_label.add_text('All drivers operational!')
					OSload = true
					driverLoad = false
			#		endOfPlaytest()
	if OSload:
		if int(timer_with_script.time_left) == 1:
			rich_text_label.newline()
			rich_text_label.add_text('Loading OS')
			OSload = false
			autorunFUNCloadDots = true
	if autorunFUNCloadDots:
		loadDots()
func shutDownTimer():
	if not fullShutdownLock and runSpace1:
		rich_text_label.newline()
		rich_text_label.add_text('N')
		rich_text_label.newline()
		rich_text_label.newline()
		rich_text_label.add_text('Shutting down')
		fullShutdownLock = true
	if int(timer_with_script.time_left) == 0 and not shutdownWait:
		shutdownWait = true
		runSpace1 = true
	if int(timer_with_script.time_left) == 2 and runSpace1 and shutDownNumberLock <1:
		#rich_text_label.newline()
		rich_text_label.add_text('.')
		shutDownNumberLock +=1
		runSpace2 = true
	if int(timer_with_script.time_left) == 1 and runSpace2 and shutDownNumberLock <2:
		#rich_text_label.newline()
		rich_text_label.add_text('.')
		runTime1 = true
		shutDownNumberLock +=1
	if int(timer_with_script.time_left) == 0 and runTime1 and shutDownNumberLock <3:
		#rich_text_label.newline()
		rich_text_label.add_text('.')
		runTime2 = true
		shutDownNumberLock +=1
	if int(timer_with_script.time_left) == 1 and runTime2:
		get_tree().quit()
func endOfPlaytest():
	if endOfPlaytestHelper:
		print('End of playtest (' + versionNumber + ')')
		rich_text_label.newline()
		rich_text_label.add_text('#######################')
		rich_text_label.newline()
		rich_text_label.add_text('#   END OF PLAYTEST   #')
		rich_text_label.newline()
		rich_text_label.add_text(str('#   Version ') + versionNumber + str('  #'))
		rich_text_label.newline()
		rich_text_label.add_text('#######################')
		endOfPlaytestHelper = false
func loadDots():
	if int(timer_with_script.time_left) == 0 and not NOTloadDots1:
				rich_text_label.add_text('.')
				NOTloadDots1 = true
				loadedDotsCounter += 1
				NOTloadDots2 = false
	if int(timer_with_script.time_left) == 1 and not NOTloadDots2:
				rich_text_label.add_text('.')
				NOTloadDots2 = true
				loadedDotsCounter += 1
				NOTloadDots3 = false
	if int(timer_with_script.time_left) == 0 and not NOTloadDots3:
				rich_text_label.add_text('.')
				NOTloadDots3 = true
				loadedDotsCounter += 1
	if int(timer_with_script.time_left) == 1 and loadedDotsCounter > 3 and lockaddDot:
		lockaddDot = false
	if int(timer_with_script.time_left) == 0 and loadedDotsCounter > 3 and not lockaddDot:
		loadedDotsCounter += 1
		lockaddDot = true
		if addDot and addDotCounter < 3:
			rich_text_label.add_text('.')
			addDotCounter += 1
	if loadedDotsCounter == 3 and not lockCFCCFEPOprotocolMsgs:
		rich_text_label.newline()
		rich_text_label.add_text('Warning: No active user detected in facility premises with authorisation to continue to final stage of system wakeup.')
		loadedDotsCounter += 1
	if loadedDotsCounter == 4 and not lockCFCCFEPOprotocolMsgs:
		rich_text_label.newline()
		rich_text_label.add_text('Requesting permission from central facility computer to continue to final stage of system wakeup')
		addDot = true
	if addDotCounter == 2 and int(timer_with_script.time_left):
		rich_text_label.add_text('.')
		addDotCounter += 1
	if addDotCounter == 3 and not lockCFCCFEPOprotocolMsgs:
		rich_text_label.newline()
		rich_text_label.add_text('Unable to connect to central facility computer.')
		addDotCounter += 1
	if addDotCounter == 4 and int(timer_with_script.time_left) == 0 and not lockCFCCFEPOprotocolMsgs:
		addDotCounter += 1
		rich_text_label.newline()
		rich_text_label.add_text('Initiating central facility computer connection failure emergency power on protocol. Continuing to final stage of system wakeup')
		finalPowerOnMsg = true
	if finalPowerOnMsg and int(timer_with_script.time_left) == 1 and not lockCFCCFEPOprotocolMsgs:
		finalPowerOnMsg = false
		rich_text_label.newline()
		rich_text_label.add_text('Finalising wakeup sequence')
		addDotCounter = 0
		lockCFCCFEPOprotocolMsgs = true
	if addDotCounter == 3 and lockCFCCFEPOprotocolMsgs:
		#endOfPlaytest()
		#game_stats()
		#game_start_enabler = true
		addDotCounter += 1
	if addDotCounter == 4 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		rich_text_label.newline()
		rich_text_label.add_text('Loading sensors')
		addDotCounter +=1
	if addDotCounter == 5 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		rich_text_label.newline()
		rich_text_label.add_text('All sensors online')
		addDotCounter +=1
		game_start_enabler = true
	if addDotCounter == 6 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		rich_text_label.newline()
		rich_text_label.add_text('Finalising final stages of wakeup sequence')
		addDotCounter +=1
	if addDotCounter == 7 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1 and not lock:
		addDotCounter = 11
	if addDotCounter == 11 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0 and not lock:
		addDotCounter = 7
		lock = true
	if addDotCounter == 7 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		rich_text_label.add_text('.')
		addDotCounter +=1
	if addDotCounter == 8 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		rich_text_label.add_text('.')
		addDotCounter +=1
	if addDotCounter == 9 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		rich_text_label.add_text('.')
		addDotCounter +=1
	if addDotCounter == 10 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		addDotCounter +=1
	if addDotCounter == 11 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		addDotCounter +=1
		rich_text_label.newline()
		rich_text_label.add_text('Wakeup complete')
	if addDotCounter == 12 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		addDotCounter +=1
	if addDotCounter == 13 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		rich_text_label.newline()
		rich_text_label.newline()
		rich_text_label.newline()
		addDotCounter += 1
	if addDotCounter == 14 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		addDotCounter += 1
	if addDotCounter == 15 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		addDotCounter += 1
	if addDotCounter == 16 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		addDotCounter +=1
	if addDotCounter == 17 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		addDotCounter += 1
		endOfPlaytest()
	if addDotCounter == 18 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 0:
		addDotCounter += 1
	if addDotCounter == 19 and lockCFCCFEPOprotocolMsgs and int(timer_with_script.time_left) == 1:
		endOfPlaytest()
	createStatBoxes = true
func stats_boxes():
	if loadingTimerVar == 1:
		lockStatsInStatBoxes = false
		secondBox_lock_hypens = false
	elif loadingTimerVar == 0:
		lockStatsInStatBoxes2 = false
		secondBox_unlock_hypens = false
	if editor_description == 'stats_boxes()' and firstBox_create:
		if not resetBoxLoadingTimerPoints:
			resetBoxLoadingTimerPoints = true
			boxLoadingTimerPoints = 0
		if loadingTimerVar == 0 and not lockStatsInStatBoxes and statBoxHypenCount < 46:
			bottom_l_text_box_2.add_text('-')
			statBoxHypenCount +=1
			lockStatsInStatBoxes = true
		elif loadingTimerVar == 1 and not lockStatsInStatBoxes2 and statBoxHypenCount < 46:
			bottom_l_text_box_2.add_text('-')
			statBoxHypenCount +=1
			lockStatsInStatBoxes2 = true
		if statBoxHypenCount == 45:
			start_second_text_box = true
			bottom_l_text_box_2.push_font_size(8)
			bottom_l_text_box_3.push_font_size(8)
			bottom_l_text_box_3.newline()
			bottom_l_text_box_3.add_text(' ')
			bottom_l_text_box_3.push_font_size(8)
			bottom_l_text_box_3.add_text('                                                                                                                                                                                                                                                                                                                                                                                            Terracota')
			bottom_l_text_box_3.push_font_size(20)
			bottom_l_text_box_2.newline()
			bottom_l_text_box_2.add_text('                                                                                                                                                                                                                                                                                                                                                                                                   Ex')
			bottom_l_text_box_3.newline()
			bottom_l_text_box_2.newline()
			bottom_l_text_box_3.add_text(' ')
			bottom_l_text_box_2.push_font_size(20)
			statBoxHypenCount +=1
		if loadingTimerVar == 0 and not lockStatsInStatBoxes and statBoxHypenCount > 45:
			lockStatsInStatBoxes = true
			if firstBox_create_second_line and statBoxHypenCount < 135:
				bottom_l_text_box_2.add_text('-')
			if statBoxHypenCount <91:
				bottom_l_text_box_3.add_text('-')
			statBoxHypenCount +=1
		elif loadingTimerVar == 1 and not lockStatsInStatBoxes2 and statBoxHypenCount > 45:
			lockStatsInStatBoxes2 = true
			if firstBox_create_second_line and statBoxHypenCount <135:
				bottom_l_text_box_2.add_text('-')
			if statBoxHypenCount <90:
				bottom_l_text_box_3.add_text('-')
			statBoxHypenCount +=1
		if statBoxHypenCount == 90:
			firstBox_create_second_line = true
	if timer_2_5s.editor_description == 'second_box()' and loadingTimerVar == 0 and not secondBox_lock_hypens and secondBox_hypen_count < 44:
		secondBox_lock_hypens = true
		bottom_l_text_box_3.add_text('-')
		secondBox_hypen_count +=1
	if timer_2_5s.editor_description == 'second_box()' and loadingTimerVar == 1 and not secondBox_unlock_hypens and secondBox_hypen_count < 44:
		secondBox_unlock_hypens = true
		bottom_l_text_box_3.add_text('-')
		secondBox_hypen_count +=1
	elif secondBox_hypen_count == 43:
		firstBox_create = true
func formulas():
		batteryPerctange = (battery / maxBattery) * 100
		totalHealth = hp + battery
		#loadingTimerVar = timer_2_5s.time_left + 0.95
		maxHp = PlayerStats.max_health
		hp = PlayerStats.health
		battery = PlayerStats.battery
		maxBattery = PlayerStats.max_battery
		if time_minutes > 59:
			time_minutes = 0
			time_hours +=1
		if time_hours > 23:
			time_hours = 0
			days +=1
func game_stats(): 
		health_stats_box.clear()
		health_stats_box.add_text(' Core Temprature: ' +str(core_temp) + '°')
		health_stats_box.add_text(' / Exterior plating: ' +str(hp) +'/' +str(maxHp))
		health_stats_box.add_text('  Battery charge: ' + str(battery) + '/' + str(maxBattery))
		# + ' (' + str(batteryPerctange) + '%)')
		#health_stats_box.add_text('  Total:' + str(totalHealth) + '/70')
		misc_stats_box.clear()
		misc_stats_box.add_text('  Floor ' +str(floor))
		misc_stats_box.add_text(' / Gold: ' +str(gold))
		misc_stats_box.add_text(' / Turn ')
		if turn_number:
			misc_stats_box.add_text(str(turn_number) +str(turn_letter))
		else:
			misc_stats_box.add_text('N/A')
		misc_stats_box.add_text(' / Memory: ' +str(memory) +'/' +str(maxMemory) +'GB')
		misc_stats_box.add_text(' / Time: ' +str(time_hours))
		if time_hours < 10:
			misc_stats_box.add_text('0')
		misc_stats_box.add_text(':' +str(time_minutes))
		if time_minutes < 10:
			misc_stats_box.add_text('0')
		misc_stats_box.add_text('  (Day ' +str(days) +')')
func deck():
	pass
func settings():
	menu_box.clear()
	menu_box.add_text('--------------------------------------------')
	menu_box.push_font_size(1)
	menu_box.newline()
	menu_box.push_font_size(13)
	menu_box.add_text('                                 |')
	menu_box.newline()
	menu_box.add_text('                                 |')
	menu_box.newline()
	menu_box.add_text('                                 |')
	menu_box.newline()
	menu_box.add_text('                                 |')
	menu_box.add_text(' ---------------------------------')
	menu_box.newline()
	menu_box.add_text('                                 |')
	menu_box.newline()
	menu_box.add_text('                                 |')
	menu_box.newline()
	menu_box.add_text('                                 |')
	menu_box.newline()

var stay_on_hovering_8 = false
var stay_on_hovering_8_timer = 80
func hovering_selector():
	if not hovering_selector_number and Input.is_action_just_pressed("ui_left"):
		hovering_selector_number =2
	if not hovering_selector_number and Input.is_action_just_pressed("ui_right"):
		hovering_selector_number =3
	if not hovering_selector_number and Input.is_action_just_pressed("ui_up"):
		hovering_selector_number =1
	if not hovering_selector_number and Input.is_action_just_pressed("ui_down"):
		hovering_selector_number =3
	if hovering_selector_number == 1 and Input.is_action_just_pressed("ui_down"):
		hovering_selector_number = 2
	if hovering_selector_number == 2 and Input.is_action_just_pressed("ui_right"):
		hovering_selector_number = 3
	if hovering_selector_number == 3 and Input.is_action_just_pressed("ui_up"):
		hovering_selector_number = 1
	if hovering_selector_number == 3 and Input.is_action_just_pressed("ui_left"):
		hovering_selector_number = 2
	if hovering_selector_number == 2 and Input.is_action_just_pressed("ui_up"):
		hovering_selector_number = 1
	if hovering_selector_number == 3 and Input.is_action_just_pressed("ui_down"):
		stay_on_hovering_5 = true
		stay_on_hovering_5_timer = 0
		hovering_selector_number = 4
	if hovering_selector_number == 4 and Input.is_action_just_pressed("ui_left"):
		stay_on_hovering_5 = true
		stay_on_hovering_5_timer = 0
		hovering_selector_number = 5
	if hovering_selector_number == 4 and Input.is_action_just_pressed("ui_up") and not stay_on_hovering_5:
		hovering_selector_number = 3
	if hovering_selector_number == 5 and Input.is_action_just_pressed("ui_right"):
		stay_on_hovering_5 = true
		stay_on_hovering_5_timer = 0
		hovering_selector_number = 4
	if hovering_selector_number == 5 and Input.is_action_just_pressed("ui_up"):
		hovering_selector_number = 3
	if hovering_selector_number == 5 and Input.is_action_just_pressed("ui_left") and not stay_on_hovering_5 and not stay_on_hovering_8:
		hovering_selector_number = 2
	if hovering_selector_number == 4 and Input.is_action_just_pressed("ui_right") and not stay_on_hovering_5:
		hovering_selector_number = 6
	if hovering_selector_number == 6 and Input.is_action_just_pressed("ui_left"):
		hovering_selector_number = 4
	if hovering_selector_number == 6 and Input.is_action_just_pressed("ui_down"):
		hovering_selector_number = 7
	if hovering_selector_number == 6 and Input.is_action_just_pressed("ui_up") and not stay_on_hovering_5:
		hovering_selector_number = 3
	if hovering_selector_number == 7 and Input.is_action_just_pressed("ui_left"):
		stay_on_hovering_5 = true
		stay_on_hovering_5_timer = 0
		hovering_selector_number = 8
	if hovering_selector_number == 7 and Input.is_action_just_pressed("ui_up"):
		stay_on_hovering_5 = true
		stay_on_hovering_5_timer = 0
		hovering_selector_number = 6
	if hovering_selector_number == 8 and Input.is_action_just_pressed("ui_right"):
		hovering_selector_number = 7
	if hovering_selector_number == 8 and Input.is_action_just_pressed("ui_up"):
		stay_on_hovering_5 = true
		stay_on_hovering_5_timer = 0
		hovering_selector_number = 4
	if hovering_selector_number == 8 and Input.is_action_just_pressed("ui_left") and not stay_on_hovering_5:
		stay_on_hovering_5 = true
		stay_on_hovering_8 = true
		stay_on_hovering_5_timer = 0
		stay_on_hovering_8_timer = 0
		hovering_selector_number = 5
	if hovering_selector_number == 4 and Input.is_action_just_pressed("ui_down") and not stay_on_hovering_5:
		hovering_selector_number = 8
#	print(str(hovering_selector_number) + ' - '+str(stay_on_hovering_5_timer))
	stay_on_hovering_5_timer +=1
	if not stay_on_hovering_8_timer == 80:
		stay_on_hovering_8_timer +=1
	if stay_on_hovering_5_timer <60:
		stay_on_hovering_5 = false
	if stay_on_hovering_8_timer <60:
		stay_on_hovering_8 = false

	hovering_selector_counter += 1
	if hovering_selector_counter > 99:
		hovering_selector_counter = 0
	if hovering_selector_counter > 50:
		if hovering_selector_number == 1:
			hovering_selector_1.hide()
		if hovering_selector_number == 2:
			hovering_selector_2.hide()
		if hovering_selector_number == 3:
			hovering_selector_3.hide()
		if hovering_selector_number == 4:
			hovering_selector_4.hide()
		if hovering_selector_number == 6:
			hovering_selector_6.hide()
		if hovering_selector_number == 7:
			hovering_selector_7.hide()
		if hovering_selector_number == 8:
			hovering_selector_8.hide()
	if hovering_selector_counter < 50:
		if hovering_selector_number == 1:
			hovering_selector_1.show()
		if hovering_selector_number == 2:
			hovering_selector_2.show()
		if hovering_selector_number == 3:
			hovering_selector_3.show()
		if hovering_selector_number == 4:
			hovering_selector_4.show()
		if hovering_selector_number == 6:
			hovering_selector_6.show()
		if hovering_selector_number == 7:
			hovering_selector_7.show()
		if hovering_selector_number == 8:
			hovering_selector_8.show()
	if not hovering_selector_number == 1:
		hovering_selector_1.hide()
	if not hovering_selector_number ==2:
		hovering_selector_2.hide()
	if not hovering_selector_number ==3:
		hovering_selector_3.hide()
	if not hovering_selector_number ==4:
		hovering_selector_4.hide()
	if not hovering_selector_number == 6:
		hovering_selector_6.hide()
	if not hovering_selector_number == 7:
		hovering_selector_7.hide()
	if not hovering_selector_number == 8:
		hovering_selector_8.hide()
	timea +=128
	print(str(hovering_selector_number) + ' - ' + str(stay_on_hovering_5_timer))
	#print(hovering_selector_counter)

var seed_generator
var seed_boss_selector
var seed_enemy_selector
var seed_event_selector
var seed_mini_selector
var seed_shop_selector
var seed_loot_selector
var seed_locker:bool = false
var replace_with_how_many_different_in_act = 1
var seed_boss = 2
var seed_enemy
var seed_event
var seed_mini
var seed_shop
var seed_loot
var seed_chances
func seed_granter():
	if not seed_locker:
		seed_locker = true
		seed_generator = RandomNumberGenerator.new()
		seed_boss_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_enemy_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_event_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_mini_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_shop_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_loot_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		#seed = str(seed_boss_selector) + '.' +str(seed_enemy_selector) + '.' +str(seed_event_selector) + '.' +str(seed_mini_selector) + '.' +str(seed_shop_selector) + '.' +str(seed_loot_selector)
		seed_boss = str(seed_boss_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, 1))
		seed_mini = str(seed_mini_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		#seed_loot  = str(seed_enemy_selector) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		seed_enemy = str(seed_enemy_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		seed_event  = str(seed_enemy_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		#seed_shop = str(seed_enemy_selector) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		seed_chances = (str(seed_boss) +'-' +str(seed_mini) +'-' +str(seed_enemy) +'-' +str(seed_event))
		#print('Seed - ' +str(seed))

var floor_lineup
var floor_enemy_chance
var floor_event_chance
var floor_event_1
var floor_event_2
var floor_event_3
var floor_event_4
var floor_event_5
var floor_event_6
var floor_event_7
var floor_event_8
var floor_event_9
var floor_event_10
var floor_event_11
var floor_event_12
var floor_event_13
var floor_event_14
var floor_event_15
var floor_event_16
var floor_event_17
var floor_event_18
var floor_event_19
var floor_event_20
var floor_event_21
var floor_event_22
var floor_event_23
var floor_event_24
var floor_event_25
var floor_event_26
var floor_event_27
var floor_event_28
var floor_event_29
var floor_event_30
var floor_event_31
var floor_lineup_act_1
var floor_lineup_act_2
var floor_lineup_act_3
var floor_lineup_act_4
var floor_lineup_act_5
var floor_lineup_act_6
var floor_lineup_act_7
var floor_chance_counter:int 
var floor_lock_generation:bool = false
var seed

func room_selector():
	#print(floor_chance_counter)
	if not floor_lock_generation:
		floor_enemy_chance = seed_generator.randi_range(1, 100)
		floor_event_chance = seed_generator.randi_range(1, 90)
		seed_generator = RandomNumberGenerator.new()
		if floor_chance_counter == 1:
			if floor_event_chance < floor_enemy_chance:
				floor_event_1 = 'E'
			else:
				floor_event_1 = 'R'
		if floor_chance_counter == 2:
			if floor_event_chance < floor_enemy_chance:
				floor_event_2 = 'E'
			else:
				floor_event_2 = 'R'
		if floor_chance_counter == 3:
			if floor_event_chance < floor_enemy_chance:
				floor_event_3 = 'E'
			else:
				floor_event_3 = 'R'
		if floor_chance_counter == 4:
			if floor_event_chance < floor_enemy_chance:
				floor_event_4 = 'E'
			else:
				floor_event_4 = 'R'
		if floor_chance_counter == 5:
			if floor_event_chance < floor_enemy_chance:
				floor_event_5 = 'E'
			else:
				floor_event_5 = 'R'
		if floor_chance_counter == 6:
			if floor_event_chance < floor_enemy_chance:
				floor_event_6 = 'E'
			else:
				floor_event_6 = 'R'
		if floor_chance_counter == 7:
			if floor_event_chance < floor_enemy_chance:
				floor_event_7 = 'E'
			else:
				floor_event_7 = 'R'
		if floor_chance_counter == 8:
			if floor_event_chance < floor_enemy_chance:
				floor_event_8 = 'E'
			else:
				floor_event_8 = 'R'
		if floor_chance_counter == 9:
			if floor_event_chance < floor_enemy_chance:
				floor_event_9 = 'E'
			else:
				floor_event_9 = 'R'
		if floor_chance_counter == 10:
			if floor_event_chance < floor_enemy_chance:
				floor_event_10 = 'E'
			else:
				floor_event_10 = 'R'
		if floor_chance_counter == 11:
			if floor_event_chance < floor_enemy_chance:
				floor_event_11 = 'E'
			else:
				floor_event_11 = 'R'
		if floor_chance_counter == 12:
			if floor_event_chance < floor_enemy_chance:
				floor_event_12 = 'E'
			else:
				floor_event_12 = 'R'
		if floor_chance_counter == 13:
			if floor_event_chance < floor_enemy_chance:
				floor_event_13 = 'E'
			else:
				floor_event_13 = 'R'
		if floor_chance_counter == 14:
			if floor_event_chance < floor_enemy_chance:
				floor_event_14 = 'E'
			else:
				floor_event_14 = 'R'
		if floor_chance_counter == 15:
			if floor_event_chance < floor_enemy_chance:
				floor_event_15 = 'E'
			else:
				floor_event_15 = 'R'
		if floor_chance_counter == 16:
			if floor_event_chance < floor_enemy_chance:
				floor_event_16 = 'E'
			else:
				floor_event_16 = 'R'
		if floor_chance_counter == 17:
			if floor_event_chance < floor_enemy_chance:
				floor_event_17 = 'E'
			else:
				floor_event_17 = 'R'
		if floor_chance_counter == 18:
			if floor_event_chance < floor_enemy_chance:
				floor_event_18 = 'E'
			else:
				floor_event_18 = 'R'
		if floor_chance_counter == 19:
			if floor_event_chance < floor_enemy_chance:
				floor_event_19 = 'E'
			else:
				floor_event_19 = 'R'
		if floor_chance_counter == 20:
			if floor_event_chance < floor_enemy_chance:
				floor_event_20 = 'E'
			else:
				floor_event_20 = 'R'
		if floor_chance_counter == 21:
			if floor_event_chance < floor_enemy_chance:
				floor_event_21 = 'E'
			else:
				floor_event_21 = 'R'
		if floor_chance_counter == 22:
			if floor_event_chance < floor_enemy_chance:
				floor_event_22 = 'E'
			else:
				floor_event_22 = 'R'
		if floor_chance_counter == 23:
			if floor_event_chance < floor_enemy_chance:
				floor_event_23 = 'E'
			else:
				floor_event_23 = 'R'
		if floor_chance_counter == 24:
			if floor_event_chance < floor_enemy_chance:
				floor_event_24 = 'E'
			else:
				floor_event_24 = 'R'
		if floor_chance_counter == 25:
			if floor_event_chance < floor_enemy_chance:
				floor_event_25 = 'E'
			else:
				floor_event_25 = 'R'
		if floor_chance_counter == 26:
			if floor_event_chance < floor_enemy_chance:
				floor_event_26 = 'E'
			else:
				floor_event_26 = 'R'
		if floor_chance_counter == 27:
			if floor_event_chance < floor_enemy_chance:
				floor_event_27 = 'E'
			else:
				floor_event_27 = 'R'
		if floor_chance_counter == 28:
			if floor_event_chance < floor_enemy_chance:
				floor_event_28 = 'E'
			else:
				floor_event_28 = 'R'
		floor_chance_counter += 1
		if floor_chance_counter == 30:
			floor_lock_generation = true
			floor_lineup_act_1 = 'RE'  + floor_event_2 + floor_event_3 + 'CR' + floor_event_4 + floor_event_5 + 'CLB-'
			floor_lineup_act_2 = 'CS' + floor_event_6 + floor_event_7 + floor_event_8 + 'LC' + floor_event_9 + floor_event_10 +'SL' +floor_event_11 + floor_event_12 + 'RCB-' 
			floor_lineup_act_3 = 'CR' + floor_event_13 + floor_event_14 + 'SL' +floor_event_15 + floor_event_16 + floor_event_17 + 'C' + floor_event_18 + 'L-'
			floor_lineup_act_4 = floor_event_19 + floor_event_20 + 'RCB-'
			floor_lineup_act_5 = 'CS' + floor_event_27 + floor_event_28 + floor_event_26 + 'CRL-'
			floor_lineup_act_6 = floor_event_1 + 'EC' + floor_event_21 + floor_event_22 + floor_event_23 + floor_event_24 +'CL' + floor_event_25 + 'RCLS-'
			floor_lineup_act_7 = 'CEELCEB'
			floor_lineup = str(floor_lineup_act_1)  +str(floor_lineup_act_2)  +str(floor_lineup_act_3)  +str(floor_lineup_act_4)  +str(floor_lineup_act_5)  + str(floor_lineup_act_6) + str(floor_lineup_act_7)
			#'RXXXCRXXCMB.CXXMCXSXMXXSCB.CRXSXXXCM.XRCB.CSXXXMCXXCB.CXXSMCMXXCB.CSEEMCEB'
			seed = floor_lineup + '.' + seed_chances
			print('Seed: ' + seed)

func enemy_and_event_selector():
	pass

var difficulty

func main_menu():
	pass


var achievement_following_footsteps = false
var achievement_timer_unlock = false
var achievement_rare_splash = false
func achievments():
	if userName == 'skye' and not achievement_following_footsteps:
		if int(achivment_timer.time_left) == 0:
			achievement_timer_unlock = true
		if achievement_timer_unlock and int(achivment_timer.time_left) == 1:
			achievement_timer_unlock = false
			rich_text_label.newline()
			rich_text_label.add_text("Achievement: Following her footsteps (You're not actually her though, are you?)")
			print("Achievement: Following her footsteps (You're not actually her though, are you?)")
			achievement_following_footsteps = true
	#print(userName + str(achivment_timer.time_left))
		

## Maybs ost names
# Defense Construct #4086FE12 - Main menu and boot intro
# Limited options - Event and reward music
# Warning: Exteral plating damaged - Comabt music
# ERROR: Out of memory! - Combat music
# Buy something! - Shop music
# It's Jerry! - All interactions with jerry except for jerry bossfight
# The core infector - The core infector bossfight
# The snail that started it all - Jerry bossfight
# Thank you for playtesting! - Credits

## Cult of Snal
# "Snal" gives order via 'The Blessed Parchment' a book in the center of the churchs main cathedrial which text is magically changed by "Snal"

## Act 1 Events
# 
## Act 1 Enemies
# Infected scientist (Small Health) (Attacks for 13 -> 50% - Applies 4 Critical and 6 shield -> Attacks for 8 and shields 4 OR 50% - Attacks for 8 and shields 4 -> Applies 4 Critical and 6 shield THEN -> Repeats T1 - T3
## Act 2 Events
# Jerry the slime! (rdm_a2_jerry) -> Free help!: Gain Jerry as an ally OR Free potion!: Obtain a random potion OR Free infuser!: Obtain a random infuser OR Fight: Fight Jerry
## Act 2 Enemies
# Jerry the slime (set_a2_jerry) (Lethal) -> 
## Act 3 Events
# Thieving gang -> Pay up: Lose gold: ((Current gold / 2) - 35 OR Bribe: Pay 150 - 200 gold, obtain a random proccessor OR Hire: Pay, 80 gold, Gain x1 thief as ally (Tanks 20 HP for you, deals small DMG each turn) (Can do multiple times)
# Inn -> Stay a night: Pay 50 gold, free safe haven OR Leave
# Heist -> Help thieves: Gain (80-120 gold), 30% of betral (lose 30 - 80 gold) OR Help nobleman: Gain (30 - 50 gold)
# Street robbery -> Intervene: Take (5-15) damage, obtain LVL 1 merchants favour OR Ignore: Leave, pay 10% more on all purchases in cybercity
## Act 3 Enemies
# 
## Act 4 Events
# Kitchen (Same as safe haven)
## Act 4 Enemies
# Palace guards (Two of them, medium health, if both are alive: 30% to apply small shield to both guards (if one is alive applies small-medium shield to itself (~60-80% TOTAL shield gained from both guards being alive), 50% chance to apply medium DMG, 20% to apply 2 stunned ONCE)
## Act 5 Events
# Find a damaged boss data chip in ground (Same as boss data chip but only three cards)
# Another Jerry the slime! (rdm_a5_jerry) -> Free help!: Gain Jerry as an ally OR Free processor!: Obtain a free processor OR Fight!: Fight this Jerry
# [Name TBD] -> Gain 300 gold, obtain a LVL 3 Curse of greed OR Lose 50 gold
## Act 5 Enemies
# Jerry the slime (set_a5_jerry) (Lethal) (A lot harder than set_a2_jerry) -> 
# Swarm of bats (Four of them, small health,=, 60% chance of small-medium DMG ATK, 40% chance of applying stunned ATK ONCE)
## Act 6 Events
# Starfield Industries construct repair shop (rdm_a6_repair) -> Purchase repairs: Pay 35 gold. heal to max health OR Purchase batteries: Pay 65 gold, Regenerate 30% of max battery charge OR Leave
# Phil & Co. processor shop (rdm_a6_processor) -> Regular processor: Pay 100 gold, obtain a random LVL 1 processor (you get to see option) OR Premium processor: Pay 120 gold, obtain a random LVL 2 processor (you get to see option) OR Ultra Deluxe processor: Pay 140 gold, obtain a random LVL 3 processor (you get to see option) OR Leave
# Phil & Co. Genreal shop (rdm_a1_genreal) -> Purchase data chip: Pay 30 gold, obtain a random data chip OR Purchase TWO! data chips: Pay 50 gold, obtain two random data chips OR Purchase Ultra Deluxe data chip bundle EX: Pay 60 gold, obtain a random data chip and a boss data chip OR Leg of Jerry: Pay 200 gold, obtain Leg of Jerry OR Leave
## Act 7 Enemies
# Infected bruiser + Infected sorcerer
# Infected sentry (Medium - High health), ATK for 20 -> ATK for 30 -> Give itself 5 damage up -> Repeat
# 
# Fungal construct (Lethal) (High Health) Gives itself 2 defense up -> Attacks for 3 five times -> Gives itself 2 damage up -> Repeat
# Spore spreader (Lethal) (Medium health) Summons spore striker and defender as allies -> Applies confused  and 2 injured -> Attacks for 10 three times -> Repeats T2 - T3
# Spore striker (Ally) (Medium health) (Is summoned -> Attacks for 25 -> Attacks for 10 twice -> Repeats T2 - T3)
# Spore defender (Ally) (Small health) (Is summoned -> Applies 30 shield to what summoned it -> Applies 20 shield to all allies but itslef -> Infects you with a Spore infection -> Repeats T2 - T4
# Infected Archmage (Lethal)
# Core Infector [STD] (Boss) (Very high health) (Infects you with a Spore infection  Applies 4 Stunned and 3 Injured to EVERYONE -> Attacks for 35 -> Attacks for 15 twice -> Summons a Infector bodyguard -> Applies a medium buff to all allies -> Attacks for 40 -> Attacks for 10 twice -> Repeats T5 - T7)
# Core Infector [DTH] (Boss) (Very high health) (Infects you with 2 Spore infections  Summons an Infector bodygaurd  Applies 4 Stunned and 3 Injured to EVERYONE -> Attacks for 40 -> Applies a medium buff to itself -> Attacks for 15 twice -> Applies 3 thorns to all allies -> Repeats T2 - T4)
# Infector bodyguard (Ally) (High health) (Is summoned -> Attacks for 20 -> Applies either 1 injured or 2 Damaged -> Attacks for 25 -> Applies 2 defense up to Core Infector -> Repeats T2 - T4)

## Debuffs
# Stunned (Attacks deal 25% less DMG, decreases by 1 each turn)
# Sightless (Attacks deal 40% less DMG, decreases by 1 each turn))
# Memory drain (Lose X max memory)
# Confusion (Skip to a random turn after each turn i.e: 3? -> 1?, turn letter resets to TA when debuff is lost)
# Damaged (Take X additional damage, decreases by 1 each turn)
# Electrocuted (Take X DMG at the end of each turn, allies with electrocuted gain X - 1 electrocuted at the start of each turn. Decreases by 1 each turn.)
# Injured (Take 40% more damage from attacks, decreases by 1 each turn)

## Buffs
# Genetic algorithm (Decrease X random debuffs by one each turn)
# Dodge (Negative damage from enemies 40% of the time, decreases by 1 each turn)
# Damage up (Deal X additional DMG)
# Defense up (Take X less DMG)
# Battery up (Recharge X more battery charges)
# Critical (Attacks have a (X times 10)% chance to deal double damage, decreases by 1 each turn)
# Spare battery charges (The next ATK you recive which decreases battery charges cannot decrease more than 1 battery charge)
# Thorns (Upon reciving damage deal X damage to what attacked you)

## Safe havens
# Option - Repair plating (Heal to max HP)
# Option - Forage for biofuel (Regenerate 40% of max battery charge)
# Option - Enhance programs (Enhance two programs (Special 1st upgrade, ever upgrade after increases stats by 40% of current stats, then 30%, then 20%, etc)
# Option - Downgrade & Upgrade - Remove one processor, upgrade one processor, enhance a program

## After each combat
# * Obtain gold: ((10 - 30) + Biome bonus) * Enemy type (Biome bonus = 0 -> 2 -> 4 -> 6, etc) (Enemy type: If Regular = 1, if event = 1.2, if mini = 1.6, if boss = 2.5 if biome > 4, if biome <3 = 2)
# ** Obtain data chip:
# ** If Regular = Obtain one out of four cards with 60% for LVL 1, 35% for LVL 2, 5% for LVL 3 and 90% chance for no enhancement and 10% for one)
# ** If Event = Obtain one out of three cards with 50% for LVL 1, 40% for LVL 2, 10% for LVL 3 and 85% chance for no enhancement and 15% for one)
# ** If Mini = Obtain one out of four cards with 40% for LVL 1, 30% for LVL 2, 30% for LVL 3 and 75% chance for no enhancement and 20% for one and 5% for two)
# ** If Boss = Obtain one out of four cards with 100% for LVL 3 and 50% for no enhancement, 25% for one, 20% for two and 5% for three 
# *** Chance for potion ((20% + (Chance for last potion * 0.7 )) + 100% if boss reward (yes this means that you can get two pots) (if you obtain a pot the chance goes back to 20%)
# **** Obtain a LVL 3 proccessor if boss, and LVL 1 processor if mini, (you can get LVL 2 from shops)

## Shop
# 4 random LVL 2 proccessors appear, each cost 140 - 180 gold
# 2 random [Physical] or [Standard] program, each cost 20 - 100 gold
# 2 random [Burst] or [Overlcoked] program, each cost 60 - 110 gold
# 2 random [Physical], [Burst], [Standard] or [Overlcoked] enhanced programs, each cost 30 - 150 gold
# 2 random potions, can purchase both for 40 - 60 gold
# 1 Mystery processor box, cannot see contents, contains 1 random LVL 2 processor and two random potions, costs 30 - 120 gold

## Processors
# If you already have a proccessor (Any LVL), you cannot see it again (You run out of processors instead you get a either a strength, health or charge booster (can have any number of them)
# ** Strength booster LVL <null> - (Attacks deal one additional damage)
# ** Health booster LVL <null> - (Gain +3 max health)
# ** Charge booster LVL <null> - (Gain +5 max battery charges)
# * Battle senses LVL 1 - (Events have a 20% chance to be replaced with a enemy comabt) -> LVL 2 (Enemy Combats have a 20% to be replaced with a Mini) -> LVL 3 (You can choose replace regular combats with a mini or a mini with a regular combat)  
# * Additional battery charges LVL 1 - (Gain 10 additional max battery charges) -> LVL 2 (Gain 20 additional max battery charges, lose 5 max health) -> LVL 3 (Gain 60 additional battery charges, lose 29 max health)
# * Merchants favour [Can only obtain from specific town village event] LVL 1 - (Recive a 25% discount on all purchases in the city) -> LVL 2 (Recive a 40% discount on all pruchases in the city) -> LVL 3 (Recive a 30% discount on all purchases)
# * Spiked plating LVL 1 (Gain 4 thorns at the start of each combat) -> LVL 2 (Gain 7 thorns at the start of each combat) -> LVL 3 (Gain 2 thorns at the start of each turn)
# * Water cooling LVL 1 (Negative temprature effects apply after an additional 30°) -> LVL 2 (Negative temprature effects apply after an additional 50°) -> LVL 3 (Negative temprature effects apply after an additional 100°)
# * Titanium pole LVL 1 (Whenever you recive damage take one less) -> LVL 2 (Whenever you recive damage take two less) -> LVL 3 (Whenever you recive damage only take 80% damage)
# * [Name TBD] LVL 1 (Whenever you lose health gain 5 battery charges) -> LVL 2 (Whenever you lose halth gain 10 battery charges) -> LVL 3 (Whenever you are below 10 battery charges gain 10 battery charges next turn)
# * Gold powered charges LVL 1 (Attacks deal 30% more damage, gain 20 less gold at the end of each combat) -> LVL 2 (Attacks deal 30% more damage, gain 10 less gold at the end of each combat) -> (Attacks deal 50% more damage, you can no longer gain gold)
# * [Name TBD] LVL 1 (Gain 20 additonal gold from events) -> LVL 2 (Gain 20 additional gold at the end of each combat) -> LVL 3 (Gain double gold at the end of each combat, purchases are 10% more expensive)
# * Curse of greed [Obtained from specific event] LVL 1 (Lose 10 gold each floor) -> LVL 2 (Lose 20 gold each floor) -> LVL 3 (Lose 40 gold each floor)
# * Bronze clock
#
# Data loss [Processor] Gain 1.5 additional max memory. At the start of each enemy encounter PERMANENTLY remove a program from your programs list
# Shield theif [Processor] Whenever an enemy gains shield steal 20% of it as battery charges. Lose 10 max health
# Wise financial decisions [Processor] If you do not purchase anything in a shop gain 80 gold. 
# Solar panels [Processor] Gain 1 additional max memory in encounters started during 06:00 to 20:00


## Program types
# * Malware - If not played at the end of each turn, recive a negative effect or debuff (Some powers give bonous for playing malware)
# * Virus - Applies a negative effect or debuff at the start of the next turn (Can be played for 0 memory and is unstable but when played appllies a debuff stronger than if left alone)
# ** Physical - Does not require memory use and (usally) doesn't last more than one turn (Literally a physical action i.e a punch)
# *** Burst - Kills itself at the start of next turn
# **** Standard - Uses at least 1 memory (Essintally StS power)
# ***** Overclocked - (Usally at least 1.5 memory) Kills itself after 2-3 turns, Are usally unstable, Usally also applies a small debuff

## Program ideas (Ensure that you add good Act 1 and Act 2 programs!)
# Evasive maneuvers [Physical] - Negative the next time you would take damage this turn / 1 Mem / Any
# Dodge and roll [Physical] - Deal 6 damage  Gain 1 Dodge / 0.5 Mem / All B
# Stomp [X] [Physical] Deal 8 [+4] damage / All B
# Scratch [X] [Physical] Deal 4 damage. Apply 1 [+1] injured / All D
# Crunch [X] [Physical] Deal 6 [+2] damage twice. Apply 1 stunned / All A
# [Burst]
# Infuser abuse [X] [Burst] Infuser effects are applied twice. [Can be infused X times]. Unstable / 1 Memory / All A
# Chaos! [2] [Burst] Gain confused and one additional turn before enemies attack. End your turn. Unstable / 1 [0] Memory / Any
# Time dilation [2] [Burst] Gain one additional turn before enemy attacks but do not gain energy back that turn. [~]Unstable[~] / 1 Memory / Any
# Heat rays [Burst] - Deal damage equal to core temprature divided by 10 / 1 Mem / All D
# Heat beam [Burst] - Deal 10 damage plus 1 for every 30° core temprature / 1 Mem / All A
# Inversment [Burst] - Gain 2 max memory ONLY next turn / 1 Mem / All C
# Loan [Burst] - Gain 2 max memory ONLY this turn  Lose 1 max memory ONLY next turn / 0 Mem / All C
# Malware launchers [Burst] - Deal 8 damage  Damage increases by 6 for every malware program in your hand / 0.5 Mem / Any
# [Standard]
# Memory rush [Standard] Malware programs cost 0 memory / 0.5 Mem / Any
# Energy conversion [Standard] Gain battery charges equal to core temprature divded by 15 / 0.5 Mem / All A
# Heatsinks [Standard] Lose 20° core temprature / 1 Mem / All C
# Malware protection [Standard] For every malware program in your hand gain a random buff / 1 Mem / All B
# [Overclocked]
# Reboot [X] [Overclocked] You cannot play programs. Gain 99 shield. Kills itself after 1 [X] turn[s] / 0 Memory / All D
# Data catalyst [Overclocked] All programs cost 0 memory  Gain confused  Kills itself after 3 turns / 3 Mem / Any
# Missile launcher [Overclocked] Deal 15 damage to all enemies  Kills itself after 3 turns / 1.5 Mem / Any
# Self destruct [Overlclocked] When this program is killed Take 99 damage then Deal damage equal to battery charges lost  Kills itself after 2 turns / 1.5 Mem / All D
# Antivirus [Overclocked] Virus programs cannot apply debuffs  Kills itslef after 2 turns / 2 Mem / ALL
# [Malware]
# Hello! [Malware] Add a Hello! to your program list for the rest of this encounter / 0 Memory / Any
# Headache [Malware] Gain 2 stunned / All D
# Blindness [Malware] Gain 2 Sightless / All A
# [Virus]
# Memory drain [Virus] Lose one max memory ONLY this turn / Lose two max memory ONLY this turn. Unstable / Any
# Spore infection [Virus] Lose one health / Heal 5. Add a spore infection to your program list this combat / Any
# Sticky [Virus] Apply 1 stunned / Apply 2 stunned. Unstable / Any


## Starter programs
# * Punch [X] [Physical] - Deal 8 [+3] damage / Any
# * Punch [X] [Physical] - Deal 8 [+3] damage / Any
# * Punch [X] [Physical] - Deal 8 [+3] damage / Any
# ** Recharge [X] [Burst] Recharge 5 [+4] battery charges / 0.5 Mem / Any
# ** Recharge [X] [Burst] Recharge 5 [+4] battery charges / 0.5 Mem / Any
# *** Heatsinks [X] [Standard] Lose 15° [+10] core temprature / 1 Mem / All C
# *** Deflector shields [2] [Overclocked] - Gain 5 [+2] battery charges and 5 [+1]°. Kills itself after 3 turns / 2 Mem / All B
# **** Suprsie! [Malware] - Apply a random debuff to everyone / Apply two random debuffs to everyone / 1 Mem / Any
# ***** Eye beams [X] [Burst] - Deal 12 damage to a random enemy then give 2 damaged and 1 [+1] injured / 1 Mem / All C

## Infuser ideas
# Data gain [Infuser] Add a random 0 memory program to your programs list for the rest of this encounter. Program gains unstable
# Vampire [Infuser] Heal health equal to half the damage dealt to this enemy
# Surprise? [Infuser] Add a random Malware program to your hand next turn. It costs zero memory. 
# Heat gain [Infuser] Gain 8 degrees
# Heat loss [Infuser] Lose 8 degrees


## Core temprature
# Resets to 80° at the start of each encounter
# Increases by 5° for every 1 Memory used at the end of each turn
# If is <160 you lose 3 health at the start of each turn
# If is <180 you lose 10 health at the start of each turn

## Turns
# 1A -> 1B -> 1C -> 1D -> 2A -> 2B -> etc
# If a program has Any, it has a 30% chance to appear at the top of your hand each turn
# If a program has All C it appears at the middle of your hand every C turn i.e 1C, 2C, etc
# If a program has ALL it appears at the bottom of you hand every turn
# Viruses always appear at the top of your hand every turn

## Health
# Enemy attacks and programs cannot cause you to run out of battery charges and lose health in one turn
# Enemy attacks and programs cannot causes you to lose more than 25 health in one turn
# Enemies lose shield after two turns

## Difficulties
# Standard [STD]
# Threatening [THR]
# Hazardous [HAZ]
# Lethal [LHL]
# Death [DTH]
# * Modifers:
# STD: 
# THR:
# Infected enemies appear 15% more often
# Enemies have 20% more health
# Lethal enemies attack for 10% more damage
# HAZ:
# Infected enemies appear 20% more often
# Enemies have 20% more health
# Lethal enemies attack for 20% more damage
# LHL:
# Infected enemies appear 25% more often
# Enemies have 20% more health
# Lethal enemies attack for 20% more damage
# Lethal enemies have 10% more health
# Gain 20% less gold from defeating enemies
# DTH:
# Infected enemies appear 30% more often
# Enemies have 20% more health
# Lethal enemies attack for 20% more damage
# Lethal enemies have 10% more health
# Gain 30% less gold from defeating enemies
# Start each run with Deadly Spores
# The Core Infector has new attacks
# Gain the intrest of a god

## Potions
# Potion of self revival [Potion] When drunk if you would die in the next 2 turns revive yourself with 30 battery charges
# Potion of rememberance [Potion] Play the next program twice.
# "A mystical potion said to enhance the drinkers rememberance."
# Potion of memory [Potion] Gain 1.5 additional mx memory this encounter
# "A mystical potion said to enhance the memeory of machines."
# Potion of strength [Potion] Gain 3 damange up
# "A mystical potion said to enhance the drinkers physical abilities."
# Potion of health [Potion] Gain 20 additional max health this encounter
# "A mystical potion said to enhance the drinkers healthiness."
# Potion of revival [Potion] The next time an ally dies revive them to max health and remove this potion
# "A mystical potion said to revive drinkers from the dead."
# Potion of life [Potion] Gain 10 additional max health and heal to max health
# "A mystical potion said to blessed by Snal themself."
# Potion of defence [Potion] Gain 3 defence up.
# "A mystical potion said to enhacne the drinkers defensive abilities."
# Potion of death [Potion] [STD] Gain 5 critical and 3 damage up
# "A mystical potion said to transform the drinker into death itself."
# Potion of death [Potion] [DTH] Die
# "Try drinking this now."
# Strange juices [Potion] Gain 2 random buffs
# "A mystical potion said to do something or rather."
# Vile juices [Potion] Apply 2 random debuffs to an enemy
# "A mystical potion said to infict pain on those who touch it."
# Molotov cocktail [Potion] Deal 25 damage to an enemy
# "A mystical potion said to be used to firebomb peoples houses."
# Phil & Co Trademark Brew [Potion] Gain 5 damage up and a random buff
# "A mysstical potion said to be a free gift for staying at any Phil & Co Inn."

## Achievements
# Hackerman (Enter a command in the debug console)
# Hey! I saw that! (Enable achievements in the debug console after they were disabled due to cheat commands)
# It's speedrunning time (Beat the game in under 30 minutes)
# Victory? (Die before the core infectors first attack)
# Victory! (Defeat the core infector)
# The snail who created it all (Confront Snal)
# Ascension (Make the world anew)
# These don't carry over you know (Beat the game with at least 100 spare gold and all potions slots filled)
# Collector (Draw a full hand of infused programs)
# Threatening (Beat the game on threateing difficulty) 
# Hazardous (Beat the game on hazardous difficulty) 
# Lethal (Beat the game on lethal difficulty) 
# Death (Beat the game on death difficulty) 
# Gotta go fast (Beat the game before day 5)
# Taking your time (Reach day 10)

## After core infector
# After defeating the core infector cutscence plays out where snal appears in a blinding flash and goes like
# "Hello [user_name]... I am Snal"
# "You might know me as that god that The cult of Snal worships"
# "You probally thought that I didn't exist like most people who come from the city do..."
# "You know I actually helped create that place'
# "It's why it's so developed compared to the surface of Alymeria"
# "You know I probally shouldn't have kept the two populations seperated for as long as I did..."
# "Uniting the two of them 30 years ago was one of the best descions that I made"
# "Anyways... the reason for my intervention"
# "The world... all of Alymeria"
# "Is saved all because of you"
# "And I'm not talking about this machine that your using"
# "I see you down there back in the facility where all this began"
# "Holled up in the freezer room... controlling this machine with a [IRL machine name]"
# "Tell me what you wish for and it will be yours"
# Then there are options like
# Riches (Start your next run with 150 gold)
# Immortality (Start your next run with + 10 max health
# Love (Start your next run with Jerry the Slime as an ally)
# [OPTION LOCKED] Requires all four Jerry parts (X/4) # X = number on you
# If you have 5 head of jerry [OPTION LOCKED] is replaced with:
# The death of all Jerrys (Present Corpse of Jerry)
#  If you choose The death of all Jerrys snal goes
# "Noooo!"
# "Jerry!"
# "WHY WOULD YOU DO THIS TO A JERRY"
# "Wait... this isn't even the body of a Jerry..."
# "WHY WOULD YOU KILL FOUR DIFFERNT JERRYS THEN STICH THEIR BODY PARTS TOGETHER!"
# "IS THIS SUPPOSED TO BE SOME KIND OF SICK JOKE!?"
# "THATS IT!"
# "YOU CHOSE THIS PATH"
# Then the dialogue box goes:
# Snal attacks for 56^108 damage! [Snal bossfight starts]

## Corpse of Jerry
# If you have Head, Arm, Leg and Heart of Jerry they combine into Corpse of Jerry
# Jerry part descriptions
# Head of Jerry - Why would you hurt Jerry...
# Arm of Jerry - At least Jerry tried...
# Leg of Jerry - Why are they even selling this...
# Heart of Jerry - Jerry just wanted to help...
# Corpse of Jerry - You monster...
# If a Jerry ally dies get Arm of Jerry
# If you defeat a Jerry get Head of Jerry
# If you don't have Leg of Jerry encounter rdm_a6_genreal on the last event floor of act 6
# If you didn't encounter rdm_a2_jerry encounter it on the last event floor of act 2
# If you didn't encounter rdm_a5_jerry encounter it on the last event floor of act 5
# In metro sequence there is a jerry on the train which says that it will help you in the fight, if jerry dies in the fight you get Heart of Jerry

## Snal bossfight
# Health - 800
# Starting buffs:
# Power of life (Whenever you play a program heals 3 health)
# Power of creation (Whenever you heal, heals double the amount)
# Power of destruction (At the end of every turn all enemies lose 3 health)
# Turns:
# Attacks for 56^108 damage
# Temprature shock (Increases core temprature by 40°)
# Slimy strike (Attacks for 30 damage twice. Adds a Sticky to your draw pile)
