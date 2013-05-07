class APP_BlockStone extends APP_Block;

var ParticleSystemComponent SmokeParticleSystem;
var ParticleSystemComponent ExlopsionParticleSystem;
var AudioComponent ExplodeSound;
var int Health;

var Material                        DamagedMaterial;

auto state Fixed{
	// COLISIONS here informations from physics
	event RigidBodyCollision( PrimitiveComponent HitComponent,
	                      PrimitiveComponent OtherComponent,
				          const out CollisionImpactData RigidCollisionData, 
				          int ContactIndex ){
			local float collisionforce;
			// totalnormalforcevector -> Force of impact
			collisionforce = vsize(rigidcollisiondata.totalnormalforcevector);	
			Health = Health - collisionforce;

			//Worldinfo.Game.Broadcast(self,"HP: "@Health);
			if (Health < 0){
			  // IS ENOUTH TO DESTROY OBJECT?
			  ExplodeSound.Play();				
			  self.GotoState('Destroyed_');
			  // Destroyed is own function, siehe unten
			}else{
			  self.GotoState('Falling_');
			}
	}
begin:
		Health = ImpactForceForDestruction;
	//setphysics(PHYS_NONE); // example
}

state Falling_ {
	ignores RigidBodyCollision;

	event Timer() 
	{
		self.GotoState('Fixed');
	}
	begin:
	settimer(0.1,false);
}

state Destroyed_{

ignores RigidBodyCollision;

begin:
 //TODO: do some animation here
	 bisDead =true;
	 APP_Game(worldinfo.Game).getGameStateData().Score += Score;
	 // boom
	 spawn(class 'APP_Block_ParticleActor',self,'mytaghere', self.Location ,self.Rotation,/*Archetype here*/ ,true);
	self.destroy();
}


DefaultProperties
{
	Score=30000;
    ImpactForceForDestruction=20000.0
	
	DamagedMaterial = Material'AngryPiouPiouXAllAssets.PhysicalMaterial.M_CH_Gibs_Corrupt01'

	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_NEC_Walls_BSP_Concrete'
		    PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.PhysicalMaterials.PM_Stone'  //contains physical parameters + impact effects
		    
      End Object

		// Smoke
	Begin Object Class=ParticleSystemComponent Name=TrailParticleComponent0
		Template      =ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.P_FX_Smoke_SubUV_01'
		bAutoActivate =false
		// SecondsBeforeInactive=1.0f
	End Object


		// Exlosion
	Begin Object Class=ParticleSystemComponent Name=TrailParticleComponent1
		Template      = ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.P_VH_Death'
		bAutoActivate =false
		// SecondsBeforeInactive=1.0f
	End Object
	ExlopsionParticleSystem=TrailParticleComponent1
	components.add(TrailParticleComponent1);

	Begin Object Class=AudioComponent Name=ExlosionSoundComponent0
        SoundCue=SoundCue'AngryPiouPiouXAllAssets.Sounds.Explosion'
        bAutoPlay=false     
    End Object    

	SmokeParticleSystem=TrailParticleComponent0
	ExplodeSound = ExlosionSoundComponent0;

	components.add(TrailParticleComponent0);
	components.Add(ExlosionSoundComponent0)


}
