show_debug_message("### oFieldMonsterHero.create - before event_inherited")
event_inherited();
show_debug_message("### oFieldMonsterHero.create - after event_inherited")


///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

// HEARTHSTONE CUSTOM BOARD: 8 Slots (2 Rows of 4)
// Row 1 (Front): Indices 0-3
// Row 2 (Back): Indices 4-7
posLocation = [
	[690, 600], // Slot 0
	[870, 600], // Slot 1
	[1050, 600], // Slot 2
	[1230, 600], // Slot 3
	[690, 750], // Slot 4
	[870, 750], // Slot 5
	[1050, 750], // Slot 6
	[1230, 750]  // Slot 7
];


///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////
