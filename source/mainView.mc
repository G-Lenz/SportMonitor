using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Record;
using Toybox.ActivityMonitor as AMon;
using Toybox.Position as Position;
using Toybox.Sensor as Sensor;
using Toybox.Attention as attention;
using Toybox.Application as App;

//fonts = [Gfx.FONT_XTINY,Gfx.FONT_TINY,Gfx.FONT_SMALL,Gfx.FONT_MEDIUM,Gfx.FONT_LARGE,Gfx.FONT_NUMBER_MILD,Gfx.FONT_NUMBER_MEDIUM,Gfx.FONT_NUMBER_HOT,Gfx.FONT_NUMBER_THAI_HOT];

class SMmainView extends Ui.View {
	var hrGraph = null;
                         
    function initialize() {
        Ui.View.initialize();
        postMsg("MainView: initView");   
    }
        
    //! Load your resources here
    function onLayout(dc) {
     	strHRzones = Ui.loadResource(Rez.Strings.HrZones);
     	strSunset = Ui.loadResource(Rez.Strings.Sunset);
     	strSunrise = Ui.loadResource(Rez.Strings.Sunrise);
     	hrGraph = new HRGraph([RHR,z1bpm,z2bpm,z3bpm,z4bpm,z5bpm,maxHR]);
    }

    function onHide() {
    	//hrGraph = null;
    	//postMsg("mainView onHide()");
    }

    //! Restore the state of the app and prepare the view to be shown.
    function onShow() {
    	//if(session != null){
    		//postMsg("mainView onShow()");
    	//}
    }
       	
//!-----------------------------------------------------------------
//!Common Elements --
//!-----------------------------------------------------------------        
	 function drawCommon(dc){
		
		dc.setColor(HRcolbg,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(6);
        dc.drawArc(xCenter, yCenter, 107 , Gfx.ARC_COUNTER_CLOCKWISE, 78 ,285);
        dc.setPenWidth(1);
        
        dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT);
 		var tstart = xCenter+19;

		if (Sys.getDeviceSettings().is24Hour){
			dc.drawText(tstart-38,-9 , Gfx.FONT_NUMBER_MEDIUM, time.hour.format("%2.2d"), Gfx.TEXT_JUSTIFY_CENTER);
		}else{
			//pm nachmittag
			var hour = time.hour;
			if (hour > 12){
				hour = hour-12;
				dc.drawText(tstart-65, 7, Gfx.FONT_TINY, "pm", Gfx.TEXT_JUSTIFY_CENTER);
			} else {
				dc.drawText(tstart-65, 7, Gfx.FONT_TINY, "am", Gfx.TEXT_JUSTIFY_CENTER);
			}
			dc.drawText(tstart-38,-9 , Gfx.FONT_NUMBER_MEDIUM, hour.format("%2.2d"), Gfx.TEXT_JUSTIFY_CENTER);
		}		
		dc.drawText(tstart-19, 12, Gfx.FONT_SMALL, ":", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(tstart, -9, Gfx.FONT_NUMBER_MEDIUM, time.min.format("%2.2d"), Gfx.TEXT_JUSTIFY_CENTER);   

		if(elaTimeArr != null){
	        dc.drawText(93, 163, Gfx.FONT_LARGE, elaTimeArr[0], Gfx.TEXT_JUSTIFY_RIGHT);
	        dc.drawText(95, 167, Gfx.FONT_SMALL, ":", Gfx.TEXT_JUSTIFY_CENTER);
	        dc.drawText(113, 163, Gfx.FONT_LARGE, elaTimeArr[1], Gfx.TEXT_JUSTIFY_CENTER);
	        dc.drawText(139, 165, Gfx.FONT_SMALL, elaTimeArr[2], Gfx.TEXT_JUSTIFY_CENTER);
        }

		dc.drawText(98, 196, Gfx.FONT_XTINY, "GPS:", Gfx.TEXT_JUSTIFY_CENTER);
		if (App.getApp().getGPSon()){ 
        	dc.drawText(121, 196, Gfx.FONT_XTINY, acc, Gfx.TEXT_JUSTIFY_CENTER);
        }else{
        	dc.drawText(124, 196, Gfx.FONT_XTINY, "OFF", Gfx.TEXT_JUSTIFY_CENTER);
        }
	 }     	 
	 function drawCommonLeft(dc){
	    dc.setColor(colBatt,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawRectangle(5,86,49,40);
        dc.setPenWidth(1);
        dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT); 
        
        dc.drawText(54, 27, Gfx.FONT_XTINY, timestr(LAPtime), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(36, 44, Gfx.FONT_MEDIUM, dispAsc, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(36, 67, Gfx.FONT_XTINY, "Ascent", Gfx.TEXT_JUSTIFY_CENTER);	
		
        dc.drawText(29, 85, Gfx.FONT_MEDIUM, batt.format("%d"), Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(29, 108, Gfx.FONT_XTINY, "batt", Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(40, 124, Gfx.FONT_MEDIUM, dispDist, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(40, 148, Gfx.FONT_XTINY, "Distance", Gfx.TEXT_JUSTIFY_CENTER);	
		
        dc.drawText(47, 163, Gfx.FONT_MEDIUM, trainingEffect, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(53, 184, Gfx.FONT_XTINY, "TE", Gfx.TEXT_JUSTIFY_CENTER);
					 
	 }
     	        
//!-----------------------------------------------------------------
//!New Main Page --
//!-----------------------------------------------------------------
	 function drawNewMainPage(dc){
		dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0,  width, height);
       
      //BACKGROUND     	     
	    dc.setPenWidth(1);
        dc.setColor(HRcolbg,Gfx.COLOR_TRANSPARENT);
        dc.drawLine(0, 45, width, 45);
        dc.drawLine(0, 85, width, 85);
        dc.drawLine(0, 125, width, 125);
        dc.drawLine(0, 165, width, 165);

        dc.setPenWidth(6); 
        dc.drawCircle(xCenter, yCenter, 107); 
        dc.setPenWidth(1);
        
        dc.fillRectangle(xCenter+4,85,100,3);
        dc.fillRectangle(xCenter+4,85,3,39);
        dc.fillRectangle(xCenter+4,124,100,3);    

        drawCommon(dc);
        drawCommonLeft(dc);
                
        //BattBGCOL
        
		dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT); 
                    	        
        dc.drawText(xCenter+76, 24, Gfx.FONT_TINY, "z", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter+55, 17, Gfx.FONT_MEDIUM, HRzone.format("%1.1f") , Gfx.TEXT_JUSTIFY_CENTER);
        
        //--altitude	
		dc.drawText(xCenter-22, 44, Gfx.FONT_MEDIUM, dispDsc, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter-23, 67, Gfx.FONT_XTINY, "Descent", Gfx.TEXT_JUSTIFY_CENTER);
     	dc.drawText(xCenter+36, 43, Gfx.FONT_MEDIUM, dispElev, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(143, 67, Gfx.FONT_XTINY, "alt", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter+82, 43, Gfx.FONT_MEDIUM, dispTemp, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(189, 67, Gfx.FONT_XTINY, "Temp", Gfx.TEXT_JUSTIFY_CENTER);	
        
		dc.drawText(87, 85, Gfx.FONT_SMALL, actSteps.abs(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(87, 108, Gfx.FONT_XTINY, "Steps", Gfx.TEXT_JUSTIFY_CENTER);        
        dc.drawText(xCenter+33, 81, Gfx.FONT_LARGE, hr , Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(143, 109, Gfx.FONT_XTINY, "hr", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter+85, 86, Gfx.FONT_MEDIUM, HRperc.format("%d") , Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(189, 108, Gfx.FONT_XTINY, "%HRmax", Gfx.TEXT_JUSTIFY_CENTER);     
                             
		dc.drawText(93, 124, Gfx.FONT_MEDIUM, dispSpeed, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(93, 148, Gfx.FONT_XTINY, "Speed", Gfx.TEXT_JUSTIFY_CENTER);		
     	dc.drawText(145, 124, Gfx.FONT_MEDIUM, dispAvgSpeed, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(145, 148, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_CENTER);			        
        dc.drawText(xCenter+82, 124, Gfx.FONT_MEDIUM, Kcal.format("%d") , Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(189, 148, Gfx.FONT_XTINY, "Kcal", Gfx.TEXT_JUSTIFY_CENTER); 
         
        dc.drawText(150, 162, Gfx.FONT_SMALL, steps, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(150, 180, Gfx.FONT_XTINY, "StpsAll", Gfx.TEXT_JUSTIFY_LEFT);
	} //! NewMain
	
	

//!-----------------------------------------------------------------
//! HR Bar Common
//!-----------------------------------------------------------------
	 function drawHRbarCommon(dc){        

        dc.setColor(HRcolbg,Gfx.COLOR_TRANSPARENT);

        dc.setPenWidth(1);
        dc.drawLine(0, 45, 170, 45);
        dc.drawLine(0, 85, 180, 85);
        dc.drawLine(0, 125, 180, 125);
        dc.drawLine(0, 165, 170, 165);
                       
        drawCommon(dc);
        drawCommonLeft(dc);

        hrGraph.draw(dc,hr);
          
	 }
	 	
//!-----------------------------------------------------------------
//! HR Bar Main Page --
//!-----------------------------------------------------------------
	 function drawHRbarMainPage(dc){
	 	dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0,  width, height);   

		drawHRbarCommon(dc);
		
     	//--altitude
		dc.drawText(xCenter-19, 44, Gfx.FONT_MEDIUM, dispDsc, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter-20, 67, Gfx.FONT_XTINY, "Descent", Gfx.TEXT_JUSTIFY_CENTER);
     	dc.drawText(xCenter+40, 38, Gfx.FONT_LARGE, dispElev, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter+40, 67, Gfx.FONT_XTINY, "alt", Gfx.TEXT_JUSTIFY_CENTER);	

		//Steps/HR      
		dc.drawText(87, 85, Gfx.FONT_SMALL, actSteps.abs(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(87, 108, Gfx.FONT_XTINY, "Steps", Gfx.TEXT_JUSTIFY_CENTER);        
        dc.drawText(xCenter+46, 83, Gfx.FONT_LARGE, hr , Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter+45, 109, Gfx.FONT_XTINY, "hr", Gfx.TEXT_JUSTIFY_CENTER);
             			                
 		//Dist & Speed        
		dc.drawText(99, 124, Gfx.FONT_MEDIUM, dispSpeed, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(99, 148, Gfx.FONT_XTINY, "Speed", Gfx.TEXT_JUSTIFY_CENTER);		
     	dc.drawText(155, 124, Gfx.FONT_MEDIUM, dispAvgSpeed, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(155, 148, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_CENTER);		
		           

	} //! HRbarMain
	
		
//!-----------------------------------------------------------------
//! Run Main Page --
//!-----------------------------------------------------------------
	 function drawRunMainPage(dc){       
	 	dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0,  width, height);   

		drawHRbarCommon(dc);   

     	dc.drawText(xCenter+40, 42, Gfx.FONT_MEDIUM, dispElev, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter+40, 67, Gfx.FONT_XTINY, "alt", Gfx.TEXT_JUSTIFY_CENTER);	

		if (showPace){
			dc.drawText(95, 39, Gfx.FONT_LARGE, dispPace, Gfx.TEXT_JUSTIFY_CENTER);
			dc.drawText(95, 67, Gfx.FONT_XTINY, "Pace", Gfx.TEXT_JUSTIFY_CENTER);
	
	     	dc.drawText(95, 80, Gfx.FONT_LARGE, dispAvgPace, Gfx.TEXT_JUSTIFY_CENTER);
			dc.drawText(95, 109, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_CENTER);
		}else{
			dc.drawText(95, 39, Gfx.FONT_LARGE, dispSpeed, Gfx.TEXT_JUSTIFY_CENTER);
			dc.drawText(95, 67, Gfx.FONT_XTINY, "Speed", Gfx.TEXT_JUSTIFY_CENTER);
	
	     	dc.drawText(95, 80, Gfx.FONT_LARGE, dispAvgSpeed, Gfx.TEXT_JUSTIFY_CENTER);
			dc.drawText(95, 109, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_CENTER);
		}
		dc.drawText(100, 124, Gfx.FONT_SMALL, actSteps.abs(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(100, 148, Gfx.FONT_XTINY, "Steps", Gfx.TEXT_JUSTIFY_CENTER);        
        dc.drawText(xCenter+46, 83, Gfx.FONT_LARGE, hr , Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter+45, 109, Gfx.FONT_XTINY, "hr", Gfx.TEXT_JUSTIFY_CENTER);
             			                
        //dc.drawText(152, 139, Gfx.FONT_TINY, Ui.loadResource(Rez.Strings.Run) , Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(146, 185, Gfx.FONT_XTINY, Ui.loadResource(Rez.Strings.Run) , Gfx.TEXT_JUSTIFY_CENTER);
		           
	} //! RunMain


//!-----------------------------------------------------------------
//! Bike Main Page --
//!-----------------------------------------------------------------
	 function drawBikeMainPage(dc){       
	 	dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0,  width, height);   

		drawHRbarCommon(dc);   

     	dc.drawText(xCenter+42, 42, Gfx.FONT_MEDIUM, dispElev, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter+40, 67, Gfx.FONT_XTINY, "alt", Gfx.TEXT_JUSTIFY_CENTER);	

		dc.drawText(91, 39, Gfx.FONT_LARGE, dispSpeed, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(93, 67, Gfx.FONT_XTINY, "Speed", Gfx.TEXT_JUSTIFY_CENTER);

     	dc.drawText(95, 80, Gfx.FONT_LARGE, dispAvgSpeed, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(95, 109, Gfx.FONT_XTINY, "avg", Gfx.TEXT_JUSTIFY_CENTER);
     
     	dc.drawText(97, 124, Gfx.FONT_MEDIUM, dispDsc, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(96, 148, Gfx.FONT_XTINY, "Descent", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter+46, 84, Gfx.FONT_MEDIUM, hr , Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter+45, 109, Gfx.FONT_XTINY, "hr", Gfx.TEXT_JUSTIFY_CENTER);
		
		dc.drawText(153, 119, Gfx.FONT_LARGE, Cadence, Gfx.TEXT_JUSTIFY_CENTER);             			  
		dc.drawText(153, 148, Gfx.FONT_XTINY, "Cadence", Gfx.TEXT_JUSTIFY_CENTER);
		//dc.drawText(165, 165, Gfx.FONT_XTINY, Ui.loadResource(Rez.Strings.Bike) , Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(146, 185, Gfx.FONT_XTINY, Ui.loadResource(Rez.Strings.Bike) , Gfx.TEXT_JUSTIFY_CENTER);
		              
	} //! BikeMain
		
	
//!-----------------------------------------------------------------
//! Cardio Page
//!-----------------------------------------------------------------
	 function drawCardioPage(dc){
	 	dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0,  width, height);   

        dc.setColor(HRcolbg,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(0, 45, 170, 45);
        dc.drawLine(0, 85, 180, 85);
        
		//drawHRbarCommon(dc);
		drawCommon(dc);
        //drawCommonLeft(dc);
        hrGraph.draw(dc,hr);

        
        dc.drawText(36, 44, Gfx.FONT_MEDIUM, maxHeartRate, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(36, 67, Gfx.FONT_XTINY, "maxHR", Gfx.TEXT_JUSTIFY_CENTER);	
		
		dc.drawText(xCenter-19, 44, Gfx.FONT_MEDIUM, averageHeartRate, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(xCenter-20, 67, Gfx.FONT_XTINY, "avgHR", Gfx.TEXT_JUSTIFY_CENTER);
     	
     	dc.drawText(xCenter+40, 38, Gfx.FONT_LARGE, hr, Gfx.TEXT_JUSTIFY_CENTER);
     	dc.drawText(xCenter+40, 67, Gfx.FONT_XTINY, "HR", Gfx.TEXT_JUSTIFY_CENTER);	    			
     			
     	//dc.drawText(3, 110, Gfx.FONT_XTINY, strHRzones , Gfx.TEXT_JUSTIFY_LEFT);
	    dc.drawText(20, 110, Gfx.FONT_XTINY, Lang.format("$1$, $2$, $3$",[timestr(tz0*1000),timestr(tz1*1000),timestr(tz2*1000)]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 122, Gfx.FONT_XTINY, "    0              1                2", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 136, Gfx.FONT_XTINY, Lang.format("$1$, $2$, $3$",[timestr(tz3*1000),timestr(tz4*1000),timestr(tz5*1000)]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 150, Gfx.FONT_XTINY, "    3              4                5", Gfx.TEXT_JUSTIFY_LEFT);  	
     	
	} //! HRbarMain
	
//!-----------------------------------------------------------------
//! LAP Page
//!-----------------------------------------------------------------
	 function drawLapPage(dc){
	 	dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0,  width, height);   

        dc.setColor(HRcolbg,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(0, 59, 170, 59);
        dc.drawLine(0, 151, 170, 151);

        
		//drawHRbarCommon(dc);
		drawCommon(dc);
        //drawCommonLeft(dc);
        hrGraph.draw(dc,hr);
	
		dc.drawText(18, 40, Gfx.FONT_TINY, "LAP: time,  dist,  alt", Gfx.TEXT_JUSTIFY_LEFT);
		for (var i = 0; i< 6; i++){
			if (LAPs[i][1] != 0 ){
				dc.drawText(15, (55 + i*15 ), Gfx.FONT_TINY, getLap(i), Gfx.TEXT_JUSTIFY_LEFT);
			}
		}
		//Bottom Line, actual LAP
		if (LapsDone > 0){
     		dc.drawText(30, 148, Gfx.FONT_TINY, Lang.format("$1$, $2$, $3$",[timestr(LAPtime),convertDistance(dist-LAPs[LapsDone-1][2]),convertElevation(asc-LAPs[LapsDone-1][3])]), Gfx.TEXT_JUSTIFY_LEFT);
     	}
     	else{
     		dc.drawText(30, 148, Gfx.FONT_TINY, Lang.format("$1$, $2$, $3$",[timestr(LAPtime),convertDistance(dist),convertElevation(asc)]), Gfx.TEXT_JUSTIFY_LEFT);
     	}     	
	} //! HRbarMain
	
	
	
	//!Status/Debug Seite
	function drawStatusPage (dc) {
	    dc.clear();
	    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        
        drawCommon(dc);        
        var t = Sys.getTimer();       
        var duration = ((t-startTime)/1000/60).toLong(); //[min]	//WORKS
        var perzPerHour = 0.0;
        if (duration > 1){
        	perzPerHour = ((startBatt-batt)/(duration/60.0));
        }
        perzPerHour = perzPerHour.format("%2.2f");
        dc.drawText(20, 43, Gfx.FONT_XTINY, Lang.format("Sport: $1$",[Sport.getSport()[0]]), Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(15, 60, Gfx.FONT_XTINY, Lang.format("Batt: $1$ -> $2$, $3$min, $4$%/hr",[startBatt.format("%2.1f"),batt.format("%2.1f"),duration,perzPerHour]), Gfx.TEXT_JUSTIFY_LEFT);    
	    var pos = null;
	    if (position != null and position.position != null){
	    	pos = position.position.toGeoString(Position.GEO_DEG);
	    }
	    if (pos!= null && acc > 1){
	    	dc.drawText(7, 80, Gfx.FONT_XTINY, Lang.format("Pos: $1$",[pos]), Gfx.TEXT_JUSTIFY_LEFT);
	    }else{
	    	dc.drawText(7, 80, Gfx.FONT_XTINY, Lang.format("Pos: $1$",["..."]), Gfx.TEXT_JUSTIFY_LEFT);
	    }
        if (sunset != null && sunset != 0){
        	dc.drawText(43, 120, Gfx.FONT_XTINY, Lang.format("$1$: $2$",[strSunset, sunset]), Gfx.TEXT_JUSTIFY_LEFT);
        	dc.drawText(43, 136, Gfx.FONT_XTINY, Lang.format("$1$: $2$",[strSunrise, sunrise]), Gfx.TEXT_JUSTIFY_LEFT);
        }       
	}//!Status/Debug Seite
        			
        			
        			
    //! Update the view
    function onUpdate(dc) {
    	postMem("mainView::onUpdate()");
    	if(session == null){
    		return false;
    	}	
    	if ( PageSelect == 0 ){
			drawHRbarMainPage(dc);		
		} else if ( PageSelect == 1 ){	
			drawNewMainPage(dc);
		} else if ( PageSelect == 2 ){
			drawRunMainPage(dc);
		} else if ( PageSelect == 3 ){
			drawBikeMainPage(dc);
		} else if ( PageSelect == 4 ){
			drawCardioPage(dc);
		} else if ( PageSelect == 5 ){
			drawLapPage(dc);
		} else if ( PageSelect == 6 ){
			drawStatusPage(dc);
		}
		return true;
    }
}





class BaseInputDelegate extends Ui.BehaviorDelegate
{
    function initialize() {
        Ui.BehaviorDelegate.initialize();
    }
    
    function onMenu() {
   		Ui.pushView(new Rez.Menus.SettingsMenu(), new settingsMenuDelegate(), Ui.SLIDE_UP);
   		return true;
    }
    
    function onKey(evt) {
	   	//postMsg(evt.getKey());
	    if (evt.getKey() == Ui.KEY_START or evt.getKey() == Ui.KEY_ENTER){ 
	    	activateBacklight();
            if( session == null ){
            	App.getApp().startRecording();
            	App.getApp().showView();
            }
            else {
				App.getApp().askExit();
            }
	        return true;
	    }
	    if (evt.getKey() == KEY_UP){
		    if( ( session == null ) || ( session.isRecording() == false ) ) {
		    	Ui.pushView(new Rez.Menus.SportMenu(), new sportMenuDelegate(), Ui.SLIDE_UP);
		    }
		    else if( ( session != null ) && session.isRecording() ) {
				PageDown();
				Ui.requestUpdate();
		    }
	    }
	    if (evt.getKey() == KEY_DOWN) {
	    	activateBacklight();
		    if( ( session == null ) || ( session.isRecording() == false ) ) {
		    	Ui.pushView(new Rez.Menus.SportMenu(), new sportMenuDelegate(), Ui.SLIDE_UP);
		    }
		    else if( ( session != null ) && session.isRecording() ) {
		    	PageUp();
		    	Ui.requestUpdate();
		    }
	    }
	    if (evt.getKey() == KEY_ESC){
	    	if( ( session != null ) && session.isRecording() ) {
	    	   session.addLap();
	    	   addLap();
	    	   LAPtimeStart = Sys.getTimer();
	    	   if (SoundOn){
	    	   		attention.playTone(Attention.TONE_LAP);
	    	   }
               activateBacklight();
               vibrate();
	    	   return true;
	    	}
	    	else{
	    		return false;
	    	}
	    }
	    return false;   
    }
}
