class_name Shop extends Control

const CURSOR = preload("res://assets/misc/cursor.png")
const BUBBLE_CURSOR = preload("res://assets/misc/bubble_cursor.png")

@onready var service_amount: Label = %ServiceAmount
@onready var resurrection_amount: Label = %ResurrectionAmount
@onready var refine_enhance_amount: Label = %RefineEnhanceAmount
@onready var special_offer_amount: Label = %SpecialOfferAmount
@onready var potions_bundle_1_amount: Label = %PotionBundle1Amount
@onready var potions_bundle_2_amount: Label = %PotionBundle2Amount
@onready var resurrection_icon: TextureRect = %ResurrectionIcon
@onready var merchant_animation: AnimationPlayer = %MerchantAnimation
@onready var blink_timer: Timer = %BlinkTimer

var costs := {
	"service": 40,
	"resurrection": randi_range(110, 140),
	"refine_enhance": randi_range(60, 90),
	"potions_bundle_1": randi_range(30, 60),
	"potions_bundle_2": randi_range(30, 60),
	"special_offer": randi_range(90, 120),
}
var items := {
	"resurrection": Data.removed_cores.pick_random() if !Data.removed_cores.is_empty() else Data.get_core_from_weight()
}


func _ready() -> void:
	# Setup
	reload_costs()
	Data.shop = self
	Events.shop_entered.emit()
	start_blink()
	blink_timer.timeout.connect(blink_timer_finished)
	
	# Core bestiary
	resurrection_icon.texture = items["resurrection"].icon
	resurrection_icon.mouse_entered.connect(func()->void:
		Input.set_custom_mouse_cursor(BUBBLE_CURSOR))
	resurrection_icon.mouse_exited.connect(func()->void:
		Input.set_custom_mouse_cursor(CURSOR))
	resurrection_icon.gui_input.connect(func(input:InputEvent)->void:
		if input.is_action_pressed("left_mouse"):
			Data.main.bestiary.show_core(items["resurrection"], true))


func reload_costs() -> void:
	# Cost
	for cost: String in costs:
		costs[cost] = ceili(costs[cost] * Data.multipliers["SHOP_COST"])
	
	# Coloring
	var index := 0
	for cost: int in costs.values():
		get(costs.keys()[index] + "_amount").modulate = Color.ORANGE_RED if cost > Data.gold else Color.WHITE
		index += 1
	
	# Text amounts
	service_amount.text = str(costs.get("service"))
	resurrection_amount.text = str(costs.get("resurrection"))
	refine_enhance_amount.text = str(costs.get("refine_enhance"))
	potions_bundle_1_amount.text = str(costs.get("potions_bundle_1"))
	potions_bundle_2_amount.text = str(costs.get("potions_bundle_2"))
	special_offer_amount.text = str(costs.get("special_offer"))


func start_blink() -> void:
	blink_timer.wait_time = randf_range(2.0, 8.0)
	blink_timer.start()


func blink_timer_finished() -> void:
	merchant_animation.play("blink")
	start_blink()


func item_clicked(input: InputEvent, item: String) -> void:
	if (item == "Resurrection" 
	&& input.is_action_released("right_mouse") 
	&& get_node(item).modulate != Color.WHITE.darkened(0.3)):
		if can_afford_item(item):
			Data.main.core_handler.add_core(items["resurrection"])
			Data.removed_cores.erase(items["resurrection"])
			purchase_item(item)
			return
	
	if input.is_action_released("left_mouse"):
		if get_node(item).modulate == Color.WHITE.darkened(0.3) || item == "Resurrection": 
			return
		if !can_afford_item(item): return
	else: return
	
	purchase_item(item)
	match item:
		"Service": 
			Data.character.heal(ceili(Data.character.max_health * 0.4))
			costs["service"] += 20
			service_amount.text = str(costs.get("service"))


func can_afford_item(item: String) -> bool:
	if Data.gold >= costs.get(item.to_snake_case()):
		return true
	OS.alert("You need %s more gold!" % (costs.get(item.to_snake_case()) - Data.gold))
	return false


func purchase_item(item: String) -> void:
	get_node(item).modulate = Color.WHITE.darkened(0.3)
	get_node(item).get_child(-1).show()
	get(item.to_snake_case() + "_amount").hide()
	Data.gold -= costs.get(item.to_snake_case())


func _on_begone_button_pressed() -> void:
	Events.shop_exited.emit()
