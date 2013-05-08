class APP_Arrow extends KActorSpawnable;

DefaultProperties
{
    Begin Object Name=StaticMeshComponent0
            StaticMesh=StaticMesh'AngryPiouPiouXAllAssets.StaticMeshes.TouchToMoveArrow'
		    //Materials(0)=Material'AngryPiouPiouXAllAssets.Materials.M_BlockWall_02_D'
		    //PhysMaterialOverride=PhysicalMaterial'AngryPiouPiouXAllAssets.physicsmaterial.PM_Stone'  //contains physical parameters + impact effects
		    //ReplacementPrimitive=None
            //RBChannel=RBCC_GameplayPhysics
            //bAllowApproximateOcclusion=True
            //bForceDirectLightMap=True
            //bUsePrecomputedShadows=True
            //LightingChannels=(bInitialized=True,Static=True)
		    bNotifyRigidBodyCollision=false // necessary to trigger Event RigiBodyCollisio	    
      End Object
}
