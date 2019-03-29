state("pw_x64"){
	bool loading : "pw_x64.exe", 0x1448738, 0x498;
}

init{
	int scanOffset = 0;
	var target = new SigScanTarget(14,
	 			"48 83 EC 08",		// sub rsp, 08
	 			"B8 64 00 00 00",	// mov eax, 00000064
	 			"F2 0F 2A C0",		// cvtsi2sd xmm0, eax
	 			"B8 ?? ?? ?? ??");	// mov eax, ????????
	
	foreach (var page in game.MemoryPages()){
		var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
		if ((scanOffset = (int)scanner.Scan(target)) != 0) break;
	}
	
	if (scanOffset == 0) throw new Exception("-- CANT FIND SIGNATURE");
	
	print("--FOUND SIGNATURE: " + scanOffset.ToString());
	
	int ptr = ExtensionMethods.ReadValue<int>(memory, new IntPtr(scanOffset)) - 8;
	print("--FOUND PLAYER: " + ptr.ToString());
	
	vars.watchers = new MemoryWatcherList {
		new MemoryWatcher<int>((IntPtr)ptr) { Name = "score" },
		new MemoryWatcher<bool>((IntPtr)ptr + 0x130) { Name = "levelComplete" },
		new MemoryWatcher<bool>((IntPtr)ptr + 0x138) { Name = "enterLevelScreen" }
	};
}

update{
	vars.watchers.UpdateAll(game);
}

start{
	var entering = vars.watchers["enterLevelScreen"];
	return (!entering.Current && entering.Old && vars.watchers["score"].Current == 0);
}

split{
	var levelComplete = vars.watchers["levelComplete"];
	return (levelComplete.Current && !levelComplete.Old);
}

reset{
	var score = vars.watchers["score"];
	return (score.Current == 0 && (score.Old != 0 || vars.watchers["enterLevelScreen"].Current));
}

isLoading{
	return current.loading;
}