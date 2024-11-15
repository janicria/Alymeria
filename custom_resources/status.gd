class_name Status extends Resource

signal status_applied(status: Status)
signal status_changed

enum Type {START_OF_TURN, END_OF_TURN, EVENT}
enum StackType {NONE, INTENSITY, DURATION}

@export var id: String
@export var type: Type
@export var stack_type: StackType
@export var buff: bool
@export var format_tooltip: bool
@export var duration: int : set = set_duration
@export var stacks: int : set = set_stacks
@export var icon: Texture


func initalise_target(_target: Node) -> void:
	pass


func apply_status(_target: Node) -> void:
	status_applied.emit(self)


func get_tooltip() -> String:
	if format_tooltip:
		return str(Data.StatusDescriptions.get(id)) % stacks
	return Data.StatusDescriptions.get(id) 


func set_duration(new_duration: int) -> void:
	duration = new_duration
	status_changed.emit()


func set_stacks(new_stacks: int) -> void:
	stacks = new_stacks
	status_changed.emit()
