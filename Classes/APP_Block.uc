/** 
 * Example of PhysX-Controlled Building Blocks for destroyable structure
 * - Placeable  
 * - Destroyed on Impact with a APP_Projectile type if impact >ImpactForceForDestruction
 * - 2 states: Active and InActive
 * 
 * @Todo  destruction conditions and animations 
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_Block extends KActorSpawnable 
	ClassGroup(AngryPiouPiou)
	placeable;
   

var() int Score;
var() float ImpactForceForDestruction;
var   bool bisDead;

auto state Fixed{
	
	event RigidBodyCollision( PrimitiveComponent HitComponent,
	                      PrimitiveComponent OtherComponent,
				          const out CollisionImpactData RigidCollisionData, 
				          int ContactIndex ){
			local float collisionforce;
			collisionforce = vsize(rigidcollisiondata.totalnormalforcevector);
			if (collisionforce >= ImpactForceForDestruction){
			  self.GotoState('Destroyed_');
			 // begin object class=AnimNodeSequence name=blankanimseq
			}else{
			 //TODO: do something else here
			}
	}
begin:
	//setphysics(PHYS_NONE); // example
}

state Destroyed_{

ignores RigidBodyCollision;

begin:
 //TODO: do some animation here
	 bisDead =true;
	 APP_Game(worldinfo.Game).getGameStateData().Score += Score;

	self.destroy();
}

DefaultProperties
{
	Score=1000;
    ImpactForceForDestruction=10.0
	bIsdead =false
    bEnableMobileTouch=true
  	
	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_BlockWall_02_D'
		    PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.physicsmaterial.PM_Stone'  //contains physical parameters + impact effects
		    //ReplacementPrimitive=None
            //RBChannel=RBCC_GameplayPhysics
            //bAllowApproximateOcclusion=True
            //bForceDirectLightMap=True
            //bUsePrecomputedShadows=True
            //LightingChannels=(bInitialized=True,Static=True)
		    bNotifyRigidBodyCollision=true // necessary to trigger Event RigiBodyCollision
		    ScriptRigidBodyCollisionThreshold=10.0// necessary to trigger Event RigiBodyCollision
      End Object
}

