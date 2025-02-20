//Verbs after this point.
/mob/living/carbon/alien/diona/proc/merge()

	set category = "Abilities.Diona"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(istype(src.loc,/mob/living/carbon))
		remove_verb(src, /mob/living/carbon/alien/diona/proc/merge)
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))

		if(!(src.Adjacent(C)) || !(C.client)) continue

		if(ishuman(C))
			var/mob/living/carbon/human/D = C
			if(D.species && D.species.name == SPECIES_DIONA)
				choices += C

	var/mob/living/M = tgui_input_list(src, "Who do you wish to merge with?", "Merge Choice", choices)

	if(!M)
		to_chat(src, "There is nothing nearby to merge with.")
	else if(!do_merge(M))
		to_chat(src, "You fail to merge with \the [M]...")

/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return 0
	to_chat(H, "You feel your being twine with that of \the [src] as it merges with your biomass.")
	to_chat(src, "You feel your being twine with that of \the [H] as you merge with its biomass.")
	loc = H
	add_verb(src, /mob/living/carbon/alien/diona/proc/split)
	remove_verb(src, /mob/living/carbon/alien/diona/proc/merge)
	return 1

/mob/living/carbon/alien/diona/proc/split()

	set category = "Abilities.Diona"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(!(istype(src.loc,/mob/living/carbon)))
		remove_verb(src, /mob/living/carbon/alien/diona/proc/split)
		return

	to_chat(src.loc, "You feel a pang of loss as [src] splits away from your biomass.")
	to_chat(src, "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground.")

	var/mob/living/M = src.loc

	src.loc = get_turf(src)
	remove_verb(src, /mob/living/carbon/alien/diona/proc/split)
	add_verb(src, /mob/living/carbon/alien/diona/proc/merge)

	if(istype(M))
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_mob/animal/borer) || istype(A,/obj/item/holder))
				return
