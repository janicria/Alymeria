class_name SummonStats extends Stats


@export var name: String
@export_multiline var description: String
@export_multiline var flavour_text: String = "todo me :3"
@export var green_action: SummonAction
@export var red_action: SummonAction
@export var purple_action: SummonAction
@export var finisher: SummonAction

var summon: Summon
var used_actions: Array[SummonAction]


func setup(summon: Summon) -> void:
	self.summon = summon # <- Ewwww starts
	green_action.stats = self
	red_action.stats = self
	purple_action.stats = self
	finisher.stats = self
	green_action.setup()
	red_action.setup()
	purple_action.setup()
	finisher.setup() # <- Ewwww finishes


# Godot's array's kinda suck
func action_played(action: SummonAction) -> void:
	if !action in used_actions:
		used_actions.append(action)
		update_light_texture(action, action.active_image)
	
	# If all three primary actions have been used
	if used_actions.size() == 3:
		for i in used_actions:
			update_light_texture(i, action.inactive_image)
		used_actions.clear()
		finisher.play()


func update_light_texture(action: SummonAction, image: Texture2D) -> void:
	(summon.get_node("%sLight" % SummonAction.Type.keys()[action.type]
	.to_pascal_case()).call("set_texture", image)) # Yikes


func take_damage(damage: int, status: Status = null) -> bool:
	var initial_health := health
	var result := super.take_damage(damage)
	if initial_health > health:
		if status != null:
			var status_effect := StatusEffect.new()
			status_effect.status = status
			status_effect.execute([summon])
	return result
