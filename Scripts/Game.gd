extends Node2D


func S_Init_match():
	var colors = [5,5,5]
	var color = randi()%3
	for i in 15:
		while colors[color] == 0:
			color = randi()%3
		$"/root/Main/Game/Towns".get_child(i)._Color = color
		colors[color] -= 1
	$"/root/Main/Game/Towns/Town15"._Color = randi()%3
	
	visible = true
	get_parent().get_node("ConfigNetwork").visible = false
	
	
	var _master = load("res://Scenes/Soldier.tscn").instance()
	_master._Color = 3
	_master.Master = 0
	_master.Address = 0
	_master.Id = 0
	$"/root/Main/Game/Soldiers".add_child(_master)
	
	var enermy =  load("res://Scenes/Soldier.tscn").instance()
	enermy._Color = 3
	enermy.Master = 1
	enermy.visible = false
	enermy.Address = 15
	enermy.Id = 1
	$"/root/Main/Game/Soldiers".add_child(enermy)
	
	
	rpc("C_Init_match")
	$"/root/Main/Game/Towns/Town0".call("Invade_process")
	$"/root/Main/Game/Towns/Town15".call("Invade_process")
	
remote func C_Init_match():
	visible = true
	get_parent().get_node("ConfigNetwork").visible = false
	var _master = load("res://Scenes/Soldier.tscn").instance()
	_master._Color = 3
	_master.Master = 1
	_master.Address = 15
	_master.Id = 1
	$"/root/Main/Game/Soldiers".add_child(_master)
	var enermy =  load("res://Scenes/Soldier.tscn").instance()
	enermy._Color = 3
	enermy.Master = 0
	enermy.visible = false
	enermy.Address = 0
	enermy.Id = 0
	$"/root/Main/Game/Soldiers".add_child(enermy)
	$"/root/Main/Game/Towns/Town0".call("Invade_process")
	$"/root/Main/Game/Towns/Town15".call("Invade_process")
