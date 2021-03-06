/** 
 *  Example of a Game Controller
 *  - Controls the different game states transitions 
 *  - Applying Game Rules & Display  Menu & (re)load map
 *  - states:
 *     - GameInit
 *     - GameRunning
 *     - GameResults
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */


class APP_GameStateController extends Actor;

/* Menu*/
var MobileMenuScene CurrentMenu;
var array<APP_Target> Targets;
var APP_GameStateData GameState;





//var String NextLevelMap ;   //TODO Multiple level management (with Menu to select them, save player progression )
var bool bShouldDiplayStartMenu;

var bool bForceWin;
var bool bForceLoose;

/* Init*/
function init(APP_GameStateData GS, bool bStartMenu){
    GameState = GS;
	bShouldDiplayStartMenu=bStartMenu;

	gotostate('GameInit');
}

/*States*/

State GameInit
{	
Begin:
   
    GameState.reset();
    GameState.nbTargetLeft = InitTargets();
    GameState.nbProjLeft   = APP_Game(worldInfo.Game).getThrowingStation().ProjectileNumber;
	if(bShouldDiplayStartMenu){
		CurrentMenu            = APP_GAME(worldinfo.game).getPlayerController().MPI.OpenMenuScene(class'APP_Menu_Start');
	}
	else{
		RunGame();
	}
}

function LoadRightLevel() {
	LoadNextLevel();
}

function RunGame(){
	gotostate('GameRunningPre'); 
	APP_Game(WorldInfo.game).getCamera().GotoState('OverviewCamera');
	APP_GAME(worldinfo.game).getThrowingStation().SpwanNextProjectiles();
	APP_GAME(worldinfo.game).getPlayerController().PreThrowingPhase();
}

state GameRunning
{
 event tick(float DeltaTime){
	  if(       GameState.bIsGameStarted 
			&& !GameState.bIsGamePaused
	  		&& IsGameOver(GameState)){
	  	gotostate('GameWaitingTransition');
	  }
	}
begin:
 GameState.bIsGameStarted=true;
}

state GameRunningPre
{ 
begin:
 Sleep(5);
 gotostate('GameRunning'); 
}


State GameResults 
{
begin:
	IsGameOver(GameState);
	Switch(GameState.GameOverReason)
	{
	case "WON": 
		CurrentMenu  = APP_GAME(worldinfo.game).getPlayerController().MPI.OpenMenuScene(class'APP_Menu_Level_Completed');
         break;
	case "LOST": 
		CurrentMenu  = APP_GAME(worldinfo.game).getPlayerController().MPI.OpenMenuScene(class'APP_Menu_Level_Failed');
		break;
	default:
		`WARN("GameState.GameOverReason = " @ GameState.GameOverReason @" is unknow reloading current level");
		 ReloadSameLevel();
		 break;
	}	
}

State GameWaitingTransition
{
begin:
	sleep(5.0);
    self.gotostate('GameResults');
}

/* In-state Function - Game RUNNIG*/

function bool IsGameOver(out APP_GameStateData GS)
{

	//DEBUG options exec Win / loose
	if(bForceWin)
	{
		GameState.bIsGameOver =  true;
		GameState.GameOverReason = "WON";
		return true;
	}
	if(bForceLoose)
	{
		GameState.bIsGameOver = true;
		GameState.GameOverReason = "LOST";
		return true;
	}

  //Winning Conditions
  if(AllTargetDead(GS,"WON")) return true;
	
  //Losing Conditions
   if(!HasProjectileLeft(GS,"LOST")) return true;

  return false;
	
	
	
}

/* Game Condition Rules*/

Function bool AllTargetDead(APP_GameStateData GS, String Reason)
{
	 local  APP_Target TargetTemp;
	 local bool bAllDead;
	 local int TargetNotDead;

	 bAllDead=true;
	 foreach Targets(TargetTemp){ 
     if(TargetTemp.bisDead){ 
     }else {
     	bAllDead=false ;
        TargetNotDead++;
     }
	}
	GS.nbTargetLeft = TargetNotDead;
	if(bAllDead){
	GS.bIsGameOver =  true;
	GS.GameOverReason = Reason;
	}
	return bAllDead;
}

Function bool HasProjectileLeft(APP_GameStateData GS, String Reason)
{
	if(GS.nbProjLeft>=1) {
		return true;
	}
	else{
		GS.bIsGameOver    = true;
		GS.GameOverReason = Reason;
		return false;
	}
}

function ShowLevelSelection()
{
	CurrentMenu  = APP_GAME(worldinfo.game).getPlayerController().MPI.OpenMenuScene(class'APP_Menu_LevelSelection');
}

/* Level Management*/

function LoadLevel(string LevelName)
{
	local string Command;
	Command = "open " @ LevelName;
	ConsoleCommand(Command);
}

/* In state function - Game Transition*/
function LoadNextLevel()
{
	local string level;
    // save player data (score,name) //TODO
	//load next map
	level = APP_Game(worldInfo.Game).getGameStateData().getNextLevel();
	APP_Game(worldInfo.Game).getGameStateData().SaveGame();
	`log("LOADING LEVEL "$level);
	LoadLevel(level$"?bStartMenu=false"); //will destroy nearly all objects before reloading new map
	
}

function ReloadSameLevel()
{
	local string FullMapName;
	 // save player Data

	//load next map
    FullMapName= "APP-"$ worldinfo.GetMapName() $".udk";
	LoadLevel(FullMapName$"?bStartMenu=false");
}
/* in-state functions - INIT*/

function  int InitTargets()
{
	local  APP_Target TargetTemp;
	
	// see http://udn.epicgames.com/Three/UnrealScriptIterators.html
	
	foreach AllActors(class 'APP_Target',TargetTemp) //slow but we dont care, as running at init
	{ 
     Targets.AddItem(TargetTemp); //cache target in game @init == if target dynamically created need to empty stact and reset it !!
	}	
	 return Targets.Length;
}

DefaultProperties
{
    bForceWin = false;
	bForceLoose = false;
}
