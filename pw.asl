state("pw_x64"){
	
	bool loading : "pw_x64.exe", 0x1448738, 0x498;
}

init{
	int scanOffset = 0;
	var target = new SigScanTarget(0,   "00 00 00 00", 	 // score
										"00 00 00 00", 	 // unlockPoints
										"00 00 C8 42", 	 // health
										"00 00 C8 42", 	 // maxHealth
										"00 00 00 00", 	 // mana
										"00 00 48 42", 	 // maxMana
										"00 00 80 3F", 	 // manaDrain
										"00 00 00 00", 	 // canUseMagic
										"01 00 00 00", 	 // strength
										"01 00 00 00", 	 // vitality
										"01 00 00 00", 	 // wisdom
										"01 00 00 00");  // capacity
	foreach (var page in game.MemoryPages()){
		var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
		if ((scanOffset = (int)scanner.Scan(target)) != 0) break;
	}
	
	if (scanOffset == 0) throw new Exception("-- CANT FIND SIGNATURE");
	
	print("--FOUND SIGNATURE: " + scanOffset.ToString());
	
	vars.watchers = new MemoryWatcherList {
		new MemoryWatcher<int>((IntPtr)scanOffset) { Name = "score" },
		new MemoryWatcher<bool>((IntPtr)scanOffset + 0x130) { Name = "levelComplete" },
		new MemoryWatcher<bool>((IntPtr)scanOffset + 0x138) { Name = "enterLevelScreen" }
	};

}

update{
	vars.watchers.UpdateAll(game);
}

start{
	var entering = vars.watchers["enterLevelScreen"];
	return (!entering.Current && entering.Old);
}

split{
	var levelComplete = vars.watchers["levelComplete"];
	return (levelComplete.Current && !levelComplete.Old);
}

reset{
	var score = vars.watchers["score"];
	return (score.Current == 0 && score.Old != 0);
}

isLoading{
	return current.loading;
}