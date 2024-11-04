class_name StatusEffect extends Effect

var status: Status

func execute(targets : Array[Node]) -> void:
	for target in targets:
		if !target: continue
		if target is Enemy or target is Player or target is Summon:
			target.status_handler.add_status(status.duplicate())
