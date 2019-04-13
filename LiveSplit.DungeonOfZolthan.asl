state("Dungeon of Zolthan"){
	double IGT: "Dungeon of Zolthan.exe", 0x486520;
}

gameTime{
	return TimeSpan.FromMilliseconds(current.IGT*10);
}
