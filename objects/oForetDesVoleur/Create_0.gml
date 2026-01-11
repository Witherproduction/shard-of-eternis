/// @description Init Foret des Voleurs
event_inherited();

mask_sprite = sMasqueForetDesVoleur;

// Condition : Fin du Tuto (Chap 0, Acte 1)
required_chapter = 0;
required_act = 1;

// Points du pochoir pour révéler la zone (Coordonnées écran/map)
mask_points = [
    {x:150, y:87}, {x:151, y:98}, {x:166, y:110}, {x:171, y:128}, {x:169, y:137}, {x:155, y:135}, {x:150, y:138}, {x:140, y:134}, 
    {x:123, y:149}, {x:124, y:166}, {x:108, y:168}, {x:101, y:175}, {x:93, y:165}, {x:86, y:167}, {x:85, y:175}, {x:72, y:175}, 
    {x:64, y:179}, {x:56, y:175}, {x:52, y:172}, {x:47, y:176}, {x:46, y:183}, {x:40, y:185}, {x:33, y:176}, {x:46, y:164}, 
    {x:45, y:156}, {x:39, y:147}, {x:55, y:135}, {x:55, y:135}, {x:55, y:129}, {x:47, y:125}, {x:47, y:120}, {x:55, y:114}, 
    {x:48, y:109}, {x:51, y:98}, {x:63, y:94}, {x:62, y:87}, {x:66, y:82}, {x:75, y:91}, {x:83, y:92}, {x:86, y:81}, {x:91, y:83}, 
    {x:94, y:88}, {x:100, y:88}, {x:103, y:79}, {x:109, y:76}, {x:114, y:81}, {x:113, y:87}, {x:119, y:88}, {x:121, y:80}, 
    {x:127, y:80}, {x:150, y:85}
];
