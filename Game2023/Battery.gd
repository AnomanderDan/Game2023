extends Control


onready var frame = $Power_Frame
onready var power_left = $Power_Left
onready var update_tween = $Tween

func _on_max_power_changed(max_power):
	power_left.max_value = max_power


func _on_Player_Power_changed(power):
	power_left.value = power
	update_tween.interpolate_property(frame, "value", power_left.value, power, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
