/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == DEAD)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return


	var/permitted = 0
	var/list/allowed = list("Syndicate","traitor","Wizard","Head Revolutionary","Cultist","Changeling")
	for(var/T in allowed)
		if(mind.special_role == T)
			permitted = 1
			break

	if(!permitted)
		message_admins("[ckey] has tried to suicide, but they were not permitted due to not being antagonist as human.", 1)
		to_chat(src, "Suicide is easy! Just attack yourself with a gun, while targeting your mouth.")
		to_chat(src, "Please don't do so flippantly! If you want to just leave the round, enter a hypersleep bed.")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		if(!canmove || is_mob_restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
			to_chat(src, "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))")
			return
		suiciding = 1
		var/obj/item/held_item = get_active_hand()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				var/damage_mod = 1
				switch(damagetype) //Sorry about the magic numbers.
								   //brute = 1, burn = 2, tox = 4, oxy = 8
					if(15) //4 damage types
						damage_mod = 4

					if(6, 11, 13, 14) //3 damage types
						damage_mod = 3

					if(3, 5, 7, 9, 10, 12) //2 damage types
						damage_mod = 2

					if(1, 2, 4, 8) //1 damage type
						damage_mod = 1

					else //This should not happen, but if it does, everything should still work
						damage_mod = 1

				//Do 175 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(30/damage_mod)	//hack to prevent gibbing
					adjustOxyLoss(145/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(175/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(175/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(175/damage_mod)

				//If something went wrong, just do normal oxyloss
				if(!(damagetype|BRUTELOSS) && !(damagetype|FIRELOSS) && !(damagetype|TOXLOSS) && !(damagetype|OXYLOSS))
					adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				updatehealth()
				return


		viewers(src) << pick("\red <b>[src] is attempting to bite \his tongue off! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[src] is jamming \his thumbs into \his eye sockets! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[src] is twisting \his own neck! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[src] is holding \his breath! It looks like \he's trying to commit suicide.</b>")
		adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(loc) << "\red <b>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</b>"
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		if(!canmove || is_mob_restrained())
			to_chat(src, "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))")
			return
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</b>"
		adjustOxyLoss(max(175- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		to_chat(src, "You're already dead!")
		return

	if (suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()
