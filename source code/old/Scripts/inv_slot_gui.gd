extends Panel

@onready var backgroundSprite : Sprite2D = $Sprite2D
@onready var itemSprite : Sprite2D = $CenterContainer/Panel/item

func update(item : InventoryItem):
	if !item:
		itemSprite.visible = false
	elif item:
		itemSprite.visible = true
		itemSprite.texture = item.texture
