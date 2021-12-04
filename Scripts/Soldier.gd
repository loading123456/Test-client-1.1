extends KinematicBody2D

var Master
var _Color
remote var Hp = 2 setget Set_hp
var Level = 1
var Dame = 1
var Recuperate_process = 100
remote var Rest_process = 0 setget Set_rest_process
var Exp = 0
remote var Address = 2 setget Set_address
var Id
var select = false
var move_valid = false
var next_address
var enemy = null

func Set_rest_process(value):
	Rest_process = value
	$TimeToMove.value = Rest_process
	
func Set_address(value):
	remove_from_group(str(Address)+str(Master))
	Address = value
	add_to_group(str(Address)+str(Master))
	global_position = Vector2(149*(Address%4), 149*(Address/4)) + Vector2(randi()%70+20,randi()%70+20)

	next_address = null
	Rest_process = 0
	
func Set_hp(value):
	Hp =  value
	$Hp.value = Hp
func _ready():
	name = str(Id)
	$Hp.texture_progress = load("res://Assets/Soldiers/" + str(_Color)+".png")
	$TimeToMove.value = Rest_process

	Update_address(Address)
	$Flag.texture = load("res://Assets/Towns/Flags/"+str(Master)+".png")
	name = str(Id)
	Update_rest()
	Update_hp()
	
func Update_address(town):
	remove_from_group(str(Address)+str(Master))
	add_to_group(str(town)+str(Master))
	Address = town 
	global_position = Vector2(149*(town%4), 149*(town/4)) + Vector2(randi()%70+20,randi()%70+20)
	next_address = null
	Rest_process = 0
	$"/root/Main/Game/Towns".get_child(Address).call("Invade_process")
	$"/root/Main/Game/Towns".get_child(Address).call("Display_enemy")
	$"/root/Main/Game/Towns".get_child(town).call("Display_enemy")
	rset("Address",Address)
	
func Update_rest():
	if Rest_process < 100 && Net.Master_id == Master: 
		Rest_process += 1
		$TimeToMove.value = Rest_process
		rset("Rest_process",Rest_process)
	yield(get_tree().create_timer(0.05),"timeout")
	
	Update_rest()
	
func Update_hp():
	if Master == Net.Master_id:
		if Hp < 4 + Level:
			Hp += 0.1
			$Hp.value = Hp*20
			print($Hp.value )
			rset("Hp",Hp)
	yield(get_tree().create_timer(1),"timeout")
	Update_hp()
	
func _physics_process(delta):
	if select:
		$CheckMove.global_position = lerp($CheckMove.global_position,get_global_mouse_position(),80*delta)
	

func detect_enemy():
	if Master == Net.Master_id:
		if enemy == null:
			var enemys = get_tree().get_nodes_in_group(str(Address)+str((Master+1)%2))
			if enemys.size() > 0:
				enemy = enemys[randi()%enemys.size()]
			else:
				enemy = null


func _on_Select_button_down():
	
	if Rest_process == 100 && Master == Net.Master_id:
		select = true
		$CheckMove.visible = true
		$CheckMove.texture = load("res://Assets/Soldiers/Move_ok.png")
	


func _on_Select_button_up():
	$CheckMove.visible = false
	if next_address != null:
		Update_address(next_address)
		


func _on_Area2D_area_entered(area):
	
	if (Address/4 > 0 and Address - 4 == int(area.name)) or (Address/4 <3 and Address + 4 == int(area.name)) or (Address%4 > 0 and Address - 1 == int(area.name)) or (Address%4 <3 and Address + 1 == int(area.name)):
		move_valid = true
		$CheckMove.texture = load("res://Assets/Soldiers/Move_ok.png")
		next_address = int(area.name)
	else:
		move_valid = false
		$CheckMove.texture = load("res://Assets/Soldiers/Move_not_ok.png")
		next_address = null
