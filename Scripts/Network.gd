extends Node


var Network = NetworkedMultiplayerENet.new()
var Port = 1090
var Ip = "192.168.0.100"
var Master_id = 0
 
const MAX_CLIENTS = 2

func Start_server():
	Network.create_server(Port,MAX_CLIENTS)
	get_tree().set_network_peer(Network)
	yield(Network,"peer_connected")
	$"/root/Main/Game".call("S_Init_match")
	
func Start_client():
	Network.create_client(Ip,Port)
	get_tree().set_network_peer(Network)
	Master_id = 1



