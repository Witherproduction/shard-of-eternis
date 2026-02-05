show_debug_message("### oFieldMonsterEnemy.create - before event_inherited")
event_inherited();
show_debug_message("### oFieldMonsterEnemy.create - after event_inherited")


///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

// HEARTHSTONE CUSTOM BOARD: 8 Slots (2 Rows of 4)
// Row 1 (Front): Indices 0-3
// Row 2 (Back): Indices 4-7
posLocation = [
	[690, 400], // Slot 0
	[870, 400], // Slot 1
	[1050, 400], // Slot 2
	[1230, 400], // Slot 3
	[690, 250], // Slot 4
	[870, 250], // Slot 5
	[1050, 250], // Slot 6
	[1230, 250]  // Slot 7
];


///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////
