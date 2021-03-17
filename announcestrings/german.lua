ANNOUNCE_STRINGS = {
	-- These are not character-specific strings, but are here to ease translation
	-- Note that spaces at the beginning and end of these are important and should be preserved
	_ = {
		getArticle = function(name)
			return string.find(name, "^[abfghkABFGHK]") ~= nil and "eine" or "ein"
		end,
		--Goes into {S} if there are multiple items (plural)
		-- This isn't perfect for making plural even in English, but it's close enough
		S = "n",
		STAT_NAMES = {
			Hunger = "Hunger",
			Sanity = "Gesundheit",
			Health = "Leben",
			["Log Meter"] = "Holzmeter",
			Wetness = "Feuchtigkeit",
			--Other mod stats won't have translations, but at least we can support these
		},
		ANNOUNCE_ITEM = {
			-- This needs to reflect the translating language's grammar
			-- For example, this might become "I have 6 papyrus in this chest."
			FORMAT_STRING = "{I_HAVE}{THIS_MANY} {ITEM}{S}{IN_THIS}{CONTAINER}{WITH}{PERCENT}{DURABILITY}.",
			
			--One of these goes into {I_HAVE}
			I_HAVE = "Ich habe ",
			WE_HAVE = "Wir haben ",
			
			--{THIS_MANY} is a number if multiple, but singular varies a lot by language,
			-- so we use getArticle above to get it
			
			--{ITEM} is acquired from item.name
			
			--{S} uses S above
			
			--Goes into {IN_THIS}, if present
			IN_THIS = " in dieser ",
			
			--{CONTAINER} is acquired from container.name
			
			--One of these goes into {WITH}
			WITH = " mit ", --if it's only one thing
			AND_THIS_ONE_HAS = ", und dieser hat ", --if there are multiple, show durability of one
			
			--{PERCENT} is acquired from the item's durability
			
			--Goes into {DURABILITY}
			DURABILITY = " Haltbarkeit",
			FRESHNESS = " Frische",
		},
		ANNOUNCE_RECIPE = {
			-- This needs to reflect the translating language's grammar
			-- Examples of what this makes:
			-- "I have a science machine pre-built and ready to place" -> pre-built
			-- "Ich werd eine Axt bauen" -> known and have ingredients
			-- "Kann jemand mir eine Alchemiemaschine bauen? Ich brauche eine Wissenschaftsmaschine daf�r." -> not known
			-- "Wir brauchen mehr D�rrstangen." -> known but don't have ingredients
			FORMAT_STRING = "{START_Q}{TO_DO}{THIS_MANY} {ITEM}{S}{PRE_BUILT}{END_Q}{I_NEED}{A_PROTO}{PROTOTYPER}{FOR_IT}.",
			
			--{START_Q} is for languages that match ? at both ends
			START_Q = "", --English doesn't do that
			
			--One of these goes into {TO_DO}
			I_HAVE = "Ich habe ", --for pre-built
			ILL_MAKE = "Ich werde bauen ", --for known recipes where you have ingredients
			CAN_SOMEONE = "Kann jemand mir bauen ", --for unknown recipes
			WE_NEED = "Wir brauchen mehr", --for known recipes where you don't have ingredients
			
			--{THIS_MANY} uses getArticle above to get the right article ("a", "an")
			
			--{ITEM} comes from the recipe.name
			
			--{S} uses S above

			--Goes into {PRE_BUILT}
			PRE_BUILT = " vorbereitet und bereit zum aufstellen",
			
			--This goes into {END_Q} if it's a question
			END_Q = "?",
			
			--Goes into {I_NEED}
			I_NEED = " Ich brauche ",
			
			--{PROTOTYPER} is taken from the recipepopup.teaser:GetString with this function
			getPrototyper = function(teaser)
				--This extracts from sentences like "Use a (science machine) to..." and "Use an (alchemy engine) to..."
				return teaser:gmatch("Use an? (.*) to")()
			end,
			
			--Goes into {FOR_IT}
			FOR_IT = " f�r es",
		},
		ANNOUNCE_INGREDIENTS = {
			-- This needs to reflect the translating language's grammar
			-- Examples of what this makes:
			-- "Ich brauche 2 zus�tzliche geschliffene Steine und eine Wissenschaftsmaschine um eine Alchemiemaschine zu bauen."
			FORMAT_NEED = "Ich brauche {NUM_ING} zus�tzliche {INGREDIENT}{S}{AND}{A_PROTO}{PROTOTYPER} zum bauen {A_REC} {RECIPE}.",
			
			--If a prototyper is needed, goes into {AND}
			AND = " und ",
			
			-- This needs to reflect the translating language's grammar
			-- Examples of what this makes:
			-- "Ich habe genug Zweige um 9 Vogelfallen zu bauen, aber ich brauche eine Wissenschaftsmaschine."
			FORMAT_HAVE = "Ich habe genug {INGREDIENT}{ING_S} zum bauen {A_REC} {RECIPE}{REC_S}{BUT_NEED}{A_PROTO}{PROTOTYPER}.",
			
			--If a prototyper is needed, goes into {BUT_NEED}
			BUT_NEED = ", aber ich brauche ",
		},
		ANNOUNCE_SKIN = {
			-- This needs to reflect the translating language's grammar
			-- For example, this might become "Ich habe den tragische Fackel �berzug f�r die Fackel"
			FORMAT_STRING = "Ich habe den {SKIN} �berzug f�r das {ITEM}.",
			
			--{SKIN} comes form the skin's name
			
			--{ITEM} comes from the item's name
		},
		ANNOUNCE_TEMPERATURE = {
			-- This needs to reflect the translating language's grammar
			-- For example, this might become "Ich habe eine angenehme Temperatur"
			-- or "Das Biest ist am erfrieren!"
			FORMAT_STRING = "{PRONOUN} {TEMPERATURE}",
			
			--{PRONOUN} is picked from this
			PRONOUN = {
				DEFAULT = "Ich bin",
				BEAST = "Das Biest ist", --for Werebeaver
			},
			
			--{TEMPERATURE} is picked from this
			TEMPERATURE = {
				BURNING = "�berhitzen!",
				HOT = "fast am �berhitzen!",
				WARM = "ein bischen hei�.",
				GOOD = "eine angenehme Temperatur.",
				COOL = "ein bischen kalt.",
				COLD = "fast am erfrieren!",
				FREEZING = "ich erfriere!",
			},
		},
		ANNOUNCE_WORLDTEMP = {

			FORMAT_STRING = "{PRONOUN} {TEMPERATURE}",

			PRONOUN = {
				DEFAULT = "I'm ",
				BEAST = "The beast is ", --for Werebeaver
				WORLD = "The climate ", --WORLD TEMP - Shang
			},

			--{WORLDTEMP} is picked from this
			WORLDTEMP = {
				BURNING = "overheating!",
				HOT = "almost overheating!",
				WARM = "a little bit hot.",
				GOOD = "at a comfortable temperature.",
				COOL = "a little bit cold.",
				COLD = "almost freezing!",
				FREEZING = "freezing!",
			},
		},
		ANNOUNCE_SEASON = "Es sind {DAYS_LEFT} Tage �brig im {SEASON}.",
		ANNOUNCE_GIFT = {
			CAN_OPEN = "Ich habe ein Geschenk und ich werde es gleich �ffnen!",
			NEED_SCIENCE = "Ich brauche zus�tzliche Wissenschaft um dieses Geschenk zu �ffnen!",
		},
		ANNOUNCE_HINT = "Ank�ndigen",
	},
	-- Everything below is character-specific
	UNKNOWN = {
		HUNGER = {
			FULL  = "Ich bin pappsatt!", 	-- >75%
			HIGH  = "Ich bin ziemlich voll.",			-- >55%
			MID   = "Ich bin bischen hungrig.", 	-- >35%
			LOW   = "Ich bin hungrig!", 				-- >15%
			EMPTY = "Ich bin am verhungern!", 			-- <15%
		},
		SANITY = {
			FULL  = "Mein Gehirn ist in Topzustand!", 			-- >75%
			HIGH  = "Ich f�hle mich ziemlich gut.", 				-- >55%
			MID   = "Ich werde ein bischen nerv�s.", 				-- >35%
			LOW   = "Ich f�hle mich etwas verr�ckt, hier!", 			-- >15%
			EMPTY = "AAAAHHHH! Bleibt weg ihr Alptr�ume!", 	-- <15%
		},
		HEALTH = {
			FULL  = "Ich bin topfit!", 	-- 100%
			HIGH  = "Ich hab ein paar Schrammen.", 	-- >75%
			MID   = "Ich bin verletzt.", 			-- >50%
			LOW   = "Ich bin schwer verletzt!", 	-- >25%
			EMPTY = "Ich bin t�dlich verwundet!", 	-- <25%
		},
		WETNESS = {
			FULL  = "Ich bin komplett durchn�sst!", 	-- >75%
			HIGH  = "Ich bin durchn�sst!",					-- >55%
			MID   = "Ich bin zu nass!", 				-- >35%
			LOW   = "Ich werde etwas feucht.", 		-- >15%
			EMPTY = "Ich bin ziemlich trocken.", 				-- <15%
		},
	},
	WILSON = {
		HUNGER = {
			FULL  = "Ich bin pappsatt!",
			HIGH  = "Ich ben�tige nichts zum essen.",
			MID   = "Ich k�nnte einen Snack vertragen.",
			LOW   = "Ich bin echt hungrig!",
			EMPTY = "Ich... brauche... Essen...",
		},
		SANITY = {
			FULL  = "So ausgewogen wie man nur sein kann!",
			HIGH  = "Mir gehts gut.",
			MID   = "Mein Kopf tut weh...",
			LOW   = "Wa-- was ist los!?",
			EMPTY = "Hilfe! Die Dinger werden mich fressen!!",
		},
		HEALTH = {
			FULL  = "Fit wie ein Turnschuh!",
			HIGH  = "Bin verletzt, aber kann noch weitergehen.",
			MID   = "Ich... Ich glaube ich brauche Erste Hilfe.",
			LOW   = "Ich habe soviel Blut verloren...",
			EMPTY = "Ich... Ich werd hier drau�en j�mmerlich verrecken...",
		},
		WETNESS = {
			FULL  = "Ich habe meinen S�ttigungspunkt erreicht!",
			HIGH  = "Wasser, so durchn�sst!",
			MID   = "Meine Kleidung scheint durchl�ssig.",
			LOW   = "Oh, H2O.",
			EMPTY = "Ich bin ziemlich trocken.",
		},
	},
	WILLOW = {
		HUNGER = {
			FULL  = "Ich werd fett, wenn ich nicht aufh�re zu essen.",
			HIGH  = "Angenehm satt.",
			MID   = "Mein Feuer braucht Brennstoff.",
			LOW   = "Ugh, Ich verhungere hier dr�ben!",
			EMPTY = "Ich bin quasi nur Haut und Knochen!",
		},
		SANITY = {
			FULL  = "Ich glaube ich hatte jetzt genug Feuer.",
			HIGH  = "Hab ich Bernie tanzen sehen? ... ne, vergiss es.",
			MID   = "Ich f�hle mich k�lter als sonst...",
			LOW   = "Bernie, warum friere ich so!?",
			EMPTY = "Bernie, besch�tz mich vor diesen schrecklichen Dingern!",
		},
		HEALTH = {
			FULL  = "Keine einzige Schramme!",
			HIGH  = "Ich hab 1 oder 2 Schrammen. Ich sollte sie ver�den.",
			MID   = "Diese Fleischwunden brennen, Ich brauch einen Arzt...",
			LOW   = "Ich f�hle mich schwach... Ich k�nnte... sterben.",
			EMPTY = "Mein Feuer ist fast erloschen...",
		},
		WETNESS = {
			FULL  = "Uff, dieser Wolkenbruch ist das Letzte!",
			HIGH  = "Ich hasse all dieses Wasser!",
			MID   = "Dieser Platzregen ist zu viel.",
			LOW   = "Oh ha, wenn dieser Regen weiter...",
			EMPTY = "Nicht genug Regen um dieses Feuer zu l�schen.",
		},
	},
	WOLFGANG = {
		HUNGER = {
			FULL  = "Wolfgang ist voll und m�chtig!",
			HIGH  = "Wolfgang muss essen und m�chtig werden!",
			MID   = "Wolfgang k�nnte mehr essen.",
			LOW   = "Wolfgang hat Loch im Bauch.",
			EMPTY = "Wolfgang braucht Essen! JETZT!",
		},
		SANITY = {
			FULL  = "Wolfgang f�hlt sich gut im Kopp!",
			HIGH  = "Wolfgang Kopp f�hlt sich lustig.",
			MID   = "Wolfgang Kopp aua",
			LOW   = "Wolfgang sieht gruselige Monster...",
			EMPTY = "Gruselige Monster �berall!",
		},
		HEALTH = {
			FULL  = "Wolfgang braucht keine Flickarbeit!",
			HIGH  = "Wolfgang braucht kleinen �lwechsel.",
			MID   = "Wolfgang schmerzt.",
			LOW   = "Wolfgang braucht viel Hilfe um sich nicht verwundet zu f�hlen.",
			EMPTY = "Wolfgang k�nnte sterben...",
		},
		WETNESS = {
			FULL  = "Wolfgang ist jetzt vielleicht aus Wasser gemacht!",
			HIGH  = "Es ist wie in der Badewanne hocken.",
			MID   = "Wolfgang mag keinen Waschtag.",
			LOW   = "Regenzeit.",
			EMPTY = "Wolfgang ist trocken.",
		},
	},
	WENDY = {
		HUNGER = {
			FULL  = "Keine Nahrungsmenge kann das Loch in meinem Herzen stopfen.",
			HIGH  = "Ich bin voll, aber trotzdem begierig nach etwas das kein Freund geben kann.",
			MID   = "Ich bin nicht leer, aber auch nicht voll. Seltsam.",
			LOW   = "Ich bin voll von Leere.",
			EMPTY = "Ich hab die langsamste Methode zum Sterben gefunden. Verhungern.",
		},
		SANITY = {
			FULL  = "Meine Gedanken sind kristallklar.",
			HIGH  = "Meine Gedanken werden d�ster.",
			MID   = "Meine Gedanken sind fieberhaft...",
			LOW   = "Siehst du sie, Abigail? Diese D�monen lassen mich dich vielleicht wiedersehen, bis bald.",
			EMPTY = "Bringt mich zu Abigail, Kreaturen der Dunkelheit und Nacht!",
		},
		HEALTH = {
			FULL  = "Mir gehts gut, aber ich bin mir sicher ich werde wieder verletzt.",
			HIGH  = "Ich sp�re Schmerz, aber nicht viel.",
			MID   = "Leben bringt Schmerz, aber ich bin nicht an soviel gew�hnt.",
			LOW   = "Verbluten... w�re jetzt einfach...",
			EMPTY = "Ich werde bei Abigail sein, sehr bald...",
		},
		WETNESS = {
			FULL  = "Eine Apokalypse aus Wasser!",
			HIGH  = "Eine Ewigkeit von Feuchtigkeit und Leid.",
			MID   = "Feucht und traurig.",
			LOW   = "Vielleicht f�llt dieses Wasser die Leere in meinem Herzen.",
			EMPTY = "Meine Haut ist genauso trocken wie mein Herz.",
		},
	},
	WX78 = {
		HUNGER = {
			FULL  = "TREIBSTOFF-STATUS: MAXIMALES LEISTUNGSVERM�GEN",
			HIGH  = "TREIBSTOFF-STATUS: HOCH",
			MID   = "TREIBSTOFF-STATUS: AKZEPTABEL",
			LOW   = "TREIBSTOFF-STATUS: NIEDRIG",
			EMPTY = "TREIBSTOFF-STATUS: KRITISCH",
		},
		SANITY = {
			FULL  = "PROZESSOR-STATUS: VOLL EINSATZBEREIT",
			HIGH  = "PROZESSOR-STATUS: FUNKTIONAL",
			MID   = "PROZESSOR-STATUS: BESCH�DIGT",
			LOW   = "PROZESSOR-STATUS: FEHLER BEVORSTEHEND",
			EMPTY = "PROZESSOR-STATUS: MEHRERE FEHLER ERFASST",
		},
		HEALTH = {
			FULL  = "EXOSKELETT-STATUS: PERFEKTER ZUSTAND",
			HIGH  = "EXOSKELETT-STATUS: BRUCH ERFASST",
			MID   = "EXOSKELETT-STATUS: MITTELM�SSIGER SCHADEN",
			LOW   = "EXOSKELETT-STATUS: INTEGRIT�T ZUSAMMENBRECHEND",
			EMPTY = "EXOSKELETT-STATUS: NICHTFUNKTIONST�CHTIG",
		},
		WETNESS = {
			FULL  = "FEUCHTE-STATUS: KRITISCH",
			HIGH  = "FEUCHTE-STATUS: FAST KRITISCH",
			MID   = "FEUCHTE-STATUS: INAKZEPTABEL",
			LOW   = "FEUCHTE-STATUS: TOLERABEL",
			EMPTY = "FEUCHTE-STATUS: AKZEPTABEL",
		},
	},
	WICKERBOTTOM = {
		HUNGER = {
			FULL  = "Ich sollte Forschung betreiben und mich nicht vollstopfen.",
			HIGH  = "Satt, aber nicht aufgebl�ht.",
			MID   = "Ich f�hle mich ein bischen hungrig.",
			LOW   = "Diese Bibliothekarin braucht Nahrung, f�rchte ich!",
			EMPTY = "Wenn ich nicht sofort Nahrung bekomme, werde ich verhungern!",
		},
		SANITY = {
			FULL  = "Nichts Verd�chtiges passiert.",
			HIGH  = "Ich glaube ich hab ein bischen Kopfschmerzen.",
			MID   = "Diese Migr�ne ist unertr�glich.",
			LOW   = "Ich bin mir nicht mehr sicher, ob diese Dinger eingebildet sind!",
			EMPTY = "Hilfe! Diese abgr�ndigen Scheu�lichkeiten sind feindlich!",
		},
		HEALTH = {
			FULL  = "Ich bin topfit f�r mein hohes Alter!",
			HIGH  = "Ein paar Kratzer, aber nichts Schlimmes.",
			MID   = "Meine medizinische Notlage steigt an.",
			LOW   = "Ohne Heilung wird das mein Ende sein.",
			EMPTY = "Ich brauche sofortige Erste Hilfe!",
		},
		WETNESS = {
			FULL  = "Positiv durchn�sst!",
			HIGH  = "Ich bin feucht, feucht, feucht!",
			MID   = "Ich frage mich was der S�ttigungspunkt meines K�rpers ist...",
			LOW   = "Die Schichten der N�sse steigen an.",
			EMPTY = "Ich bin hinreichend frei von Feuchtigkeit.",
		},
	},
	WOODIE = {
		HUMAN = {
			HUNGER = {
				FULL  = "Alles komplett voll!",
				HIGH  = "Satt genug zum B�ume f�llen.",
				MID   = "K�nnte einen Snack vertragen, h�!",
				LOW   = "L�ute die Essensglocke!",
				EMPTY = "Ich verhungere!",
			},
			SANITY = {
				FULL  = "Alles gut an der Nordgrenze!",
				HIGH  = "Immernoch gut in der R�be.",
				MID   = "Ich glaub ich brauch nen Nickerchen, h�!",
				LOW   = "Haut ab ihr Alptraumtrampel!",
				EMPTY = "Alle meine Schrecken sind echt, und tun weh!",
			},
			HEALTH = {
				FULL  = "Fit wie eine Trillerpfeife!",
				HIGH  = "Was dich nicht umbringt macht dich nur st�rker, h�?",
				MID   = "K�nnte etwas Gesundheit vertragen.",
				LOW   = "Das f�ngt echt an weh zu tun, h�...",
				EMPTY = "Legt mich zur Ruhe... im Wald...",
			},
			WETNESS = {
				FULL  = "Viel zu nass selbst zum B�ume f�llen, h�?",
				HIGH  = "Schottenstoff ist nicht genug bei dieser N�sse.",
				MID   = "Ich werde richtig nass, h�?",
				LOW   = "Der Schotten�berwurf ist warm, selbst wenn er nass ist.",
				EMPTY = "Praktisch kein Tropfen, h�?",
			},
			["LOG METER"] = {
				FULL  = "K�nnte immer nochmehr Holzscheite gebrauchen, aber nicht in meinem Magen, h�?",	-- > 90%
				HIGH  = "Ich sehne mich nach einem �stchen.",						-- > 70%
				MID   = "Holzscheite sehen sehr lecker aus.",									-- > 50%
				LOW   = "Ich f�hle den Fluch ausbrechen.",									-- > 25%
				EMPTY = "Graaww, h�?",	-- < 25% (this shouldn't be possible, he'll become a werebeaver)
			},
		},
		WEREBEAVER = {
			-- HUNGER = { -- werebeaver doesn't have hunger
				-- FULL  = "",
				-- HIGH  = "",
				-- MID   = "",
				-- LOW   = "",
				-- EMPTY = "",
			-- },
			SANITY = {
				FULL  = "Die Augen vom Biest sind weit offen und wachsam.",
				HIGH  = "Das Biest zwinkert den Alptr�umen zu.",
				MID   = "Das Biest dreht sich nach unsichtbaren Sachen um.",
				LOW   = "Das Biest zittert und die Augen flackern.",
				EMPTY = "Das Biest knurrt und scheint von multiplizierenden Alptr�umen verfolgt zu werden.",
			},
			HEALTH = {
				FULL  = "Das Biest h�pft lebhaft.",
				HIGH  = "Das Biest hat ein paar Schrammen.",
				MID   = "Das Biest leckt seine Wunden.",
				LOW   = "Das Biest wiegt seine Pfote.",
				EMPTY = "Das Biest humpelt l�cherlich.",
			},
			WETNESS = {
				FULL  = "Das Fell vom Biest ist komplett durchn�sst.",
				HIGH  = "Das Biest hinterl�sst eine Spur von kleinen Pf�tzen.",
				MID   = "Das Fell vom Biest ist ein bischen nass.",
				LOW   = "Das Biest tropft ein wenig.",
				EMPTY = "Das Fell vom Biest ist trocken.",
			},
			["LOG METER"] = {
				FULL  = "Das Biest sieht fast menschlich aus.",				-- > 90%
				HIGH  = "Das Biest kaut an einem Holzhappen.",		-- > 70%
				MID   = "Das Biest kaut an einem Zweig.",					-- > 50%
				LOW   = "Das Biest guckt gefr��ig auf diese B�ume.",	-- > 25%
				EMPTY = "Das Biest sieht durchsichtig aus.",						-- < 25%
			},
		},
	},
	WES = {
		HUNGER = {
			FULL  = "*t�tschelt den Magen zufrieden*",
			HIGH  = "*t�tschelt den Magen*",
			MID   = "*bringt die Hand zum offnenen Mund*",
			LOW   = "*bringt die Hand zum offnenen Mund, Augen weitend*",
			EMPTY = "*umklammert eingefallenen Magen mit einem verzweifelten Ausdruck*",
		},
		SANITY = {
			FULL  = "*gr��t*",
			HIGH  = "*daumen hoch*",
			MID   = "*reibt die Schl�fe*",
			LOW   = "*blickt wie wahnsinnig umher*",
			EMPTY = "*wiegt Kopf, vor und zur�ckwippend*",
		},
		HEALTH = {
			FULL  = "*t�tschelt das Herz*",
			HIGH  = "*f�hlt Puls, Daumen hoch*",
			MID   = "*bewegt Hand um den Arm, als ob er ihn verbindet*",
			LOW   = "*wiegt den Arm*",
			EMPTY = "*schwankt dramatisch, dann f�llt um*",
		},
		WETNESS = {
			FULL  = "*schwimmt wie wahnsinnig nach oben*",
			HIGH  = "*schwimmt nach oben*",
			MID   = "*schaut ver�chtlich in den Himmel*",
			LOW   = "*versteckt Kopf unter Armen*",
			EMPTY = "*grinst, h�lt unsichtbaren Regenschirm*",
		},
	},
	WAXWELL = {
		HUNGER = {
			FULL  = "Ich hatte ein richtiges Festmahl.",
			HIGH  = "Ich bin satt, aber nicht �berm��ig.",
			MID   = "Ein Snack scheint bestellt zu sein.",
			LOW   = "Ich bin Leer im Inneren.",
			EMPTY = "Nein! Ich hab meine Freiheit nicht erlangt nur um hier zu verhungern!",
		},
		SANITY = {
			FULL  = "Adretter gehts nichtmehr.",
			HIGH  = "Mein normalerweise standhafter Intellekt scheint... schwankend.",
			MID   = "Aua. Mein Haupt schmerzt.",
			LOW   = "Ich muss meinen Kopf freikriegen, Ich fange an ... SIE .. zu sehen.",
			EMPTY = "Hilfe! Diese Schatten sind echte Biester, wei�t du!",
		},
		HEALTH = {
			FULL  = "Ich bin total unverletzt.",
			HIGH  = "Ist nur ne kleine Schramme.",
			MID   = "Ich muss mich vielleicht zusammenflicken.",
			LOW   = "Das ist nicht mein Schwanenlied, aber nah dran.",
			EMPTY = "Nein! Ich bin nicht entkommen nur um hier zu sterben!",
		},
		WETNESS = {
			FULL  = "Nasser als Wasser.",
			HIGH  = "Ich glaub nicht ich werde jemals wieder trocken.",
			MID   = "Dieser Regen wird meinen Anzug ruinieren.",
			LOW   = "Dampf ist nicht gediegen.",
			EMPTY = "Trocken und adrett.",
		},
	},
	WEBBER = {
		HUNGER = {
			FULL  = "Beide unserer M�gen sind gef�llt!",				-- >75%
			HIGH  = "Wir k�nnten ein Nippelchen mehr essen.",					-- >55%
			MID   = "Wir glauben es ist langsam Mittagszeit!",			-- >35%
			LOW   = "Wir k�nnten jetzt sogar Moms Reste essen...",-- >15%
			EMPTY = "Unsere B�uchlein sind leer!",						-- <15%
		},
		SANITY = {
			FULL  = "Wir f�hlen uns sehr gut ausgeruht!",							-- >75%
			HIGH  = "Ein Nickerchen w�rde nicht Schaden.",							-- >55%
			MID   = "Unsere K�pfe tun weh...",							-- >35%
			LOW   = "Wann war die letzde Zeit wenn wir Nickerchen hatten?!",	-- >15%
			EMPTY = "Wir f�rchten uns nicht vor euch, schaurige Dinger!",		-- <15%
		},
		HEALTH = {
			FULL  = "Wir haben nicht mal ne Schramme!",				-- 100%
			HIGH  = "Wir brauchen bald nen Pflaster.",				-- >75%
			MID   = "Wir brauchen mehr als Pflaster...",	-- >50%
			LOW   = "Unser K�rper schmerzt...",							-- >25%
			EMPTY = "Wir wollen noch nicht sterben...",					-- <25%
		},
		WETNESS = {
			FULL  = "W��h, wir sind durchn�sst!", 						-- >75%
			HIGH  = "Unser Fell ist durchn�sst!",							-- >55%
			MID   = "Wir sind nass!", 									-- >35%
			LOW   = "Wir sind unangenehm feucht.", 					-- >15%
			EMPTY = "Wir lieben in Pf�tzen zu spielen.", 					-- <15%
		},
	},
	WATHGRITHR = {
		HUNGER = {
			FULL  = "Ich hungere nach Schlachten, nicht Fleisch!", 				-- >75%
			HIGH  = "Ich bin ges�ttigt genug f�r die Schlacht.",					-- >55%
			MID   = "Ich k�nnte nen Fleischhappen vertragen.", 					-- >35%
			LOW   = "Ich sehne mich nach einem Festmahl!", 							-- >15%
			EMPTY = "Ich verhungere ohne ein Mahl!", 				-- <15%
		},
		SANITY = {
			FULL  = "Ich f�rchte keine Sterblichen!", 							-- >75%
			HIGH  = "Ich f�hle mich besser im Kampf!", 					-- >55%
			MID   = "Meine Gedanken wandern...", 							-- >35%
			LOW   = "Diese Schatten dringen durch meinen Speer...", -- >15%
			EMPTY = "Bleibt zur�ck, Biester der Dunkelheit!", 				-- <15%
		},
		HEALTH = {
			FULL  = "Meine Haut ist undurchdringlich!", 					-- 100%
			HIGH  = "Ist ja nur ne Fleischwunde!", 					-- >75%
			MID   = "Ich bin verwundet, aber ich kann noch k�mpfen.", 			-- >50%
			LOW   = "Ohne Hilfe, werde ich bald in Walhalla verweilen...", 	-- >25%
			EMPTY = "Meine Saga erreicht sein Ende...", 					-- <25%
		},
		WETNESS = {
			FULL  = "Ich bin komplett feucht!", 					-- >75%
			HIGH  = "Ein Krieger so feucht kann nicht k�mpfen!",				-- >55%
			MID   = "Meine R�stung wird rosten!", 							-- >35%
			LOW   = "Ich brauche kein Bad danach.", 				-- >15%
			EMPTY = "Staubtrocken f�r den Kampf!", 						-- <15%
		},
	},
	WINONA = {
		HUNGER = {
			FULL  = "Ich hatte schon meine anst�ndige Mahlzeit f�r den Tag.",
			HIGH  = "Ich hab immer Platz f�r mehr Fra�!",
			MID   = "Darf ich bitte in die Mittagspause?",
			LOW   = "Ich geh schon auf dem Zahnfleisch, Chef.",
			EMPTY = "Die Fabrik wird einen Arbeiter verlieren wenn ich nicht schnell Fra� kriege!",
		},
		SANITY = {
			FULL  = "So vern�nftig wie immer.",
			HIGH  = "Alles gut unter der Motorhaube!",
			MID   = "Ich glaube ich hab paar Schrauben locker...",
			LOW   = "Mein Verstand ist gebrochen, Ich sollte ihn selbst reparieren.",
			EMPTY = "Dies ist ein Alptraum! Haha! Ich meins ernst.",
		},
		HEALTH = {
			FULL  = "Ich bin genauso gesund wie ein Pferd!",
			HIGH  = "Eh, Ich werds abarbeiten.",
			MID   = "Ich kann jetzt nicht aufgeben.",
			LOW   = "Kann ich endlich meine Betriebsrente einsacken...?",
			EMPTY = "Ich glaub meine Schicht ist zu Ende...",
		},
		WETNESS = {
			FULL  = "Ich kann SO nicht arbeiten!",
			HIGH  = "Mein Blaumann sammelt Feuchtigkeit an!",
			MID   = "Jemand sollte ein Schild: Vorsicht Rutschgefahr! aufstellen.",
			LOW   = "Sorgen Sie immer f�r einen ausgeglichenen Fl�ssigkeitshaushalt w�hrend der Arbeit.",
			EMPTY = "Das ist nichts.",
		},
	},
	WARLY = {
		HUNGER = {
			FULL  = "Meine Kochkunst ist mein Verderben!", 	-- >75%
			HIGH  = "Ich glaube ich hatte genug, f�r jetzt.",			-- >55%
			MID   = "Zeit f�r Abendessen plus Nachtisch.", 	-- >35%
			LOW   = "Ich hab das Abendbrot verpasst!", 				-- >15%
			EMPTY = "Verhungern... der schlimmste Tod!", 			-- <15%
		},
		SANITY = {
			FULL  = "Das exquisite Aroma meiner Kochkunst h�lt mich gesund.", 			-- >75%
			HIGH  = "Ich f�hle mich etwas benebelt.", 				-- >55%
			MID   = "Ich kann nicht klar denken.", 				-- >35%
			LOW   = "Das Fl�stern... helft mir!", 			-- >15%
			EMPTY = "Ich kann diesen Wahnsinn nicht l�nger aushalten!", 	-- <15%
		},
		HEALTH = {
			FULL  = "Ich bin komplettfit.", 	-- 100%
			HIGH  = "Es war schlimmer als ich Zwiebeln geschnitten habe.", 	-- >75%
			MID   = "Ich blute...", 			-- >50%
			LOW   = "Ich k�nnte einen Verband gebrauchen!", 	-- >25%
			EMPTY = "Glaube dies ist das Ende, alter Freund...", 	-- <25%
		},
		WETNESS = {
			FULL  = "Ich f�hle die Fische in meiner Kleidung schwimmen.", 	-- >75%
			HIGH  = "Wasser wird meine exquisiten Speisen verderben!",					-- >55%
			MID   = "Ich sollte meine Kleidung trocknen bevor ich mich erk�lte.", 				-- >35%
			LOW   = "Dies ist nicht die Zeit oder der Ort f�r ein Bad.", 		-- >15%
			EMPTY = "Nur ein paar Spritzer, kein Problem.", 				-- <15%
		},
	},
	WALANI = {
		HUNGER = {
			FULL  = "Mmmm lecker, das war ein Festmahl des Himmels.", 	-- >75%
			HIGH  = "Ich k�nnte immernoch einen Snack vertragen.",			-- >55%
			MID   = "Essen, Essen, Essen!", 	-- >35%
			LOW   = "Mein Magen wird implodieren!", 				-- >15%
			EMPTY = "Bitte... irgendwas zu essen!", 			-- <15%
		},
		SANITY = {
			FULL  = "Es gibt nichts besseres als Surfen um mich fit zu halten.", 			-- >75%
			HIGH  = "Das Meer ruft mich.", 				-- >55%
			MID   = "Meinem Kopf wirds schwindelig.", 				-- >35%
			LOW   = "Uff! Ich brauch mein Surfbrett!", 			-- >15%
			EMPTY = "Was sind diese... Dinger?!", 	-- <15%
		},
		HEALTH = {
			FULL  = "Hab mich niemals besser gef�hlt.", 	-- 100%
			HIGH  = "Ein paar Schrammen, kein gro�es Brimborium.", 	-- >75%
			MID   = "Ich k�nnte etwas Heilung vertragen!", 			-- >50%
			LOW   = "F�hlt sich an als ob meine Eingeweide aufgegeben haben.", 	-- >25%
			EMPTY = "Jeder einzelne Knochen in meinem K�rper ist zersplittert!", 	-- <25%
		},
		WETNESS = {
			FULL  = "Ich bin durch und durch feucht!", 	-- >75%
			HIGH  = "Meine Kleidung scheint ziemlich feucht zu sein.",					-- >55%
			MID   = "Ich brauch gleich mal ein Handtuch.", 				-- >35%
			LOW   = "Ein bischen Feuchtigkeit hat noch niemanden geschadet.", 		-- >15%
			EMPTY = "Ich sehe einen Sturm aufziehen!", 				-- <15%
		},
	},
	WOODLEGS = {
		HUNGER = {
			FULL  = "Harr, das war ein tolles Mahl, B�rschchen!", 	-- >75%
			HIGH  = "Mein B�uchlein ist ziemlich voll.",			-- >55%
			MID   = "Es ist Zeit f�r mein t�gliches Mahl.", 	-- >35%
			LOW   = "Aye! Ihr Gesindel, wo ist mein Mahl!?", 				-- >15%
			EMPTY = "Ich werd zu Tode verhungern!", 			-- <15%
		},
		SANITY = {
			FULL  = "Aye, die See, sie ist eine Sch�nheit!", 			-- >75%
			HIGH  = "Zeit f�r einen Ritt auf der See!", 				-- >55%
			MID   = "Ich vermisse meine liebe See...", 				-- >35%
			LOW   = "Kann mich nicht an das letzte Mal segeln erinnern.", 			-- >15%
			EMPTY = "Ich bin ein S�bel rasselnder Piratenkapit�n, nicht eine Landratte!", 	-- <15%
		},
		HEALTH = {
			FULL  = "Harr, Ich bin eine harte Nuss zu knacken!", 	-- 100%
			HIGH  = "War das schon alles?", 	-- >75%
			MID   = "Ich geb nochnicht auf!", 			-- >50%
			LOW   = "Woodlegs ist kein Angsthase!", 	-- >25%
			EMPTY = "Yarr! Du gewinnst, Gesinde!", 	-- <25%
		},
		WETNESS = {
			FULL  = "Ich bin bis auf die Knochen durchn�sst!", 	-- >75%
			HIGH  = "Ich mag wenn die Gischt 'unter dem Bug' bleibt.",					-- >55%
			MID   = "Mein Matrosenhemd f�llt sich mit Wasser.", 				-- >35%
			LOW   = "Meine Kniebundhose ist durchn�sst!", 		-- >15%
			EMPTY = "Yarr! Ein Sturm braut sich zusammen.", 				-- <15%
		},
	},
	WILBUR = {
		HUNGER = {
			FULL  = "*h�pft herum in die H�nde klatschend*", 	-- >75%
			HIGH  = "*klatscht gl�cklich in die H�nde*",			-- >55%
			MID   = "*krault seinen Bauch*", 	-- >35%
			LOW   = "*guckt traurig und krault Bauch*", 				-- >15%
			EMPTY = "OOAOE! *reibt Bauch*", 			-- <15%
		},
		SANITY = {
			FULL  = "*klopft auf den Kopf*", 			-- >75%
			HIGH  = "*zeigt Daumen hoch*", 				-- >55%
			MID   = "*schaut schreckhaft*", 				-- >35%
			LOW   = "*schreit gespenstisch*", 			-- >15%
			EMPTY = "OOAOE! OOOAH!", 	-- <15%
		},
		HEALTH = {
			FULL  = "*trommelt auf die Brust mit beiden H�nden*", 	-- 100%
			HIGH  = "*trommelt auf die Brust*", 	-- >75%
			MID   = "*streichelt sanft Flecken mit ausgefallenem Fell*", 			-- >50%
			LOW   = "*humpelt mitleiderregend*", 	-- >25%
			EMPTY = "OAOOE! OOOOAE!", 	-- <25%
		},
		WETNESS = {
			FULL  = "*nie�t*", 	-- >75%
			HIGH  = "*reibt H�nde zusammen*",					-- >55%
			MID   = "Ooo! Ooae!", 				-- >35%
			LOW   = "Oooh?", 		-- >15%
			EMPTY = "Ooae Oooh Oaoa! Ooooe.", 				-- <15%
		},
	},
}