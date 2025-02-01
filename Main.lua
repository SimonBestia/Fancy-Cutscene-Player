--[[ Fancy Cutscene Player
	-- By SimonBestia
		-- Special thanks to derpy54320
		-- //                Microsoft Copilot
]]

-- Do NOT touch!!!! (pls)
LoadScript('thumbnails.lua')
require('utility/texture')

local ar = GetDisplayAspectRatio()
local sx, sy, sz, sh, sa = SystemGetSavedPositionInformation()
local chapterSelected = false
local scrollOffset = 0
local chapname
local cutsceneThumbnails = {}
local cutsceneThumbnailsToLoad = {
	'1-01', '1-02B', '1-02D', '1-02E', '1-03', '1-04', '1-05', '1-06', '1-06B', '1-07', '1-08', '1-09', '1-1-1', '1-1-2', '1-10', '1-11', '1-B', '1-BB', '1-BC', '1-G1', '1-S01',
	'2-0', '2-01', '2-02', '2-03', '2-03b', '2-04', '2-05', '2-06', '2-07', '2-08', '2-09', '2-09B', '2-B', '2-BB', '2-G2', '2-S02', '2-S04', '2-S05', '2-S05B', '2-S05C', '2-S06', '2-S07',
	'3-0', '3-01', '3-01AA', '3-01AB', '3-01BA', '3-01CA', '3-01CB', '3-01DA', '3-01DB', '3-01DC', '3-02', '3-S10', '3-04', '3-04B',  '3-G3', '3-05', '3-06', '3-B', '3-BB', '3-BC', '3-BD', '3-R05A', '3-R05B', '3-S03',
	'4-0', '4-02', '4-B1', '4-B1D', '4-04', '4-03', '4-G4', '4-05', '4-06', '4-B2', '4-B2B', '4-S12', '4-S12B', '3-S11', '3-S11C',
	'5-0', '5-01', '5-02', '5-02B', '5-03', '5-04', '5-05', '5-05B', '5-06', '5-07', '5-09', '5-09B', '5-B', '5-BC', '5-G5', '6-0', '6-02', '6-02B', '6-B', '6-B2', '6-BB', '6-BC',
	'1-1', '2-09A', '3-03', '4-B1B', '4-B1C', '', 'CS_COUNTER', 'FX-TEST', 'TEST', 'weedkiller'
}
local cutsceneDescriptions = {

	['1-01'] = 'In the REAL beginning...',
	--['1-02'] = '',
	['1-02B'] = 'Jimmy makes his first friend at the academy: Gary Smith.',
	--['1-02C'] = '',
	['1-02D'] = 'The zoo of Bullworth Academy.\nMeet the Nerds, the Preppies, the Greasers, and the Jocks.',
	['1-02E'] = 'Pete Kowalski introduces himself to Jimmy.\nHe and Gary already seem to get along... thus the trio is born.',
	['1-03'] = "Jimmy is ambushed by Davis for being a teacher's pet.\nJimmy, very appropriately, teaches him a lesson as one.",
	['1-04'] = "Gary shares his true intentions of taking over the school.",
	['1-05'] = 'Jimmy is wandering in the library when he comes across Algernon.\nHe needs help from a librarian such as Jimmy.',
	['1-06'] = 'Gary has a habit of picking on Pete when bored.\nAfter being stopped by Jimmy, they all decide to pick on the elderly, instead.',
	['1-06B'] = 'When the elderly turns out to be a war veteran, Jimmy chooses to befriend him.\nHe needs help gathering some radio parts.',
	['1-07'] = 'Gary, Pete, and Jimmy are hanging out in the dorm when Algie arrives.\nHis friend Bucky is being bullied by non other than the bullies themselves.',
	['1-08'] = "Jimmy is hanging out in the girls' dorm, as boys normally do.\nHe sees the popular girl Mandy stealing Beatrice's notes and offers to get them back when Beatrice threatens to tell on him.",
	['1-08B'] = 'Description for ID',
	['1-09'] = "It's time to vote, with Earnest and Ted representing the two only choices.\nHow fair is this election? Who will Jimmy side with?",
	--['1-09B'] = '',
	--['1-1-02'] = '',
	['1-1-1'] = 'In the beginning there was Jimmy Hopkins...',
	['1-1-2'] = "Jimmy meets Bullworth Academy's headmaster: Dr. Crabblesnitch.\nDespite Jimmy's past record, Dr. Crabblesnitch has a good feeling about him.",
	['1-1'] = 'An incomplete version of 1-10.',
	['1-10'] = 'Jimmy finds Gary in an impatient mood. When he sees him, Gary rushingly says he has big plans, as usual.\nWait... did he say something about not taking his medications?',
	['1-11'] = "It's Halloween: everyone's favourite prankster holiday and the prefects are away...",
	['1-B'] = 'In a major plot twist, Gary no longer has any use for Jimmy.\nHe throws him and the biggest school bully, Russell, in "The Hole".',
	['1-BB'] = 'Russell wins. Our protagonist has failed...',
	['1-BC'] = 'Jimmy takes down Russell and questions Gary. He never cared for friendship...\nWill Jimmy and Pete manage by themselves and their new friend Russell?',
	['1-G1'] = 'Beatrice has her diary taken away by Mr. Hattrick.\nThe amount of fantasies involving Jimmy makes him decide to help.',
	['1-S01'] = "Mr. Hattrick and Mr. Galloway are fighting again. This time Hattrick is upset at Galloway's drinking problems.\nJimmy decides to help dealing with that hypocrite.",
	['2-0'] = 'After hearing things about him and "farmyard animals", Crabblesnitch gives Jimmy an errand.\nMeanwhile, Gord and the preppies take an interest to Jimmy after defeating Russell.',
	['2-01'] = "Jimmy's errand is to help out Edna, who is in charge of the cafeteria.\nShe shows only the highest respect towards the quality of the menu at the academy.",
	['2-02'] = 'Jimmy sees Zack having an asthma attack after a kid ran out of his store with some comics.\nZack asks Jimmy to retrieve them in exchange for money and comics.',
	['2-03'] = 'The preppies invite Jimmy on a revenge hit on Hattrick for bullying Galloway.\nGet some eggs and get ready to egg his house. Smashing!',
	['2-03b'] = 'Gary appears and spoils the plans by spreading lies about Jimmy to the preppies.\nWith reasoning out of the way, Jimmy has no option but fight his way out.',
	['2-04'] = 'Jimmy finds Pete all alone in the dorm. He misses the times of hanging around Jimmy and Gary.\nWhen Pete tells Jimmy of a bike race everyone is at, Jimmy decides to take him along.',
	['2-04B'] = 'Description for 2-04B',
	['2-05'] = "Jimmy sees Russell picking on Oh outside of his store.\nAfter clearing some misunderstandings, Jimmy grabs Russell and some eggs to go egg Tad's house.",
	['2-06'] = 'Pinky sees Jimmy wandering around Old Bullworth Vale and uses that opportunity to her advantage.\nJimmy bows to the princess and helps her getting the best seat in the theatre.',
	['2-07'] = 'Jimmy goes to claim the trophy for winning the bike race. It even has his name misspelt!\nThe preppies unexpectedly show up to steal it, however. Get it back!',
	['2-08'] = 'Dr. Slawter calls Jimmy for a favour. Apparently the Harringtons got themselves a Crapula Maxima Fortisima.\nHe teaches him about the two sides to biology in his proposition to kill it.',
	['2-09'] = 'Pete helps Jimmy find a way to get revenge on the preppies once and for all.\nHe suggests defeating their renowned boxing champion, Bif Taylor, at their own game.',
	['2-09A'] = 'An incomplete version of 2-08.',
	['2-09B'] = 'The boxing match begins.\nWill Jimmy defeat Bif and earn respect from the preppies?',
	['2-B'] = 'Jimmy defeats Bif in a fair match, but the preppies are not happy as they declare him unfit for a champion.',
	['2-BB'] = "Jimmy defeats everyone else, as well, finally earning the preppies' respect.",
	['2-G2'] = 'Pinky is dumped by her cousin Derby when she notices he is three minutes late.\nJimmy takes it further with the princess by proposing to go on a date with him, instead.',
	['2-S02'] = "Jimmy finds Mr. Galloway drunk again in his class. He has been under pressure due to Hattrick's claims.\nJimmy proposes a plan to give him something to actually complain about.",
	['2-S04'] = 'Melvin is rather distressed; some ruffians have stolen important papers of his.\nCan Jimmy earn his reward by recovering them all?',
	['2-S05'] = "Edna is getting ready to go on a date with Dr. Watts, who doesn't even know.\nShe asks Jimmy to get some items for her.",
	['2-S05B'] = 'Jimmy brings back the items to Edna and finds her looking "fantastic".\nEdna asks for another favour of watching out for her during the date. Kids like to ruin everything, after all.',
	['2-S05C'] = 'After a successful date, Edna brings Dr. Watts to a hotel to show what she knows about "chemistry" and "biology".',
	['2-S06'] = 'Jimmy comes across Burton in front of an adult store, who is collecting "research" on the dangers of dirty magazines.\nEmbarassed, he asks Jimmy to collect the "laundry" he forgot to collect while busy with such "research".',
	['2-S07'] = 'Brandy is fed up with societal stereotypes of the little people and is seen by Jimmy destroying some garden gnomes.\nShe desperately requests to destroy every gnome he comes across.',
	['3-0'] = 'Pete and Jimmy are playing darts in the dorm discussing what to do next, when Peanut asks Jimmy to help Johnny.\nDespite an initial refusal from Jimmy, Pete suggests befriending him in order to get back at Gary.',
	['3-01'] = 'Jimmy goes to see Johnny, who at first blames Jimmy for going out with Lola, suspecting her of cheating on him.\nAfter some reasoning, Jimmy agrees to help in finding evidence of her cheating on Johnny with the preppie Gord.',
	['3-01AA'] = 'Jimmy is taking a stroll in New Coventry when an homeless person, Rudy, engages in a conversation.\nHe talks about kids throwing snowballs at him, so Jimmy helps by throwing snowballs at them as they did to Rudy.',
	['3-01AB'] = 'Overflown with joy, Rudy thanks Jimmy as he collapses to the ground.',
	['3-01BA'] = "Jimmy finds Rudy again in an alley being upset about an imposter Santa who charges people for taking pictures with him.\nRudy tasks Jimmy with putting an end to the imposter's business so Rudy can start his own.",
	['3-01CA'] = 'Ms. Peters is desperate after the lead percussionist of the Christmas pageant gets appendicitus.\nForced to, Jimmy agrees to participate and give the pageant some rhythm.',
	['3-01CB'] = 'Anxiety hits Jimmy as he realises he has to perform in front of a crowd of parents.\nWill his music skills be enough to save Christmas?',
	['3-01DA'] = 'Jimmy visits Rudy as he gets his photo-shoot business ready.\nBefore they can get to it, however, they need to up the Christmas spirit of their workshop.',
	['3-01DB'] = 'Jimmy finds some more props for the workshop and gets to work to make Rudy and himself rich.\nHopefully photography class has paid off.',
	['3-01DC'] = 'Rudy is so surprised to see how much money they made he accidentally slips of his "old days at the track".\nHe pays Jimmy and leaves without a decent explanation.',
	['3-02'] = 'Having found evidence, Johnny decides to teach Gord a lesson by baiting him into the BMX park.',
	['3-03'] = 'The cutscene for the scrapped mission called "Rendezvous".\nLola wants Jimmy to watch out for Tad while she is being helped with... homework.',
	['3-04'] = "Earnest calls Jimmy in the hopes of helping Algie, who is also suspected by Johnny for going out with Lola.\nThat's crazy... Everyone knows Algie likes blondes!",
	['3-04B'] = "Jimmy finds both Algie and Chad at Lola's house, where they both get dumped.\nThey then rush back to the academy as every greaser chases after them.",
	['3-05'] = 'Jimmy finds Lola all alone after the greasers distance themselves from her.\nLeft with nothing, she asks Jimmy to retrieve some items left at the abandoned tenements.',
	['3-06'] = 'Upset with Jimmy for not doing enough, Lola tells him of a big fight between the greasers and the preppies with her at the centre.\nJimmy sees the opportunity to stop this rivalry and take down the greasers.',
	['3-B'] = 'After defeating the greasers, Jimmy is confronted by an enraged Johnny, who now feels both backstabbed and heartbroken.',
	['3-BB'] = 'Running away from the police, Jimmy finds himself cornered at the Junkyard by the greasers.',
	['3-BC'] = 'A mid-fight cutscene for "Fighting Johnny Vincent".',
	['3-BD'] = 'Jimmy defeats Johnny and the rest of the greasers.\nReluctantly ready to give up Lola, Johnny is surprised to hear it was never about her and is simply told to back off.',
	['3-G3'] = "When Jimmy goes to see Johnny at Lola's house, he finds him in a bad mood and immediately gets the wrong idea.\nLola suggests a bike race to settle who's faster once and for all.",
	['3-R05'] = 'Description for 3-R05',
	['3-R05A'] = 'Jimmy finds Dr. Watts in his class under the effects of something after being called by him.\nHe asks Jimmy to quickly deliver some "chemicals with certain properties".',
	['3-R05B'] = 'Jimmy reports back to Dr. Watts after delivering all the packages.\nThey were just full of hair growth formula... or were they?',
	['3-R07'] = "Jimmy is minding his business when Clint pushes him for fun.\nTo avoid any trouble, he fulfills Clint's wish when he offers an ultimatum of a bike or a fight.",
	['3-S03'] = 'Jimmy finds Mr. Galloway about to drink again despite his promise to quit. Mr. Hattrick is the cause as usual.\nShocked to learn he sells homework, Jimmy offers to catch him in the act, so Mr. Galloway can quit drinking for good.',
	['3-S08'] = 'Clint: a crazy Dropout who does not take kindly to strangers, particularly rich kids.\nHe orders Jimmy to destroy mailboxes in Old Bullworth Vale.',
	['3-S10'] = 'The preppies ask Jimmy to handle the greasers who are being too aggressive with Gord.\nGiven his passion for graffiti, he accepts.',
	['3-S11'] = 'Mr. Galloway never returned from the date. Hattrick guilt-tripped him into committing himself into the asylum.\nJimmy offers to go and rescue him back, as Ms. Philips is prohibited from doing so.',
	['3-S11C'] = 'Jimmy finds Mr. Galloway in a cell, starting to lose himself and thinking Hattrick was right.\nAfter some persuasion, Jimmy convinces him to leave.',
	['4-0'] = "Jimmy and Pete are taking a walk enjoying some peace, when suddenly some jocks ruin the day.\nThey are next on Jimmy and Pete's radar.",
	['4-01'] = 'Earnest calls Jimmy for his first mission as the new leader.\nHe insists on getting inappropriate pictures of the popular girl Mandy. All for the sake of the plan, of course.',
	['4-02'] = 'Jimmy tries to approach the nerds for help against the jocks, unsuccessfully.\nPete, who happens to be around, suggests using brute force.',
	['4-03'] = "The jocks launch an invasion to get back at the nerds for their previous meddling and for Mandy's sake.\nWhile Earnest is too panicked to do anything, Jimmy grabs a spud gun and goes to fight back.",
	['4-04'] = 'The nerds tell Jimmy, in multiple languages, a way to get back at the jocks.\nThey suggest taking control of a funhouse the jocks will be at. Scary.',
	['4-05'] = "Earnest calls Jimmy for his final plan on getting revenge on the jocks.\nThe first step? Steal the team's mascot outfit.",
	['4-06'] = 'Jimmy catches Earnest reading an inappropriate magazine, or personal history, as Earnest calls it.\nMore importantly, he tells Jimmy about the final step of taking down the jocks: Operation Trojan Cow.',
	['4-B1'] = "After dealing with all the other nerds, Jimmy confronts Earnest at the old observatory.\nIt's brains against brawn.",
	['4-B1B'] = 'A mid-fight cutscene for "Nerd Boss Fight".',
	['4-B1C'] = 'A mid-fight cutscene for "Nerd Boss Fight".',
	--['4-B1C2'] = '',
	['4-B1D'] = "Jimmy's brawn ends up winning against Earnest's brains.\nJimmy tells Earnest he won't do them any wrong and just wants to get revenge on the jocks.",
	['4-B2'] = 'Jimmy almost single-handedly ruins the prep work for The Big Game and reveals his identity in front of everyone.\nAll that remains is defeating the football team.',
	['4-B2B'] = 'Jimmy beats the football team at their own game, finally earning the respect of every clique at the academy.',
	['4-G4'] = 'Jimmy finds Mandy alone in the gym who, after the posters fiasco, is just about ready to give up on life.\nFeeling remorse, Jimmy offers to cover up all the posters.',
	--['4-S11'] = '',
	['4-S12'] = 'Jimmy visits Ms. Philips and sees her new painting. While he is more into in music, Ms. Philips respects that.\nAs she draws comparisons with real love and asks for a favour, Jimmy gets the wrong idea.',
	['4-S12B'] = 'Jimmy gets back to Ms. Philips for her favour and finds Mr. Galloway there.\nAs Ms. Philips comes back, it all turned out to be a misunderstanding, and she and Mr. Galloway go on a date.',
	['5-0'] = 'Everyone is finally getting along and Jimmy is living the life.\nPete wants to keep him grounded, though. Gary could be planning something.',
	['5-01'] = 'Jimmy goes to the library only to be surrounded by nerds blaming him for everything.\nThe library is infested with rats and they are too scared to get rid of them.',
	['5-02'] = "Jimmy finds the preppies mad at him for stealing their trophies.\nThey quickly point the finger at the greasers when Jimmy says he's innocent.",
	['5-02B'] = 'Jimmy returns with evidence proving it was the townies, but the preppies dismiss it and leave.',
	['5-03'] = 'Jimmy walks on Lola and Norton in the middle of a heated argument about the disappearance of Johnny.\nApparently some orderlies may have picked him up.',
	['5-04'] = "Jimmy is walking around the jocks' territory when Mr. Burton points out the gym is on fire.\nWhile accused over something he never cared for, Jimmy offers to step inside and rescue the trapped students.",
	['5-05'] = 'Jimmy meets a girl named Zoe in Blue Skies. She used to be a student but was expelled due to Mr. Burton.\nTogether, they come up with a plan to make him pay.',
	['5-05B'] = 'The plan is a success and makes for a memorable experience... for Burton.',
	['5-06'] = 'Expelled and with no respect, Jimmy gives up on Bullworth Academy and admits having lost to Gary.\nPete convinces him to not give up and visit Russell for help against the townies.',
	['5-07'] = 'A cutscene for "Busting In".\nJimmy, motivated back by Pete, comes up with a plan to deal with the leader of the townies: Edgar.',
	['5-09'] = "Basking in adulation, Jimmy is hanging with all the clique leaders, when Pete comes to ruin the party and warn about Gary.\nIgnoring him, Jimmy decides to leave his mark on the town's hall.",
	['5-09B'] = "Jimmy returns only to find Pete in a rush. He tells Jimmy all the cliques are now against each other again.\nGary must have used Jimmy's absence as an opportunity. Should have listened to Pete beforehand...",
	['5-B'] = 'A mid-fight cutscene for "Showdown At the Plant".\nJimmy already knows Gary is behind the recent behaviour of the townies.',
	['5-BC'] = 'Jimmy defeats Edgar, but they never needed to fight. Edgar was tricked by Gary just like Jimmy.\nThe two team up and decide to get back at Gary.',
	['5-G5'] = 'Jimmy and Zoe are enjoying their time and Zoe suggests a little game.\nWhoever can smash the most expensive Spencer Shipping property wins.',
	['6-0'] = "After all the issues on campus, Jimmy gets called to the Principal's Office, for the last time.\nGary snitched on Dr. Crabblesnitch, pushing him to expell Jimmy altogether.",
	['6-02'] = 'Getting sidetracked in Blue Skies, Jimmy is shocked to learn from Zoe that a faction war started at the Academy.\nJimmy quickly snaps back to duty and decides to meet up with Russell and Edgar.',
	['6-02B'] = 'Jimmy and Russell head back to the Academy to find Edgar and his buddies.\nThe plan is bust in and beat everyone the old-fashioned way.',
	['6-B'] = "Jimmy chases Gary all the way to the school's rooftop to confront Gary.\nIt is time to finish this.",
	['6-B2'] = 'An incomplete version of 2-08.',
	['6-BB'] = 'Cornered by Jimmy, Gary explains his reasoning, revealing his superiority complex.\nIn a grapple attempt, they both fall down to the scaffolds and settle their fight there.',
	['6-BC'] = "Jimmy and an unconscious Gary fall into Dr. Crabblesnitch's office. Having heard Gary's speech, Crabblesnitch expells him.\nHe vows to fire Burton, make Pete the next headmaster, and to let Jimmy back into the academy. Everything is sorted out.",
	['candidate'] = 'Description for candidate',
	['CS_COUNTER'] = 'An incomplete version of 5-09.',
	['FX-TEST'] = 'A basic cutscene with Edna and a cigarette.',
	['TEST'] = 'Just like the previous, but without Edna.',
	['weedkiller'] = 'An incomplete version of 2-08.',

}
local chapters = {}
local cutscenes = {}
local Option1 = true
local Option2 = false
local Option3 = false
local Option4 = false
local Option5 = false
local Option6 = false
local Option7 = false
local Option8 = false
local TblRoofTopProps = {}
local PreviousChapter
local SmokesTable = {}
local FiresTable = {}
local quitmoviemsg

-- Technically customisable settings, but you shouldn't touch either
local MenuSpeed = 170
local currentChapter = 1
local currentCutscene = 1
local cutscenesPerPage = 9

-- Config settings (see config.ini)
local DebugOn
if GetConfigBoolean(GetScriptConfig(), 'use_narcissus', false) then
	SetTextFont('NarcissusOpenSG')
else
	SetTextFont('Arial')
	SetTextBlack()
	SetTextShadow()
end
if GetConfigBoolean(GetScriptConfig(), 'debug_on', true) then
	DebugOn = true -- If true, you can freeroam around while using the menu
	Option1 = false
end
textFormatting = PopTextFormatting()


-- Core
function MissionSetup()

		while not SystemIsReady() do
			Wait(0)
		end
		while AreaIsLoading() or IsStreamingBusy() do
			Wait(0)
		end
		DATLoad('1_01.DAT', 2)
		DATInit()
		ClothingBackup()
		if DebugOn then
			for _, cutsceneID in ipairs(cutsceneThumbnailsToLoad) do
				load_thumbnail(cutsceneID)
			end
			print(tostring(table.getn(cutsceneThumbnailsToLoad)))
		end

end

function main()

		if not DebugOn then
			SetupScene()
		end
		FancyCutscenePlayerLogic()

end

function MissionCleanup()

		CameraFade(500, 0)
		Wait(500)
		StopCutscene()
		F_PostCSClean()
		F_PostCSSpawn()
		PlayerSetControl(1)
		CameraReset()
		CameraReturnToPlayer(false)
		HUDRestoreVisibility()
		SoundStopStream()
		StopPedProduction(false)
		UnpauseGameClock()
		PedSetFlag(gPlayer, 43, true)
		PedSetEffectedByGravity(gPlayer, true)
		SoundRestartAmbiences()
		Wait(500)
		CameraFade(500, 1)

end

-- Actual code
function SetupScene()

		MusicFadeWithCamera(true)
		CameraFade(500, 0)
		Wait(500)
		PedSetFlag(gPlayer, 43, false)
		PedSetEffectedByGravity(gPlayer, false)
		if not DebugOn then
			for _, cutsceneID in ipairs(cutsceneThumbnailsToLoad) do
				load_thumbnail(cutsceneID)
			end
		end
		PauseGameClock()
		SoundPlayStream('MS_ArtClass.rsm', 0.5)
		HUDSaveVisibility()
		HUDClearAllElements()
		px, py, pz, pz2, h, node, cx, cy, cz, clx, cly, clz = DefineSceneValues()
		AreaTransitionXYZ(sa, px, py, pz, true)
		PlayerSetPosSimple(px, py, pz2)
		PedFaceHeading(gPlayer, h, 0)
		PedSetActionNode(gPlayer, '/Global/FancyCutsPlayerNodes/Anims/'..node, 'FancyCutsPlayerNodes.act')
		CameraSetXYZ(cx, cy, cz, clx, cly, clz)
		if (sa == 30 or sa == 57 or sa == 59 or sa == 60 or sa == 61) then
			SoundStopAmbiences()
		end
		CreateThread(function()
			while true do
				PedSetFlag(gPlayer, 43, false)
				PedSetEffectedByGravity(gPlayer, false)
				PlayerSetControl(0)
				Wait(0)
			end
		end)
		Wait(500)
		CameraFade(500, 1)
		ToggleHUDComponentVisibility(42, true)

end

function DefineSceneValues()

		local animgroup
		local px, py, pz
		local pz2
		local h
		local node
		local cx, cy, cz, clx, cly, clz

		if sa == 2 then
			StopPedProduction(true)
			animgroup = '4_06BIGGAME'
			px, py, pz = -634.85, -288.37, 5.65
			pz2 = 5.62
			h = 0
			node = 'ReadBookStand'
			cx, cy, cz, clx, cly, clz = -634.34, -287.31, 7.03, -637.45, -289.90, 6.76
		elseif (sa == 14) or (sa ~= 2 and sa ~= 30 and sa ~= 57 and sa ~= 59 and sa ~= 60 and sa ~= 61) then
			sa = 14
			StopPedProduction(true)
			animgroup = 'Area_GirlsDorm'
			px, py, pz = -492.05, 308.94, 31.515
			pz2 = 31.516
			node = 'ReadBook'
			cx, cy, cz, clx, cly, clz = -492.15, 309.35, 32.89, -491.70, 305.69, 31.34
			h = 175
		elseif sa == 30 then
			StopPedProduction(true)
			animgroup = 'Area_GirlsDorm'
			px, py, pz = -733.79, 36.59, -2.15
			pz2 = -2.15
			cx, cy, cz, clx, cly, clz = -733.55, 36.7, -0.95, -737.38, 35.55, -0.90
			node = 'ReadBook'
			h = 75
		elseif sa == 57 then
			animgroup = 'MINICHEM'
			px, py, pz = -654.17, 247.589, 15.4
			pz2 = 15.372
			cx, cy, cz, clx, cly, clz = -652.93, 247.03, 16.4, -655.01, 249.88, 16.60
			node = 'ReadBookStand2'
			h = -90
		elseif sa == 59 then
			animgroup = 'MINICHEM'
			px, py, pz = -741.4, 348.73, 3.51
			pz2 = 3.64
			cx, cy, cz, clx, cly, clz = -742.11, 347.57, 4.64, -738.63, 349.51, 5.35
			node = 'ReadBookStand2'
			h = -90
		elseif sa == 60 then
			animgroup = '4_06BIGGAME'
			px, py, pz = -778.21, 358.6, 6.39
			pz2 = 6.37
			h = 0
			node = 'ReadBookStand'
			cx, cy, cz, clx, cly, clz = -777.44, 359.74, 7.81, -780.41, 358.10, 8.10
		elseif sa == 61 then
			animgroup = '4_06BIGGAME'
			px, py, pz = -697.08, 353.25, 3.29
			pz2 = 3.29
			cx, cy, cz, clx, cly, clz = -697.58, 354.41, 4.69, -697.51, 350.42, 5
			node = 'ReadBookStand'
			h = 0
		end
		if animgroup ~= nil then
			if not HasAnimGroupLoaded(animgroup) then
				LoadAnimationGroup(animgroup)
			end
		end
		return px, py, pz, pz2, h, node, cx, cy, cz, clx, cly, clz

end

function FancyCutscenePlayerLogic()

	while true do

		if not chapterSelected then
			if F_IsButtonPressedWithDelayCheck(2, 0, false, MenuSpeed) and currentChapter > 1 then
				SoundPlay2D('NavDwn')
				currentChapter = currentChapter - 1
			elseif F_IsButtonPressedWithDelayCheck(3, 0, false, MenuSpeed) and currentChapter < table.getn(chapters) then
				SoundPlay2D('NavUp')
				currentChapter = currentChapter + 1
			elseif F_IsButtonPressedWithDelayCheck(7, 0, false, nil) then
				SoundPlay2D('RightBtn')
				chapterSelected = true
				scrollOffset = 0
			end
		else
			if F_IsButtonPressedWithDelayCheck(0, 0, false, MenuSpeed) and currentCutscene > 1 then
				SoundPlay2D('NavDwn')
				currentCutscene = currentCutscene - 1
				if currentCutscene <= scrollOffset then
					scrollOffset = (math.ceil(currentCutscene / 3) - 1) * 3 -- set offset to the current zero-based row * 3
				end
			elseif F_IsButtonPressedWithDelayCheck(1, 0, false, MenuSpeed) and currentCutscene < table.getn(cutscenes[currentChapter]) then
				SoundPlay2D('NavUp')
				currentCutscene = currentCutscene + 1
				if currentCutscene - scrollOffset > cutscenesPerPage then
					scrollOffset = (math.ceil(currentCutscene / 3) - 3) * 3 -- set offset to 2 rows before the current zero-based row * 3
				end
			elseif F_IsButtonPressedWithDelayCheck(2, 0, false, MenuSpeed) and currentCutscene > 3 then
				SoundPlay2D('NavDwn')
				currentCutscene = currentCutscene - 3
				if currentCutscene <= scrollOffset then
					scrollOffset = (math.ceil(currentCutscene / 3) - 1) * 3
				end
			elseif F_IsButtonPressedWithDelayCheck(3, 0, false, MenuSpeed) and currentCutscene < (table.getn(cutscenes[currentChapter]) - 2) then
				SoundPlay2D('NavUp')
				currentCutscene = currentCutscene + 3
				if currentCutscene - scrollOffset > cutscenesPerPage then
					scrollOffset = (math.ceil(currentCutscene / 3) - 3) * 3
				end
			elseif F_IsButtonPressedWithDelayCheck(8, 0, false, 0) then
				SoundPlay2D('WrongBtn')
				chapterSelected = false
				currentCutscene = 1
				scrollOffset = 0
			elseif F_IsButtonPressedWithDelayCheck(7, 0, false, nil) then
				SoundPlay2D('RightBtn')
				F_PlayCutscene()
				F_PostCSClean()
				F_PostCSSpawn()
			elseif F_IsButtonPressedWithDelayCheck(6, 0, false, nil) and chapterSelected then
				SoundPlay2D('RightBtn')
				local stoppedmovie
				CreateThread(function()
					repeat
						Wait(0)
					until GetCutsceneRunning() ~= 0
					while not stoppedmovie do
						if IsButtonPressed(6, 0) and GetCutsceneTime() > 3000 then
							if not stoppedmovie then
								stoppedmovie = true
							end
							CameraFade(1000, 0)
							Wait(1000)
							StopCutscene()
						end
						if not quitmoviemsg then
							quitmoviemsg = true
							repeat
								DrawRectangle(0.835, 0.925, 0.135, 0.023*ar, 0, 0, 0, 100)
								QOL_GenMenuText('Interrupt Movie:', 0.839, 0.93, 6)
								Wait(0)
							until GetCutsceneTime() > 3500
						end
						Wait(0)
					end
				end)
				for i, cut in cutscenes[currentChapter] do
					if not stoppedmovie then
						F_PlayCutscene(cut)
						F_PostCSClean()
					else
						stoppedmovie = false
						break
					end
				end
				F_PostCSSpawn()
			elseif F_IsButtonPressedWithDelayCheck(8, 0, false, 0) then
				SoundPlay2D('WrongBtn')
				chapterSelected = false
				currentCutscene = 1
				scrollOffset = 0
			end
		end
		Menu_CutscenePlayer()

		Wait(0)
	end

end

function Menu_CutscenePlayer()

		DrawTextInline('\n\n~i~~xy~ Cutscene Player - Main', 0.51, 0.09, 0, 1)
		DrawRectangle(-0.01, 0.85, 1.01, 0.3, 0, 0, 0, 100)
		if Option5 then
			chapters = {'Chapter I', 'Chapter II', 'Chapter III', 'Chapter IV', 'Chapter V', 'Chapter 6'}
			cutscenes = {
				{'1-01', '1-02B', '1-02D', '1-02E', '1-03', '1-04', '1-05', '1-06', '1-06B', '1-07', '1-08', '1-09', '1-1-1', '1-1-2', '1-10', '1-11', '1-B', '1-BB', '1-BC', '1-G1', '1-S01'},
				{'2-0', '2-01', '2-02', '2-03', '2-03b', '2-04', '2-05', '2-06', '2-07', '2-08', '2-09', '2-09B', '2-B', '2-BB', '2-G2', '2-S02', '2-S04', '2-S05', '2-S05B', '2-S05C', '2-S06', '2-S07'},
				{'3-0', '3-01', '3-01AA', '3-01AB', '3-01BA', '3-01CA', '3-01CB', '3-01DA', '3-01DB', '3-01DC', '3-02', '3-03', '3-04', '3-04B', '3-05', '3-06', '3-B', '3-BB', '3-BC', '3-BD', '3-G3', '3-R05A', '3-R05B', '3-S03', '3-S08', '3-R07', '3-S10', '3-S11', '3-S11C'},
				{'4-0', '4-01', '4-02', '4-03', '4-04', '4-05', '4-06', '4-B1', '4-B1B', '4-B1C', '4-B1D', '4-B2', '4-B2B', '4-G4', '4-S12', '4-S12B'},
				{'5-0', '5-01', '5-02', '5-02B', '5-03', '5-04', '5-05', '5-05B', '5-06', '5-07', '5-09', '5-09B', '5-B', '5-BC', '5-G5'},
				{'6-0', '6-02', '6-02B', '6-B', '6-BB', '6-BC'},
			}
		else
			chapters = {'Chapter I', 'Chapter II', 'Chapter III', 'Chapter IV', 'Chapter V', 'Unused'}
			cutscenes = {
				{'1-1-1', '1-1-2', '1-02B', '1-02E', '1-02D', '1-03', '1-04', '1-05', '1-06', '1-06B', '1-07', '1-08', '1-09', '1-11', '1-10', '1-B', '1-BB', '1-BC', '1-G1', '2-S04'},
				{'2-0', '2-01', '1-S01', '2-06', '2-G2', '2-03', '2-03b', '2-04', '2-07', '2-05', '2-09', '2-09B', '2-B', '2-BB', '2-08', '2-S06', '2-S07'},
				{'3-0', '3-01AA', '3-01AB', '3-01BA', '3-01CA', '3-01CB', '3-01DA', '3-01DB', '3-01DC',  '3-01', '3-02', '3-S10', '3-04', '3-04B',  '3-G3', '3-05', '3-06', '3-B', '3-BB', '3-BD', '3-R05A', '3-R05B', '2-02', '2-S02', '2-S05', '2-S05B', '2-S05C'},
				{'4-0', '4-02', '4-B1', '4-B1D', '4-01', '4-04', '4-03', '4-G4', '4-05', '4-06', '4-B2', '4-B2B', '4-S12', '4-S12B', '3-S11', '3-S11C'},
				{'5-0', '5-09', '5-09B', '5-01', '5-04', '5-03', '5-02', '5-02B', '5-05', '5-05B', '6-0', '5-06', '5-BC', '6-02', '6-02B', '6-B', '6-BB', '6-BC', '3-S03', '5-G5', '3-S08', '3-R07'},
				{'1-01', '1-1', '2-09A', '3-03', '3-BC', '4-B1B', '4-B1C', '5-07', '5-B', '6-B2', 'CS_COUNTER', 'FX-TEST', 'TEST', 'weedkiller'}
			}
		end
		for i = 1, table.getn(chapters) do
			local y = 0.32 + (i - 2.5) * 0.1
			if i == currentChapter then
				DrawRectangle(0.1, y, 0.2, 0.08, 0, 0, 255, 100) -- Blue-tinted rectangle for selected chapter
			else
				DrawRectangle(0.1, y, 0.2, 0.08, 0, 0, 0, 100) -- Transparent black rectangle for non-selected chapters
			end
			SetTextFormatting(textFormatting)
			SetTextPosition(0.2, y + 0.01)
			SetTextScale(2)
			SetTextColour(255, 255, 255, 255)
			DrawText(chapters[i])
		end

		-- These first four are general and will affect everything cutscene box-related. Feel free to customise
		-- Position
		local START_X = 0.35
		local START_Y = 0.19
		-- Spacing
		local RECT_SPACING_X = 0.2
		local RECT_SPACING_Y = 0.2

		-- Shadow for non-selected
		local NON_SELECTED_BORDER_WIDTH = 0.172
		local NON_SELECTED_BORDER_HEIGHT = 0.1582
		-- Border when selected
		local BORDER_WIDTH = 0.187
		local BORDER_HEIGHT = 0.193
		-- Position (Thumbnails Only. Both Selected and not)
		local THUMBNAIL_X_OFFSET = 0.09
		local THUMBNAIL_Y_OFFSET = 0.073
		-- Size of current selection and the rest (width is automatically increased to keep aspect ratio)
		local THUMBNAIL_HEIGHT_SELECTED = 0.178
		local THUMBNAIL_HEIGHT_NON_SELECTED = 0.172

		-- 3x3 Cutscene boxes. Yakuza-style-ish
		local startCutscene = 1 + scrollOffset
		local endCutscene = math.min(startCutscene + cutscenesPerPage - 1, table.getn(cutscenes[currentChapter]))

		for j = startCutscene, endCutscene do
			local index = j - startCutscene + 1
			local x = START_X + math.mod(index - 1, 3) * RECT_SPACING_X
			local y = START_Y + math.floor((index - 1) / 3) * RECT_SPACING_Y

			if j == currentCutscene and chapterSelected then
				DrawRectangle(x - 0.0035, y - 0.024, BORDER_WIDTH, BORDER_HEIGHT, 20, 20, 20, 170) -- Border for selected
				local description = cutsceneDescriptions[cutscenes[currentChapter][j]]
				SetTextFormatting(textFormatting)
				SetTextAlign('LEFT')
				SetTextScale(1.1)
				SetTextPosition(0.1, 0.86)
				SetTextColour(205, 205, 205, 255)
				SetTextShadow()
				SetTextBold()
				if currentChapter == 1 then
					chapname = 'Chapter I: Making New Friends and Enemies'
				elseif currentChapter == 2 then
					chapname = 'Chapter II: Rich Kid Blues'
				elseif currentChapter == 3 then
					chapname = 'Chapter III: Love Makes the World Go Around'
				elseif currentChapter == 4 then
					chapname = 'Chapter IV: A Healthy Mind In a Healthy Body, and Other Lies'
				elseif currentChapter == 5 then
					chapname = 'Chapter V: The Fall and Rise of Jimmy Hopkins, Aged 15'
				elseif currentChapter == 6 then
					if Option5 then
						chapname = 'Chapter 6: Endless Summer'
					else
						chapname = 'Unused Cutscenes'
					end
				end
				DrawText(chapname..' | '..cutscenes[currentChapter][j], 0.1, 0.86)
				QOL_GenMenuText('\n'..description, 0.1, 0.868, nil, 0.9)
				local cutsceneID = cutscenes[currentChapter][j]
				draw_thumbnail(cutsceneID, x+THUMBNAIL_X_OFFSET, y+THUMBNAIL_Y_OFFSET, THUMBNAIL_HEIGHT_SELECTED, 255, 255, 255, 255, true)
			else
				DrawRectangle(x+0.008, y+0.007, NON_SELECTED_BORDER_WIDTH, NON_SELECTED_BORDER_HEIGHT, 0, 0, 0, 100) -- Border for non-selected
				local cutsceneID = cutscenes[currentChapter][j]
				local textureID = cutsceneThumbnails[cutsceneID]
				if chapterSelected then -- Colours for non-selected stuff
					draw_thumbnail(cutsceneID, x+THUMBNAIL_X_OFFSET, y+THUMBNAIL_Y_OFFSET, THUMBNAIL_HEIGHT_NON_SELECTED, 170, 170, 170, 255, false)
				else
					draw_thumbnail(cutsceneID, x+THUMBNAIL_X_OFFSET, y+THUMBNAIL_Y_OFFSET, THUMBNAIL_HEIGHT_NON_SELECTED, 100, 100, 100, 255, false)
				end
			end
		end

		-- Scrolling Bar
		if chapterSelected then
			-- Both Grey and White indicators' shared dimensions
			local scrollbarWidth = 0.007
			local scrollbarHeight = 0.55
			local scrollbarX = 0.95 - scrollbarWidth
			local scrollbarY = 0.188

			-- Define the dimensions and position of the scroll indicator
			local currentRow = math.ceil(scrollOffset / 3)
			local indicatorWidth = scrollbarWidth
			local totalRows = math.ceil(table.getn(cutscenes[currentChapter]) / 3)
			local indicatorHeight = scrollbarHeight / (totalRows - (math.floor(cutscenesPerPage / 3) - 1))
			local indicatorX = scrollbarX
			local indicatorY = scrollbarY + currentRow * indicatorHeight

			-- Draw the grey bar + white scroll indicator
			DrawRectangle(scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight, 0, 0, 0, 100)
			DrawRectangle(indicatorX, indicatorY, indicatorWidth, indicatorHeight, 255, 255, 255, 255)
		end

		if F_IsButtonPressedWithDelayCheck(9, 0, false, nil) then
			Menu_Options()
		end
		if chapterSelected then
			local x = 0.94
			x = x - QOL_GenMenuText_2('| Info and Settings:', x, 0.86, 9)
			x = x - QOL_GenMenuText_2('| Play All:', x, 0.86, 6, true)
			QOL_GenMenuText_2('Play:', x, 0.86, 7, true)
		else
			QOL_GenMenuText_2('Info and Settings:', 0.94, 0.86, 9)
		end

end

function Menu_Options()

		local Selection = 1
		local Page = 1
		local options = {}

		while true do

			if Page == 1 then
				options = {
					{name = 'Menu Speed: ', value = MenuSpeed, text = 'Universal menu speed.\nA higher value means more delay when scrolling.'},
					{name = 'Avoid Fade In: ', value = Option1, text = "If ~g~true~s~, camera won't fade back in after the cutscene ends.\nUseless unless debugging.\n~y~Note:~s~ If you're ever stuck in a loading screen, use CameraFade(0, 1) in the console."},
					{name = 'Avoid Fade Out: ', value = Option2, text = "If ~g~true~s~, camera won't fade in when the cutscene starts. Instead it will start immediately.\n~r~Warning:~s~ May crash the game."},
					{name = "Don't Transition Back: ", value = Option3, text = "If ~g~true~s~, player won't be teleported to their previous location.\nUseless unless debugging."},
					{name = "Don't Transition To: ", value = Option4, text = "If ~g~true~s~, player won't be teleported to cutscene location.\n~y~Note:~s~ For technical reasons, does not apply to 5-05B when enabling mission-related props."},
					{name = 'Order by Internal IDs: ', value = Option5, text = 'If ~g~true~s~, cutscenes will be listed based on their ID, rather than when they actually take place.\nUnused stuff included.'},
				}
			elseif Page == 2 then
				options = {
					{name = 'Chap. 3 Cutscenes in Winter: ', value = Option6, text = 'If ~g~true~s~, cutscenes listed under Chapter III will take place in that chapter and feature Christmas props.'},
					{name = 'Mission-related Props: ', value = Option7, text = 'If ~g~true~s~, props loaded only during a specific cutscene/mission are accounted for.\nAffected Cutscenes: 1-1-1, 2-S07, 3-01CA, 3-01CB, 3-01DA, 3-01DB, 3-01DC, 3-R05B, 5-04, 5-05B, 6-B, 6-BB, 6-BC.\nBonus: Restores unused VFX for 2-S07, plays BGM for 5-05B.'},
					{name = 'Mission-related Clothing: ', value = Option8, text = 'If ~g~true~s~, Jimmy will wear clothes that are appropriate for the story.'},
				}
			end

			DrawRectangle(0.225, 0.34, 0.572, 0.353, 0, 0, 0, 100)
			local menuText = 'Cutscene Player - Settings\n'
			local optionText = ''
			local optionValueText = ''

			if Page == 1 then
				menuText = menuText..'~w~General     ~o~Accuracy'
			else
				menuText = menuText..'General     ~w~Accuracy'
			end

			for i, option in ipairs(options) do
				if i == Selection then
					DrawTextInline('~xy~'..'>', 0.229, 0.35 + (i-1)*0.055, 0, 3)
				end
				optionText = optionText..'~w~'..option.name..'~o~\n'
				local colour
				if option.value then
					colour = '~g~ '
				else
					colour = '~r~ '
				end
				if type(option.value) == 'number' then
					colour = '~c~'
				end
				optionValueText = optionValueText..colour..tostring(option.value)..'\n'
			end

			DrawRectangle(-0.01, 0.85, 1.01, 0.3, 0, 0, 0, 100)
			DrawTexture(GetInputTexture(10, 0), 0.321, 0.24, 0.052/ar, 0.052)
			DrawTexture(GetInputTexture(12, 0), 0.65, 0.24, 0.052/ar, 0.052)
			DrawTextInline('\n\n~i~'..menuText, 0, 1)
			DrawTextInline('~xy~'..optionText, 0.25, 0.35, 0, 3)
			DrawTextInline('~xy~'..optionValueText, 0.7, 0.35, 0, 3)
			if options[Selection].text then
				DrawTextInline('~scale~'..'~xy~'..options[Selection].text, 1, 0.1, 0.86, 0, 4)
			end
			QOL_GenMenuText('Back:', 0.881, 0.86, 8)

			if F_IsButtonPressedWithDelayCheck(8, 0, false, nil) then
				FancyCutscenePlayerLogic()
			end

			-- Menu logic
			if F_IsButtonPressedWithDelayCheck(0, 0, false, MenuSpeed) then
				if Page == 1 then
					if Selection == 1 then
						MenuSpeed = MenuSpeed - 1
						if MenuSpeed < 1 then
							MenuSpeed = 1
						end
					elseif Selection == 2 then
						Option1 = not Option1
					elseif Selection == 3 then
						Option2 = not Option2
					elseif Selection == 4 then
						Option3 = not Option3
					elseif Selection == 5 then
						Option4 = not Option4
					elseif Selection == 6 then
						Option5 = not Option5
					end
				elseif Page == 2 then
					if Selection == 1 then
						Option6 = not Option6
					elseif Selection == 2 then
						Option7 = not Option7
					elseif Selection == 3 then
						Option8 = not Option8
					end
				end
			elseif F_IsButtonPressedWithDelayCheck(1, 0, false, MenuSpeed) then
				if Page == 1 then
					if Selection == 1 then
						MenuSpeed = MenuSpeed + 1
					elseif Selection == 2 then
						Option1 = not Option1
					elseif Selection == 3 then
						Option2 = not Option2
					elseif Selection == 4 then
						Option3 = not Option3
					elseif Selection == 5 then
						Option4 = not Option4
					elseif Selection == 6 then
						Option5 = not Option5
					end
				elseif Page == 2 then
					if Selection == 1 then
						Option6 = not Option6
					elseif Selection == 2 then
						Option7 = not Option7
					elseif Selection == 3 then
						Option8 = not Option8
					end
				end
			end
			if F_IsButtonPressedWithDelayCheck(10, 0, false, MenuSpeed) then
				Page = Page - 1
				if Page < 1 then
					Page = 1
				else
					SoundPlay2D('ButtonDown')
				end
				if Selection > 3 then
					Selection = 1
				end
			elseif F_IsButtonPressedWithDelayCheck(12, 0, false, MenuSpeed) then
				Page = Page + 1
				if Page > 2 then
					Page = 2
				else
					SoundPlay2D('ButtonUp')
				end
				if Selection > 3 then
					Selection = 1
				end
			end


			if F_IsButtonPressedWithDelayCheck(2, 0, false, nil) then
				SoundPlay2D('NavDwn')
				Selection = Selection - 1
				if Selection < 1 then
					Selection = table.getn(options)
				end
			elseif F_IsButtonPressedWithDelayCheck(3, 0, false, nil) then
				SoundPlay2D('NavUp')
				Selection = Selection + 1
				if Selection > table.getn(options) then
					Selection = 1
				end
			end

			Wait(0)
		end

end

F_PlayCutscene = function(allcuts)

		local currentCutsceneName

		if allcuts then
			currentCutsceneName = allcuts
		else
			currentCutsceneName = cutscenes[currentChapter][currentCutscene]
		end
		if Option6 and currentChapter == 3 then
			CameraFade(1000, 0)
			Wait(1000)
			PreviousChapter = ChapterGet()
			if PreviousChapter ~= 2 then
				ChapterSet(2)
			end
			AreaLoadSpecialEntities('Christmas', true)
		end
		if Option7 then
			if currentCutsceneName == '1-1-1' then
				if not IsActionTreeLoaded('1_01.act') then
					LoadActionTree('1_01.act')
				end
				PAnimDelete(TRIGGER._TSCHOOL_FRONTGATE)
				if not PAnimExists(TRIGGER._TSCHOOL_FRONTGATE) then
					PAnimCreate(TRIGGER._TSCHOOL_FRONTGATE)
				end
				CreateThread(function()
					repeat
						Wait(0)
					until GetCutsceneRunning() ~= 0
					for i, gate in shared.gSchoolGates, nil, nil do
						DeletePersistentEntity(gate.id, gate.bPool)
					end
					repeat
						Wait(0)
					until GetCutsceneTime() > 58000
					PAnimSetActionNode(TRIGGER._TSCHOOL_FRONTGATE, '/Global/1_01/Gates/OpenHold', '1_01.act')
				end)
			end
			if currentCutsceneName == '1-11' then
				AreaLoadSpecialEntities('Halloween1', true)
				AreaEnsureSpecialEntitiesAreCreated()
			end
			if currentCutsceneName == '2-S07' then
				AreaLoadSpecialEntities('2s07', true)
				CutSceneSetActionNode("2-S07")
			end
			if currentCutsceneName == '3-01CA' or currentCutsceneName == '3-01CB' then
				AreaLoadSpecialEntities('nutcracker', true)
			end
			if currentCutsceneName == '3-01DA' or currentCutsceneName == '3-01DB' or currentCutsceneName == '3-01DC' then
				AreaLoadSpecialEntities('Rudy1', true)
				AreaLoadSpecialEntities('Rudy3', true)
				AreaLoadSpecialEntities('Rudy2', true)
				AreaEnsureSpecialEntitiesAreCreated()
			end
			if currentCutsceneName == '3-R05B' then
				AreaLoadSpecialEntities('delivery', true)
				AreaEnsureSpecialEntitiesAreCreated()
			end
			if currentCutsceneName == '5-04' then
				CameraFade(1000, 0)
				Wait(1000)
				AreaTransitionXYZ(0, -623.166992, -75.117599, 59.786098, true)
				SmokesTable = {}
				FiresTable = {}
				local firecoords = {
					{46.363098, -63.564800, 11.100000},
					{47.299999, -56.731300, 11.500000},
					{46.250000, -43.762501, 11.140000},
					{47.500000, -53.510300, 5.076090},
					{47.299999, -53.631302, 11.500000}
				}
				for i = 1, 5 do
					local x = firecoords[i][1]
					local y = firecoords[i][2]
					local z = firecoords[i][3]
					SmokesTable[i] = EffectCreate('SmokeStackLRG', x, y, z)
					FiresTable[i] = EffectCreate('GymFire', x, y, z)
				end
			end
			if currentCutsceneName == '5-05B' then
				CameraFade(1000, 0)
				Wait(1000)
				SoundStopStream()
				if Option4 then
					Option4 = false
				end
				AreaTransitionXYZ(0, 471.465, 258.79, 15, true)
				MusicAllowPlayDuringCutscenes(true)
				SoundPlayStream('5-05_NIS_PottyFall.rsm', 1)
				Wait(1000)
				MusicFadeWithCamera(false)
				Wait(4000)
				SoundPlayPreloadedStream()
				CreateThread(function()
					repeat
						Wait(0)
					until GetCutsceneRunning() ~= 0
					AreaEnsureSpecialEntitiesAreCreatedWithOverride('5_05', 0)
					repeat
						Wait(0)
					until GetCutsceneRunning() == 0
					MusicFadeWithCamera(true)
					SoundStopStream()
					SoundPlayStream('MS_ArtClass.rsm', 0.5)
					MusicAllowPlayDuringCutscenes(false)
				end)
			end
			if currentCutsceneName == '6-B' or currentCutsceneName == '6-BB' then
				local roofalreadyloaded
				for collection,scripts in pairs(GetAllScriptInfo(false)) do
					for _,script in ipairs(scripts) do
						if script.name == 'RoofTopMod.lua' then
							roofalreadyloaded = true
						end
					end
				end
				if not roofalreadyloaded then
					F_SetupRoof()
				end
			end
			if currentCutsceneName == '6-BC' then
				debr1, debr2 = CreatePersistentEntity('Poffice_Gdebris', -701.292, 207.294, 31.731, 0, 5)
			end
		end
		if Option8 then
			CameraFade(1000, 0)
			Wait(1000)
			if currentCutsceneName == '1-01' or currentCutsceneName == '1-1-1' or currentCutsceneName == '1-1-2' or currentCutsceneName == '1-02B' or currentCutsceneName == '5-06' or currentCutsceneName == '5-07' or currentCutsceneName == '5-B' or currentCutsceneName == '5-BC' or currentCutsceneName == '6-02' or currentCutsceneName == '6-02B' or currentCutsceneName == '6-B' or currentCutsceneName == '6-BB' or currentCutsceneName == '6-BC' then
				ClothingSetPlayerOutfit('Starting')
			elseif currentCutsceneName == '1-11' then
				ClothingSetPlayerOutfit('Halloween')
			elseif currentCutsceneName == '2-03' or currentCutsceneName == '2-03b' then
				if math.random(2) == 1 then
					ClothingSetPlayer(1, 'R_Sweater1')
				else
					ClothingSetPlayer(1, 'R_Sweater5')
				end
			elseif currentCutsceneName == '2-B' then
				ClothingSetPlayerOutfit('Boxing')
			elseif currentCutsceneName == '2-BB' then
				ClothingSetPlayerOutfit('Boxing NG')
			elseif currentCutsceneName == '3-01CB' then
				ClothingSetPlayerOutfit('Nutcracker')
			elseif currentCutsceneName == '4-06' or currentCutsceneName == '4-B2' or currentCutsceneName == '4-B2B' then
				ClothingSetPlayerOutfit('MascotNoHead')
			else
				ClothingSetPlayerOutfit('Uniform')
			end
			ClothingBuildPlayer()
		end
		if currentCutsceneName ~= '5-05B' then
			SoundStopStream()
		end
		if chapname == 'Unused Cutscenes' and currentCutsceneName ~= '1-01' and currentCutsceneName ~= '3-03' and currentCutsceneName ~= '3-BC' and currentCutsceneName ~= '4-B1B' and currentCutsceneName ~= '4-B1C' and currentCutsceneName ~= '5-07' and currentCutsceneName ~= '5-B' then
			local PreviousArea
			local X, Y, Z
			if DebugOn then
				PreviousArea = AreaGetVisible()
				X, Y, Z = PlayerGetPosXYZ()
			end
			CameraFade(1000, 0)
			Wait(1000)
			if not Option4 then
				if (currentCutsceneName == '1-1' or currentCutsceneName == 'CS_COUNTER') and PreviousArea ~= 14 then
					AreaTransitionXYZ(14, -502.28, 310.96, 31.41, true)
					AreaAddExtraScene(270, -100, true, true, true, 0, 10)
				elseif (currentCutsceneName == '2-09A' or currentCutsceneName == '6-B2' or currentCutsceneName == 'weedkiller') and PreviousArea ~= 6 then
					AreaTransitionXYZ(6, -708.41, 312.53, 33.38, true)
				elseif (currentCutsceneName == 'FX-TEST' or currentCutsceneName == 'TEST') then
					AreaTransitionXYZ(2, -628.28, -312.97, 0.00, true)
				end
			end
			Wait(500)
			LoadCutscene(currentCutsceneName)
			CutSceneSetActionNode(currentCutsceneName)
			LoadCutsceneSound('3-BC')
			repeat
				Wait(0)
			until IsCutsceneLoaded()
			AreaClearAllPeds()
			StartCutscene()
			CameraFade(1000, 1)
			repeat
				Wait(0)
			until IsButtonBeingPressed(7, 0)
			AreaRemoveExtraScene()
			CameraFade(1000, 0)
			Wait(1000)
			if DebugOn then
				AreaTransitionXYZ(PreviousArea, X, Y, Z)
			end
			StopCutscene()
		else
			PlayCutsceneWithLoad(currentCutsceneName, Option1, Option2, Option3, Option4)
		end

end

F_PostCSClean = function()

		if Option6 and ChapterGet() ~= PreviousChapter and currentChapter == 3 then
			ChapterSet(PreviousChapter)
			AreaLoadSpecialEntities('Christmas', false)
			AreaEnsureSpecialEntitiesAreCreated()
		end
		if Option7 then
			PAnimDelete(TRIGGER._TSCHOOL_FRONTGATE)
			AreaLoadSpecialEntities('Halloween1', false)
			AreaLoadSpecialEntities('2s07', false)
			AreaLoadSpecialEntities('nutcracker', false)
			AreaLoadSpecialEntities('Rudy1', false)
			AreaLoadSpecialEntities('Rudy3', false)
			AreaLoadSpecialEntities('Rudy2', false)
			AreaLoadSpecialEntities('delivery', false)
			AreaEnsureSpecialEntitiesAreCreated()
			for i, smoke in SmokesTable do
				EffectKill(smoke)
			end
			for i, fire in FiresTable do
				EffectKill(fire)
			end
			if IsMissionCompleated('5_05') then
				AreaEnsureSpecialEntitiesAreCreatedWithOverride('5_05', 2)
			else
				AreaEnsureSpecialEntitiesAreCreatedWithOverride('5_05', 1)
			end
			for i, Prop in TblRoofTopProps do
				DeletePersistentEntity(Prop.ID, Prop.Pool)
			end
			DeletePersistentEntity(debr1, debr2)
			debr1 = nil
			debr2 = nil
		end
		if Option8 then
			ClothingRestore()
			ClothingBuildPlayer()
		end

end

F_PostCSSpawn = function()

		if not DebugOn then
			AreaTransitionXYZ(sa, px, py, pz, true)
			PlayerSetPosSimple(px, py, pz2)
			PedFaceHeading(gPlayer, h, 0)
			PedSetActionNode(gPlayer, '/Global/FancyCutsPlayerNodes/Anims/'..node, 'FancyCutsPlayerNodes.act')
			CameraSetXYZ(cx, cy, cz, clx, cly, clz)
			if (sa == 30 or sa == 57 or sa == 59 or sa == 60 or sa == 61) then
				SoundStopAmbiences()
			end
			Wait(500)
			SoundPlayStream('MS_ArtClass.rsm', 0.5)
			CameraFade(1000, 1)
		end

end

F_SetupRoof = function()

		local function CreatePersistentEntityAndInsert(model, x, y, z, r, a)
			local PropID, PropPool = CreatePersistentEntity(model, x, y, z, r, a)
			table.insert(TblRoofTopProps, {ID = PropID, Pool = PropPool})
		end
		CreatePersistentEntityAndInsert('SC1b_fence_d', 186.021, -73.3169, 35.3693, 0, 0)
		CreatePersistentEntityAndInsert('SC1d_lad04', 190.857, -73.0157, 35.4244, 0, 0)
		CreatePersistentEntityAndInsert('SC1d_bldgmain_A', 191.754, -73.3854, 51.0535, 0, 0)
		CreatePersistentEntityAndInsert('SC_FanBlade03', 178.574, -73.157, 23.2994, 0, 0)
		CreatePersistentEntityAndInsert('SC_FanBlade02', 178.57, -73.1494, 23.1368, 0, 0)
		CreatePersistentEntityAndInsert('FGRD_SC1b20', 186.239, -73.3414, 34.9336, 0, 0)
		if WeatherGet() == 2 or WeatherGet() == 5 then
			CreatePersistentEntityAndInsert('SC1d_bldgmain_wtr01', 186.087, -73.4308, 23.9015, 0, 0)
		end
		CreatePersistentEntityAndInsert('SC1d_roofsteps', 195.981, -79.7682, 43.6757, 0, 0)
		CreatePersistentEntityAndInsert('DL_SC1d_L', 189.734, -72.4095, 33.7901, 0, 0)
		CreatePersistentEntityAndInsert('PR_AlleyLamp', 182.208, -67.7659, 29.8164, 0, 0)
		CreatePersistentEntityAndInsert('pxLad3M', 181.94, -64.992, 23.2626, 0, 0)
		CreatePersistentEntityAndInsert('pxLad4M', 186.38, -66.1529, 26.0975, 90, 0)
		CreatePersistentEntityAndInsert('Ladder_5M', 184.314, -80.2621, 35.6872, 90, 0)
		CreatePersistentEntityAndInsert('pxLad5M', 204.592, -67.2104, 30.3007, 0, 0)
		CreatePersistentEntityAndInsert('Scaffold', 178.173, -73.1613, 40.1403, 0, 0)
		CreatePersistentEntityAndInsert('Scaffold', 178.173, -73.1613, 35.2763, 0, 0)
		CreatePersistentEntityAndInsert('Scaffold', 178.173, -73.1613, 30.5194, 0, 0)
		CreatePersistentEntityAndInsert('Ladder_3M', 181.94, -65.028, 23.2625, 0, 0)
		CreatePersistentEntityAndInsert('Ladder_4M', 186.435, -66.1529, 26.0975, 90, 0)
		CreatePersistentEntityAndInsert('pxLad5M', 184.349, -80.2622, 35.6869, -90, 0)
		CreatePersistentEntityAndInsert('Ladder_5M', 204.592, -67.2498, 30.301, 0, 0)
		CreatePersistentEntityAndInsert('Ladder_4M', 186.002, -81.7648, 23.2896, 0, 0)
		CreatePersistentEntityAndInsert('pxLad4M', 186.002, -81.78, 23.2896, 180, 0)
		CreatePersistentEntityAndInsert('pxLad3M', 197.356, -81.2369, 29.6798, 90, 0)
		CreatePersistentEntityAndInsert('Ladder_3M', 197.398, -81.2371, 29.6798, 90, 0)
		CreatePersistentEntityAndInsert('pxLad3M', 199.835, -80.9096, 32.6819, 180, 0)
		CreatePersistentEntityAndInsert('Ladder_3M', 199.835, -80.881, 32.6818, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 197.159, -75.7203, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 191.725, -75.7203, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 191.725, -73.4447, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 186.275, -73.4447, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell', 186.275, -71.1643, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('BrickPile', 203.279, -66.6406, 30.7234, 0, 0)
		CreatePersistentEntityAndInsert('BrickPile01', 204.748, -77.8347, 36.1466, 0, 0)
		CreatePersistentEntityAndInsert('BrickPile02', 186.117, -79.5076, 36.1196, 0, 0)
		CreatePersistentEntityAndInsert('WheelBrl', 183, -80.2706, 41.078, 0, 0)
		CreatePersistentEntityAndInsert('WheelBrl', 204.582, -68.668, 35.6995, 0, 0)
		CreatePersistentEntityAndInsert('WALKTschoolRoofOP', 186.462, -73.2229, 37.8194, 0, 0)
		CreatePersistentEntityAndInsert('pxTrel10M', 294.797, -18.145, 6.54785, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 197.159, -73.4447, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 197.159, -71.1643, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 191.722, -71.1643, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('SCBell2', 186.275, -75.7203, 46.4597, 0, 0)
		CreatePersistentEntityAndInsert('NOGO_tschoolRoofOP', 186.462, -73.2229, 30.3808, 0, 0)

		Wait(500)
		PAnimSetActionNode('SCBell', 197.159, -75.7203, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart1', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell2', 197.159, -73.4447, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart2', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell2', 197.159, -71.1643, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart3', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell', 191.725, -75.7203, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart4', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell', 191.725, -73.4447, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart5', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell2', 191.725, -71.1643, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart6', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell2', 186.275, -75.7203, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart7', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell', 186.275, -73.4447, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart8', 'Act/Props/SCBell.act')
		PAnimSetActionNode('SCBell', 186.275, -71.1643, 46.4597, 1, '/Global/SCBELL/Idle/IdleAnimationChooser/animstart9', 'Act/Props/SCBell.act')
		GeometryInstance('SCBell', false, 197.15899658203, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 197.15899658203, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 197.15899658203, -71.16429901123, 46.459701538086, false)
		GeometryInstance('SCBell', false, 191.72500610352, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell', false, 191.72500610352, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 191.72500610352, -71.16429901123, 46.459701538086, false)
		GeometryInstance('SCBell2', false, 186.27499389648, -75.72029876709, 46.459701538086, false)
		GeometryInstance('SCBell', false, 186.27499389648, -73.444702148438, 46.459701538086, false)
		GeometryInstance('SCBell', false, 186.27499389648, -71.16429901123, 46.459701538086, false)

end

QOL_GenMenuText = function(text, x, y, button, wrap)

        SetTextAlign('LEFT')
        SetTextPosition(x, y)
        SetTextColour(205, 205, 205, 255)
        SetTextShadow()
        SetTextBold()
		if wrap then
			SetTextWrapping(wrap)
		end
        local w,h = DrawText(text)
        if button then
            local texture = GetInputTexture(button,0)
            if texture then
				local tw = h*GetTextureDisplayAspectRatio(texture)
                DrawTexture(texture,0.005+x+w,y,tw,h,255,255,255,255)
            end
        end

end

QOL_GenMenuText_2 = function(text, x, y, button)

        SetTextAlign('RIGHT')
        SetTextColour(205, 205, 205, 255)
        SetTextShadow()
        SetTextBold()
		local w,h = MeasureText(text)
        if button then
            local texture = GetInputTexture(button,0)
            if texture then
				local tw = h * GetTextureDisplayAspectRatio(texture)
                DrawTexture(texture,x-tw,y,tw,h,255,255,255,255)
				x = x - tw - 0.005
				w = w + tw + 0.01
            end
        end

		SetTextPosition(x, y)
		DrawText(text)
        return w

end