// TG OD
state("Thief", "1.37"){
	int Level : "thief.exe", 0x279088;
	int loading : "thief.exe", 0x2467D0;
    int menuState : "thief.exe", 0x279090;
	int igt : "thief.exe", 0x244238;
	string255 cutsceneName : "thief.exe", 0x24CB20;
}

// TDP OD
state("Thief", "1.33"){
	int Level : "thief.exe", 0x278FB8;
	int loading: "thief.exe", 0x246700;
	int menuState : "thief.exe", 0x278FC0;
	int igt : "thief.exe", 0x244168;
	string255 cutsceneName : "thief.exe", 0x24CA50;
}

// TFix 1.20a
state("Thief", "1.22"){
	int Level : "thief.exe", 0x3D8800;
	int loading: "thief.exe", 0x3D89B0;
	int menuState : "thief.exe", 0x3D8808;
	int igt : "thief.exe", 0x4C6234;
	string255 cutsceneName : "thief.exe", 0x5CF9DE;
}

init{
	version = modules.First().FileVersionInfo.ProductVersion;
	
	vars.levelTracker = 0;
	vars.tg_missions = false;
	vars.order_tdp = new List<int> {1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14};
	vars.order_tg = new List<int> {1, 2, 3, 4, 5, 15, 6, 7, 16, 9, 17, 10, 11, 12, 13, 14};
}

startup{
	settings.Add("normal", false, "Normal Mode");
	settings.Add("expert", false, "Expert Mode");
	settings.Add("il", false, "ILs");
}

start{
	if (settings["il"]){
		return (current.igt != 0);
	}
	else if (settings["normal"] && current.Level == vars.order_tg[0]){
		vars.levelTracker = 0;
		return (current.menuState == 10 && current.loading != 0);
	}
	else if (settings["expert"] && current.Level == vars.order_tg[1]){
		vars.levelTracker = 1;
		return (current.menuState == 10 && current.loading != 0);
	}
}

split{
	if (current.Level == 15){
		vars.tg_missions = true;
	}
	
	if (settings["il"]){
		return (current.igt == old.igt && current.menuState == 12);
	}
	else if ((settings["normal"] || settings["expert"])){
		bool split = false;
		if (current.menuState == 12 && (current.cutsceneName == "success" || current.cutsceneName.Substring(current.cutsceneName.Length-11, 11) == "success.avi")){
			if ((vars.tg_missions && current.Level == vars.order_tg[vars.levelTracker])
					|| (!vars.tg_missions && current.Level == vars.order_tdp[vars.levelTracker])){
				vars.levelTracker += 1;
				return true;
			}
		}
	}
}

isLoading{
	return ((current.loading != 0 && current.menuState != 9) || current.menuState == 6 || current.menuState == 12);
}