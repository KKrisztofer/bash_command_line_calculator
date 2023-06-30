#!/bin/bash
#Készítette: Kerekes Krisztofer
#Neptun: TRNA8A
function program(){
	read -p "Add meg a matematikai kifejezést: " megoldando #beolvasom a matematikai kifejezést.
	megoldando_db=${#megoldando}	#külön változóba teszem a karakterek számát.
	megengedett="0123456789()-*/^+."	#definiálom az elfogadott karaktereket.
	megengedett_db=${#megengedett}	#meghatározom az elfogadott karakterek számát.
	megengedett_szamlalo=0	#ebben a változóban számolom meg, hogy a megadott matematikai kifejezés hány darab megengedett karaktert tartalmaz.
	zarojel=0	#ez a változó növekszik egyel, ha nyitó- és csökken egyel, ha csukózárójelet talál a ciklus.
	zarojel_hiba=0	#ha a zárójelezésben nincs hiba, ez a változó nulla marad a program végéig.
	sorrend_hiba=0	#ha a sorrendben nincs hiba, ez a változó nulla marad a program végéig.
	zarojelek=""	#ebben a változóban csak a zárójelek lesznek kiválogatva egymás utáni sorrendben.
	
	for ((i=0; i<megoldando_db; i++))
	do
		van_hiba=$megengedett_szamlalo
		karakter=${megoldando:$i:1}
		for ((j=0; j<megengedett_db; j++))
		do
			megengedett_karakter=${megengedett:$j:1}
			if [ "$karakter" = "$megengedett_karakter" ]
					#egyesével összehasonlítom az összes karaktert az összes megengedett karakterrel.
			then
				((megengedett_szamlalo=megengedett_szamlalo+1))
			fi
		done
		
		if [ "$karakter" = "(" ]
		then
			((zarojel=zarojel+1))	#nyitózárójelnél hozzáadok 1-et.
		elif [ "$karakter" = ")" ]					
		then
			((zarojel=zarojel-1))	#csukózárójelnél kivonok 1-et.
			if [ "$zarojel" -lt 0 ]
			then
				((zarojel_hiba=zarojel_hiba+1)) #ha a 'zarojel' változó értéke minuszba megy, akkor biztos hibás a zárójelezés.
			fi
		fi
		if [ "$van_hiba" -eq "$megengedett_szamlalo" ]
		then
			((index=i+1))
			echo "A $index. helyen nem megengedett karakter van."
		fi
	done
	
	if [ "$zarojel" -ne 0 ] #ha a 'zarojel' értéke nem nulla, akkor a zárójelek száma nem egyenlő.
	then
		((zarojel_hiba=zarojel_hiba+1))
	fi
	
	zarojel_index=()
	for ((i=0; i<megoldando_db; i++))	#egy külön változóba kiválogatom csak a zárójeleket.
	do					#egy tömbbe kiválogatom a zárójelek indexét.
		karakter=${megoldando:$i:1}
		if [ "$karakter" = "(" ]
		then
			zarojelek="$zarojelek("
			zarojel_index+=($i)
		fi
		if [ "$karakter" = ")" ]
		then
			zarojelek="$zarojelek)"
			zarojel_index+=($i)
		fi
	done

	zarojelek_db=${#zarojelek}
	for ((i=0; i<zarojelek_db; i++))	#karakterenként végigmegyek a csak zárójeleket tartalmazó stringen.
	do
		zarojel_ind=$i
		zaro_i=-1
		zarojelszam=0
		zj=${zarojelek:$zarojel_ind:1}
		if [ "$zj" = "(" ]	#ha találok egy nyítózárójelet, megkeresem a párját.
		then
			for ((j=zarojel_ind; j<zarojelek_db; j++))
			do
				zarojel_j=${zarojelek:$j:1}
				if [ "$zarojel_j" = "(" ]
				then
					((zarojelszam=zarojelszam+1))
				fi
				if [ "$zarojel_j" = ")" ]
				then
					((zarojelszam=zarojelszam-1))
				fi
				if [ "$zarojelszam" = 0 ] #ha sikerült megtalálni a párját, a 'zaro_i' változó értéke megváltozik.
				then
					zaro_i=$j
					break;
				fi
			done
		else			#ha találok egy csukózárójelet megkeresem a párját.
			for ((j=zarojel_ind; j>=0; j--))
			do
				zarojel_j=${zarojelek:$j:1}
				if [ "$zarojel_j" = ")" ]
				then
					((zarojelszam=zarojelszam+1))
				fi
				if [ "$zarojel_j" = "(" ]
				then
					((zarojelszam=zarojelszam-1))
				fi
				if [ "$zarojelszam" = 0 ] #ha sikerült megtalálni a párját, a 'zaro_i' változó értéke megváltozik.
				then
					zaro_i=$j
					break;
				fi
			done
		fi
		if [ "$zaro_i" = -1 ] #ha a 'zaro_i' értéke nem változott, akkor nincs párja a zárójelnek.
		then
			((index=${zarojel_index[$i]}+1))
			echo "A $index. helyen lévő zárójelnek nincs párja."
		fi
	done
	
	for ((i=0; i<megoldando_db; i++))
	do
		hiba_hely=-1
		karakter=${megoldando:$i:1}
		for ((j=13; j<megengedett_db; j++)) 	#a ciklus 13-ről indul, mert csak a matematikai műveletvégző karaktereket keresem.
						#a kivonáson kívül, mert azt külön vizsgálom meg.(mert a minusz számoknál is funkcionál ez a jel.)
		do
			matematikai_karakter=${megengedett:$j:1}
			if [ "$karakter" = "$matematikai_karakter" ]
			then
				((k=i+1))
				if [ "$i" -eq 0 ] || [ "$k" -eq $megoldando_db ]
				then
					((sorrend_hiba=sorrend_hiba+1))
					hiba_hely=$i
					#ha az első vagy az utolsó helyen van matematikai karakter, akkor a kifejezés biztosan hibás.
				else
					elozo_karakter=${megoldando:$i-1:1}
					kovetkezo_karakter=${megoldando:$i+1:1}
					
					#ha talál egy matematikai karaktert, megvizsgálja az előttelévő karaktert is.
					#ha az előtte lévő karakter egy nyitózárójel vagy egy másik matematikai karakter, akkor a sorrend hibás.
					case $elozo_karakter in
						"(")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"*")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"/")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"^")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"+")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"-")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						".")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
					esac
					
					#megvizsgálja a utána lévő karaktert is.
					#ha az utána lévő karakter egy csukózárójel vagy egy másik matematikai karakter, akkor a sorrend hibás.
					case $kovetkezo_karakter in
						")")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"*")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"/")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"^")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"+")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						"-")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
						".")
							((sorrend_hiba=sorrend_hiba+1))
							hiba_hely=$i
							break;
						;;
					esac
				fi
			fi
		done
		
		((k=i+1))
		if [ "$i" -ne 0 ] && [ "$k" -ne $megoldando_db ]
		then
			if [ "$karakter" = "(" ] #nyitózárójel előtt nem lehet szám.
			then
				elozo_karakter=${megoldando:$i-1:1}
				case $elozo_karakter in
					"0")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"1")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"2")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"3")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"4")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"5")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"6")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"7")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"8")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
					"9")
						hiba_hely=$i
						((sorrend_hiba=sorrend_hiba+1))
						
						break
					;;
				esac
			fi
			if [ "$karakter" = ")" ] #csukózárójel után nem lehet szám.
			then
				kovetkezo_karakter=${megoldando:$i+1:1}
				case $kovetkezo_karakter in
					"0")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"1")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"2")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"3")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"4")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"5")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"6")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"7")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"8")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
					"9")
						((sorrend_hiba=sorrend_hiba+1))
						hiba_hely=$i
						break;
					;;
				esac
			fi
		fi
		
		if [ "$karakter" = "-" ]
		then
			kovetkezo_karakter=${megoldando:$i+1:1}
			if [ "$kovetkezo_karakter" = ")" ]	#a minusz jel után nem lehet csukózárójel.
			then
				((sorrend_hiba=sorrend_hiba+1))
				hiba_hely=$i
			fi
		fi
		
		
		if [ "$hiba_hely" -ne -1 ]
		then
			((index=$hiba_hely+1))
			echo "Szintaktikai hiba a $index. karakter közelében."
		fi
	done
	((utolso=megoldando_db-1))
	utolso_karakter=${megoldando:$utolso:1}
	if [ "$utolso_karakter" = "-" ]	#külön ellenőrzöm, hogy az utolsó karakter ne legyen '-' karakter.
	then
		((sorrend_hiba=sorrend_hiba+1))
	fi
	
	#általános megfogalmazásban kiírja a hibákat.
	if [ "$megengedett_szamlalo" -ne "$megoldando_db" ]
	then
		echo "Matematikailag helytelen karaktereket tartalmaz."
	fi
	
	if [ "$zarojel_hiba" -ne 0 ]
	then
		echo "Hibás a zárójelezés! Ellenőrizze a nyitó- és csukózárójeleket."
	fi
	
	if [ "$sorrend_hiba" -ne 0 ]
	then
		echo "Szintaktikai hiba! Nem megfelelő a matematikai sorrend."
	fi
	
	#ha nem volt hiba, awk segítségével kiszámolja a végeredményt.
	if [ "$megengedett_szamlalo" -eq "$megoldando_db" ] && [ "$zarojel_hiba" -eq 0 ] && [ "$sorrend_hiba" -eq 0 ]
	then
		echo "Eredmeny: "
		awk "BEGIN { print $megoldando }"
	fi
	
}
function h(){
	echo "A program a megadott matematikai műveletet hajtja végre."
	echo "A program ellenőrzi a szintaktikai helyességet, hogy a zárójelezés helyes-e, illetve hogy szerepel-e benne matematikailag helytelen karakter."
}

case $1 in	#megvizsgálja a megadott argumentumot.
	-h | -help)
		h	#ha az argumentum '-h' vagy "-help", meghívom a 'h' függvényt, ami kiírja a helpet.
		;;
	*)
		program	#ha az argumentum bármi más/nem létezik, megívom a 'program' függvényt.
		;;
esac
