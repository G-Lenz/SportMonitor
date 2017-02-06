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

class SMendView extends Ui.View {                        
    function initialize() {
        View.initialize();
        postMsg("Endview: initView");
        postMem("Endview: initView()");
    }
               			
    //! Update the view
    function onUpdate(dc) {
	    dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		
		var t = Sys.getTimer();
        var duration = ((t-startTime)/1000/60).toLong(); //[min]	//WORKS
        var perzPerHour = 0.0;
        if (duration > 1){
        	perzPerHour = ((startBatt-batt)/(duration/60.0));
        }
        perzPerHour = perzPerHour.format("%2.2f");
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(109, 15, Gfx.FONT_XTINY, Lang.format("$1$ $2$",[AppName,Version]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawText(30, 30, Gfx.FONT_XTINY, Lang.format("Sport: $1$",[Sport.getSport()[0]]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 45, Gfx.FONT_XTINY, Lang.format("Bat: $1$ -> $2$, $3$min, $4$%/hr",[startBatt.format("%2.1f"),batt.format("%2.1f"),duration,perzPerHour]), Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawText(20, 45, Gfx.FONT_XTINY, Lang.format("Batt: $1$ -> $2$, $3$min, $4$%/hr",[startBatt,batt,duration,perzPerHour]), Gfx.TEXT_JUSTIFY_LEFT);    
	    dc.drawText(5, 75, Gfx.FONT_XTINY, Lang.format("TrainingEffect: $1$",[trainingEffect]), Gfx.TEXT_JUSTIFY_LEFT);
	    if(activityInfo != null && asc != null){
	    	dc.drawText(2, 90, Gfx.FONT_XTINY, Lang.format("Dist: $1$, Time: $2$, asc: $3$",[dispDist,timestr(activityInfo.elapsedTime),dispAsc]), Gfx.TEXT_JUSTIFY_LEFT);
	    }
	    
	    
	    dc.drawText(3, 110, Gfx.FONT_XTINY, strHRzones , Gfx.TEXT_JUSTIFY_LEFT);
	    dc.drawText(60, 110, Gfx.FONT_XTINY, Lang.format("$1$, $2$, $3$",[timestr(tz0*1000),timestr(tz1*1000),timestr(tz2*1000)]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(60, 122, Gfx.FONT_XTINY, "    0              1                2", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(60, 136, Gfx.FONT_XTINY, Lang.format("$1$, $2$, $3$",[timestr(tz3*1000),timestr(tz4*1000),timestr(tz5*1000)]), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(60, 150, Gfx.FONT_XTINY, "    3              4                5", Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter, 190, Gfx.FONT_XTINY, Ui.loadResource(Rez.Strings.byebye), Gfx.TEXT_JUSTIFY_CENTER);
        postMem("endView::onUpdate()");
    }
}

class EndViewDelegate extends Ui.BehaviorDelegate
{
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(evt) {
    	 Ui.popView(Ui.SLIDE_UP);
    	 Ui.popView(Ui.SLIDE_UP);
	     return true;
    }
}
