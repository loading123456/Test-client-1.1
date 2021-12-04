extends TextureRect

var invade = false
remote var invade_process = 50 setget set_invade_process
remote var _Color:int setget Set_color
remote var Master = null
remote var create_soldier_process = 0 setget set_create_soldier_process
var _create_soldier = false

func set_invade_process(value):
	invade_process = value
	if invade_process == 100:
		Master = (Net.Master_id+1)%2
	$Flag.value = invade_process

func set_create_soldier_process(value):
	create_soldier_process = value
	$TimeToCreateSoldier.value = create_soldier_process
	
func _ready():
	
	$CheckMove.name = str(get_index())
	set_physics_process(false)
	set_process(false)
	update_invade_process()
	update_create_soldier_process()

func Set_color(value):
	_Color = value
	texture = load("res://Assets/Towns/"+str(_Color)+".png")
	if Net.Master_id == 0:
		rset("_Color",_Color)


func Invade_process():
	if get_tree().get_nodes_in_group(str(get_index())+str(Net.Master_id)).size()>0: 
		if get_tree().get_nodes_in_group(str(get_index())+str((Net.Master_id+1)%2)).size() == 0:
			if Master != Net.Master_id:
				Master = Net.Master_id
				rset("Master",Master)
				invade = true
	else:
		invade = false
				
	if get_tree().get_nodes_in_group(str(get_index())+"0").size()>0: 
		if get_tree().get_nodes_in_group(str(get_index())+"1").size() > 0:
			invade = false
	if get_tree().get_nodes_in_group(str(get_index())+"0").size()==0: 
		if get_tree().get_nodes_in_group(str(get_index())+"1").size() == 0:
			invade = false
		
func update_invade_process():
	if invade:
		if Net.Master_id == 0:
			if  invade_process < 100:
				invade_process += 1
				$Flag.value = invade_process
				_create_soldier = false
				rset("invade_process",invade_process)
			else:
				Master = 0
				_create_soldier = true
		else:
			if  invade_process > 0:
				invade_process -= 1
				$Flag.value = invade_process
				_create_soldier = false
				rset("invade_process",invade_process)
			else:
				Master = 1
				_create_soldier = true
				
	yield(get_tree().create_timer(0.1),"timeout")
	update_invade_process()




		
func update_create_soldier_process():
	if _create_soldier and invade:
		if create_soldier_process < 100:
			create_soldier_process += 1
			$TimeToCreateSoldier.value = create_soldier_process
		else:
			Create_new_soldier()
			create_soldier_process = 0
		rset("create_soldier_process",create_soldier_process)

	yield(get_tree().create_timer(0.1),"timeout")
	update_create_soldier_process()

func Create_new_soldier():
	if get_tree().get_nodes_in_group(str(get_index())+str(Master)).size() < 3:
		var soldier =  load("res://Scenes/Soldier.tscn").instance()
		soldier._Color = _Color
		soldier.Master = Master
		soldier.Address = get_index()
		soldier.Id = Storage.Id_soldier
		$"/root/Main/Game/Soldiers".add_child(soldier)
		rpc("Create_new_enemy",Storage.Id_soldier)
		Storage.Id_soldier +=2
		
	if get_tree().get_nodes_in_group(str(get_index())+str(Master)).size() == 3:
		_create_soldier = false
		invade = false
		
remote func Create_new_enemy(_id):
	var enemy =  load("res://Scenes/Soldier.tscn").instance()
	enemy._Color = _Color
	enemy.Master = Master
	enemy.Address = get_index()
	enemy.Id = _id
	enemy.visible = true
	
	$"/root/Main/Game/Soldiers".add_child(enemy)
		


remote func Display_enemy():
	rpc("Display_enemy")
	if get_tree().get_nodes_in_group(str(get_index())+str(Net.Master_id)).size()==0:
		for i in get_tree().get_nodes_in_group(str(get_index())+str((Net.Master_id+1)%2)):
			i.visible = false
	else:
		for i in get_tree().get_nodes_in_group(str(get_index())+str((Net.Master_id+1)%2)):
			i.visible = true
			
	get_tree().call_group(str(get_index())+'0', "detect_enemy")
	get_tree().call_group(str(get_index())+'1', "detect_enemy")
