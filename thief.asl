// IMPORTANT
// The splitter currently only works for OD versions 1.33 and 1.33 and ND version 1.22 (TFix 1.20a)
//
// CREDITS:
// Jayrude - Code and testing
// Psych0sis - Finding memory addresses and testing
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
}

// TDP OD
state("Thief", "1.33"){
	int level : "thief.exe", 0x278FB8;
	int loading: "thief.exe", 0x246700;
	int menuState : "thief.exe", 0x278FC0;
	int igt : "thief.exe", 0x244168;
	string255 cutsceneName : "thief.exe", 0x24CA50;
}

// TFix 1.20a
state("Thief", "1.22"){
	int level : "thief.exe", 0x3D8800;
	int loading: "thief.exe", 0x3D89B0;
	int menuState : "thief.exe", 0x3D8808;
	int igt : "thief.exe", 0x4C6234;
	string255 cutsceneName : "thief.exe", 0x5CF9DE;
}

init{
	version = modules.First().FileVersionInfo.ProductVersion;
	
	vars.category = timer.Run.CategoryName.ToLower();
	vars.splitIndex = 0;
	vars.splits = new List<int> {1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14};
}

startup{
	settings.Add("il", false, "Doing IL runs");
}

start{
	if (settings["il"]) return (current.igt == 0 && current.menuState == 10);
	vars.splitsIndex = 0;
	if (vars.category == "any% expert") vars.splitsIndex += 1;
	return (current.level == vars.splits[vars.splitsIndex] && current.menuState == 10 && current.loading != 0);
}

split{
	if (current.level == 15){
		vars.splits = new List<int> {1, 2, 3, 4, 5, 15, 6, 7, 16, 9, 17, 10, 11, 12, 13, 14};
	}
	
	if (settings["il"]) return (current.igt == old.igt && current.menuState == 12);
	if (current.menuState == 12 && current.level == vars.splits[vars.splitsIndex] && current.cutsceneName.Contains("success")){
		vars.splitsIndex += 1;
		return true;
	}
}

isLoading{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}