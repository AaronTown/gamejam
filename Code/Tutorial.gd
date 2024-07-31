extends Control

signal next

#var dialogue = ["Welcome to Prismatic, a tower defense game about utilizing the qualities of light to defeat the oncoming waves of darkness!",
			#"In this quick tutorial you will be guided on how to destroy the first few waves of the enemy, Shadow Moths!",
			#"You will start each level with a Main Emitter, this is your final bastion and primary weapon against your foe! You can use your mouse to aim your beam of light. Remember the closer the shadow is to the light the more quickly the shadow will be illuminated!",
			#"Quick here comes some now!",
			#"Well done! Those things are deadly! Just a handful can snuff out your light; if that happens then the realm is forfeit!",
			#"In addition to your primary Emitter you can employ the assistance of smaller secondary emitters. ",
			#"These towers just as capable of dismissing any shadows around, but because of their smaller size they need to be rotated manually so you can only change their angle inbetween waves.",
			#"To counteract this downside we have the ability to construct reflectors anywhere on the field. These can also only be adjusted manually and therefore can only be altered inbetween waves. ",
			#"We do need resources to construct these additional towers, but it looks like you picked up a few gems from that last wave, use some to build an Emitter and a Reflector.",
			#"Oh and just in time! It's even more of them this time!",
			#"Well with a display like that I think you're more than ready to handle this yourself! Good luck out there!",
			#"Oh, what's this? We've never seen anything like this before! A shadow...with colour?? And they seem to be totally unaffected by the light!? ",
			#"The only thing I can think of is that maybe if we hit em with the opposite colour then maybe that'll do it!",
			#"Here! Take these lenses we found! Put them in any Emitter or Reflector to change the light coming from it!"]
var dialogue = ["Welcome to Prismatic a tower defense game about utilizing the qualities of light to defeat the oncoming waves of darkness!",
			"Here come the Shadow Moths! Quick defeat them with your light! (Click Play to start the wave)",
			"Well done those things are deadly!",
			"Looks like the Shadow Moths dropped some gems use those to build another Emitter and a Reflector",
			"Click on the tower icons in the bottom right to select a tower and click on the map to place it. Use the Mouse Wheel to rotate the tower",
			"Well with a display like that I think you're more than ready to handle this yourself! Good luck out there!",
			"Oh what's this? It looks like there are more Shadow Moths incoming but this time... they have color?",
			"The white light isn't gonna affect these guys, use these lens to change your light to red and cancel out the enemy color!",
			"Click on the tower to open the color menu and click a color to change the tower type",
			"Great Job! You got the idea now. Keep an eye out for other colored enemies. Use the Color Wheel in the top left to decide your attack!"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#game.round_start.connect(TutorialStep)
	

func TutorialStep(round):
	#get_parent().get_node("Level1").paused = true
	#get_node("/root").get_tree().paused = true
	show()
	match round:
		1:
			#print(round)
			RunDialogue(dialogue.slice(0,2))
		2: 
			RunDialogue(dialogue.slice(2,5))
			if TotalMoney.money < 15:
				TotalMoney.money = 15
		3:
			RunDialogue(dialogue.slice(5,6))
		4:
			RunDialogue(dialogue.slice(6,8))
			TotalMoney.tutorial = false
		5:
			RunDialogue([dialogue[9]])
		

func RunDialogue(text):
	for line in text:
		#print(line)
		$Label.text = line
		await next
	#get_parent().get_node("Level1").paused = false
	#get_node("/root").get_tree().paused = false
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	#print("pressed")
	next.emit()
