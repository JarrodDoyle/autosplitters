// NewDark 1.21
state("Thief2", "1.21"){
	int level 				: 0x3BFEE0;
	int loading				: 0x3C0090;
	int menuState 			: 0x3BFEE8;
	int igt 				: 0x4AD700;
	string255 cutsceneName 	: 0x5BB818, 0x458, 0x14, 0x4, 0x4, 0x24, 0x68;
}

// NewDark 1.22
state("Thief2", "1.22"){
	int level 				: 0x3D8800;
	int loading				: 0x3D89B0;
	int menuState 			: 0x3D8808;
	int igt 				: 0x4C6234;
	string255 cutsceneName 	: 0x5CF9DE;
}

// NewDark 1.24
state("Thief2", "1.24"){
	int level 				: 0x3DCB80;
	int loading				: 0x3DCD30;
	int menuState 			: 0x3DCB88;
	int igt 				: 0x4CA9D8;
	string255 cutsceneName 	: 0x5D4FE8;
}

// NewDark 1.25
state("Thief2", "1.25"){
	int level 				: 0x3DDB90;
	int loading				: 0x3DDD40;
	int menuState 			: 0x3DDB98;
	int igt 				: 0x4CBA98;
	string255 cutsceneName 	: 0x5DB0C0;
}

// NewDark 1.26
state("Thief2", "1.26"){
	int level 				: 0x3DE0C8;
	int loading				: 0x3DE278;
	int menuState 			: 0x3DE0D0;
	int igt 				: 0x4CC138;
	string255 cutsceneName 	: 0x5DB970;
}

// NewDark 1.27
state("Thief2", "1.27"){
	int level 				: 0x3DF0C8;
	int loading				: 0x3DF278;
	int menuState 			: 0x3DF0D0;
	int igt 				: 0x4CD178;
	string255 cutsceneName 	: 0x5DC9B8;
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
	if (settings["il"]) return (current.menuState == 13);
	if (current.menuState == 12 && current.level == vars.splits[vars.splitsIndex] && (current.cutsceneName.Contains("success") || current.cutsceneName.Contains("cs10"))){
		vars.splitsIndex += 1;
		return true;
	}
}

reset{
	if (settings["il"]){
		return (current.menuState == 7 || current.menuState == 9);
	}
	return (current.level == vars.splits[0] && current.menuState == 7);
}

isLoading{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}

gameTime{
	if (settings["il"]) return TimeSpan.FromMilliseconds(current.igt);
}