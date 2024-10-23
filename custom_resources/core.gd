class_name Core
extends Resource

enum Type {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, RIGHT_CLICK, EVENT}
enum Rarity {COMMON, UNCOMMON, RARE, SPECIAL}

@export var core_name: String
@export var icon: Texture
@export var type: Type
@export var rarity: Rarity
@export_multiline var slotted_tooltip: String
@export_multiline var dump_tooltip: String
@export_multiline var flavour_text: String = "Very flavoury text here"
