extends HBoxContainer
class_name MultiTrackTrack

@onready var label: Label = $Container3/Label

var track: AudioStream
var channel: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "Channel " + str(channel) + ": " + str(roundi(AudioManager.get_channel_volume(AudioManager.BUS_TYPE.BGM, channel)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Channel " + str(channel) + ": " + str(roundi(AudioManager.get_channel_volume(AudioManager.BUS_TYPE.BGM, channel)))


func _on_volume_value_changed(value: float) -> void:
	AudioManager.set_channel_volume(AudioManager.BUS_TYPE.BGM, channel, value)


func _on_play_track_pressed() -> void:
	channel = AudioManager.play(track, AudioManager.BUS_TYPE.BGM, channel)


func _on_pause_track_pressed() -> void:
	AudioManager.pause(AudioManager.BUS_TYPE.BGM, channel)


func _on_stop_track_pressed() -> void:
	AudioManager.stop(AudioManager.BUS_TYPE.BGM, channel)


func _on_continue_pressed() -> void:
	AudioManager.cont(AudioManager.BUS_TYPE.BGM, channel)
