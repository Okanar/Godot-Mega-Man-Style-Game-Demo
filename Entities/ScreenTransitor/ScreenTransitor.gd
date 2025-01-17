extends ReferenceRect

class_name ScreenTransitor

signal transition_activated

### EXPORT VARIABLES ### 

#Change to what view when transiting.
export (NodePath) var target_view

#Appear usable on specified view.
export (NodePath) var active_view

#Which direction the screen transits.
export (int, "Left", "Right", "Up", "Down") var direction
export (Vector2) var transit_duration := Vector2(1.8, 2)

#Transit distance in pixels.
export (float) var transit_distance = 24

#Resets player's velocity after the screen is transited.
#When true, the player's velocity_x or y becomes zero.
export (bool) var reset_velocity_x = false
export (bool) var reset_velocity_y = false

#Adds up delay time in seconds before the screen begins transiting.
export (float, 0, 1) var start_delay = 0

#Adds up delay time in seconds after the screen finishes transiting.
export (float, 0, 1) var finish_delay = 0


onready var level := get_node_or_null("/root/Level") as Level

#On player enters area...
func _on_AreaNotifier_entered_area() -> void:
	if level != null:
		if get_node_or_null(target_view) == null:
			push_warning("Target view is null. Can't transit!")
			return
		if get_node_or_null(active_view) == null:
			push_warning("Active view is null. Can't transit!")
			return
		else:
			if get_node(active_view).name != get_node("/root/GlobalVariables").current_view:
				push_warning("Entered area, but not in current view.")
				return
		
		print(self.get_path(), ": Transiting from " , get_node(active_view).name, " to ", get_node(target_view).name)
		transit()
		emit_signal("transition_activated")
	else:
		push_warning("Level is null. Can't transit!")

func transit():
	var dir : Vector2
	if direction == 0:
		dir = Vector2.LEFT
	if direction == 1:
		dir = Vector2.RIGHT
	if direction == 2:
		dir = Vector2.UP
	if direction == 3:
		dir = Vector2.DOWN
	
	level.init_screen_transition(
		dir,
		transit_duration.x if direction == 0 or direction == 1 else transit_duration.y,
		get_node(target_view),
		reset_velocity_x,
		reset_velocity_y,
		start_delay,
		finish_delay,
		transit_distance
	)
	
	get_node("/root/LevelBrightness").toggle_brightness(false, 0)