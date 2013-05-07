/** 
 *  Example of a Player Controller
 *  Role: 
 *  -Interprets player inputs according to game state, and move player Pawn accordingly
 *  -Defines InputClass to use in Defaultproperties
 *  States:
 *    - PlayerInit
 *    - PlayerMovingCamera
 *    - PlayerThrowing
 *    - PlayerWaitingResults
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */



class APP_PlayerController extends SimplePC
	config(Game);

/*Input buffered var*/
var vector2D StartTouch2DVector,EndTouch2DVector,Swipe2DVector;
var vector   Swipe2DVector3D;
var float    Swipe2DVectorVSize;
var  float   Angle,AngleBefore;
var rotator  r;

var  APP_Projectile          LastProjectileThrown; 

/** init*/

function init(){
	InitPhase();
}

/**Helpers functions to change states (avoid to update all code when changing state's name*/

function InitPhase(){
	 self.gotostate('PlayerInit');
}
function PreThrowingPhase(){
	 self.gotostate('PlayerMovingCamera');
}
function ThrowingPhase(){
	 self.gotostate('PlayerThrowing');
}
function PostThrowingPhase(){
	 self.gotostate('PlayerWaitingResult');
}

/** exec functions for debugging */

exec function ThrowProj(){
    APP_Game(WorldInfo.game).getThrowingStation().ThrowProjectileFrom(Swipe2DVector3D,pawn.location);
}

exec function PauseMenu(){
	APP_Game(WorldInfo.game).getThrowingStation().setGameSpeed(0.0);
	APP_Game(WorldInfo.game).getGameStateController().CurrentMenu = APP_GAME(worldinfo.game).getPlayerController().MPI.OpenMenuScene(class'APP_Menu_GameMenu');
}

exec function MoveCamera(){
   self.gotostate('PlayerMovingCamera');
}
exec function Win(){
	APP_Game(WorldInfo.game).getGameStateController().bForceWin = true;
}
exec function Loose(){
APP_Game(WorldInfo.game).getGameStateController().bForceLoose = true;
}

exec function SpecialEffect()
{
	APP_Game(WorldInfo.game).getThrowingStation().LastProjectileThrown.SpecialEffect();
}

exec function OpenInGameMenu(){
APP_GAME(worldinfo.Game).getPlayerController().MPI.OpenMenuScene(class'APP_Menu_GameMenu');
}
/** Player Inputs Event*/
/******************************* Player Pawn interaction handling ( event-driven inputkey mapped processing) */

/** ini mobile input zone (set up from DefaultGame.ini) */

function SetupZones(){

	super.SetupZones();
	FreeLookZone.OnTapDelegate          =  MobilePlayerInput(PlayerInput).ProcessWorldTouch; // to trigger Onmobileinput event on actor
	FreeLookZone.OnProcessInputDelegate = TouchScreenInputCallback;
}

/** Player Touch Screen events  handling*/

Function bool TouchScreenInputCallback(MobileInputZone Zone,
								float DeltaTime,
								int Handle,
								ETouchType EventType,
								Vector2D TouchLocation){
	/* place holder overridded in state*/	
	 return false;
}

function UpdateRotation( float DeltaTime ){
       /*function overrided to cancel any pawn rotation from inputs, computed by parent class*/
}


/** STATES*/

State PlayerInit  
{
	/**
	 * Just an example of using ther player tick to read input and compute a player move
	 * not used in our current game version
	 * */
	
	event playertick(float deltatime) {

           PlayerInput.PlayerInput(DeltaTime);
		   PlayerMove(DeltaTime);
     }

	 /**
	  *   just an example of a player pawn acceleration modification
	  *   here: only permit the pawn to move along the Y axis of the Throwing station
	  *   it computes Pawn Movement from integrated inputs (i.e. according to deltatime, Rawdata smoothing , ...) 
	  * */

	function PlayerMove(float DeltaTime) {

		 local vector NewAccel,X,Y,Z;
		 GetAxes(APP_Game(WorldInfo.game).getThrowingStation().rotation,X,Y,Z); // get local referential of fixed throwing station in map
		 NewAccel = PlayerInput.aForward * Y ;
		 NewAccel.Z	= 0;
		 NewAccel = Pawn.AccelRate * Normal(NewAccel);
		 Pawn.acceleration = NewAccel;  
	}
begin:
		//set pawn default loc/rot
        pawn.setPhysics(PHYS_NONE); //by default PHYS_WALKING = pawn fall on the floor, and we want it to be sticked to the throwing station 
		pawn.SetLocation(APP_Game(WorldInfo.game).getThrowingStation().location);
		pawn.SetRotation(APP_Game(WorldInfo.game).getThrowingStation().Rotation); // pointing like throwing station
        // set camera motion mode
		APP_Game(worldinfo.Game).getCamera().SetToFollowPlayerInputs(self);
}

State PlayerMovingCamera {

	Function bool TouchScreenInputCallback(MobileInputZone Zone,
									float DeltaTime,
									int Handle,
									ETouchType EventType,
									Vector2D TouchLocation){
		if (EventType == Touch_Began)	{
			StartTouch2DVector = TouchLocation;
			return false;
		}
		else if(EventType == Touch_Moved)	{
			EndTouch2DVector    = TouchLocation;
			Swipe2DVector       = class 'APP_MathUtils'.static.getVectorDir(StartTouch2DVector ,EndTouch2DVector);
 			APP_Game(WorldInfo.game).getCamera().updateCameraHorizontalAndVerticalOffset(Swipe2DVector,DeltaTime);
			return false; 
		}	else	if (EventType == Touch_Ended)	{
			return false; 
		}
		return false;
	}
begin:
 APP_Game(WorldInfo.game).getCamera().SetToFollowPlayerInputs(self); 
 pawn.SetRotation(APP_Game(WorldInfo.game).getThrowingStation().Rotation); // reset rotation to horizontal
    
}


State PlayerThrowing{

	Function bool TouchScreenInputCallback(MobileInputZone Zone,
									float DeltaTime,
									int Handle,
									ETouchType EventType,
									Vector2D TouchLocation){						
        local rotator newPawnRotation;

		if (EventType == Touch_Began){
			StartTouch2DVector = TouchLocation;
			return true; //input handled no further proceessing
		}else if(EventType == Touch_Moved){
			EndTouch2DVector=TouchLocation;
			Swipe2DVector       = class 'APP_MathUtils'.static.getVectorDir(StartTouch2DVector ,EndTouch2DVector);
			newPawnRotation     = APP_Game(WorldInfo.game).getThrowingStation().getElevation(StartTouch2DVector,EndTouch2DVector,pawn.rotation);
			pawn.SetRotation(newPawnRotation);
			//TODO DEBUG
			//APP_PlayerPawn(Pawn).ScaleX(Swipe2DVector);
			return true; //input handled no further proceessing
		}else if (EventType == Touch_Ended){
			  APP_Game(WorldInfo.game).getThrowingStation().ThrowProjectile(pawn.rotation,
			  																class 'APP_MathUtils'.static.Magnitude(Swipe2DVector),
			  																pawn.location);;
			self.GotoState('PlayerWaitingResult');
			return true; //input handled no further proceessing
		}
		return false; // input not handled
	}	
begin:
	
	
}


state PlayerWaitingResult{

	Function bool TouchScreenInputCallback(MobileInputZone Zone,
									float DeltaTime,
									int Handle,
									ETouchType EventType,
									Vector2D TouchLocation){
		if (EventType == Touch_Began){
			//TODO: trigger a projectile's option when touch screen while projectile is in the air
			APP_Game(WorldInfo.game).getThrowingStation().LastProjectileThrown.SpecialEffect();
			return true; //input handled no further proceessing
		}
		return false; // input not handled
	}

begin:

	LastProjectileThrown = APP_Game(worldinfo.Game).getThrowingStation().LastProjectileThrown;
	APP_Game(worldinfo.Game).getThrowingStation().ReActivate();
	//APP_Game(worldinfo.Game).getCamera().followProjectFromBehind(
	//	APP_Game(worldinfo.Game).getThrowingStation().LastProjectileThrown
	//	);
	//DEBUG TODO uncomment
	//APP_Game(WorldInfo.game).getCamera().SetToFollowProjectile(LastProjectileThrown,6.0);
	sleep(3.0); // hardcoded waiting time
	self.gotostate('PlayerMovingCamera');
}


defaultproperties
{
  InputClass=class'APP_PlayerInput'
}