class_name RunStartup
extends Resource

enum Type {NEW_RUN, CONTINUED_RUN}
enum Difficulity {STANDARD, THREATENING, HAZARDOUS, LETHAL, DEATH}

@export var type: Type
@export var difficulty: Difficulity
@export var picked_character: CharacterStats
