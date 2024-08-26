extends CanvasLayer

var combat_checker = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if combat_checker:
		combat()


func combat():
	combat_checker = ''
	get_parent().get_child(1).get_child(15).queue_free()
	get_parent().get_child(1).queue_free()
	get_parent().show()

