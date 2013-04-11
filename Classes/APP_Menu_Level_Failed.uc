/** 
 *  Example of a Menu for Mobile
 *  Inherits from APP_Menu_Level_Completed
 *  but hiddes Buttons
 *      - Next
 *  and change WON message by "Level Failed"
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */



class APP_Menu_Level_Failed extends APP_Menu_Level_Completed;


defaultproperties
{   
  /*just overriding entity componend to hide buttons*/
  Begin Object Name=GameOverReasonLabel 
	  Caption="LEVEL FAILED !!!"
  End Object
  
Begin Object  Name=NextButton
   bIsHidden=true
   End Object
}