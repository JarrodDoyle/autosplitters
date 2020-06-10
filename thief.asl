// CREDITS:
// Jayrude - Code and testing
// Psych0sis - Finding memory addresses and testing
// DanPC - Found memory addresses for "Find Constantine" objective and TDP OD
// Skejven - Testing with weird dodgy Polish version
// Black secret - Testing with GoG version
// OneginIII - Testing
// TheAmorphousGamer - Testing

// TG OD
state("Thief", "1.37"){
	int level : "thief.exe", 0x279088;
	int loading : "thief.exe", 0x2467D0;
	int menuState : "thief.exe", 0x279090;
	int igt : "thief.exe", 0x244238;
	string255 cutsceneName : "thief.exe", 0x24CB20;
	byte eyeSplit : "thief.exe", 0x279034, 0xC8, 0x18, 0xA0, 0x0, 0x10;
	int difficulty : "thief.exe", 0x279064;
}

// TDP OD
state("Thief", "1.33"){
	int level : "thief.exe", 0x278FB8;
	int loading: "thief.exe", 0x246700;
	int menuState : "thief.exe", 0x278FC0;
	int igt : "thief.exe", 0x244168;
	string255 cutsceneName : "thief.exe", 0x24CA50;
	byte eyeSplit : "thief.exe", 0x24D704, 0x38, 0x244, 0x0, 0x10;
	int difficulty : "thief.exe", 0x278f94;
}

// TFix 1.20a
state("Thief", "1.22"){
	int level : "thief.exe", 0x3D8800;
	int loading: "thief.exe", 0x3D89B0;
	int menuState : "thief.exe", 0x3D8808;
	int igt : "thief.exe", 0x4C6234;
	string255 cutsceneName : "thief.exe", 0x5CF9DE;
	byte eyeSplit : "thief.exe", 0x5C1284, 0xC8, 0x18, 0xFC, 0x0, 0x10;
	int difficulty : "thief.exe", 0x5C1280;
}

init{
	version = modules.First().FileVersionInfo.ProductVersion;
	vars.splitIndex = 0;
	vars.splits = new List<int> {1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14};
	vars.hasSplitOnEye = false;
}

startup{
	settings.Add("eye", true, "To the Eye split");
	settings.Add("il", false, "Doing IL runs");
}

start{
	if (settings["il"]) return (current.igt == 0 && current.menuState == 10);
	vars.splitsIndex = (current.difficulty == 0) ? 0 : 1;
	vars.hasSplitOnEye = false;
	return (current.level == vars.splits[vars.splitsIndex] && current.menuState == 10 && current.loading != 0);
}

split{
	if (current.level == 15){
		vars.splits = new List<int> {1, 2, 3, 4, 5, 15, 6, 7, 16, 9, 17, 10, 11, 12, 13, 14};
	}
	
	if (settings["il"]) return (current.menuState == 13);
	if (current.menuState == 12 && current.level == vars.splits[vars.splitsIndex] && current.cutsceneName.Contains("success")){
		vars.splitsIndex += 1;
		return true;
	}
	if (settings["eye"] && !vars.hasSplitOnEye && current.level == 14 && current.eyeSplit == 1){
		vars.hasSplitOnEye = true;
		return true;
	}
}

reset{
	if (settings["il"]){
		return (current.menuState == 7 || current.menuState == 9);
	}
	return (current.level == vars.splits[(current.difficulty == 0) ? 0 : 1] && current.menuState == 7);
}

isLoading{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}

gameTime{
	if (settings["il"]) return TimeSpan.FromMilliseconds(current.igt);
}