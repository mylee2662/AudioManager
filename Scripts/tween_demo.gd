extends Control

@export var track1: AudioStream
@export var track1_channel: int = 0
@export var track2: AudioStream
@export var track2_channel: int = 1

var tween1_duration: int
var tween2_duration: int
var track1_tween_val: int
var track2_tween_val: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play(track1, AudioManager.BUS_TYPE.BGM, track1_channel)
	AudioManager.play(track2, AudioManager.BUS_TYPE.BGM, track2_channel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tween_1_pressed() -> void:
	AudioManager.tween_channel(AudioManager.BUS_TYPE.BGM, track1_channel, track1_tween_val, tween1_duration)


func _on_tween_2_pressed() -> void:
	AudioManager.tween_channel(AudioManager.BUS_TYPE.BGM, track2_channel, track2_tween_val, tween2_duration)


func _on_track_1_tween_duration_text_changed(new_text: String) -> void:
	tween1_duration = int(new_text)

func _on_track_1_tween_text_changed(new_text: String) -> void:
	var new_val: int = int(new_text)
	track1_tween_val = new_val


func _on_track_2_tween_text_changed(new_text: String) -> void:
	var new_val: int = int(new_text)
	
	track2_tween_val = new_val


func _on_track_2_tween_duration_text_changed(new_text: String) -> void:
	tween2_duration = int(new_text)


func _on_track_1_fade_in_pressed() -> void:
	AudioManager.fade_in_channel(AudioManager.BUS_TYPE.BGM, track1_channel, 100, 1)

func _on_track_1_fade_out_pressed() -> void:
	AudioManager.fade_out_channel(AudioManager.BUS_TYPE.BGM, track1_channel, 1)


func _on_track_2_fade_in_pressed() -> void:
	AudioManager.fade_in_channel(AudioManager.BUS_TYPE.BGM, track2_channel, 100, 1)


func _on_track_2_fade_out_pressed() -> void:
	AudioManager.fade_out_channel(AudioManager.BUS_TYPE.BGM, track2_channel, 1)


func _on_fade_in_all_pressed() -> void:
	AudioManager.fade_in_all_channels(AudioManager.BUS_TYPE.BGM, 100, 1)


func _on_fade_out_all_pressed() -> void:
	AudioManager.fade_out_all_channels(AudioManager.BUS_TYPE.BGM, 1)
