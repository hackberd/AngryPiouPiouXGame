class APP_Block_Bouncing extends APP_Block;

auto state Fixed{
	ignores RigidBodyCollision;

/* TODO: PLACEHOLDER: For Later use, if any game logic applied when hitting the Bouncing Block
	event RigidBodyCollision( PrimitiveComponent HitComponent,
	                      PrimitiveComponent OtherComponent,
				          const out CollisionImpactData RigidCollisionData, 
			              int ContactIndex ){}
*/
begin:
	setphysics(PHYS_NONE);
}

DefaultProperties
{
	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.BouncingWall'
	End Object
	
}