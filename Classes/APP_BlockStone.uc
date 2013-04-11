class APP_BlockStone extends APP_Block;

var ParticleSystemComponent ExlopsionParticleSystem;
var AudioComponent ExplodeSound;
var int Health;

auto state Fixed{
	// COLISIONS here informations from physics
	event RigidBodyCollision( PrimitiveComponent HitComponent,
	                      PrimitiveComponent OtherComponent,
				          const out CollisionImpactData RigidCollisionData, 
				          int ContactIndex ){
			local float collisionforce;
			// totalnormalforcevector -> Force of impact
			

			
			
			ExlopsionParticleSystem.SetActive(true);
			
			collisionforce = vsize(rigidcollisiondata.totalnormalforcevector);
			
			Health = Health - collisionforce;

			//Worldinfo.Game.Broadcast(self,"HP: "@Health);
			if (Health < 0){
			  // IS ENOUTH TO DESTROY OBJECT?
			   ExplodeSound.Play();				
			   ExlopsionParticleSystem.SetActive(false);
			  self.GotoState('Destroyed_');
			  // Destroyed is own function, siehe unten
			
			}else{
			
			  self.GotoState('Falling_');
			}
	}
begin:
	//setphysics(PHYS_NONE); // example
}

state Falling_ {
	ignores RigidBodyCollision;

	event Timer() 
	{
		self.GotoState('Fixed');
	}
	begin:
	settimer(0.2,false);
}

DefaultProperties
{
	Score=10000;
    ImpactForceForDestruction=10000.0
	Health = 10000.0
	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_NEC_Walls_BSP_Concrete'
		    PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.PhysicalMaterials.PM_Stone'  //contains physical parameters + impact effects
		    
      End Object

		// Das ist der pfad, aber nicht aktiviert
	Begin Object Class=ParticleSystemComponent Name=TrailParticleComponent0
		Template      =ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.P_VH_Gib_Explosion'
		bAutoActivate =false
	End Object

	Begin Object Class=AudioComponent Name=ExlosionSoundComponent0
        SoundCue=SoundCue'AngryPiouPiouXAllAssets.Sounds.Explosion'
        bAutoPlay=false     
    End Object    

	ExlopsionParticleSystem=TrailParticleComponent0
	ExplodeSound = ExlosionSoundComponent0;

	components.add(TrailParticleComponent0);
	components.Add(ExlosionSoundComponent0)


}
