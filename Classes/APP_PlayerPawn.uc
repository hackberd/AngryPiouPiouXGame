
/** 
 *  Example of Player Pawn
 *  Roles: 
 *   - Defines Player visual representation 
 *     (here a gun rotating around the APP_ThrowingStation pivot point and always facing station's rotation)
 *   -  In theory should handle Pawn animation, motion, inventory, ... see UTPawn.uc)
 *  Note:
 *  - Could be used to modified Camera (here just for info, we are using the APP_Camera actor instead)
 *  - assigned to APP_PlayerController when APP_Game is initialising the game (Pawn Class specified in APP_Game
 *    default properties)
 *   
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_PlayerPawn extends SimplePawn
	 config(Game);

auto state Active{ 
}

function ScaleX(vector2D v){
  local float scaleFactor;
  local vector NewDrawScale;
  scaleFactor   = class 'APP_MathUtils'.static.Magnitude(v);
  NewDrawScale     = self.DrawScale3D;
  NewDrawScale.X   = scaleFactor * 0.01;
  Worldinfo.Game.Broadcast(self, " DrawScale.X " @ DrawScale);
  NewDrawScale.X   =  Fclamp(NewDrawScale.X,1.0,10.0);
  self.SetDrawScale3D( NewDrawScale);
}

	

simulated function bool CalcCamera( float fDeltaTime,  //just for demo (called if setviewtargetsetToPawn// `logd("CalcCamera" @ fDeltaTime);
	                                out vector out_CamLoc, 
	                                out rotator out_CamRot, 
	                                out float out_FOV ){
	 return super.CalcCamera(fDeltaTime ,out_CamLoc,out_CamRot, out_FOV ); //Camera overriding could go here
}

defaultproperties 
{
	Begin Object Class=SkeletalMeshComponent Name=JazzGun
		 SkeletalMesh=SkeletalMesh'AngryPiouPiouXAllAssets.SkeletalMeshes.SK_JazzGun'
		//AnimSets(0)=AnimSet'KismetGame_Assets.Anims.SK_Jazz_Anims'
		//AnimTreeTemplate=AnimTree'KismetGame_Assets.Anims.Jazz_AnimTree'
		Rotation=(Pitch=0,Yaw=-16384,Roll=0) //rotation on oject model (in object coordinate system) to get the face of the gun aligned with the X-axis ( = self.rotation)
		BlockRigidBody=false
		CollideActors=false
		HiddenGame=false
		scale=3.0 
		CastShadow=true
	End Object
	Mesh=JazzGun
	Components.Add(JazzGun)
}
