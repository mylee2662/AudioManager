extends Control

@export var sfx_stream: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_pressed("ui_accept")): 
		AudioManager.play(sfx_stream, AudioManager.BUS_TYPE.SFX)


func _on_button_pressed() -> void:
	AudioManager.play(sfx_stream, AudioManager.BUS_TYPE.SFX)
