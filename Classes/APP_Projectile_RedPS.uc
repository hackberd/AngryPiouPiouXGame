class APP_Projectile_RedPS  extends Actor;

var ParticleSystemComponent ExlopsionParticleSystem;

auto state Exploded{

begin:
	ExlopsionParticleSystem.SetActive(true);
	sleep(0.5);
	self.destroy();
}

DefaultProperties
{
  Begin Object Class=ParticleSystemComponent Name=TrailParticleComponent1
		Template      = ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.RedSpawn'
		//
		//
		//
		//ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.Spawn_Blue'
		//ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.P_Flagbase_FlagCaptured_Red'
		bAutoActivate =true
		// SecondsBeforeInactive=1.0f
	End Object
	ExlopsionParticleSystem=TrailParticleComponent1
	components.add(TrailParticleComponent1);
}
