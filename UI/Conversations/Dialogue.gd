extends Control

signal dialogue_started
signal dialogue_ended

signal _dialogue_next
signal _choice_confirmed(answer : bool)

@export var characters_per_second = 50.0

var _character_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("convo_next"):
		if is_instance_valid(_character_tween):
			_character_tween.stop()
			$Speech/Text.visible_ratio = 1.0
			_character_tween.finished.emit() # Sneaky...
		else:
			_dialogue_next.emit()

func _show_picture(name_ : String):
	for child in $Speech/Pictures/Frame.get_children():
		child.visible = (child.name == name_)

## Run a conversation to completion
func run_conversation(convo : Conversation):
	get_tree().paused = true
	dialogue_started.emit()
	# Set up
	_show_picture(convo.dialogue_pages[0].get("image", ""))
	$Name/Name.text = convo.dialogue_pages[0].get("name", "")
	$Speech/Text.text = ""
	
	# Fade in
	var fade_tween = create_tween()
	self.modulate = Color.TRANSPARENT
	self.visible = true
	fade_tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	await fade_tween.finished
	
	# Run the actual conversation
	await _run_conversation_meat(convo)
	
	# Fade out
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3)
	fade_tween.tween_callback(func(): self.visible = false)
	await fade_tween.finished
	dialogue_ended.emit()
	get_tree().paused = false

func _run_conversation_meat(convo : Conversation):
	# Go through conversation.
	await _run_dialogue_pages(convo.dialogue_pages)
	
	# Choice?
	if !convo.choice_text.is_empty():
		$QuestionDialog.dialog_text = convo.choice_text
		$QuestionDialog.visible = true
		var answer = await _choice_confirmed
		$QuestionDialog.visible = false
		if is_instance_valid(convo.choice):
			convo.choice.call(answer)
		if answer: await _run_dialogue_pages(convo.dialogue_pages_choice_yes)
		else: await _run_dialogue_pages(convo.dialogue_pages_choice_no)
	
	convo.callback.call()
	
	# Is there more?
	if is_instance_valid(convo.next):
		await _run_conversation_meat(convo.next)

func _run_dialogue_pages(pages : Array[Dictionary]):
	var name = ""
	var image = ""
	for page in pages:
		name = page.get("name", name)
		image = page.get("image", image)
		if page.has("when"):
			if !page["when"].call():
				continue
		_show_picture(image)
		$Name/Name.text = name
		$Speech/Text.text = page["text"]
		$Speech/Text.visible_characters = 0
		#$Talkingsound.play()
		_character_tween = create_tween()
		var num_characters = $Speech/Text.get_total_character_count()
		_character_tween.tween_property($Speech/Text, "visible_characters", num_characters, num_characters / characters_per_second)
		await _character_tween.finished
		#$Talkingsound.stop()
		_character_tween = null
		if page.has("callback"):
			page["callback"].call()
		await _dialogue_next

func _on_question_dialog_yessed():
	_choice_confirmed.emit(true)

func _on_question_dialog_cancelled():
	_choice_confirmed.emit(false)

func _on_talkingsound_finished():
	#$Talkingsound.play()
	pass
