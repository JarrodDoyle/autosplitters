state("pw_x64"){
	bool levelComplete  : "mono.dll", 0x2629c8, 0x550, 0x550, 0x18, 0x130;
	bool entering		: "mono.dll", 0x2629c8, 0x550, 0x550, 0x18, 0x138;
	bool loading		: "pw_x64.exe", 0x1448738, 0x498;
}

init{
	vars.hasSplit = false;
}


start{
	if (!current.entering && old.entering && !current.loading){
		vars.hasSplit = false;
		return true;
	}
}

split{
	if (current.entering && vars.hasSplit){
		vars.hasSplit = false;
	}
	
	if (current.levelComplete && !vars.hasSplit){
		vars.hasSplit = true;
		return true;
	}
}

isLoading{
	return current.loading;
}