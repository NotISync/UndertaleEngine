extends BackBufferCopy

func _process(delta):
	if(is_instance_valid(vars.battle_box)):
		$masks/top_left.global_position = vars.battle_box.get_node("corner_top").global_position
		$masks/top_left.global_rotation = vars.battle_box.get_node("corner_top").global_rotation
		$masks/bottom_right.global_position = vars.battle_box.get_node("corner_bottom").global_position
		$masks/bottom_right.global_rotation = vars.battle_box.get_node("corner_bottom").global_rotation
		$masks/box_mask/top_left.global_position = vars.battle_box.get_node("corner_top_inner").global_position
		$masks/box_mask/top_left.global_rotation = vars.battle_box.get_node("corner_top_inner").global_rotation
		$masks/box_mask/bottom_right.global_position = vars.battle_box.get_node("corner_bottom_inner").global_position
		$masks/box_mask/bottom_right.global_rotation = vars.battle_box.get_node("corner_bottom_inner").global_rotation
		$masks/box_mask/box.offset_left = vars.battle_box.offset_left
		$masks/box_mask/box.offset_top = vars.battle_box.offset_top
		$masks/box_mask/box.offset_right = vars.battle_box.offset_right
		$masks/box_mask/box.offset_bottom = vars.battle_box.offset_bottom
		$masks/box_mask/box.global_position = vars.battle_box.global_position
		$masks/box_mask/box.rotation = vars.battle_box.rotation
