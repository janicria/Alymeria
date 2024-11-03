extends Core

var shop: Shop


func added() -> void:
	Events.shop_entered.connect(shop_entered)
	Events.shop_exited.connect(shop_exited)


func shop_entered() -> void:
	if coreui == null or !coreui.playable: return
	shop = Data.shop
	Data.multipliers["SHOP_COST"] -= 0.3 if coreui.slotted else 0.2
	shop.reload_costs()
	shop.items["resurrection"] = Data.get_core_from_rarity(Core.Rarity.RARE)
	coreui.playable = false


func shop_exited() -> void:
	Data.multipliers["SHOP_COST"] += 0.3 if coreui.slotted else 0.2
