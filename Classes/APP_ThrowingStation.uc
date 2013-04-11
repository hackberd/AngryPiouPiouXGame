/** 
 *  Example of "Slingshot" (i.e. Birdss Slingshot in Angry Birds)
 *  Roles: 
 *   - Defines reference point for player's pawn location and rotation
 *   - Defines the type of projectiles to use and function to spawn them and apply in impulse on
 *  States:
 *  -ACTIVE
 *  Note:
 *  
*/

class APP_ThrowingStation extends DynamicSMActor ClassGroup(AngryPiouPiou) placeable ;

var() class<APP_Projectile>  ProjectileClass;

var() int                    ProjectileNumber;
var() float                  MaxImpulseForce;
var() float                  InputVectorMultiplier;

var() float NewGameSpeed;

var() float DefaultGravity;

var() Material TouchMaterial;
var Material NoTouchMaterial;

var  APP_Projectile          LastProjectileThrown; 

var vector2D                 PrevStartTouch,PrevStopTouch;

//var APP_Projectile AngryPiouPiouXProjectileArchetype; // i.e. list of default properties that the Level Editor can edit from the Editor, can experitment different properties without to have to recompile the script
                                                        //: details on archetype: http://udn.epicgames.com/Three/ArchetypesTechnicalGuide.html 

var APP_GameStateData GameState;

/** Init*/
function init(APP_GameStateData GS){
    GameState = GS;
	GameState.nbProjLeft = ProjectileNumber;
	setGameSpeed();
	NoTouchMaterial = StaticMeshComponent.GetMaterial(0).GetMaterial();
	gotostate('Active');
}

/** Debuggin function */
function setGameSpeed() {
	WorldInfo.Game.SetGameSpeed(NewGameSpeed);
	
	}

function setGravity() {
	//WorldInfo.Game.SetPhysics(
}




function ReActivate(){
gotostate('Active');
}

State Active{
event bool OnMobileTouch(PlayerController InPC, Vector2D TouchLocation){
	worldinfo.Game.Broadcast(self, " OBJECT TOUCH " @ self @" At POSITION" @ Touchlocation.X@" " @Touchlocation.X);
	
	// set material
	StaticMeshComponent.SetMaterial(0, TouchMaterial);
	
	APP_Game(WorldInfo.game).getPlayerController().ThrowingPhase();
	self.GotoState('Inactive');
	return true; //input processeed
}
}

State Inactive{
event bool OnMobileTouch(PlayerController InPC, Vector2D TouchLocation){
	// do nothing until player has thrown the "bird" , avoid player to re-touch station while rotating the pawn
	
	return true; //input processeed
}
}

Function ThrowProjectile(rotator r, float magnitude, vector origin){
   local vector impulse;
   impulse = vector (r);
   impulse = normal(impulse) * magnitude;
   ThrowProjectileFrom( Impulse,  origin);
}

Function ThrowProjectileFrom(vector Impulse, vector origin){
	// Impuse -> Direction

	local vector  loc;
	local rotator rot;
	
	loc     = origin;
	rot     = Rotator (Impulse);
	// Spawn Projectile, 
	LastProjectileThrown    = spawn(class 'APP_Projectile',
									self,
									'projectile_tag', 
									loc, 
									rot,/*Archetype here*/ ,
									true);

	// SET GRAVITY
	WorldInfo.WorldGravityZ = LastProjectileThrown.Gravity;
	//

    Impulse *= self.InputVectorMultiplier;
	
    WorldInfo.Game.Broadcast(self," Impulse with multiplier "@Vsize(Impulse));
	
	if(Vsize(impulse)> self.MaxImpulseForce) {
		impulse = Normal(impulse) * MaxImpulseForce;
	}
	WorldInfo.Game.Broadcast(self," Impulse with after nomarlisation "@Vsize(Impulse));
	
	// SET NO TOUCH MATERIAL
	StaticMeshComponent.SetMaterial(0, NoTouchMaterial);
	
	LastProjectileThrown.ApplyImpulse(Impulse,VSize(Impulse), LastProjectileThrown.location);
	
	GameState.nbProjLeft--;
}

function resetGravity() {
	WorldInfo.WorldGravityZ = DefaultGravity;
}

function rotator getElevation(vector2D StartTouch, vector2D EndTouch, Rotator PawnRot){
	local vector2D  direction;
	local rotator newRotation; 
	local float Yoffset,PitchAngle;
	local float dir;
	if(class 'APP_MathUtils'.static.equal(EndTouch,PrevStopTouch)) {
		return PawnRot;
	}
	
	PrevStopTouch  = EndTouch;

	direction = class 'APP_MathUtils'.static.getVectorDir(StartTouch,EndTouch);
    Yoffset = StartTouch.Y - EndTouch.Y;
	if(Yoffset < 0) dir = 1.0;  // if up
	else            dir =-1.0;  // if down
    PitchAngle          = class 'APP_MathUtils'.static.getAngle(direction);//dir * Magnitude(direction);
	newRotation         = self.rotation;
	newRotation.Pitch   = abs(PitchAngle) *dir *DegToUnrRot * 0.3;
	PitchAngle          = newRotation.pitch * UnrRotToDeg;
	Worldinfo.Game.Broadcast(self, " PitchAngle" @ PitchAngle @"Magnitude(v)"@class 'APP_MathUtils'.static.Magnitude(direction) @" Yoffset "@Yoffset);
	return newRotation;
}

function vector Elevation(vector2D up2D){
	 local vector newVector,X,Y,Z ;
	 self.getAxes(self.Rotation,X,Y,Z);
	 newVector = normal(X)  + normal(Z) * class 'APP_MathUtils'.static.Magnitude(up2D) * 100.0 +  Y;
	 return newVector;
}
function vector addElevation(vector originalVector, float angle_degree){
	 local vector up, newVector ;
	 local float sizeOfUp, radian;
	 radian = (angle_degree * 2 * PI) /360 ;
	 up = vect(0.0,0.0,1.0);
	 sizeOfUp = sin(radian) * VSize(originalVector);
	 up *= sizeOfUp;
	 newVector = originalVector + up;
	 return newVector;
}


DefaultProperties
{
	//AngryPiouPiouXProjectileArchetype=APP_Projectile'AngryPiouPiouXAllAssets.Projectile.ProjectileArchetype'
    ProjectileClass=class'APP_Projectile'
    ProjectileNumber=5
	MaxImpulseForce=4000
    InputVectorMultiplier=1000
	NewGameSpeed=1
	bEnableMobileTouch=True
	DefaultGravity = -520;

	
	TouchMaterial = Material'AngryPiouPiouXAllAssets.Materials.APP_BlockWall_Green'

	Tag="MAINTHROWINGSTATION"
	Begin Object  Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.TexPropCylinder'
		//Materials(0)=MaterialInstanceConstant'AngryPiouPiouXAllAssets.Materials.APP_BlockWall_ThrowingStation'
		Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_BlockWall_02_D'
		BlockRigidBody=false
		bUsePrecomputedShadows=
	FALSE
		
	End Object
	DrawScale=0.300000
	PrePivot=(X=0.000000,Y=0.000000,Z=250.000000) // shift the mesh pivot point to be on the top of the cylinder
	
	

	// Collision Cylinde ringame
	Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollisionRadius=+00050.000000
		CollisionHeight=+000150.000000
		CollideActors=true
		// soll ball nicht blocken
		blockActors=false
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}
