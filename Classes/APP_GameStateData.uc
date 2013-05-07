/** 
 *  Example of a Game State Data holder
 *  -Database of the current game states (game variables values)
 *  -Accessed/Modified by Game Entities
 *  -Centralise all important game gata
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_GameStateData extends Object;

//REM: var are public for code simplification
var public int      nbProjLeft;
var public int      nbTargetLeft;
var public float    Score;
var public string   Reason;
var public String   GameOverReason;
var public bool     bIsGameOver;
var public bool     bIsGameStarted;
var public bool     bIsGamePaused;

var int LevelIndex;
var array<string>  Levels;
var array<bool>  LevelsComplete;

function init(){
	Levels.AddItem("APP-Level-0.udk");
	Levels.AddItem("APP-Level-1.udk");
	Levels.AddItem("APP-Level-2.udk");
	Levels.AddItem("APP-Level-3.udk");
	Levels.AddItem("APP-Level-4.udk");

	reset(); // just as security
}

function reset(){ 
	bIsGameOver     = false;
	bIsGameStarted  = false;
	bIsGamePaused   = false;
	
}

exec function initreset() {
	 local array<bool>  LevelsCompletes;
	`log("RESETTING GAME STATE DATA");
	Score           = 0;

	LevelsCompletes.AddItem(false);
	LevelsCompletes.addItem(false);
	LevelsCompletes.AddItem(false);
	LevelsCompletes.AddItem(false);
	LevelsCompletes.AddItem(false);

	self.LevelsComplete = LevelsCompletes;
	self.LevelIndex = 0;
	SaveGame();
}

/** Saving/loading functions example*/
/*
 * * TODO: Finish load game features by adding last game map play plus overall player score/achievement system 
* */

function SaveGame(){
	`log("SAVING DATA, LEVEL"$LevelIndex);
	class'Engine'.static.BasicSaveObject(self, "APP_SavedGame1.bin", true, 0);
}
Function LoadSavedGame(){
 local APP_GameStateData TempGameState;
 TempGameState = new class'APP_GameStateData';
 if(class'Engine'.static.BasicLoadObject(TempGameState, "APP_SavedGame1.bin", true, 0)){
	
	self.score = TempGameState.Score; // just for example (should have an overall score (i.e. cumulated for each map)
	self.LevelIndex = TempGameState.LevelIndex;
	self.LevelsComplete = TempGameState.LevelsComplete;
	`log("LOADING DATA, LEVEL "$LevelIndex);
 }
 else {
	initreset();
 }
}

function string getNextLevel(){
	local string level;

	self.LevelsComplete[LevelIndex] = true;
	LevelIndex++;
	level = Levels[LevelIndex];

	if (LevelIndex == 4) {
		 LevelIndex = 0;
	}
	return level;
}

DefaultProperties
{
	Score = 0
	bisGameOver     = false
	bIsGameStarted  = false
	bIsGamePaused   = false
}



