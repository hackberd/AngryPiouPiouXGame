class APP_Projectile_BlueBird extends APP_Projectile;

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

var bool special;
/*
event bool OnMobileTouch(PlayerController InPC, Vector2D TouchLocation){

	worldinfo.Game.Broadcast(self, " OBJECT TOUCH " @ self @" At POSITION" @ Touchlocation.X@" " @Touchlocation.X);
	self.SpecialEffect();
	return true; //input processeed
}
*/

function SpecialEffect()
{
	local APP_Projectile_BlueBird newBird;
	local Vector location_;
	if (special) {
		special = false;
	location_ = self.Location;
	location_.Y = location.Y - 0.1;
	newBird = spawn(class 'APP_Projectile_BlueBird',self,'mytaghere', location_ ,self.Rotation,/*Archetype here*/ ,true);

	newBird.ApplyImpulse(self.Velocity*1.5,VSize(self.Velocity),newBird.Location);
	newBird.SetDrawScale(0.1);
	APP_Game(worldinfo.Game).getCamera().setProjectile(
		newBird
		);
	newBird = spawn(class 'APP_Projectile_BlueBird',self,'mytaghere', self.Location,self.Rotation,/*Archetype here*/ ,true);
	// FRand() random float 0 to 1.0
	// vect http://udn.epicgames.com/Three/UnrealScriptFunctions.html
	newBird.ApplyImpulse(self.Velocity*1.4,VSize(self.Velocity),newBird.Location);
	newBird.SetDrawScale(0.1);

	newBird = spawn(class 'APP_Projectile_BlueBird',self,'mytaghere', self.Location,self.Rotation,/*Archetype here*/ ,true);
	// FRand() random float 0 to 1.0
	// vect http://udn.epicgames.com/Three/UnrealScriptFunctions.html
	newBird.ApplyImpulse(self.Velocity*1.2,VSize(self.Velocity),newBird.Location);
	newBird.SetDrawScale(0.1);
	
	}
	self.Destroy();
}


DefaultProperties
{
	 MyName = "Blue Bird"
	bEnableMobileTouch = true
   special = true;
	DrawScale             =0.2
	

	Begin Object Name=StaticMeshComponent0
            StaticMesh      =StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Sphere'
        	Materials(0)    =Material'AngryPiouPiouXAllAssets.Materials.VertexColorViewMode_BlueOnly'
			PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.PhysicalMaterials.PM_Projectile'
		    bNotifyRigidBodyCollision=true // necessary to trigger Event RigiBodyCollision
		    ScriptRigidBodyCollisionThreshold=10.0// necessary to trigger Event RigiBodyCollision
     End Object

}
