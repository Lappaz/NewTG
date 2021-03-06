/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
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
					adjustBruteLoss(175/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(175/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(175/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(175/damage_mod)

				//If something went wrong, just do normal oxyloss
				if(!(damagetype | BRUTELOSS) && !(damagetype | FIRELOSS) && !(damagetype | TOXLOSS) && !(damagetype | OXYLOSS))
					adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				updatehealth()
				return

		var/suicide_message = pick("[src] �������&#255; �������� ���� &#255;���! ��(�) �������&#255; ��������� ������!.", \
							"[src] �������&#255; �������� ���� �����! ��(�) �������&#255; ��������� ������!.", \
							"[src] �������&#255; �������� ���� ���. ��(�) �������&#255; ��������� ������!.", \
							"[src] ����������� �������! ��(�) �������&#255; ��������� ������!.")

		visible_message("<span class='danger'>[suicide_message]</span>", "<span class='userdanger'>[suicide_message]</span>")

		adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		visible_message("<span class='danger'>[src]'s ���� ��������� � ��������!. ��� �����&#255;�� ���� � �����.</span>", \
						"<span class='userdanger'>[src]'s ���� ��������� � ��������!. ��� �����&#255;�� ���� � �����.</span>")
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		visible_message("<span class='danger'>[src] �������&#255; �������� ���� &#255;���. ��(�) �������&#255; ��������� ������.</span>", \
				"<span class='userdanger'>[src] �������&#255; �������� ���� &#255;���. ��(�) �������&#255; ��������� ������.</span>")
		adjustOxyLoss(max(175- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		visible_message("<span class='danger'>[src] ����������&#255;. ��(�) �������&#255; ��������� ������.</span>", \
				"<span class='userdanger'>[src] ����������&#255;. ��(�) �������&#255; ��������� ������.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		visible_message("<span class='danger'>[src] ��������� �������. ��(�) �������&#255; ��������� ������.</span>", \
				"<span class='userdanger'>[src] ��������� �������. ��(�) �������&#255; ��������� ������.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "����������&#255; ����� ����� ��������� (����� ��������� �����)"
	set name = "pAI Suicide"
	var/answer = input("������� ����������&#255;? ��� �������� �� ��������!.", "������", "���") in list ("��", "���")
	if(answer == "��")
		card.removePersonality()
		var/turf/T = get_turf(src.loc)
		T.visible_message("<span class='notice'>[src] ������� ��������� �� �����, \"���������� &#255;���. �������� ����� ��������, ����� ���������� �����������&#255; ������&#255;�� ���������� ���.\"</span>", "<span class='notice'>[src] ������������ �����.</span>")
		death(0)
	else
		src << "������ ������� �������."

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		visible_message("<span class='danger'>[src] ������� ��� ���&#255;! ��(�) �������&#255; ��������� ������.</span>", \
				"<span class='userdanger'>[src] ������� ��� ���&#255;! ��(�) �������&#255; ��������� ������.</span>", \
				"<span class='notice'>�� ������� �����!</span>")
		//put em at -175
		adjustOxyLoss(max(175 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()


/mob/living/carbon/slime/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		visible_message("<span class='danger'>[src] ���&#255;�. ������ ��(�) �����&#255;�(�) ���� � �����.</span>", \
						"<span class='userdanger'>[src] ���&#255;�. ������ ��(�) �����&#255;�(�) ���� � �����.</span>")
		setOxyLoss(100)
		adjustBruteLoss(100 - getBruteLoss())
		setToxLoss(100)
		setCloneLoss(100)

		updatehealth()

/mob/living/simple_animal/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("�� �������, ��� ������ ��������� ������?", "����������� ������", "��", "���")
	if(!canSuicide())
		return
	if(confirm == "��")
		suiciding = 1
		visible_message("<span class='danger'>[src] ���������� ������.������ ��(�) �����&#255;�(�) ���� � �����.</span>", \
						"<span class='userdanger'>[src] ���������� ������.������ ��(�) �����&#255;�(�) ���� � �����.</span>")
		death(0)


/mob/living/proc/canSuicide()
	if(stat == CONSCIOUS)
		return 1
	else if(stat == DEAD)
		src << "�� ��� �����(�)!"
	else if(stat == UNCONSCIOUS)
		src << "�� ������(�) ���� � ��������, ����� ����������&#255;."
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		src << "�� �� ������ ����������&#255;, ������ ��&#255;������!"
		return
	return 1