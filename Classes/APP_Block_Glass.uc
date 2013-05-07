class APP_Block_Glass extends APP_Block;

var ParticleSystemComponent SmokeParticleSystem;
var ParticleSystemComponent ExlopsionParticleSystem;
var AudioComponent ExplodeSound;
var int Health;


auto state Fixed{
	// COLISIONS here informations from physics
	
	event RigidBodyCollision( PrimitiveComponent HitComponent,
	                      PrimitiveComponent OtherComponent,
				          const out CollisionImpactData RigidCollisionData, 
				          int ContactIndex ){
			//Worldinfo.Game.Broadcast(self,"HP: "@Health);
			
			   ExplodeSound.Play();				
			  self.GotoState('Destroyed_');
			 
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
	Score=10000;
	
    ImpactForceForDestruction=1
	
	Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.Cube'
		    Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_HU_Deck_SM_Fwindow_Glassbroken_Mat'
		    PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.physicsmaterial.PM_Wood'  //contains physical parameters + impact effects
    End Object

	Begin Object Class=AudioComponent Name=ExlosionSoundComponent0
        SoundCue=SoundCue'AngryPiouPiouXAllAssets.Sounds.Explosion'
        bAutoPlay=false     
    End Object    

	ExplodeSound = ExlosionSoundComponent0;
	components.Add(ExlosionSoundComponent0)


}
