class_name StatsUI
extends HBoxContainer

@onready var barrier : HBoxContainer = %Barrier
@onready var barrier_label : Label = %BarrierLabel
@onready var health :HealthUI = %Health


func update_stats(stats: Stats) -> void:
	barrier_label.text = str(stats.barrier)
	health.update_stats(stats)
	
	barrier.visible = stats.barrier > 0
	health.visible = stats.health > 0
