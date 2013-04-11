class APP_WoodBlock extends APP_Block;

auto state Fixed{
	// COLISIONS here informations from physics
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

DefaultProperties {
	Begin Object Name=StaticMeshComponent0
		/// Mesh -> Objekt
		// 
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_BlockWall_02_D'
		    /// Material Umstellen
			PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.PhysicalMaterial.PM_Wood_Block'  //contains physical parameters + impact effects
    End Object
}