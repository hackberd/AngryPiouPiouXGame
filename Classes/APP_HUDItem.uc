/** 
 *  Example of a Head-Up Display Item
 *  -Defines: Position, Police, Color, Texture for a Label and a Value to be displayed on screen
 *  -Drawn on screen by APP_HUD Class
 *  -Abstract
 * - each class derriving from it can be initialised from the .ini config file (see DefaultGame.ini)
 * 
 * @note   Code Simplified for Demonstration 
 * @author JLL
 * @version 1.0 April 3, 2013.
 */
  
class APP_HUDItem extends Object 
abstract
config(game); //config keyword see http://udn.epicgames.com/Three/ConfigurationFiles.html

var config Bool        bShouldBeDisplayed;

var config String       LabelFontClass; // object cannot be defined in config, need to give a string containing class to 
var        Font        LabelFont; 
var config String      Label;
var config Vector2D    TextLocation;
var config Color       TextColor;
var config Vector2D    Scale;

var config String               BackGroundTextureClass; // object cannot be defined in config, need to give a string containing class to 
var       Texture              BackGroundTexture;
var config Vector2D            BackGroundTextureLocation;
var config ECanvasBlendMode    BackGroundTextureBlendMode;

var String       VariableValue; 

function loadAssets(){
   loadFont();
   loadTexture();
}

function loadFont(){
		LabelFont =Font( DynamicLoadObject( LabelFontClass, class'font', true ) );
	    if(LabelFont==none){
	    	`LogError('HUD',"CLASS"@LabelFontClass@"NOT FOUND - Using Default Font");
	    
	    }
}

function loadTexture(){
	BackGroundTexture = Texture( DynamicLoadObject(BackGroundTextureClass, class'Texture', true ) );
    if(BackGroundTexture==none)`LogError('HUD',"CLASS"@LabelFontClass@"NOT FOUND");
}

function setValue(coerce string Value){
	VariableValue = Value;
}

function Draw(Canvas canvas)
{
     if(bShouldBeDisplayed){
		 if(BackGroundTexture!=none) { 
	 	 DrawBackgroundTexture(canvas);
		 }
		 DrawVariable(canvas,VariableValue);
     }
}

function DrawVariable(Canvas canvas,coerce string VarValue)
{
	local Vector2D TextSize;
	//draw VariableName
	if(LabelFont!=none) Canvas.font = LabelFont;
	Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B);
	Canvas.SetPos(TextLocation.X, TextLocation.Y);
	Canvas.DrawText(Label,false,Scale.X, Scale.Y);
	//draw VariableValue
	Canvas.TextSize(Label, TextSize.X, TextSize.Y);
	Canvas.SetPos(TextLocation.X + (TextSize.X * Scale.X), TextLocation.Y); // compute offset due to scale
	Canvas.DrawText(VarValue,false, Scale.X, Scale.Y);
}

function DrawBackgroundTexture(Canvas canvas)
{
	canvas.setpos(BackGroundTextureLocation.X, BackGroundTextureLocation.Y);
	canvas.DrawBlendedTile (BackGroundTexture,
							BackGroundTexture.GetSurfaceWidth(),
							BackGroundTexture.GetSurfaceHeight(),
							0.0,
							0.0,
							1.0,
							1.0,
							BackGroundTextureBlendMode);
	
}
DefaultProperties
{
}

