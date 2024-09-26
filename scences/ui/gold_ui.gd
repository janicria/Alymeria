class_name GoldUI
extends HBoxContainer

@onready var label: Label = $Label


func _ready() -> void:
	if !GameManager.gold_changed.is_connected(_update_gold):
		GameManager.gold_changed.connect(_update_gold)
		_update_gold()


func _update_gold() -> void:
	label.text = str(GameManager.gold)
