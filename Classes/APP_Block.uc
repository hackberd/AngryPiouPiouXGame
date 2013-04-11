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
   

var(SCORING_SYSTEM) int Score;
var(IMPACT_FORCE) float ImpactForceForDestruction;
var   bool bisDead;

// First state Fixed
auto state Fixed{
	// COLISIONS here informations from physics
	// 
	event RigidBodyCollision( PrimitiveComponent HitComponent,
	                      PrimitiveComponent OtherComponent,
				          const out CollisionImpactData RigidCollisionData, 
				          int ContactIndex ){
			local float collisionforce;
			// totalnormalforcevector -> Force of impact
			collisionforce = vsize(rigidcollisiondata.totalnormalforcevector);
			if (collisionforce >= ImpactForceForDestruction){
			  // IS ENOUTH TO DESTROY OBJECT?
			  self.GotoState('Destroyed_');
			  // Destroyed is own function, siehe unten
			}else{
			 //TODO: do something else here
			}
	}
begin:
	//setphysics(PHYS_NONE); // example
}

state Destroyed_{
	// Phsyic many rigidbodcolission -> ignore all future events
	ignores RigidBodyCollision;

	begin:
	 //TODO: do some animation here
	bisDead =true;
	APP_Game(worldinfo.Game).getGameStateData().Score += Score;
	sleep(0.0);
	self.destroy();
}

DefaultProperties
{
	// PROPERTIES OF THIS ONE
	Score=1000;
    ImpactForceForDestruction=10.0
	bIsdead =false
    bEnableMobileTouch=true
  	
	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_BlockWall_02_D'
		    PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.physicsmaterial.PM_Stone'
		
            //RBChannel=RBCC_GameplayPhysics
		    //LightingChannels=(bInitialized=True,Static=True)

		    bNotifyRigidBodyCollision=true // necessary to trigger Event RigiBodyCollision
		    ScriptRigidBodyCollisionThreshold=10.0// necessary to trigger Event RigiBodyCollision
      End Object
}

