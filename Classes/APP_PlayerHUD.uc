
/** 
 *  Example of HUD
 *  Role: Draw HUDItem according to game states(overrides function DrawHUD())
 *        if GameOver displays GameOverHUD config
 *        else display GameRunning HUD
 *  states:
 *    - Active
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_PlayerHUD extends UDKHUD;

var APP_GameStateData GameState;

var APP_HUDItem  ProjectileScore;
var APP_HUDItem  TargetScore;
var APP_HUDItem  Score;
var APP_HUDItem  GameOverScore;
var APP_HUDItem  GameOverReason;

var array<APP_HUDItem> HUDItems;

/* Init*/
function init(APP_GameStateData GS){
    GameState = GS;
	gotostate('Drawing');
}

/** State */
STATE Drawing{
function DrawHUD(){
   super.DrawHUD();
   UpdateHUDConfig(); // select HUD items to display according to game state (i.e playing or gameover)
   UpdateHUDitems();  //pulling game state data per item
   DrawHUDItems();
}
} /** end Display State*/



simulated event postbeginplay(){
 super.postbeginplay();
 initialHUDItems();
}

function initialHUDItems(){
     local APP_HUDItem temp;
	
	 //TODO: Refactor repetitive code
     ProjectileScore    = new class'APP_HUDItem_Projectile';
	 HUDItems.AddItem(ProjectileScore);
	 TargetScore        = new class'APP_HUDItem_Target';
	 HUDItems.AddItem(TargetScore);
	 Score              = new class'APP_HUDItem_Score';
	 HUDItems.AddItem(Score);
	 GameOverScore      = new class 'APP_HUDItem_GameOverScore';
	 HUDItems.AddItem(GameOverScore);
	 GameOverReason     = new class 'APP_HUDItem_GameOverReason';
	 HUDItems.AddItem(GameOverReason);
	
	 foreach HUDItems(temp) temp.LoadAssets(); // font and texture specified in config file
}

/** Update */
function UpdateHUDConfig() // Use one State and multi-HUD config system for generic Drawning
{
  if(!GameState.bIsGameOver) 
  	SetHUDGameRunning();
   else 
   	SetHUDGameOver();
}

function UpdateHUDitems(){
   ProjectileScore.setValue(GameState.nbProjLeft);
   TargetScore    .setValue(GameState.nbTargetLeft);
   Score.setValue(GameState.score);
   GameOverReason .setValue(" "@GameState.GameOverReason);
   GameOverScore  .setValue(GameState.score);
}

function DrawHUDItems(){
	local APP_HUDItem  Item;
	foreach HUDItems(Item){
	 if(Item.bShouldBeDisplayed){
	 	Item.Draw(Canvas);
	 }
	}
}

Function SetHUDGameRunning(){
	ProjectileScore.bShouldBeDisplayed  = true;
	TargetScore.bshouldBeDisplayed      = true;
	Score.bshouldBeDisplayed            = true;
	GameOverScore.bShouldBeDisplayed    = false;
	GameOverReason.bShouldBeDisplayed   = false;

}
Function SetHUDGameOver(){
	ProjectileScore.bShouldBeDisplayed  = false;
	TargetScore.bshouldBeDisplayed      = false;
	Score.bshouldBeDisplayed            = false;
	GameOverScore.bShouldBeDisplayed    = true;
	GameOverReason.bShouldBeDisplayed   = true;
}

DefaultProperties
{
	
}
