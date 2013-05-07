/** 
 *  Example of "Birds' Target" (i.e. Pigs in Angry Birds)
 *  Roles: 
 *   - Special type of APP_Block that should be destroyed by Player using APP_Projectile
 *   - Physics-based entities that should be destroyed by APP_Projectile
 *   - destroyed when hit by a APP_Projectile or APP_Blocks falling or any Physics-based Actor colliding with it
 *  Note:
 *  - Here: any physics collision will Destroyed (see Parent's code)
 *  - APP_GameController is collecting all the targets present in the Map at Level Initialisation
 *    to track their states and determine if all of them have been killed by the player
 *   
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_Target extends APP_Block ClassGroup(AngryPiouPiou)
	placeable;

DefaultProperties
{
	bIsdead =false
    bEnableMobileTouch=true
	Drawscale=0.3
    ImpactForceForDestruction=600
	Score=20000;

	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    //Materials(0)=MaterialInstanceConstant'AngryPiouPiouXAllAssets.Materials.APP_BlockWall_Target'
            Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.APP_BlockWall_Green'
		    //ReplacementPrimitive=None
            //RBChannel=RBCC_GameplayPhysics
            //bAllowApproximateOcclusion=True
            //bForceDirectLightMap=True
            //bUsePrecomputedShadows=True
            //LightingChannels=(bInitialized=True,Static=True)
		    bNotifyRigidBodyCollision=true // necessary to trigger Event RigiBodyCollision
		    ScriptRigidBodyCollisionThreshold=10.0// necessary to trigger Event RigiBodyCollision
      End Object
	//ImpactSoundComponent=SoundCue'CastleAudio.UI.UI_TouchToMove_Cue'
}

