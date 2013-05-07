/** 
 * Example of Camera 
 * - 2 (main) states: FOLLOW_PLAYERINPUT and FOLLOW_PROJECTILE
 * 
 * @Todo  : depth navigation (zoom in/out)
 * @Todo  : new navigation trajectory (e.g. orbiting) 
 *  
 *  
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_Camera extends DynamicCameraActor
ClassGroup(AngryPiouPiou)
placeable;

var APP_PlayerController PlayerController;
var bool bFixedCameraOn;

var actor  target;
var actor  Previoustarget;
var actor  Maintarget;
var actor ProjectileToFollow;

var actor  Projectiletarget;
var float  ProjFollowinDuration;

var float  distance;
var vector offset;
var rotator rotationbefore;

var vector2D ScreenVectorMovement;

/** Init*/

function init(APP_PlayerController PC){
    PlayerController = PC;
	SetToFollowPlayerInputs(PC);
}

/** States*/

state INACTIVE{ //in case Releasing Target = for debug
}

State ACTIVE { // just for example of state inheritance 
  simulated event Beginstate(name PrevState){
  }
  simulated event EndState(name NextState){
  }
}

state FollowProjectile extends ACTIVE {
  simulated event Beginstate(name PrevState){
		super.Beginstate( PrevState);// just for example of state inheritance 
  	    rotationbefore= self.rotation;
   }
  simulated event EndState(name NextState){
	   super.EndState( NextState);
	   SetRotation(rotationbefore);
  }
	event tick(float DeltatTime){
	   local rotator rot;
	   //local vector DirectionCamToProj
	   // AB =B-A
	   //
	   rot = rotator ( Projectiletarget.location - self.location);
	   setRotation(rot);
	}
begin: 
	Sleep(ProjFollowinDuration);
	self.gotostate('FollowPlayerInputs');
}

state FollowPlayerInputs extends ACTIVE {

	event tick(float DeltatTime){
	   local vector loc;
	   local vector camX,camY,camZ;
	   getAxes(self.Rotation,camX,camY,camZ);
	   // note: CamZ = Vertical (left/right) , CamY = Horizontal(up/down), CamX = depth (forward/backward)
	   // note: ScreenVectorMovement.Y = vertical screen axis (positive Y-axis is pointing downward of screen)
	   // note: ScreenVectorMovement.X = horizontal screen axis (positive X-axis is pointing Left of screen)
	   loc = self.location + camZ * -1 * ScreenVectorMovement.Y + camY * ScreenVectorMovement.X;  
	   ScreenVectorMovement.X  = 0; // otherwise keep moving even after touch
	   ScreenVectorMovement.Y  = 0; // otherwise keep moving even after touch
	   setlocation(loc);
	}
begin: 
}


function followProjectFromBehind(actor a) {
	ProjectileToFollow = a;
	self.GotoState('ProjectFromBehind');
}

state ProjectFromBehind extends ACTIVE {

	event tick(float DeltatTime){
	   local vector loc;
	   local vector camX,camY,camZ;
	   getAxes(ProjectileToFollow.Rotation,camX,camY,camZ);

	   loc = ProjectileToFollow.location + camZ * -1 * ScreenVectorMovement.Y + camY * ScreenVectorMovement.X;  
	   setlocation(loc);
	   setRotation(rotator(camX));
	}
begin: 
}


/**
 *  Functions 
* */


function SetToFollowPlayerInputs(PlayerController PC){
	PC.SetViewTarget(self);
	self.gotostate('FollowPlayerInputs');
}

function SetToFollowProjectile(actor ProjCamTarget ,float Duration){
	 self.Projectiletarget     = ProjCamTarget;
     self.ProjFollowinDuration = Duration;
	 //SetTimer(duration, false, nameof(ReleaseTemporaryTarget)); // for demo
	 self.gotostate('FollowProjectile');
}


function updateCameraHorizontalAndVerticalOffset(Vector2D v, float delTatime){
		ScreenVectorMovement.X = v.X * delTatime ; // treat as an "acceleration" : integrated over time | and Z because Z-axis is the camera up vector
		ScreenVectorMovement.Y = v.Y * delTatime ;
}

/**
 *  Functions for debugging 
 * */
function ToggleCamera()
{
  bFixedCameraOn=!bFixedCameraOn;
  if(bFixedCameraOn)	 acquireTarget(PlayerController.Pawn,PlayerController);
  else                   releaseTarget(PlayerController);
}
function  AcquireTarget(actor Camtarget, PlayerController PC){
   self.Target = Camtarget;
   Maintarget = Camtarget;
   PC.SetViewTarget(self);
   gotostate('FollowPlayerInputs');
}

function  ReleaseTarget(PlayerController PC){
  PC.SetViewTarget(PC.pawn);
  PC.GotoState('PlayerWalking');
  gotostate('INACTIVE');
}

function AcquireTemporaryTarget (actor Camtarget, PlayerController PC,float duration){
   self.Projectiletarget = Camtarget;
   SetTimer(duration, false, nameof(ReleaseTemporaryTarget));
}

function  ReleaseTemporaryTarget(PlayerController PC){
   self.gotostate('FollowPlayerInputs');
}


DefaultProperties
{
	tag="MAIN_CAMERA"
  
	distance = 400
	offset=(X=0.0,Y=0.0,Z=0.0)
	ScreenVectorMovement=(X=0.0,Y=0.0)
	
	/**inherited var*/
	FOVAngle=90.0
	bConstrainAspectRatio=TRUE
	AspectRatio=AspectRatio4x3 
}
