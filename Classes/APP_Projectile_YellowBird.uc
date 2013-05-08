class APP_Projectile_YellowBird extends APP_Projectile;

/*
 * Blue Bird --> OnTouchEvent 1 Bird = 3 little Birds!
 * 
 * TODO: 
 *  1 - Find/Grab Touch event after throwing the projectile
 *      1.1: exec function to simulate TouchEvent
 *      1.2: Get real Touch event
 *  2 - Destroy current one
 *  3 - Spawn 3 others 
 *          - where: current position of this object
 *          - 
 */
var bool special ;

/*
event bool OnMobileTouch(PlayerController InPC, Vector2D TouchLocation){

	worldinfo.Game.Broadcast(self, " OBJECT TOUCH " @ self @" At POSITION" @ Touchlocation.X@" " @Touchlocation.X);
	self.SpecialEffect();
	return true; //input processeed
}
*/

function SpecialEffect()
{
	if (special) {
		special = false;
		ApplyImpulse(self.Velocity,VSize(self.Velocity) * 1.6,Location);
	}
}


DefaultProperties
{
	bEnableMobileTouch = true
	special = true;
	DrawScale             =0.2
    MyName = "Yellow Bird"
	Begin Object Name=StaticMeshComponent0
            StaticMesh      =StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
        	Materials(0)    =Material'AngryPiouPiouXAllAssets.Materials.Yellow'
       
			PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.PhysicalMaterials.PM_Wood_Block'
			//
			//
			//
		    bNotifyRigidBodyCollision=true // necessary to trigger Event RigiBodyCollision
		    ScriptRigidBodyCollisionThreshold=10.0// necessary to trigger Event RigiBodyCollision
     End Object
      
	


}
