class_name MaxSizeContainer
extends Container


func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		# Must re-sort the children
		for c in get_children():
			# Fit to own size
			# fit_child_in_rect(c, Rect2(Vector2(), rect_size))
			pass