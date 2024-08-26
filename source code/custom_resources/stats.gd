class_name Stats
extends Resource

signal stats_changed

@export var max_health := 1
@export var art : Texture
@export var id : String

var health : int : set = set_health
var barrier : int : set = set_barrier


func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()


func set_barrier(value : int) -> void:
	barrier = clampi(value, 0, 999)
	stats_changed.emit()


func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	var initial_damage := damage
	damage = clampi(damage - barrier, 0, damage)
	self.barrier = clampi(barrier - initial_damage, 0, barrier)
	self.health -= damage


func heal(amount : int) -> void:
	self.health += amount


func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.barrier = 0
	return instance
