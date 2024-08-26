extends Control
@onready var inventory = $/root/Node2D/background_images/InventoryGui
@onready var dark_tint = $"Dark Tint"
var is_paused:bool = false
var output = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#inventory.open()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_mode = Node.PROCESS_MODE_ALWAYS
	if Input.is_action_just_pressed("pause_menu"):
		dark_tint.show()
		get_tree().paused = not get_tree().paused
		if is_paused:
			is_paused = false
			dark_tint.hide()
		else:
			is_paused = true

#		var hyfetch = OS.execute("hyfetch", ["--distro", "arch"], output) ; print(output)




	if Input.is_action_just_pressed("d_pressed"):
		if inventory.isOpen:
			inventory.close()
		elif !inventory.isOpen:
			inventory.open()
