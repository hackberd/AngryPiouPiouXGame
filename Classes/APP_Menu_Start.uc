/** 
 *  Example of a Menu for Mobile
 *  -Called when level is loaded if bstartMenu=true in command line options
 *  -Buttons
 *      - Play
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */


class APP_Menu_Start extends MobileMenuScene;

var bool bTouchHandled; 

event OnTouch(MobileMenuObject Sender, ETouchType EventType, float TouchX, float TouchY)
{	
	local APP_Game game;
	
	if(bTouchHandled) return; // to avoid OnTouch Events reception when menu is closing

	if(Sender == none){
      return;
   }else if(Sender.Tag ~= "PLAY"){
	  game = APP_GAME(InputOwner.Outer.worldinfo.Game); //TODO refactor long casting
	  game.getGameStateController().RunGame();
	  bTouchHandled=true;
      InputOwner.CloseMenuScene(self);// always at the end , as it will put the inputowner to none    
   }else if(Sender.Tag ~= "LOAD"){
	  game = APP_GAME(InputOwner.Outer.worldinfo.Game); //TODO refactor long casting
	  /*
	   * TODO: Finish load game features by adding last game map play plus overall player score/achievement system 
	   * */
	  game.getGameStateData().LoadSavedGame();
	  game.getGameStateController().RunGame();
	  bTouchHandled=true;
      InputOwner.CloseMenuScene(self);// always at the end , as it will put the inputowner to none    
   }
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

  Begin Object Class=MobileMenuLabel Name=MainLabel
      Tag="MainLabel"
      Left=0.2
      Top=0.2
      Width=0.0
      Height=0.2
	  bRelativeLeft=true
      bRelativeTop=true
      bRelativeWidth=true
      bRelativeHeight=true
	  Caption="ANGRY PiouPiou 3D"
	  TextFont=MultiFont'CastleFonts.Positec'
	  TextColor=(R=255,G=0,B=0,A=255)
	  TouchedColor=(R=255,G=0,B=255,A=0)
	  TextXScale=3.0
	  TextYScale=3.0
	 bAutoSize=true
   End Object
   MenuObjects.Add(MainLabel)


   Begin Object Class=MobileMenuButton Name=PlayButton
      Tag="PLAY"
	  Caption="Play"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=0.35
      Top=0.35
      Width=300
      Height=200
      bRelativeLeft=true
      bRelativeTop=true
      TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(PlayButton)

	 Begin Object Class=MobileMenuButton Name=LoadButton
      Tag="LOAD"
	  Caption="LOAD SAVE GAME"
	  CaptionColor=(R=255,G=0,B=0,A=127);
      Left=0.35
      Top=0.7
      Width=300
      Height=200
      bRelativeLeft=true
      bRelativeTop=true
      TopLeeway=20
      Images(0)=Texture2D'CastleUI.menus.T_CastleMenu2'
      Images(1)=Texture2D'CastleUI.menus.T_CastleMenu2'
      ImagesUVs(0)=(bCustomCoords=true,U=306,V=220,UL=310,VL=48)
      ImagesUVs(1)=(bCustomCoords=true,U=306,V=271,UL=310,VL=48)
   End Object
   MenuObjects.Add(LoadButton)
}