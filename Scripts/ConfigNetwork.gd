extends Panel


func _on_CreateServer_pressed():
	Net.Start_server()
	$Notify.text = "Server is started"
	
	

func _on_CreateClient_pressed():
	Net.Start_client()
	$Notify.text = "Client is started"
	Storage.Id_soldier = 3
	$"/root/Main/Game/Chatbox/Flag".texture= load("res://Assets/Towns/Flags/1.png")
