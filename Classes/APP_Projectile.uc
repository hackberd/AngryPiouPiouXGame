/** 
 *  Example of "Birds' projectile" (i.e. Birds in Angry Birds)
 *  Roles: 
 *   - Physics-based entities that is spawned by the APP_ThrowingStation
 *      (specified in APP_ThrowingStation's variable var() class<APP_Projectile>  ProjectileClass)
 *   - Projectile spawns using the Player's pawn rotation (i.e. gun direction)
 *   - Throwing impulsion magnitude depends on user inputs (size of the "Pulling" vector)
 *  States:
 *  -PROJECTED
 *  -DESTROYED_ANIMATION
 *  Note:
 *  - Here: any physics collision will destroyed it 
 *  
 *  NB: gravity is set in DefaultGameUDK .ini
 *  
 *  [Engine.WorldInfo]
		DefaultGravityZ=-520.0
		RBPhysicsGravityScaling=2.0
	NB: could be changed via editor 
		(worldinfo --> global gravity or adding Physics velocity of a Physics volumes 
		 (e.g. default physisc volume - by default wrapping the whole scene)

 *   
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_Projectile  extends KActorSpawnable ClassGroup(AngryPiouPiou)
	placeable;

var ParticleSystemComponent TrailParticleSystem;

simulated event Postbeginplay(){
   super.PostBeginPlay(); //dont lost previous initialisation (i.e. parent's constructor-like)
   TrailParticleSystem.SetActive(true);
}

auto state Projected{

event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
				const out CollisionImpactData RigidCollisionData, int ContactIndex ){
	 APP_Game(worldinfo.Game).getCamera().setToNormalCam();
	 self.GotoState('Destroyed_');	
 }
}

State Destroyed_{
	ignores RigidBodyCollision;
begin:
 TrailParticleSystem.SetActive(false);
}

/**Special Effect**/
function SpecialEffect()
{
	/*Stub function for Child to override*/
}

DefaultProperties
{     
	  LifeSpan              =4.0 //automaticall destroyed after 4 sec
	  bEnableMobileTouch    =True
      DrawScale             =0.2

	 Begin Object Name=StaticMeshComponent0
            StaticMesh      =StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Sphere'
        	Materials(0)    =Material'AngryPiouPiouXAllAssets.Materials.M_BlockWall_02_D'

			PhyMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.PhysicalMaterials.PM_Projectile'
								
		    bNotifyRigidBodyCollision=true // necessary to trigger Event RigiBodyCollision
		    ScriptRigidBodyCollisionThreshold=10.0// necessary to trigger Event RigiBodyCollision
     End Object
      
	Begin Object Class=ParticleSystemComponent Name=TrailParticleComponent0
		Template      =ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.ProjectileTrail'
		bAutoActivate =false
		SecondsBeforeInactive=5.0f
	End Object

	TrailParticleSystem=TrailParticleComponent0
	components.add(TrailParticleComponent0);
}
