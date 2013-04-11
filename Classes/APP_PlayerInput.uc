
/** 
 *  Example of Mobile Player Inputs
 *  Roles: 
 *   - Defines Mobile Inputs zones
 *   - Processes Raw Inputs to smooth them
 *  Note:
 *  - Here just a placeholder for demo and future modification
 *  - assigned to APP_PlayerController (in default properties)
 *   
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */

class APP_PlayerInput extends  MobilePlayerInput ;
/* 
 * Input mobile zones setup from config file
 * 
 * in Mobile-UDKGame.ini
 * 
 * [AngryPiouPiouXGame.APP_Game]
   RequiredMobileInputConfigs=(GroupName="UberGroup",RequireZoneNames=("MenuSlider","UberStickMoveZone","UberStickLookZone","UberLookZone"))
* 
 * */

DefaultProperties
{
}
