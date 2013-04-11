

class APP_MathUtils extends actor;


static function float Magnitude(vector2D v){
 return sqrt(square(v.X) + square(v.Y));
}

static function vector2D getVectorDir(vector2d StartSwipeLoc, vector2D EndSwipeLoc){
	    return (EndSwipeLoc - StartSwipeLoc);   
}
static function bool equal(vector2D v, vector2D u){
  if(v.X == u.X && v.Y == u.Y) return true;
  return false;
}

static function float getAngle(vector2D v){
	  local float angle;
	  local vector2D VerticalAxis;
	  VerticalAxis.X = 1;
	  VerticalAxis.Y = 0;
	  angle = Acos( ((v.x *VerticalAxis.x) + (v.y *VerticalAxis.y))/ Magnitude(v)); //dot product / vector magnitude
	  angle = angle * RadToDeg;
	  //angle = angle * RadToUnrRot;
	  return angle;
	}

static function rotator getPitchOnlyRotator(float angle){
	local rotator r;
	r.Pitch = angle * DegToRad * RadToUnrRot;
	return r;
}

static function vector get3DLine(LocalPlayer _Player,vector2D lineStart, vector2D lineEnd){
        
	    local Vector2D ViewportSizee;
		local vector   StartLine3DVector,EndLine3DVector;
		local vector   StartLine3DVectorDir,EndLine3DVectorDir ;
		local color c;
		c.R = 255;
	
	     _Player.ViewportClient.GetViewportSize(ViewportSizee);
		// Get the screen space in terms of 0 to 1
		lineEnd.X = lineEnd.X / ViewportSizee.X;
		lineEnd.Y = lineEnd.Y / ViewportSizee.Y;
		lineStart.X = lineStart.X / ViewportSizee.X;
		lineStart.Y = lineStart.Y / ViewportSizee.Y;

	   _Player.DeProject(lineStart, StartLine3DVector, StartLine3DVectorDir);
	   
	    _Player.DeProject(lineEnd, EndLine3DVector, EndLine3DVectorDir); 
		
	    `if(`notdefined(FINAL_RELEASE))
	      // DrawDebugLine(StartLine3DVector, EndLine3DVector, 255,0, 0,true); // SLOW! Use for debugging only!
		   DrawDebugCone(StartLine3DVector,(EndLine3DVector-StartLine3DVector),3.0,3.0,3.0,5,c,true);
		  //DrawDebugSphere(StartLine3DVector,3.0,5,250,0,0,true);
        `endif
	 
		return (EndLine3DVector-StartLine3DVector);
}


DefaultProperties
{
}
