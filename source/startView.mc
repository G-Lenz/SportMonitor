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

class SMstartView extends Ui.View {        
	var bitmap = null;               
	var strExit = null;
    function initialize() {
        View.initialize();
        //postMsg("Startview: initView");
    }
        
    //! Load your resources here
    function onLayout(dc) {
        //width = dc.getWidth(); //218
        //postMsg(width);
        //height = dc.getHeight(); //218
        //postMsg(height);
        //xCenter = width / 2;
        //yCenter = height / 2; 
        bitmap = Ui.loadResource(Rez.Drawables.Icon50);
        //bitmap = Ui.loadResource(Rez.Drawables.LauncherIcon);
        //AppName = Ui.loadResource(Rez.Strings.AppName);
        strExit = Ui.loadResource(Rez.Strings.Exit);  
    }
        			
    //! Update the view
    function onUpdate(dc) {
	    dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		
		if (position == null){
			position = Position.getInfo();
		}
		if (position != null){
    		acc = position.accuracy;
    	}
    	if (acc == null){
    		acc = 42;
    	}
    	var HR = null;
    	//sensorInfo = Sensor.getInfo();
    	if (sensorInfo != null){
    		HR = sensorInfo.heartRate;
    	}

    	batt = Sys.getSystemStats().battery;
    	if (startBatt == null){
    		startBatt = batt;
    		startTime = Sys.getTimer();
    	}
     	colBatt = Gfx.COLOR_DK_GREEN;
     	if (batt < 70){
     		colBatt = Gfx.COLOR_DK_BLUE;
     	}
     	if (batt < 50){
     		colBatt = Gfx.COLOR_DK_RED;
     	}
     	
     	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_WHITE);
     	dc.drawText(109, 11, Gfx.FONT_XTINY, Lang.format("$1$ $2$",[AppName,Version]), Gfx.TEXT_JUSTIFY_CENTER);
        
	    dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_TRANSPARENT);
        dc.drawLine(100, 62, width, 62);
        dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT);
        
        dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_TRANSPARENT);
        dc.drawLine(100, 145, width, 145);
        dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT);
        
        //dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_TRANSPARENT);
        //dc.drawLine(80, 15, 80, 200);
        //dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT);
        
     	var s1 = 100;
     	var s2 = 155;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.drawText(s1, 70, Gfx.FONT_SMALL, "GPS:", Gfx.TEXT_JUSTIFY_LEFT);
        //if (App.getApp().getGPSon()){
	        if (acc < 3){
	        	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_WHITE);
	        	dc.drawText(s2, 70, Gfx.FONT_SMALL, "wait" , Gfx.TEXT_JUSTIFY_LEFT);
	        	dc.drawText(s2+40, 70, Gfx.FONT_SMALL, acc, Gfx.TEXT_JUSTIFY_LEFT);
	        }else{
	        	dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_WHITE);
	        	dc.drawText(s2, 70, Gfx.FONT_SMALL, "ok: ", Gfx.TEXT_JUSTIFY_LEFT);
	        	dc.drawText(s2+27, 70, Gfx.FONT_SMALL, acc, Gfx.TEXT_JUSTIFY_LEFT);
	        }
        //}
        //else{
        //		dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_WHITE);
	    //    	dc.drawText(s2, 70, Gfx.FONT_SMALL, "OFF", Gfx.TEXT_JUSTIFY_LEFT);
        //}
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.drawText(s1, 90, Gfx.FONT_SMALL, "HR:", Gfx.TEXT_JUSTIFY_LEFT);
        if (HR == null){
        	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_WHITE);
    		dc.drawText(s2, 90, Gfx.FONT_SMALL,"wait", Gfx.TEXT_JUSTIFY_LEFT);
    	}else{
    		dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_WHITE);
    	    dc.drawText(s2, 90, Gfx.FONT_SMALL, HR, Gfx.TEXT_JUSTIFY_LEFT);
    	}
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.drawText(s1, 110, Gfx.FONT_SMALL, "Batt:", Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(colBatt, Gfx.COLOR_WHITE);
        dc.drawText(s2, 110, Gfx.FONT_SMALL, batt.format("%d"), Gfx.TEXT_JUSTIFY_LEFT);
        dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_WHITE);
    	dc.drawText(125, 30, Gfx.FONT_MEDIUM, "Start ->", Gfx.TEXT_JUSTIFY_LEFT);
    
    	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_WHITE);
    	dc.drawText(125, 150, Gfx.FONT_MEDIUM, Lang.format("$1$ ->",[strExit]), Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.drawText(1, 90, Gfx.FONT_MEDIUM, "<-Sport", Gfx.TEXT_JUSTIFY_LEFT);
    	dc.drawText(15, 130, Gfx.FONT_SMALL, Sport.getSport()[0], Gfx.TEXT_JUSTIFY_LEFT);
    	
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(57, 185, Gfx.FONT_XTINY, "Menu for Settings", Gfx.TEXT_JUSTIFY_LEFT);
    	
       	dc.drawBitmap(34, 39, bitmap);
       	
       	//dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_WHITE);
        //dc.drawText(57, 185, Gfx.FONT_XTINY, Lang.format("SportMonitor $1$",[Version]), Gfx.TEXT_JUSTIFY_LEFT);
    }
}

