class_name DamageEffect
extends Effect

var amount := 0


func exectute(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount)
