using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityRecording as Record;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as AMon;
using Toybox.Position as Position;
using Toybox.Sensor as Sensor;
using Toybox.Application as App;
using Toybox.Attention as attention;

class SettingsView extends Ui.View {
    hidden var width;
    hidden var height;
    hidden var xCenter;
    hidden var yCenter;
    var target = null;

    //! Load your resources here
    function onLayout(dc) {
        width = dc.getWidth();
        height = dc.getHeight();
        xCenter = width / 2;
        yCenter = height / 2;   
    }

    function initialize(item) {
        View.initialize();
     	target = item;
    }
    
    function onHide() {
    }

    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		
        if (target == :Light){
        	//postMsg("SV: Light");
        	dc.drawText(110, 25, Gfx.FONT_LARGE, "Light", Gfx.TEXT_JUSTIFY_CENTER);
        	if (BacklightOn == true){
				dc.drawText(110, 100, Gfx.FONT_LARGE, "ON", Gfx.TEXT_JUSTIFY_CENTER);
			}
			else{
			    dc.drawText(110, 100, Gfx.FONT_LARGE, "OFF", Gfx.TEXT_JUSTIFY_CENTER); 
			}   
        	
        } else  if (target == :Sound) {
        	//postMsg("Sound");
        	dc.drawText(110, 25, Gfx.FONT_LARGE, "Sound", Gfx.TEXT_JUSTIFY_CENTER);
			if (SoundOn == true){
				dc.drawText(110, 100, Gfx.FONT_LARGE, "ON", Gfx.TEXT_JUSTIFY_CENTER);
			}
			else{
			    dc.drawText(110, 100, Gfx.FONT_LARGE, "OFF", Gfx.TEXT_JUSTIFY_CENTER); 
			}   	
        } else  if (target == :Vibration) {
        	//postMsg("Vibration");
        	dc.drawText(110, 25, Gfx.FONT_LARGE, "Vibration", Gfx.TEXT_JUSTIFY_CENTER);
        	if (VibrationOn == true){
				dc.drawText(110, 100, Gfx.FONT_LARGE, "ON", Gfx.TEXT_JUSTIFY_CENTER);
			}
			else{
			    dc.drawText(110, 100, Gfx.FONT_LARGE, "OFF", Gfx.TEXT_JUSTIFY_CENTER); 
			}   	
        } else  if (target == :SaveSport) {
        	dc.drawText(110, 80, Gfx.FONT_LARGE, "Save last sport", Gfx.TEXT_JUSTIFY_CENTER);
        	if (SaveLastSportOn == true){
				dc.drawText(110, 150, Gfx.FONT_LARGE, "ON", Gfx.TEXT_JUSTIFY_CENTER);
			}
			else{
			    dc.drawText(110, 150, Gfx.FONT_LARGE, "OFF", Gfx.TEXT_JUSTIFY_CENTER); 
			}   	
        }
    }
}


class SettingsViewDelegate extends Ui.BehaviorDelegate
{
	var target = null;
	//var state = null;
    function initialize(item) {
    	BehaviorDelegate.initialize();
     	target = item;
     	//postMsg(Lang.format("target: $1$",[target]));
    }

    function onKey(evt) {
	    if (evt.getKey() == Ui.KEY_START or evt.getKey() == Ui.KEY_ENTER){
	    	var app = App.getApp(); 
		   	if (target == :Light){
	        	app.setProperty("Backlight",BacklightOn);
	        	postMsg(Lang.format("Save Backlight: $1$",[BacklightOn]));
	        } else  if (target == :Sound) {
				app.setProperty("Sound",SoundOn);
				postMsg(Lang.format("Save Sound: $1$",[SoundOn]));	
	        } else  if (target == :Vibration) {
				app.setProperty("Vibration",VibrationOn);	
				postMsg(Lang.format("Save Vibration: $1$",[VibrationOn]));
	        } else  if (target == :SaveSport) {
				app.setProperty("SaveLastSport",SaveLastSportOn);	
				postMsg(Lang.format("Save SaveLastSportOn: $1$",[SaveLastSportOn]));
	        }	    	
	    	Ui.popView(Ui.SLIDE_UP);
	        return true;
	    }
	    if (evt.getKey() == KEY_UP || evt.getKey() == KEY_DOWN){
		   	if (target == :Light){
	        	BacklightOn = !BacklightOn;
	        } else  if (target == :Sound) {
				SoundOn = !SoundOn;
	        } else  if (target == :Vibration) {
				VibrationOn = !VibrationOn;
	        } else  if (target == :SaveSport) {
				SaveLastSportOn = !SaveLastSportOn;
	        }
	        Ui.requestUpdate();
		    return true;
	    }
	    if (evt.getKey() == KEY_ESC){
	    	Ui.popView(Ui.SLIDE_UP);
	    	return true;
	    }
	    return false;   
    }
}
