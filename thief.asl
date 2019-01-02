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
	
	vars.levelTracker = 0;
	if (settings["tdp nd"] || settings["tdp od"]){
		vars.order = new List<int> {2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14};
	}
	else if (settings["tg nd"] || settings["tg od"]){
		vars.order = new List<int> {2, 3, 4, 5, 15, 6, 7, 16, 9, 17, 10, 11, 12, 13, 14};
	}
	else {
		vars.order = new List<int>();
	}
	if (settings["normal"]){
		vars.order.Insert(0, 1);
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
}

// Starts the timer when you load into Keeper's
start 
{
	if (settings["il"]){
		return (current.igt != 0);
	}
	else if ((settings["normal"] || settings["expert"]) && current.Level == vars.order[0]){
		vars.levelTracker = 0;
		return (current.menuState == 10);
	}
}

// Reset splits when starting new run. Doesn't reset a finished run
reset 
{
	return (current.Level == vars.order[0] && old.Level != vars.order[0]);
}

// Splits at the end of each level and on maw end cutscene
split
{
	if (settings["il"]){
		return (current.igt == old.igt && current.menuState == 12);
	}
	else if (settings["normal"] || settings["expert"]){
		if (current.Level == vars.order[vars.levelTracker] && current.menuState == 12 && (current.cutsceneName == "success" || current.cutsceneName == "success.avi")){
			vars.levelTracker += 1;
			return true;
		}
	}
	return false;
}

// Returns true if loading or in briefing cutscenes
isLoading
{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}