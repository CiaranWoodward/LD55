extends Node

@onready var game_fail = Conversation.new()
@onready var game_win = Conversation.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	game_fail.is_triggered = func():
		return Global.game_state == Global.GameState.GAME_OVER
	game_fail.script([
		{
			text = "Why do I even bother trying to integrate into this insane society of cats?",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "DO YOU WANT ANOTHER WAR?!?!",
		},
		{
			text = "BECAUSE THAT'S WHAT YOU'RE GONNA GET!",
		},
		{
			text = "GAME OVER!",
		},
	])
	
	game_win.is_triggered = func():
		return Global.game_state == Global.GameState.GAME_WIN
	game_win.script([
		{
			text = "This is why we employ cats!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Great Job!",
		},
		{
			text = "The Game Jam is over, and they all got their summons!",
		},
		{
			text = "Congratulations!",
		},
	])
	
	Story.active_set.push_back(game_fail)

func take_quota(convo : Conversation):
	pass
