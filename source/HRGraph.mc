using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class HRGraph {
	var colorZone0 = Gfx.COLOR_BLUE;
	var colorZone1 = Gfx.COLOR_GREEN;
	var colorZone2 = Gfx.COLOR_YELLOW;
	var colorZone3 = Gfx.COLOR_DK_GREEN;
	var colorZone4 = Gfx.COLOR_ORANGE;
	var colorZone5 = Gfx.COLOR_RED;
	//var colorHRMark = Gfx.COLOR_PURPLE;
	//var colorHRMark = Gfx.COLOR_BLACK;
	
	var RHR= 60;
	var HRmax=200;
	
	var startAngle = 300;
	var rangeGFX = 120;
	var fac = 0; 

	var z1 = 110; //bpm
	var z2 = 150;
	var z3 = 160;
	var z4 = 180;
	var z5 = 190;
				
	var sz0 = 0;
	var ez0 = 0;
	var sz1 = 0;
	var ez1 = 0;
	var sz2 = 0;
	var ez2 = 0;
	var sz3 = 0;
	var ez3 = 0;
	var sz4 = 0;
	var ez4 = 0;
	var sz5 = 0;
	var ez5 = 0;
					
	function initialize(settings){
		//Sys.println("HRGraphInit()");
		
		if (settings != null){
			//Sys.println("HRGraphInit() Settings given");
			RHR = settings[0];
			z1 = settings[1];
			z2 = settings[2];
			z3 = settings[3];
			z4 = settings[4];
			z5 = settings[5];
			HRmax = settings[6];
		}
		
		fac = 1.0*rangeGFX/(HRmax-RHR); 
		
		sz0 = 0;
		ez0 = fac*(z1-RHR);
		sz1 = ez0+1;
		ez1 = fac*(z2-RHR);
		sz2 = ez1+1;
		ez2 = fac*(z3-RHR);
		sz3 = ez2+1;
		ez3 = fac*(z4-RHR);
		sz4 = ez3+1;
		ez4 = fac*(z5-RHR);
		sz5 = ez4+1;
		ez5 = rangeGFX;
						
		sz0 = degToRightBar(sz0);
		ez0 = degToRightBar(ez0);
		sz1 = degToRightBar(sz1);
		ez1 = degToRightBar(ez1);
		sz2 = degToRightBar(sz2);
		ez2 = degToRightBar(ez2);
		sz3 = degToRightBar(sz3);
		ez3 = degToRightBar(ez3);
		sz4 = degToRightBar(sz4);
		ez4 = degToRightBar(ez4);
		sz5 = degToRightBar(sz5);
		ez5 = degToRightBar(ez5);	
		
		/*Sys.println(Lang.format("HRG:RHR: $1$",[RHR]));
		Sys.println(Lang.format("HRG:z1: $1$",[z1]));
		Sys.println(Lang.format("HRG:z2: $1$",[z2]));
		Sys.println(Lang.format("HRG:z3: $1$",[z3]));
		Sys.println(Lang.format("HRG:z4: $1$",[z4]));
		Sys.println(Lang.format("HRG:z5: $1$",[z5]));
		Sys.println(Lang.format("HRG:HRmax: $1$",[HRmax]));*/
		postMsg(Lang.format("HRG-> RHR: $1$, z1: $2$, z2: $3$, z3: $4$, z4: $5$, z5: $6$, max: $7$",[RHR,z1,z2,z3,z4,z5,HRmax]));
	}
	
	function degToRightBar(angle){	
		var x = startAngle + angle;
		if (x > 360){
			x = x-360;
		}
		return x.toLong();
	}	

	function draw(dc, HR){
		var width = dc.getWidth();
        var height = dc.getHeight();
		var centerx = width/2;
		var centery = height/2;
		
		if (HR == null){
			HR = 0;
		}
		if(HR < RHR){
			HR = RHR-1;
		}
		if(HR > HRmax){
			HR = HRmax+3;
		}
		var sHRMark = fac*(HR-RHR)-1;
		var eHRMark = sHRMark+2;
		var sHRMarkb = degToRightBar(sHRMark-1);
		var eHRMarkb = degToRightBar(eHRMark+1);
		sHRMark = degToRightBar(sHRMark);
		eHRMark = degToRightBar(eHRMark);	
				
		var unset = 9;//Pens
		var set = 31;
		var unsetR = centerx-3;
		var setR = centerx-10;
		dc.setPenWidth(unset);
		//drawArc(x, y, r, attr, degreeStart, degreeEnd)
		//300° bis 60° = 120°/6Zonen = 20°
		
		dc.setColor(colorZone0, Gfx.COLOR_TRANSPARENT);	
		if (HR < z1){
			dc.setPenWidth(set);
			dc.drawArc(centerx-1, centery, setR, Gfx.ARC_COUNTER_CLOCKWISE, sz0, ez0);
			dc.setPenWidth(unset);
		}else{
			dc.drawArc(centerx-1, centery, unsetR, Gfx.ARC_COUNTER_CLOCKWISE, sz0, ez0);
		}
		
		dc.setColor(colorZone1, Gfx.COLOR_TRANSPARENT);
		if (HR >=z1 and HR < z2){
			dc.setPenWidth(set);
			dc.drawArc(centerx-1, centery, setR, Gfx.ARC_COUNTER_CLOCKWISE, sz1, ez1);
			dc.setPenWidth(unset);
		}else{
			dc.drawArc(centerx-1, centery, unsetR, Gfx.ARC_COUNTER_CLOCKWISE, sz1, ez1);
		}
		
		dc.setColor(colorZone2, Gfx.COLOR_TRANSPARENT);
		if (HR >=z2 and HR < z3){
			dc.setPenWidth(set);
			dc.drawArc(centerx-1, centery, setR, Gfx.ARC_COUNTER_CLOCKWISE, sz2, ez2);
			dc.setPenWidth(unset);
		}else{
			dc.drawArc(centerx-1, centery, unsetR, Gfx.ARC_COUNTER_CLOCKWISE, sz2, ez2);
		}
				
		dc.setColor(colorZone3, Gfx.COLOR_TRANSPARENT);
		if (HR >=z3 and HR < z4){
			dc.setPenWidth(set);
			dc.drawArc(centerx-1, centery, setR, Gfx.ARC_COUNTER_CLOCKWISE, sz3, ez3);
			dc.setPenWidth(unset);
		}else{
			dc.drawArc(centerx-1, centery, unsetR, Gfx.ARC_COUNTER_CLOCKWISE, sz3, ez3);
		}
		
		dc.setColor(colorZone4, Gfx.COLOR_TRANSPARENT);
		if (HR >=z4 and HR < z5){
			dc.setPenWidth(set);
			dc.drawArc(centerx-1, centery, setR, Gfx.ARC_COUNTER_CLOCKWISE, sz4, ez4);
			dc.setPenWidth(unset);
		}else{
			dc.drawArc(centerx-1, centery, unsetR, Gfx.ARC_COUNTER_CLOCKWISE, sz4, ez4);
		}
		
		dc.setColor(colorZone5, Gfx.COLOR_TRANSPARENT);
		if (HR >=z5){
			dc.setPenWidth(set);
			dc.drawArc(centerx-1, centery, setR, Gfx.ARC_COUNTER_CLOCKWISE, sz5, ez5);
			dc.setPenWidth(unset);
		}else{
			dc.drawArc(centerx-1, centery, unsetR, Gfx.ARC_COUNTER_CLOCKWISE, sz5, ez5);
		}
		
		//Zeiger
		dc.setPenWidth(50);
		dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_TRANSPARENT);
		dc.drawArc(centerx-1, centery, centerx-23, Gfx.ARC_COUNTER_CLOCKWISE, sHRMarkb , eHRMarkb);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.drawArc(centerx-1, centery, centerx-23, Gfx.ARC_COUNTER_CLOCKWISE, sHRMark , eHRMark);		
		
		//dc.drawArc(centerx-1, centery, centerx-10, Gfx.ARC_COUNTER_CLOCKWISE, 300, 5);
	}
}
