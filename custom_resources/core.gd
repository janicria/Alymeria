class_name Core extends Resource

enum Type {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, RIGHT_CLICK, EVENT}
enum Rarity {COMMON, UNCOMMON, RARE, SPECIAL}
enum Pool {GLOBAL, SPECIAL, MACHINE}

@export var core_name: String
@export var icon: Texture
@export var type: Type
@export var rarity: Rarity
@export var pool: Pool
@export_multiline var slotted_tooltip: String
@export_multiline var dump_tooltip: String
@export_multiline var flavour_text: String = "Very flavoury text here"

var coreui: CoreUI


func to_bestiary() -> Array:
	return [core_name, icon, "%s\n\n%s" % [slotted_tooltip, dump_tooltip], flavour_text]


func activate() -> void:
	pass


func added() -> void:
	pass


func removed() -> void:
	pass
