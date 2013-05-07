class APP_Menu_GameMenu extends MobileMenuScene;
/** 
 *  Example of a Menu for Mobile
 *  -Called when player won the game by the game Controller 
 *  - Displays Score and Won Message : Level Completed
 *  -Buttons
 *      - Replay
 *      - Next
 *      - Quit
 *      - Save Game (TODO)
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */


var bool bTouchHandled; 


event InitMenuScene(MobilePlayerInput PlayerInput, int ScreenWidth, int ScreenHeight, bool bIsFirstInitialization)
{ 
   local MobileMenuLabel p;
   super.InitMenuScene(PlayerInput,ScreenWidth,ScreenHeight, bIsFirstInitialization);
   p =MobileMenuLabel(FindMenuObject("ScoreLabel"));
   p.caption = "SCORE :" @  APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().Score;
}

event OnTouch(MobileMenuObject Sender, ETouchType EventType, float TouchX, float TouchY)
{		
   if(bTouchHandled)  return; // to avoid OnTouch Events reception when menu is closing
   if(Sender == none) return;

   if(Sender.Tag ~= "QuitButton"){ 
	  InputOwner.outer.ConsoleCommand("Exit"); // TODO: very brutal !! game should be saved before, and exit menu displayed
       RequestClosing(); 
   }
   else if(Sender.Tag ~= "SaveButton"){
	 APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateData().SaveGame();  
   	 APP_GAME(InputOwner.Outer.worldinfo.Game).Broadcast(InputOwner.Outer, " Game Saved"); // TODO
    //  RequestClosing();
   }
   else if(Sender.Tag ~= "ReplayButton"){
	  APP_GAME(InputOwner.Outer.worldinfo.Game).getGameStateController().ReloadSameLevel();
      RequestClosing();
   }
   else if(Sender.Tag ~= "NextButton"){
	 APP_GAME(InputOwner.Outer.worldinfo.Game).getThrowingStation().setGameSpeed(1.0);	
	RequestClosing();
	 
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
	  Caption="LEVEL PAUSED"
	  TextFont=MultiFont'CastleFonts.Positec'
	  TextColor=(R=255,G=0,B=0,A=255)
	  TouchedColor=(R=255,G=0,B=255,A=0)
	  TextXScale=3.0
	  TextYScale=3.0
	 bAutoSize=true
   End Object
   MenuObjects.Add(GameOverReasonLabel)

  Begin Object Class=MobileMenuLabel Name=ScoreLabel
      Tag="ScoreLabel"
      Left=0.3
      Top=0.4
      Width=0.0
      Height=0.2
	  bRelativeLeft=true
      bRelativeTop=true
      bRelativeWidth=true
      bRelativeHeight=true
	  Caption="Score"
	  TextFont=MultiFont'CastleFonts.Positec'
	  TextColor=(R=255,G=0,B=0,A=255)
	  TouchedColor=(R=255,G=0,B=255,A=0)
	  TextXScale=2.0
	  TextYScale=2.0
	 bAutoSize=true
   End Object
   MenuObjects.Add(ScoreLabel)


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


    Begin Object Class=MobileMenuButton Name=QuitButton
      Tag="QuitButton"
	  Caption="Quit"
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
   MenuObjects.Add(QuitButton)

	Begin Object Class=MobileMenuButton Name=SaveButton
      Tag="SaveButton"
	  Caption="Save"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=450
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
   MenuObjects.Add(SaveButton)

  Begin Object Class=MobileMenuButton Name=ReplayButton
      Tag="ReplayButton"
	  Caption="Replay"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=600
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
   MenuObjects.Add(ReplayButton)
 
	Begin Object Class=MobileMenuButton Name=NextButton
      Tag="NextButton"
	  Caption="Resume"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=750
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
   MenuObjects.Add(NextButton)

}