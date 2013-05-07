/** 
 *  Example of a Physics-Based Game Framework
 *  - Game Type: Angry-Birds-like 3D
 *  - Defines Game Entities in a Level
 *  - Init Game by creating them 
 *  - Contain Accessors to Them (lazy initialisation) - Singleton-like Patterns
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */


class APP_Game extends FrameworkGame;
 
/**UDK derived Game Actors */
var APP_PlayerController            GamePlayerControler;
var APP_PlayerPawn                  GamePlayerPawn;
var APP_PlayerHUD                   GamePlayerHUD;

/**Game specific Actors*/
var APP_GameStateController GameStateController;
var APP_GameStateData       GameStateData;
var APP_Camera              GameMainCamera;
var APP_ThrowingStation     GameMainThrowingStation;

var class<APP_GameStateController> GameStateControllerClass;
var class<APP_GameStateData>       GameStateDataClass;
var class<APP_Camera>              GameMainCameraClass;
var class<APP_ThrowingStation>     GameMainThrowingClass;
var class<APP_Level> AllLevels;

var name       GameStateControllerTag;
var name       GameStateDataTag;
var name       GameMainCameraTag;
var name       GameMainThrowingTag;



var bool       bStartMenu;


event InitGame( string Options, out string ErrorMessage )
{
	
  local String bStartMenuOption;
  `log("Got Here");
  super.InitGame(Options,ErrorMessage);
  BstartMenuOption = ParseOption( Options, "bStartMenu" ) ;
  if(bStartMenuOption==""){
	errorMessage = "Missing bStartMenu in Game launching options";
   `LOG(ErrorMessage);
    bStartMenu=false; //by default no startmenu if not specified (convenient when testing game in level editor)
  }else{
   bStartMenu = ( bStartMenuOption ~= "True" ); //to avoid re-displayer start menu (every time loading a map)
  }
}


/*States*/
auto State InitMainGameActors
{
Begin:   
    Worldinfo.Game.Broadcast(self,"Welcome to AngryPiouPiou iOS v0.01");
   `log("----------------------------------------------------------------");
   
   `log("APP Game Actor Loading...");
   
	InitUDKGameActors(); //init UDK inherited Actors (i.e playercontroller, pawn, HUD)
 
    InitGameActors();  //init APP Game Actors 
	
   `log("APP Game Actor Loaded !!");
    
   `log("----------------------------------------------------------------");
}

/* Default Events Overriding*/

event OnEngineHasLoaded()
{/*WorldInfo extends Zone Info - Contains all script accessible actor in Level (Pawn,Controller), MapInfo, Gravity etc..*/
  WorldInfo.Game.Broadcast(self, "AngryPiouPiou - Engine Finished Loaded");
}

function bool PreventDeath(Pawn KilledPawn, Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
  return true; // for the moment, we dont want to kill Player Pawn (dont want to deal with Playerpawn, Unpossess-Respawn-Possess cycle
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return super.SetGameType(MapName,Options, Portal); // could be used later to filter game map name, or force or override few default class at startup
}
  

/** Game Actors Init*/

function InitUDKGameActors()
{
	local Actor A;
	// tell all actors the game is starting
	ForEach AllActors(class'Actor', A)
	{
		A.MatchStarting();
	}
	// start human players first
	StartHumans();
	bWaitingToStartMatch = false;
	// fire off any level startup events
	WorldInfo.NotifyMatchStarted();
}


function InitGameActors(){



GamePlayerControler    = getPlayerController();
GamePlayerPawn          = getGamePlayerPawn();
GamePlayerHUD           = getHUD();

GameStateData               = getGameStateData();
GameStateController         = getGameStateController();
GameMainCamera              = getCamera();
GameMainThrowingStation     = getThrowingStation();

GameStateData.init();
GamePlayerHUD.init(GameStateData);
GamePlayerControler.init(); 
GameMainCamera.init(GamePlayerControler);
GameMainThrowingStation.init(GameStateData) ;
GameStateController.init(GameStateData,bStartMenu); // Always init Game controller last one as it uses game actors states to decide of the next game state 
}

/**
 *  Functions to init main Game Actor References (e.g. Camera, player controller)
 *  Most of these function "find" actor that have been placed in the map by level designer (e.g. Camera)
 *  They output a error message in log file if havent find the necessary actors in map
 * */


/* init Actor Lazy Initialisation*/

function APP_Camera getCamera()
{   //lazy initialisation
   local bool bFound;
   bFound=false;
	if(GameMainCamera==none)
	{
		foreach allactors(class'APP_Camera' ,GameMainCamera) //slow but done only at level loading
		{ 
 			if(GameMainCamera.Tag==GameMainCameraTag) 
 			{
 			`logd("Camera found "@GameMainCamera);
			 bFound=true;
			 break;
 			} 		
        }
		if(!bFound) `log("ERROR ==> not APP_Camera found in map !! Please place one");
	}
	
	return GameMainCamera;
}


/* init */
function APP_ThrowingStation getThrowingStation()
{   //lazy initialisation
   local bool bFound;
   bFound=false;
	if(GameMainThrowingStation==none)
	{
		foreach allactors(class'APP_ThrowingStation' ,GameMainThrowingStation) //slow but done only at level loading
		{ 
 			if(GameMainThrowingStation.Tag==GameMainThrowingTag) 
 			{
 			`logd("ThrowingStation found "@GameMainThrowingStation);
			 bFound=true;
			 break;
 			} 		
        }
	  if(!bFound) `log("ERROR ==>  APP_ThrowingStation not found in map !! Please place one");
	}
	return GameMainThrowingStation;
}

function APP_PlayerController getPlayerController(){
  if(GamePlayerControler ==none){
	GamePlayerControler    = APP_PlayerController(self.GetALocalPlayerController());
  }
  return GamePlayerControler;
}

function APP_PlayerHUD getHUD(){
  if(GamePlayerHUD==none){
	GamePlayerHUD= APP_PlayerHUD(GamePlayerControler.myHUD);
  }
  return GamePlayerHUD;
}

function APP_PlayerPawn getGamePlayerPawn(){
   if(GamePlayerPawn==none){
   GamePlayerPawn = APP_PlayerPawn(getPlayerController().Pawn);
   }
   return GamePlayerPawn;
}



function APP_GameStateData getGameStateData(){
	if(GameStateData==none) {
		GameStateData =new GameStateDataClass;
		`log("LOADING GAMESTATE DURING START");
		GameStateData.LoadSavedGame();
	}
	return GameStateData;
}

function  APP_GameStateController getGameStateController(){
  if(GameStateController==none) GameStateController     =Spawn(GameStateControllerClass,self);
  return GameStateController;
}

/**define default value (i.e. a prototype)*/
defaultproperties
{
	/*UDK Default Game Actor Class Framework*/
	HUDType                     =class'APP_PlayerHUD'
	PlayerControllerClass       =class'APP_PlayerController'
	DefaultPawnClass            =class'APP_PlayerPawn'
	//PlayerReplicationInfoClass  =class'AngryPiouPiouXGame.AngryPiouPiouXPlayerReplicationInfo'
    //GameReplicationInfoClass    =class'AngryPiouPiouXGame.AngryPiouPiouXGameGameReplicationInfo'
	
	bDelayedStart=false

	/*PHYSIC-BASED Game AngryPiouPiou extended Class Framework*/
	GameStateControllerClass            =class'APP_GameStateController'
	GameStateDataClass                  =class'APP_GameStateData'
	GameMainCameraClass                 =class'APP_Camera'
	GameMainThrowingClass               =class'APP_ThrowingStation'

	/*Game Actor Tag for in-level retrieval (ie.if already placed in map)*/

	GameStateControllerTag          ="GAME_CONTROLLER"
	GameStateDataTag                ="GAME_STATE"
	GameMainCameraTag               ="MAIN_CAMERA"
	GameMainThrowingTag             ="MAINTHROWINGSTATION"

	bStartMenu=true
}



