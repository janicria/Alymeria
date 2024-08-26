extends Timer
@onready var rich_text_label = %outerBox
@onready var timer_2_5s = %Timer2_5s
@onready var bottom_l_text_box_3 = %BottomLTextBox3
@onready var bottom_l_text_box_2 = %BottomLTextBox2
@onready var health_stats_box = %health_stats_box
@onready var test = $"../../Camera2D"
@onready var misc_stats_box = %misc_stats_box
@onready var deck_box = %deck_box
@onready var menu_box = %menu_box
@onready var hovering_selector_1 = $"../../../Hovering Selector/hovering_selector_1"
@onready var hovering_selector_2 = $"../../../Hovering Selector/hovering_selector_2"
@onready var hovering_selector_3 = $"../../../Hovering Selector/hovering_selector_3"
@onready var hovering_selector_4 = $"../../../Hovering Selector/hovering_selector_4"
@onready var hovering_selector_5 = $"../../../Hovering Selector/hovering_selector_5"
@onready var menu_box_deck = %menu_box_deck
@onready var menu_box_settings = %menu_box_settings
@onready var power_box = %power_box
@onready var hovering_selector_6 = $"../../../Hovering Selector/hovering_selector_6"
@onready var timer_with_script = %timer_with_script

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
const maxHp = 30
var hp:float = maxHp
const maxBattery:float = 60
var battery:int = 36
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
var thingy = false
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
var number_generator
var number_granter
var device_name = ''

func _process(delta):
	formulas()
	startBootFunc()
	mouseScrolling()
	stats_boxes()
	stats_boxes()
	if game_start_enabler:
		PrimaryControl.game_start_enabler = true
		achievments()
	

	if not hovering_selector_hider:
		hovering_selector_1.hide()
		hovering_selector_2.hide()
		hovering_selector_3.hide()
		hovering_selector_4.hide()
		#hovering_selector_5.hide()
		hovering_selector_6.hide()
		hovering_selector_hider = true
		menu_box_deck.hide()
		menu_box_settings.hide()
		menu_box.hide()
		power_box.hide()

	if PrimaryControl.can_start_boot_func_overwrite == 100:
		canStartBootFunc = true


func mouseScrolling():
	currentLine = rich_text_label.get_line_count()
	rich_text_label.mouse_force_pass_scroll_events = true
	if Input.is_action_just_pressed("scroll_up") and currentLine > 14:
		rich_text_label.scroll_to_line(currentUpScroll -1)
		currentUpScroll -=1
	

	if Input.is_action_just_pressed("scroll_down") and currentLine > 14:

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
	if int(time_left) == 1 and not lockPowerOnMsg and canStartBootFunc:
		lockPowerOnMsg = true
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randi_range(0, 999)
		device_name = 'Defense Construct #' + str(number_granter)
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randi_range(0, 99)
		device_name = str(device_name) + str(number_granter)
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randi_range(0, 99)
		device_name = str(device_name) +'FE' + str(number_granter)
		#randomize()
		rich_text_label.newline()
		rich_text_label.add_text('Connection established with ' + str(device_name))
		thingy = true
	if int(time_left) == 0 and lockPowerOnMsg and canStartBootFunc and not waitForPowerOnMsg and thingy:
		waitForPowerOnMsg = true
		rich_text_label.newline()
		rich_text_label.add_text('Continue with power on?')
	if int(time_left) == 0 and not lockYNMsg and canStartBootFunc and waitForPowerOnMsg:
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
	if lockDot2Helper and int(time_left) == 0:
		lockDot2 = false
	if not lockDot2 and int(time_left) == 1:
		timeElapsed +=1
		lockDot2 = true
		if lockDot2HelperHelperHelper and timeElapsed < 5:
			rich_text_label.add_text('.')
		if lockDot2HelperHelper:
			lockDot2Helper = true
	if int(time_left) == 0 and not lockDot:
			lockDot = true
			if not timeElapsed > 2 and not lockSystemOnlineMsg:
				rich_text_label.add_text(".")
			timeElapsed += 1
	if int(time_left) == 1:
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
			wait_time = 1.5
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
		#if int(time_left) == 0:
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
				#rich_text_label.newline()
				rich_text_label.add_text('ERROR: Username must contain at least one character')
				rich_text_label.newline()
				rich_text_label.add_text('Please enter name for new user:')
				rich_text_label.newline()
				number_of_failed_name_msgs +=1
	if welcomeUSERMsg:
		if int(time_left) == 0:
			welcomeUSERMsgHelper = true
		if welcomeUSERMsgHelper and int(time_left) == 1:
			rich_text_label.newline()
			rich_text_label.add_text(str('Welcome user ') + userName + str('!'))
			welcomeUSERMsg = false
			welcomeUSERMsgHelper = false
			driverLoad = true
	if driverLoad:

		if int(time_left) == 0 and not driverLoadHelperTheThird:
			rich_text_label.newline()
			rich_text_label.add_text('Loading drivers')
			driverLoadHelper = true
			driverLoadHelperTheThird = true
		if driverLoadHelper:
			if int(time_left) == 0 and driverLoadHelperTheSecond < 4 and not driverLoadHelperTheFourth:
				rich_text_label.add_text('')
				driverLoadHelperTheSecond += 1
				driverLoadHelperTheFourth = true
				driverLoadHelperTheSixth = true
			if int(time_left) == 1 and driverLoadHelperTheSecond < 4 and not driverLoadHelperTheFifth:
				rich_text_label.add_text('.')
				driverLoadHelperTheSecond += 1
				driverLoadHelperTheFifth = true
			if driverLoadHelperTheSixth and int(time_left) == 0:
				rich_text_label.add_text('.')
				driverLoadHelperTheSecond += 1
				driverLoadHelperTheSixth = false
			if driverLoadHelperTheSecond > 2:
				if int(time_left) == 1:
					rich_text_label.add_text('.')
					rich_text_label.newline()
					rich_text_label.add_text('All drivers operational!')
					OSload = true
					driverLoad = false
			#		endOfPlaytest()
	if OSload:
		if int(time_left) == 1:
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
	if int(time_left) == 0 and not shutdownWait:
		shutdownWait = true
		runSpace1 = true
	if int(time_left) == 2 and runSpace1 and shutDownNumberLock <1:
		#rich_text_label.newline()
		rich_text_label.add_text('.')
		shutDownNumberLock +=1
		runSpace2 = true
	if int(time_left) == 1 and runSpace2 and shutDownNumberLock <2:
		#rich_text_label.newline()
		rich_text_label.add_text('.')
		runTime1 = true
		shutDownNumberLock +=1
	if int(time_left) == 0 and runTime1 and shutDownNumberLock <3:
		#rich_text_label.newline()
		rich_text_label.add_text('.')
		runTime2 = true
		shutDownNumberLock +=1
	if int(time_left) == 1 and runTime2:
		get_tree().quit()
func endOfPlaytest():
	if endOfPlaytestHelper:

		rich_text_label.newline()
		rich_text_label.add_text('#########################')
		rich_text_label.newline()
		rich_text_label.add_text('#    END OF PLAYTEST    #')
		rich_text_label.newline()
		rich_text_label.add_text(str('#  Version ') + versionNumber + str('  #'))
		rich_text_label.newline()
		rich_text_label.add_text('#########################')
		endOfPlaytestHelper = false
func loadDots():
	if int(time_left) == 0 and not NOTloadDots1:
				rich_text_label.add_text('.')
				NOTloadDots1 = true
				loadedDotsCounter += 1
				NOTloadDots2 = false
	if int(time_left) == 1 and not NOTloadDots2:
				rich_text_label.add_text('.')
				NOTloadDots2 = true
				loadedDotsCounter += 1
				NOTloadDots3 = false
	if int(time_left) == 0 and not NOTloadDots3:
				rich_text_label.add_text('.')
				NOTloadDots3 = true
				loadedDotsCounter += 1
	if int(time_left) == 1 and loadedDotsCounter > 3 and lockaddDot:
		lockaddDot = false
	if int(time_left) == 0 and loadedDotsCounter > 3 and not lockaddDot:
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
	if addDotCounter == 2 and int(time_left):
		rich_text_label.add_text('.')
		addDotCounter += 1
	if addDotCounter == 3 and not lockCFCCFEPOprotocolMsgs:
		rich_text_label.newline()
		rich_text_label.add_text('Unable to connect to central facility computer.')
		addDotCounter += 1
	if addDotCounter == 4 and int(time_left) == 0 and not lockCFCCFEPOprotocolMsgs:
		addDotCounter += 1
		rich_text_label.newline()
		rich_text_label.add_text('Initiating central facility computer connection failure emergency power on protocol. Continuing to final stage of system wakeup')
		finalPowerOnMsg = true
	if finalPowerOnMsg and int(time_left) == 1 and not lockCFCCFEPOprotocolMsgs:
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
	if addDotCounter == 4 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		rich_text_label.newline()
		rich_text_label.add_text('Loading sensors')
		addDotCounter +=1
	if addDotCounter == 5 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		rich_text_label.newline()
		rich_text_label.add_text('All sensors online')
		addDotCounter +=1
		game_start_enabler = true
	if addDotCounter == 6 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		rich_text_label.newline()
		rich_text_label.add_text('Finalising final stages of wakeup sequence')
		addDotCounter +=1
	if addDotCounter == 7 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1 and not lock:
		addDotCounter = 11
	if addDotCounter == 11 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0 and not lock:
		addDotCounter = 7
		lock = true
	if addDotCounter == 7 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		rich_text_label.add_text('.')
		addDotCounter +=1
	if addDotCounter == 8 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		rich_text_label.add_text('.')
		addDotCounter +=1
	if addDotCounter == 9 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		rich_text_label.add_text('.')
		addDotCounter +=1
	if addDotCounter == 10 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		addDotCounter +=1
	if addDotCounter == 11 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		addDotCounter +=1
		rich_text_label.newline()
		rich_text_label.add_text('Wakeup complete')
	if addDotCounter == 12 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		addDotCounter +=1
	if addDotCounter == 13 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		rich_text_label.newline()
		rich_text_label.newline()
		rich_text_label.newline()
		addDotCounter += 1
	if addDotCounter == 14 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		addDotCounter += 1
	if addDotCounter == 15 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		addDotCounter += 1
	if addDotCounter == 16 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		addDotCounter +=1
	if addDotCounter == 17 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
		addDotCounter += 1
		endOfPlaytest()
	if addDotCounter == 18 and lockCFCCFEPOprotocolMsgs and int(time_left) == 0:
		addDotCounter += 1
	if addDotCounter == 19 and lockCFCCFEPOprotocolMsgs and int(time_left) == 1:
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
		loadingTimerVar = timer_2_5s.time_left + 0.95
		PrimaryControl.userName = userName
		if time_minutes > 59:
			time_minutes = 0
			time_hours +=1
		if time_hours > 23:
			time_hours = 0
			days +=1

var achievement_following_footsteps = false
func achievments():
	#if userName ==  'skye' and not achievement_following_footsteps:
	#	rich_text_label.newline()
	#	rich_text_label.add_text("Achievement: Following her footsteps (You're not actually her though, are you?)")
	#	achievement_following_footsteps = true
	pass
