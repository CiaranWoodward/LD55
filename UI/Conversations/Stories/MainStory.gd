extends Node

@onready var intro = Conversation.new()
@onready var intro2 = Conversation.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	intro.is_triggered = func():
		return true
	intro.script([
		{
			text = "Hello... Is anyone there?",
			image = "Catherine",
			name = "Catherine",
		},
		{
			text = "Great, another one...",
			image = "Penelope",
			name = "???",
		},
		{
			text = "???",
			image = "Catherine",
			name = "Catherine",
		},
		{
			text = "Oh, right... turn on cat translator",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "You can't just stay here for free!",
		},
		{
			text = "If you want to stay here, you need to earn your keep.",
		},
		{
			text = "Create summons for these games, so that the players can actually summon them!. You'll earn gold for each game fulfilled.",
		},
		{
			text = "Happy?",
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
		},
		{
			text = "You also need to leave some workers wandering around to haul resources.",
		},
		{
			text = "And farm enough fish to feed all of your cats.",
		},
		{
			text = "Good luck!",
		}
	])
	
	Story.active_set.push_back(intro)

func take_quota(convo : Conversation):
	pass
