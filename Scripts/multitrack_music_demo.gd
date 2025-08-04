extends Control

@onready var track_scene: PackedScene = preload("res://Components/multitrack_track.tscn")
@onready var menu_container: VBoxContainer = $Container

@export var tracks: Array[AudioStream]

@export var bgm_label: Label

var track_to_controller: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(tracks.size()):
		print(i)
		var new_track: MultiTrackTrack = track_scene.instantiate()
		new_track.track = tracks[i]
		#new_track.channel = i
		menu_container.add_child(new_track)
		track_to_controller[tracks[i]] = new_track

	bgm_label.text = "BGM: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.BGM)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_all_pressed() -> void:
	var tracks_to_channel: Dictionary = AudioManager.play_all_tracks(tracks, AudioManager.BUS_TYPE.BGM)
	
	for track in tracks_to_channel.keys():
		var curr_track_scene: MultiTrackTrack = track_to_controller[track]
		curr_track_scene.channel = tracks_to_channel[track] 

func _on_pause_all_pressed() -> void:
	AudioManager.pause_all_channels(AudioManager.BUS_TYPE.BGM)


func _on_continue_all_pressed() -> void:
	AudioManager.cont_all_channels(AudioManager.BUS_TYPE.BGM)


func _on_stop_all_pressed() -> void:
	AudioManager.stop_all_channels(AudioManager.BUS_TYPE.BGM)


func _on_bgm_value_changed(value: float) -> void:
	AudioManager.set_bus_volume(AudioManager.BUS_TYPE.BGM, value)
