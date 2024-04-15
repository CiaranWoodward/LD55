class_name Conversation
extends Node

## Callable which returns true if this conversation should be triggered. All dialogues in the
## active set are checked at the end of each turn. Once a dialogue is complete, it is removed
## from the active set.
var is_triggered : Callable = func(): return true
## Higher priorities exist earlier in the list, so will always happen first
var priority : int = 0
## Dialogue page array of dicts. See below for structure
var dialogue_pages : Array[Dictionary] = []
## Choice to print in the popup - no choice if this is empty
var choice_text : String = ""
## Call something with the result of the choice
var choice : Callable = func(): pass
## Dialogue pages which will be shown depending on the outcome of the choice
var dialogue_pages_choice_no : Array[Dictionary] = []
var dialogue_pages_choice_yes : Array[Dictionary] = []
## Run another conversation immediately after
var next : Conversation = null
## Callback after the conversation is complete
var callback : Callable = func(): pass

# Each dialogue page is a dict structured like:
# text: The text to show. Can include bbcode
# image: The name of the image to show
# name: The name of the person talking
# callback: Callable to be called when the dialogue page is fully shown
# when: Callable which returns boolean. This page will only be shown if it returns true.

func script(pages : Array[Dictionary]):
	assert(self.dialogue_pages.is_empty())
	self.dialogue_pages.assign(pages)

func yes_script(pages : Array[Dictionary]):
	assert(self.dialogue_pages_choice_yes.is_empty())
	self.dialogue_pages_choice_yes.assign(pages)

func no_script(pages : Array[Dictionary]):
	assert(self.dialogue_pages_choice_no.is_empty())
	self.dialogue_pages_choice_no.assign(pages)
