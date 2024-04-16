extends Node

@onready var intro = Conversation.new()
@onready var level1Intro = Conversation.new()
@onready var level1Complete = Conversation.new()
@onready var level2Intro = Conversation.new()
@onready var level2Complete = Conversation.new()
@onready var level3Intro = Conversation.new()
@onready var level3Complete = Conversation.new()
@onready var level4Intro = Conversation.new()
@onready var level4Complete = Conversation.new()
@onready var level5Intro = Conversation.new()
@onready var level5Complete = Conversation.new()
@onready var level6Intro = Conversation.new()
@onready var level6Complete = Conversation.new()
@onready var storyEnd = Conversation.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# 
	# Intoduction
	#
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
	intro.next = level1Intro
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
	
	# 
	# Level 1
	#
	level1Intro.script([
		{
			text = "Work the recruitment centre to hire some more worker cats.",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "To assign a worker cat just drop it on the building",
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
	level1Complete.is_triggered = func():
		return Story.level == 1 and get_tree().get_nodes_in_group("characters").filter(func(c): return c is Cat).size() >= 5
	level1Complete.script([
		{
			text = "Great work setting up the cat prodution line",
			image = "Penelope",
			name = "Penelope",
		}
	])
	level1Complete.callback = func():
		Story.level = 2
	
	# 
	# Level 2
	#
	level2Intro.is_triggered = func():
		return Story.level == 2
	level2Intro.script([
		{
			text = "I require a sacrifice!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "I want to eat grandmas now!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "You need to create a Nursing Home to create Grandmas",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "But the Nursing Home also needs to be worked by worker cats to operate",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Build me 1 Nursing Home",
			image = "Penelope",
			name = "Penelope",
		},
	])
	
	level2Complete.is_triggered = func():
		return Story.level == 2 and get_tree().get_nodes_in_group("buildings").filter(func(b: Building): return b is GrannyShack and !b.as_ui_part).size() >= 1
	level2Complete.script([
		{
			text = "Look at that, a paradise for all Grandmas!",
			image = "Penelope",
			name = "Penelope",
		}
	])
	level2Complete.callback = func():
		Story.level = 3
	
	# 
	# Level 3
	#
	level3Intro.is_triggered = func():
		return Story.level == 3
	level3Intro.script([
		{
			text = "What do gradmas need?",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Thats right they need Corn obviously",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Don't they?",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Well... they are too old for variety",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Quick build a Corn Field and work it with cats",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Then lets the cats deliver the Corn to the Nursing Home",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Produce a Grandma for me wont you?",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Im starving!",
			image = "Penelope",
			name = "Penelope",
		},
	])
	
	level3Complete.is_triggered = func():
		return Story.level == 3 and get_tree().get_nodes_in_group("characters").filter(func(c): return c is Granny).size() >= 1
	level3Complete.script([
		{
			text = "Juicy Grandma!",
			image = "Penelope",
			name = "Penelope",
		}
		
	])
	level3Complete.callback = func():
		Story.level = 4
	
	# 
	# Level 4
	#
	level4Intro.is_triggered = func():
		return Story.level == 4
	level4Intro.script([
		{
			text = "Pick her up and feed her to me!",
			image = "Penelope",
			name = "Penelope",
		},
	])
	
	level4Complete.is_triggered = func():
		return Story.level == 4 and get_tree().get_nodes_in_group("characters").filter(func(c): return c is Witch).size() >= 1
	level4Complete.script([
		{
			text = "Delicious!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "It seems that my potent magical powers have been inbued into that old hag!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "That happens from time to time...",
			image = "Penelope",
			name = "Penelope",
		}
		
	])
	level4Complete.callback = func():
		Story.level = 5
		
	# 
	# Level 5
	#
	level5Intro.is_triggered = func():
		return Story.level == 5
	level5Intro.script([
		{
			text = "Now that we have a witch it's about time we deliver the witches to the Ludum Dare games below",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "We wouldn't want the games to produce bugs now do we?",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "When you meet the games requirments it will be fully implemented",
			image = "Penelope",
			name = "Penelope",
		},
	])
	
	level5Complete.is_triggered = func():
		return Story.level == 5 and "TODO function which returns true when game requirements are met"
	level5Complete.script([
		{
			text = "Look you completed a game!",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "That deserves some gold",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "You can use it to buy more buildings",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Hey look! you've unlocked the Sheep Farm!",
			image = "Penelope",
			name = "Penelope",
		},
		
	])
	level5Complete.callback = func():
		# TODO unlock sheep farms
		Story.level = 6
		
	# 
	# Level 6
	#
	level6Intro.is_triggered = func():
		return Story.level == 6
	level6Intro.script([
		{
			text = "Sheep always leave a Demon flavoured aftertaste...",
			image = "Penelope",
			name = "Penelope",
		}
	])
	level6Complete.callback = func():
		# TODO allow demon games to spawn
		pass
	
	level6Complete.is_triggered = func():
		return Story.level == 6 and get_tree().get_nodes_in_group("characters").filter(func(c): return c is Demon).size() >= 1
	level6Complete.script([
		{
			text = "Yukcy!",
			image = "Penelope",
			name = "Penelope",
		},
		
	])
	level6Complete.callback = func():
		Story.level = 7
		
	#
	# Story End
	#
	storyEnd.is_triggered = func():
		return Story.level == 7
	storyEnd.script([
		{
			text = "Well I think you are ready now",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Some games may require Skeletons or Ghosts",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "I think the hospital tends to have an abundance of those...",
			image = "Penelope",
			name = "Penelope",
		},
		{
			text = "Dont forget to give the patence herbal medicine too...",
			image = "Penelope",
			name = "Penelope",
		}
	])
	
	Story.active_set.push_back(intro)
	Story.active_set.push_back(level1Complete)
	Story.active_set.push_back(level2Intro)
	Story.active_set.push_back(level2Complete)
	Story.active_set.push_back(level3Intro)
	Story.active_set.push_back(level3Complete)
	Story.active_set.push_back(level4Intro)
	Story.active_set.push_back(level4Complete)
	Story.active_set.push_back(level5Intro)
	Story.active_set.push_back(level5Complete)
	Story.active_set.push_back(level6Intro)
	Story.active_set.push_back(level6Complete)
	Story.active_set.push_back(storyEnd)
