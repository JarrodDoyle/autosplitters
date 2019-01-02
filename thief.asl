state("Thief", "tg od") 
{
	int Level : "thief.exe", 0x279088;
	int loading : "thief.exe", 0x2467D0;
    int menuState : "thief.exe", 0x279090;
	int igt : "thief.exe", 0x244238;
	string255 cutsceneName : "thief.exe", 0x24CB60;
}

state("Thief", "tg nd")
{
	int Level : "thief.exe", 0x3D8800;
	int loading: "thief.exe", 0x3D89B0;
	int menuState : "thief.exe", 0x3D8808;
	int igt : "thief.exe", 0x4C6234;
	string255 cutsceneName : "thief.exe", 0x5CF9DE;
}

state("Thief", "tdp od")
{
	int Level : "thief.exe", 0x278FB8;
	int loading: "thief.exe", 0x246700;
	int menuState : "thief.exe", 0x278FC0;
	int igt : "thief.exe", 0x244168;
	string255 cutsceneName : "thief.exe", 0x24CA59;
}

state("Thief", "tdp nd")
{
	int Level : "thief.exe", 0x3D8800;
	int loading: "thief.exe", 0x3D89B0;
	int menuState : "thief.exe", 0x3D8808;
	int igt : "thief.exe", 0x4C6234;
	string255 cutsceneName : "thief.exe", 0x5CF9DE;
}

init
{
	if (settings["tg nd"]){
		print("tg nd");
		version = "tg nd";
	}
	else if (settings["tg od"]){
		print("tg od");
		version = "tg od";
	}
	else if (settings["tdp nd"]){
		print("tdp nd");
		version = "tdp nd";
	}
	else if (settings["tdp od"]){
		print("tdp od");
		version = "tdp od";
	}
	
	if (settings["tdp nd"] || settings["tdp od"]){
		vars.splits = new Dictionary<int, int> {
		{3, 2}, {4, 3}, {5, 4},
		{6, 5}, {7, 6}, {9, 8},
		{10, 9}, {11, 10}, {12, 11},
		{13, 12}, {14, 13}
		};
	}
	else if (settings["tg nd"] || settings["tg od"]){
		vars.splits = new Dictionary<int, int> {
		{3, 2}, {4, 3}, {5, 4},
		{15, 5}, {6, 15}, {7, 6},
		{16, 7}, {9, 16}, {17, 9},
		{10, 17}, {11, 10}, {12, 11},
		{13, 12}, {14, 13}
		};
	}
	else {
		vars.splits = new Dictionary<int, int>();
	}
	if (settings["normal"]){
		vars.splits.Add(2, 1);
	}
}

startup
{
	settings.Add("tg nd", false, "Thief: Gold (ND)");
	settings.Add("tg od", false, "Thief: Gold (OD)");
	settings.Add("tdp nd", false, "Thief: The Dark Project (ND)");
	settings.Add("tdp od", false, "Thief: The Dark Project (OD)");
	settings.Add("normal", false, "Fullgame Normal");
	settings.Add("expert", false, "Fullgame Expert");
	settings.Add("il", false, "Individual Level");
	vars.levelsComplete = 0;
}

// Starts the timer when you load into Keeper's
start 
{
	if (settings["normal"]){
		return (current.Level == 1 && (current.menuState == 10));
	}
	else if (settings["expert"]){
		return (current.Level == 2 && (current.menuState == 10));
	}
	else if (settings["il"]){
		return (current.igt != 0);
	}
}

// Reset splits when starting new run. Doesn't reset a finished run
reset 
{
	if (settings["normal"]){
		return (current.Level == 1 && old.Level != 1);
	}
	else if (settings["expert"]){
		return (current.Level == 2 && old.Level != 2);
	}
}

// Splits at the end of each level and on maw end cutscene
split
{
	if (settings["il"]){
		return (current.igt == old.igt && current.menuState == 12);
	}
	else if ((settings["normal"] && current.Level > 1) || (settings["expert"] && current.Level > 2)){
		if (current.Level == 14){
			if (settings["tg nd"] || settings["tdp nd"]){
				return ((vars.splits[current.Level] == old.Level) || (current.Level == 14 && current.menuState == 12 && current.cutsceneName == "success"));
			}
			else if (settings["tg od"] || settings["tdp od"]){
				return ((vars.splits[current.Level] == old.Level) || (current.Level == 14 && current.menuState == 12 && current.cutsceneName == "success.avi"));
			}
		}
		return (vars.splits[current.Level] == old.Level);
	}
}

// Returns true if loading or in briefing cutscenes
isLoading
{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}