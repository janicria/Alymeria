class_name StatsUI
extends HBoxContainer

@onready var player : Node2D = $".."
@onready var barrier : HBoxContainer = $Barrier
@onready var barrier_label : Label = %BarrierLabel
@onready var health :HBoxContainer = $Health
@onready var health_label :Label = %HealthLabel


func update_stats(stats: Stats) -> void:
	barrier_label.text = str(stats.barrier)
	health_label.text = str(stats.health)


	barrier.visible = stats.barrier > 0
	health.visible = stats.health > 0
