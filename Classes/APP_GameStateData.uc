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

function init(){
	  reset(); // just as security
}

function reset(){ 
	Score           = 0;
	bIsGameOver     = false;
	bIsGameStarted  = false;
	bIsGamePaused   = false;
}

/** Saving/loading functions example*/
/*
 * * TODO: Finish load game features by adding last game map play plus overall player score/achievement system 
* */

function SaveGame(){
class'Engine'.static.BasicSaveObject(self, "APP_SavedGame.bin", true, 0);
}
Function LoadSavedGame(){
 local APP_GameStateData TempGameState;
 TempGameState = new class'APP_GameStateData';
 if(class'Engine'.static.BasicLoadObject(TempGameState, "APP_SavedGame.bin", true, 0)){
 self.score = TempGameState.Score; // just for example (should have an overall score (i.e. cumulated for each map)
 }
}

DefaultProperties
{
	Score = 0
	bisGameOver     = false
	bIsGameStarted  = false
	bIsGamePaused   = false
}



