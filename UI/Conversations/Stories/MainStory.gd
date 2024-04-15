extends Node

@onready var intro = Conversation.new()
@onready var intro2 = Conversation.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	intro.is_triggered = func():
		return Story.level == 1
	intro.script([
		{
			text = "Hello... Is anyone there?",
			image = "Catherine",
			name = "Catherine",
		},
		{
			text = "wio qwodk qwdkp dkd kqkowd ?!!?...",
			image = "Penelope",
			name = "???",
		},
		{
			text = "What? I don't understand?",
			image = "Catherine",
			name = "Catherine",
		},
		{
			text = "Ah thats better just had to turn on the translator",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "I am Penelope the portal it seems you have stumbled upon my domain",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "You can't just stay here for free!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "If you want to stay here, you need to earn your keep.",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Create summons for these LDJAM games below, so that the players of these games can actually summon them!. You'll earn gold for each game fulfilled.",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Happy?",
			image = "Penelope",
			name = "Penelope",
		},
	])
	intro.choice_text = "Happy?"
	intro.next = intro2
	intro.yes_script([
		{
			image = "Penelope",
			name = "Penelope",
			text = "Good. You seem like a pleasant kitty.",
		},
	])
	intro.no_script([
		{
			image = "Penelope",
			name = "Penelope",
			text = "Why are all of you cats so disagreeable?",
		},
	])
	intro2.script([
		{
			text = "Work the recruitment centre to hire some more worker cats.",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "The recruitment centre consumes fish, which you can get by working the fishing pond.",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "You also need to leave some workers wandering around to haul resources.",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Recruit 5 cats",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Good luck!",
			image = "Penelope",
			name = "Penelope",
		}
	])
	
	Story.active_set.push_back(intro)

func take_quota(convo : Conversation):
	pass
