class_name RewardButton extends Button

const COST_OFFSET := 45

@onready var custom_icon: TextureRect = %CustomIcon
@onready var custom_label: Label = %CustomLabel
@onready var cost_hbox: HBoxContainer = %CostHbox
@onready var cost_amount: Label = %CostAmount

var item_cost: int

func set_items(texture: Texture2D, reward_text: String, cost := 0) -> void:
	if !is_node_ready(): await ready

	custom_icon.texture = texture
	custom_label.text = reward_text
	cost_amount.text = str(cost)
	cost_hbox.visible = cost
	item_cost = cost
	cost_hbox.global_position.x = (
		Data.treasure.rewards_box.global_position.x
		+ Data.treasure.rewards_box.size.x * 2
		- COST_OFFSET)
	

func _on_pressed() -> void:
	Data.gold -= item_cost
	queue_free()
