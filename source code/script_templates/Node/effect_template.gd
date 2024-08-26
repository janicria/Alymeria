# meta-name: Effect
# meta-description: Create an effect which can be applied to a target
class_name SuperCoolAndAwesomeEffectName
extends Effect

var member_var := 0


func execute(targets : Array[Node]) -> void:
	print ("i applied an effect to ", targets, "! ",self)
	print ("it has something ", member_var, "times! ", self)
