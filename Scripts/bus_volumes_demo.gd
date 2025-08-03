extends Control

@onready var bgm_stream: AudioStream = preload("res://Sounds/irons_hot_electroswing_loop.mp3")
@onready var ui_stream: AudioStream = preload("res://Sounds/pressed_J_sad.mp3")
@onready var sfx_stream: AudioStream = preload("res://Sounds/Heartsteel_trigger_SFX.ogg")

@export var ui_label: Label
@export var bgm_label: Label
@export var sfx_label: Label
@export var master_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_label.text = "SFX: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.SFX)))
	bgm_label.text = "BGM: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.BGM)))
	ui_label.text = "UI: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.UI)))
	master_label.text = "Master: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.MASTER)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_sfx_value_changed(value: float) -> void:
	AudioManager.set_bus_volume(AudioManager.BUS_TYPE.SFX, value)
	sfx_label.text = "SFX: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.SFX)))


func _on_bgm_value_changed(value: float) -> void:
	AudioManager.set_bus_volume(AudioManager.BUS_TYPE.BGM, value)
	bgm_label.text = "BGM: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.BGM)))


func _on_ui_value_changed(value: float) -> void:
	AudioManager.set_bus_volume(AudioManager.BUS_TYPE.UI, value)
	ui_label.text = "UI: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.UI)))


func _on_master_value_changed(value: float) -> void:
	AudioManager.set_bus_volume(AudioManager.BUS_TYPE.MASTER, value)
	master_label.text = "Master: " + str(roundi(AudioManager.get_bus_volume(AudioManager.BUS_TYPE.MASTER)))


func _on_ui_sound_pressed() -> void:
	AudioManager.stop(AudioManager.BUS_TYPE.UI, 0)
	AudioManager.play(ui_stream, AudioManager.BUS_TYPE.UI, 0)


func _on_bgm_sound_pressed() -> void:
	AudioManager.stop(AudioManager.BUS_TYPE.BGM, 0)
	AudioManager.play(bgm_stream, AudioManager.BUS_TYPE.BGM, 0)


func _on_sfx_sound_pressed() -> void:
	AudioManager.stop(AudioManager.BUS_TYPE.SFX, 0)
	AudioManager.play(sfx_stream, AudioManager.BUS_TYPE.SFX, 0)
