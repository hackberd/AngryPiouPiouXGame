class APP_Menu_LevelSelection extends  MobileMenuScene;


var bool bTouchHandled; 

var array<bool> LevelsComplete;

var array<string> Levels;

event InitMenuScene(MobilePlayerInput PlayerInput, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{   
	local APP_Game game;
	local MobileMenuButton p1;
	local MobileMenuButton p2;
	local MobileMenuButton p3;
	local MobileMenuButton p4;
	local MobileMenuButton p5;
   super.InitMenuScene(PlayerInput,ScreenWidth,ScreenHeight, bIsFirstInitialization);

    game = APP_GAME(InputOwner.Outer.worldinfo.Game); //TODO refactor long casting	
	LevelsComplete = game.getGameStateData().LevelsComplete;
	Levels = game.getGameStateData().Levels;
   
   p1 =MobileMenuButton(FindMenuObject("1"));
   p1.caption = "1 ";

    p2 =MobileMenuButton(FindMenuObject("2"));
   p2.caption = "2 " @  BoolToString(LevelsComplete[0]);

    p3 =MobileMenuButton(FindMenuObject("3"));
   p3.caption = "3 " @  BoolToString(LevelsComplete[1]);

    p4 =MobileMenuButton(FindMenuObject("4"));
   p4.caption = "4 " @  BoolToString(LevelsComplete[2]);

    p5 =MobileMenuButton(FindMenuObject("5"));
   p5.caption = "5 " @  BoolToString(LevelsComplete[3]);

}

function string BoolToString(bool bo) {
	`log(bo);
   if (!bo) { return "(not yet)"; }
   else { return ""; }
}


event OnTouch(MobileMenuObject Sender, ETouchType EventType, float TouchX, float TouchY)
{		
   if(bTouchHandled)  return; // to avoid OnTouch Events reception when menu is closing
   if(Sender == none) return;

   if(Sender.Tag ~= "1"){ 
		
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateController().LoadLevel(Levels[0]$"?bStartMenu=false"); // TODO: very brutal !! game should be saved before, and exit menu displayed
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().LevelIndex = 0;
			 RequestClosing(); 
   }
   else if(Sender.Tag ~= "2"){
	if(LevelsComplete[0]) {
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateController().LoadLevel(Levels[1]$"?bStartMenu=false"); // TODO: very brutal !! game should be saved before, and exit menu displayed
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().LevelIndex = 1;
			 RequestClosing(); 
		}
	
    //  RequestClosing();
   }
   else if(Sender.Tag ~= "3"){
	  if(LevelsComplete[1]) {
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateController().LoadLevel(Levels[2]$"?bStartMenu=false"); // TODO: very brutal !! game should be saved before, and exit menu displayed
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().LevelIndex = 2;
			 RequestClosing(); 
		}
   }
   else if(Sender.Tag ~= "4"){
	if(LevelsComplete[2]) {
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateController().LoadLevel(Levels[3]$"?bStartMenu=false"); // TODO: very brutal !! game should be saved before, and exit menu displayed
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().LevelIndex = 3;
			 RequestClosing(); 
		}
   } 
   else if(Sender.Tag ~= "5"){
	if(LevelsComplete[3]) {
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateController().LoadLevel(Levels[4]$"?bStartMenu=false"); // TODO: very brutal !! game should be saved before, and exit menu displayed
			 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().LevelIndex = 4;
			 RequestClosing(); 
		}
   } 
}

function RequestClosing(){
     InputOwner.CloseMenuScene(self);// always at the end , as it will put the inputowner to none 
	 bTouchHandled=true;
}

defaultproperties
{  
	 bTouchHandled=false;
   Opacity=0.9
   Left=0
   Top=0
   Width=1.0
   Height=1
   bRelativeWidth=true
   bRelativeHeight=true
   SceneCaptionFont=MultiFont'CastleFonts.Positec' 

   Begin Object Class=MobileMenuImage Name=Background
      Tag="Background"
      Left=0
      Top=0
      Width=1.0
      Height=1.0
      bRelativeWidth=true
      bRelativeHeight=true
      Image=Texture2D'Envy_Effects.T_Black'
	 //Image=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImageDrawStyle=IDS_Tile
      //ImageUVs=(bCustomCoords=true,U=0,V=30,UL=1024,VL=180)
   End Object
   MenuObjects.Add(Background)

  Begin Object Class=MobileMenuLabel Name=GameOverReasonLabel
      Tag="MainLabel"
      Left=0.2
      Top=0.2
      Width=0.0
      Height=0.2
	  bRelativeLeft=true
      bRelativeTop=true
      bRelativeWidth=true
      bRelativeHeight=true
	  Caption="Level Selection"
	  TextFont=MultiFont'CastleFonts.Positec'
	  TextColor=(R=255,G=0,B=0,A=255)
	  TouchedColor=(R=255,G=0,B=255,A=0)
	  TextXScale=3.0
	  TextYScale=3.0
	 bAutoSize=true
   End Object
   MenuObjects.Add(GameOverReasonLabel)

  


	/** 
	 *  Button positioning
	 *  screen  1024 X 768
	 *  Button: 100  X 100
	 *  Vertical All Button  = 500 (y axis)
	 *  Horizontal window Left Gap: 300 
	 *  Inbetween Button Horizontal gap: 50
	 *  Horizontal Button #1: 300 
	 *  Horizontal Button #2: 300 + (100+50)*1   = 450
	 *  Horizontal Button #3: 300 + (100+50)*2   = 600
	 *  Horizontal Button #4: 300 + (100+50)*3   = 750
	 * */


    Begin Object Class=MobileMenuButton Name=Load1
      Tag="1"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=300
      Top=250
      Width=100
      Height=100
      bRelativeLeft=false
      bRelativeTop=false
          TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(Load1)

	Begin Object Class=MobileMenuButton Name=Load2
      Tag="2"
	  Caption="2"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=450
      Top=250
      Width=100
      Height=100
       bRelativeLeft=false
       bRelativeTop=false
      TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(Load2)

  Begin Object Class=MobileMenuButton Name=Load3
      Tag="3"
	  Caption="3"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=600
      Top=250
      Width=100
      Height=100
      bRelativeLeft=false
      bRelativeTop=false
      TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(Load3)
 
	Begin Object Class=MobileMenuButton Name=Load4
      Tag="4"
	  Caption="4"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=750
      Top=250
      Width=100
      Height=100
      bRelativeLeft=false
      bRelativeTop=false
      TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(Load4)


	 Begin Object Class=MobileMenuButton Name=Load5
      Tag="5"
	  Caption="5"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=300
      Top=500
      Width=100
      Height=100
      bRelativeLeft=false
      bRelativeTop=false
          TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(Load5)
}