class_name RewardButton
extends Button

@export var reward_icon: Texture : set = set_reward_icon
@export var reward_text: String : set = set_reward_text

@onready var custom_icon: TextureRect = %CustomIcon
@onready var custom_label: Label = %CustomLabel


func set_reward_icon(new_icon : Texture) -> void:
	reward_icon = new_icon
	
	if !is_node_ready():
		await ready
	
	custom_icon.texture = reward_icon


func set_reward_text(new_text : String) -> void:
	reward_text = new_text
	
	if !is_node_ready():
		await ready
	
	custom_label.text = reward_text


func _on_pressed() -> void:
	queue_free()
