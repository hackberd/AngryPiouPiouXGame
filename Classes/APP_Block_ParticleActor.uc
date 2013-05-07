class APP_Block_ParticleActor extends Actor;

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
		Template      = ParticleSystem'AngryPiouPiouXAllAssets.ParticleSystem.P_VH_Death'
		bAutoActivate =true
		// SecondsBeforeInactive=1.0f
	End Object
	ExlopsionParticleSystem=TrailParticleComponent1
	components.add(TrailParticleComponent1);
}
