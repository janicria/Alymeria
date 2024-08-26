extends Node

class_name ERRORS
var ErrorPointer_Temp

# DATA [Type, Amount, Cause]
# DATA[Type] [0=Warning, 1=Error, 2=Critical]
# If Warning: Nothing
# If Error: Save then crash
# If Critcal: Crash

enum {ERROR_MISSING_CARD_TEXTURE}

static var DATA = {
	ERROR_MISSING_CARD_TEXTURE :
		[0, 0, null]
}

var DATA_LastFrame
var MISSING_CARD_TEXTURE_LastFrame
var ErrorMessage_UnlockFirstMsg = ''
