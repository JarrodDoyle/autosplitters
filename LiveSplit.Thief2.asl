// IMPORTANT
// The splitter currently only works for OD versions 1.33 and 1.33 and ND version 1.22 (TFix 1.20a)
//
// CREDITS:
// Jayrude - Code and testing
// Psych0sis - Finding memory addresses and testing
// DanPC - Found memory addresses for "Find Constantine" objective
// Skejven - Testing with weird dodgy Polish version
// Black secret - Testing with GoG version
// OneginIII - Testing
// TheAmorphousGamer - Testing


// NewDark 1.21
state("Thief2", "1.21"){
	int level : "thief2.exe", 0x3BFEE0;
	int loading: "thief2.exe", 0x3C0090;
	int menuState : "thief2.exe", 0x3BFEE8;
	int igt : "thief2.exe", 0x4AD700;
	string255 cutsceneName : "thief2.exe", 0x39FD40, 0x1B0, 0x8, 0x38, 0x28, 0x68;
}

// NewDark 1.22
state("Thief2", "1.22"){
	int level : "thief2.exe", 0x3D8800;
	int loading: "thief2.exe", 0x3D89B0;
	int menuState : "thief2.exe", 0x3D8808;
	int igt : "thief2.exe", 0x4C6234;
	string255 cutsceneName : "thief2.exe", 0x5CF9DE;
}

// NewDark 1.24
state("Thief2", "1.24"){
	int level : "thief2.exe", 0x3DCB80;
	int loading: "thief2.exe", 0x3DCD30;
	int menuState : "thief2.exe", 0x3DCB88;
	int igt : "thief2.exe", 0x4CA9D8;
	string255 cutsceneName : "thief2.exe", 0x5D4FEE;
}

// NewDark 1.25
state("Thief2", "1.25"){
	int level : "thief2.exe", 0x3DDB90;
	int loading: "thief2.exe", 0x3DDD40;
	int menuState : "thief2.exe", 0x3DDB98;
	int igt : "thief2.exe", 0x4CBA98;
	string255 cutsceneName : "thief2.exe", 0x5DB0C6;
}

// NewDark 1.26
state("Thief2", "1.26"){
	int level : "thief2.exe", 0x3DE0C8;
	int loading: "thief2.exe", 0x3DE278;
	int menuState : "thief2.exe", 0x3DE0D0;
	int igt : "thief2.exe", 0x4CC138;
	string255 cutsceneName : "thief2.exe", 0x5DB976;
}

// NewDark 1.27
state("Thief" | "Thief2", "1.27"){
	int level : "thief2.exe", 0x3DF0C8;
	int loading: "thief2.exe", 0x3DF278;
	int menuState : "thief2.exe", 0x3DF0D0;
	int igt : "thief2.exe", 0x4CD178;
	string255 cutsceneName : "thief2.exe", 0x5DC9BE;
}

init{
	version = modules.First().FileVersionInfo.ProductVersion;
	
	vars.splitIndex = 0;
	vars.splits = new List<int> {1, 2, 4, 5, 6, 7, 9, 8, 10, 11, 14, 15, 12, 13, 16};
}

startup{
	settings.Add("il", false, "Doing IL runs");
}

start{
	if (settings["il"]) return (current.igt == 0 && current.menuState == 10);
	vars.splitsIndex = 0;
	return (current.level == vars.splits[vars.splitsIndex] && current.menuState == 10 && current.loading != 0);
}

split{
	if (settings["il"]) return (current.igt == old.igt && current.menuState == 12);
	if (current.menuState == 12 && current.level == vars.splits[vars.splitsIndex] && current.cutsceneName.Contains("success")){
		vars.splitsIndex += 1;
		return true;
	}
}

isLoading{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}

gameTime{
	if (settings["il"]) return TimeSpan.FromMilliseconds(current.igt);
}