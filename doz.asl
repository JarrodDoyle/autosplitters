state("Dungeon of Zolthan"){
	int roomID: "Dungeon of Zolthan.exe", 0x48846C, 0x30;
	double IGT: "Dungeon of Zolthan.exe", 0x486520;
}

startup{
	settings.Add("100%", false, "100%");
}

init{
	vars.splitIndex = 0;
	vars.splits = new List<List<int>>();
	if (settings["100%"]){
		vars.splits.Add(new List<int> {25, 26}); // High Jump
		vars.splits.Add(new List<int> {29, 30}); // Dash
		vars.splits.Add(new List<int> {24, 39}); // Double Jump
		vars.splits.Add(new List<int> {61, 42}); // Extra Heart
		vars.splits.Add(new List<int> {48, 50}); // Star Dash
		vars.splits.Add(new List<int> {60, 63}); // Extra Heart
		vars.splits.Add(new List<int> {31, 32}); // Extra Heart
		vars.splits.Add(new List<int> {57, 58}); // Rapid Fire
		vars.splits.Add(new List<int> {38, 37}); // Extra Heart
		vars.splits.Add(new List<int> {64, 55}); // Zolthan
	}
	else {
		vars.splits.Add(new List<int> {25, 26}); // High Jump
		vars.splits.Add(new List<int> {29, 30}); // Dash
		vars.splits.Add(new List<int> {24, 39}); // Double Jump
		vars.splits.Add(new List<int> {48, 50}); // Star Dash
		vars.splits.Add(new List<int> {64, 55}); // Zolthan
	}	
}

split{
	var currentSplit = vars.splits[vars.splitIndex];
	if (current.roomID == currentSplit[0] && old.roomID == currentSplit[1]){
		vars.splitIndex += 1;
		return true;
	}
}

start{
	if (current.roomID == 23 && old.roomID == 21){
		vars.splitIndex = 0;
		return true;
	}
}

reset{
	return (current.roomID == 21);
}

gameTime{
	return TimeSpan.FromMilliseconds(current.IGT*10);
}
