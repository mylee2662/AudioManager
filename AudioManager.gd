extends Node

enum BUS_TYPE {MASTER, UI, BGM, SFX}

var ui_num_players: int = 8
var bgm_num_players: int = 5
var sfx_num_players: int = 8

var ui_available: Array = []  # The available players.
var ui_queue: Array = []  # The queue of players in use
var ui_channels: Array[AudioStreamPlayer] = []
var ui_dict = {}

var bgm_available: Array = []  # The available players.
var bgm_queue: Array = []  # The queue of players in use
var bgm_channels: Array[AudioStreamPlayer]
var bgm_dict = {}

var sfx_available: Array = []  # The available players.
var sfx_queue: Array = []  # The queue of players in use
var sfx_channels: Array[AudioStreamPlayer] = [] 
var sfx_dict = {}

var ui: Node
var bgm: Node
var sfx: Node

func _ready():
	ui = Node.new()
	bgm = Node.new()
	sfx = Node.new()
	
	ui.name = "UI"
	bgm.name = "BGM"
	sfx.name = "SFX"
	
	add_child(ui)
	add_child(bgm)
	add_child(sfx)
	
	# Create the pool of AudioStreamPlayer nodes.
	for i in ui_num_players:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = str(i)
		ui.add_child(player)
		#ui_available.append(player)
		ui_channels.append(player)
		ui_dict[i] = null
		player.finished.connect(_on_ui_stream_finished.bind(player))
		player.bus = "UI"
	
	for i in bgm_num_players:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = str(i)
		bgm.add_child(player)
		#bgm_available.append(player)
		bgm_channels.append(player)
		bgm_dict[i] = null
		player.finished.connect(_on_bgm_stream_finished.bind(player))
		player.bus = "BGM"
		
	for i in sfx_num_players:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = str(i)
		sfx.add_child(player)
		#sfx_available.append(player)
		sfx_channels.append(player)
		sfx_dict[i] = null
		player.finished.connect(_on_sfx_stream_finished.bind(player))
		player.bus = "SFX"


func _on_ui_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	#ui_available.append(stream)
	#ui_dict.erase(ui_dict.find_key(stream))
	#print("TYPE: ", typeof(stream.name))
	print("UI channel ", stream.get_name().to_int(), " freed up")
	ui_dict[stream.get_name().to_int()] = null
	

func _on_bgm_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	#bgm_available.append(stream)
	#bgm_dict.erase(bgm_dict.find_key(stream))
	print("BGM channel ", stream.get_name().to_int(), " freed up")
	bgm_dict[stream.get_name().to_int()] = null

	
func _on_sfx_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	#sfx_available.append(stream)
	#sfx_dict.erase(sfx_dict.find_key(stream))
	sfx_dict[stream.get_name().to_int()] = null

func play(sound: AudioStream, bus_type: int, channel: int):
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			ui_queue.append(ui_channels[channel])
			ui_channels[channel].stream = sound
			ui_channels[channel].play()
			ui_dict[channel] = sound
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			bgm_queue.append(bgm_channels[channel])
			bgm_channels[channel].stream = sound
			bgm_channels[channel].play()
			bgm_dict[channel] = sound
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			sfx_queue.append(sfx_channels[channel])
			sfx_channels[channel].stream = sound
			sfx_channels[channel].play()
			sfx_dict[channel] = sound
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")
	

func stop(bus_type: int, channel: int):
	print("AudioManager: Channel ", channel, " stopped")
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			ui_channels[channel].stop()
			
			var stopped_player: AudioStreamPlayer = ui_channels[channel]
			var queue_pos: int = ui_queue.find(stopped_player)
			ui_queue.remove_at(queue_pos)
			
			ui_dict[channel] = null
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			bgm_channels[channel].stop()
			
			var stopped_player: AudioStreamPlayer = bgm_channels[channel]
			var queue_pos: int = bgm_queue.find(stopped_player)
			bgm_queue.remove_at(queue_pos)
			
			bgm_dict[channel] = null
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			sfx_channels[channel].stop()
			
			var stopped_player: AudioStreamPlayer = sfx_channels[channel]
			var queue_pos: int = sfx_queue.find(stopped_player)
			sfx_queue.remove_at(queue_pos)
			
			sfx_dict[channel] = null
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func cont(bus_type: int, channel: int):
	print("AudioManager: Channel ", channel, " continued")
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			ui_channels[channel].stream_paused = false
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			bgm_channels[channel].stream_paused = false
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			sfx_channels[channel].stream_paused = false
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func pause(bus_type: int, channel: int):
	print("AudioManager: Channel ", channel, " paused")
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			ui_channels[channel].stream_paused = true
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			bgm_channels[channel].stream_paused = true
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			sfx_channels[channel].stream_paused = true
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func set_bus_volume(bus_type: int, value: float):
	if(bus_type >= BUS_TYPE.MASTER and bus_type <= BUS_TYPE.SFX):
		AudioServer.set_bus_volume_db(bus_type, linear_to_db(value / 100))
	else:
		push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func set_channel_volume(bus_type: int, channel: int, value: float):
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			ui_channels[channel].volume_db = linear_to_db(value / 100)
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			bgm_channels[channel].volume_db = linear_to_db(value / 100)
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			sfx_channels[channel].volume_db = linear_to_db(value / 100)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func get_bus_volume(bus_type: int):
	if(bus_type >= BUS_TYPE.MASTER and bus_type <= BUS_TYPE.SFX):
		return db_to_linear(AudioServer.get_bus_volume_db(bus_type)) * 100
	else:
		push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func get_channel_volume(bus_type: int, channel: int):
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			return ui_channels[channel].volume_db
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			return bgm_channels[channel].volume_db
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			return sfx_channels[channel].volume_db
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func get_channel_stream(bus_type: int, channel: int):
	match bus_type:
		BUS_TYPE.UI:
			return ui_dict[channel].stream
		BUS_TYPE.BGM:
			return bgm_dict[channel].stream
		BUS_TYPE.SFX:
			return sfx_dict[channel].stream
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func get_available_channel(bus_type: int):
	match bus_type:
		BUS_TYPE.UI:
			return ui_dict.find_key(null)
		BUS_TYPE.BGM:
			return bgm_dict.find_key(null)
		BUS_TYPE.SFX:
			return sfx_dict.find_key(null)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func get_oldest_used_channel(bus_type: int):
	match bus_type:
		BUS_TYPE.UI:
			return int(ui_channels.front().name)
		BUS_TYPE.BGM:
			return int(bgm_channels.front().name)
		BUS_TYPE.SFX:
			return int(sfx_channels.front().name)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func tween_channel(bus_type: int, channel: int, value: float, duration: float):
	match bus_type:
		BUS_TYPE.UI:
			if(channel >= ui_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
				
			var tween: Tween = create_tween()
			tween.tween_property(ui_channels[channel], "volume_db", linear_to_db(value / 100), duration)
			return tween
		BUS_TYPE.BGM:
			if(channel >= bgm_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			var tween: Tween = create_tween()
			tween.tween_property(bgm_channels[channel], "volume_db", linear_to_db(value / 100), duration)
			return tween
		BUS_TYPE.SFX:
			if(channel >= sfx_num_players or channel < 0):
				push_error("AudioManager: Invalid channel number")
			
			var tween: Tween = create_tween()
			tween.tween_property(sfx_channels[channel], "volume_db", linear_to_db(value / 100), duration)
			return tween
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func fade_in_channel(bus_type: int, channel: int, value: float, duration: float):
	#print("AudioManager: Fading in " + sound_type + " channel ", channel)
	set_channel_volume(bus_type, channel, 0.0001)
	return tween_channel(bus_type, channel, value, duration)
	
func fade_out_channel(bus_type: int, channel: int, duration: float):
	# Making a naive assumption that the channel volume will already be nonzero when calling this function
	# For now, duration must always be < 1.0 
	return tween_channel(bus_type, channel, 0.0001, duration)

func tween_all_channels_parallel(bus_type: int, value: float, duration: float):
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	match bus_type:
		BUS_TYPE.UI:
			for channel in ui_dict.keys():
				if(ui_dict[channel] != null):
					tween.tween_property(ui_channels[channel], "volume_db", linear_to_db(value / 100), duration)
		BUS_TYPE.BGM:
			for channel in bgm_dict.keys():
				if(bgm_dict[channel] != null):
					tween.tween_property(bgm_channels[channel], "volume_db", linear_to_db(value / 100), duration)
		BUS_TYPE.SFX:
			for channel in sfx_dict.keys():
				if(sfx_dict[channel] != null):
					tween.tween_property(sfx_channels[channel], "volume_db", linear_to_db(value / 100), duration)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")
	
	return tween

func fade_in_all_channels(bus_type: int, value: float, duration: float):
	#Again, naively assuming that the inital volume is 0
	return tween_all_channels_parallel(bus_type, value, duration)

func fade_out_all_channels(bus_type: int, duration: float):
	return tween_all_channels_parallel(bus_type, 0.0001, duration)
	
func stop_all_channels(bus_type: int):
	match bus_type:
		BUS_TYPE.UI:
			for channel in ui_dict.keys():
				if(ui_dict[channel] != null):
					stop(bus_type, channel)
		BUS_TYPE.BGM:
			for channel in bgm_dict.keys():
				if(bgm_dict[channel] != null):
					stop(bus_type, channel)
		BUS_TYPE.SFX:
			for channel in sfx_dict.keys():
				if(sfx_dict[channel] != null):
					stop(bus_type, channel)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func cont_all_channels(bus_type: int):
	match bus_type:
		BUS_TYPE.UI:
			for channel in ui_dict.keys():
				if(ui_dict[channel] != null):
					cont(bus_type, channel)
		BUS_TYPE.BGM:
			for channel in bgm_dict.keys():
				if(bgm_dict[channel] != null):
					cont(bus_type, channel)
		BUS_TYPE.SFX:
			for channel in sfx_dict.keys():
				if(sfx_dict[channel] != null):
					cont(bus_type, channel)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")

func pause_all_channels(bus_type: int):
	match bus_type:
		BUS_TYPE.UI:
			for channel in ui_dict.keys():
				if(ui_dict[channel] != null):
					pause(bus_type, channel)
		BUS_TYPE.BGM:
			for channel in bgm_dict.keys():
				if(bgm_dict[channel] != null):
					pause(bus_type, channel)
		BUS_TYPE.SFX:
			for channel in sfx_dict.keys():
				if(sfx_dict[channel] != null):
					pause(bus_type, channel)
		_:
			push_error("AudioManager: " + str(bus_type) + " not a valid bus index")
