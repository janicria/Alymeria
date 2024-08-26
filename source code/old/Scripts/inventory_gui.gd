extends Control

@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

var isOpen = false

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func _ready():
	update()

func open():
	visible = true
	isOpen = true


func close():
	isOpen = false
	visible = false

