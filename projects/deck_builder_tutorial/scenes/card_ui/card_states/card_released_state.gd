extends CardState

var played: bool


func enter():
	played = false
	
	if not card_ui.targets.is_empty():
		Events.tooltip_hide_requested.emit()
		played = true
		print("Play card for target(s): ", card_ui.targets)
		card_ui.play()


func on_input(_event: InputEvent):
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
