class_name StatsUI extends HBoxContainer

@onready var barrier: HBoxContainer = %Barrier
@onready var barrier_label: Label = %BarrierLabel
@onready var health: HealthUI = %HealthUIStats


func update_stats(stats: Stats) -> void:
	barrier_label.text = str(stats.barrier)
	health.update_stats(stats.health, stats.max_health)
	
	barrier.visible = stats.barrier > 0
	health.visible = stats.health > 0
