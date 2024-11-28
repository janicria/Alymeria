class_name Stats extends Resource

signal stats_changed

@export var max_health := 1 : set = set_max_health
@export var art : Texture

var health: int : set = set_health
var barrier: int : set = set_barrier
var is_player := false


func set_max_health(value: int) -> void:
	max_health = clampi(value, 1, 999)


func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()


func set_barrier(value : int) -> void:
	barrier = clampi(value, 0, 999)
	stats_changed.emit()


# Returns true if health was lost
func take_damage(damage: int) -> bool:
	if damage <= 0: return false
	var initial_damage := damage
	damage = clampi(damage - barrier, 0, damage)
	barrier = clampi(barrier - initial_damage, 0, barrier)
	health -= damage
	return damage > 0


func heal(amount : int) -> void:
	health += amount
	if is_player: Data.health_healed += amount


func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.barrier = 0
	return instance
