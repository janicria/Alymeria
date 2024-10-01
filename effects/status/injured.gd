class_name Injured
extends Status


func apply_status(target: Node) -> void:
	print("%s is injured" % target)
	
	status_applied.emit(self)
