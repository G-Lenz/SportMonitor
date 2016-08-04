using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Toybox.Sensor as Sensor;
using Toybox.System as Sys;
using Toybox.Attention as attention;
using Toybox.ActivityRecording as Record;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as AMon;
using Toybox.Graphics as Gfx;
using Toybox.UserProfile as Profile;
using Toybox.Time as Time;
using Toybox.Math as Math;

var session = null;

var Version = "0.604_test";

var sensorInfo = null;
var activityInfo = null;
var position = null;
var time = 0;
var elaTime = null; //ms
var elaTimeArr = null;	//Array
var steps = 0;
var iniSteps = 0;
var actSteps = 0;
var hr = 0;
var HRperc = 0;
var HRzone = 0;
var HRcol = 0;
var HRcolbg = 0;
var Kcal = null;
var batt = null;
var startBatt = 0;
var startTime = 0;
var colBatt = 0;
var alt = 0;
var dispElev = 0;
var acc = 0;
var asc = 0;
var dispAsc = 0;
var dsc = 0;
var dispDsc = 0;
var dist = 0;
var dispDist = 0;
var speed = null;
var dispSpeed = 0;
var avgSpeed = 0;
var dispAvgSpeed = 0;
var dispPace = 0;
var dispAvgPace = 0;
var Cadence = 0;
var avgCadence = 0;
var trainingEffect = 0; 
var temp = null;
var dispTemp = "..";
var LAPtimeStart = 0;
var LAPtime = 0;
var sunrise = null;
var sunset = null;
var averageHeartRate = 0;
var maxHeartRate  = 0;

//Time in Zones
var tz0= 0;
var tz1= 0;
var tz2= 0;
var tz3= 0;
var tz4= 0;
var tz5= 0;
//HRzone Settings
var RHR= 70;
var z1bpm = 80; //lower bound
var z2bpm = 100;
var z3bpm = 120;
var z4bpm = 140;
var z5bpm = 160;
var maxHR = 170;

// --OPTIONS
var SoundOn = false;
var VibrationOn = false;
var BacklightOn = false;
var SaveLastSportOn = false;
var AutoBattOff = null;
//var showPace = true;
var showPace = false;

var BacklightTimer = -1;

var Sport = null;
    
var width = 218;
var height = 218;
var xCenter = 109; //109
var yCenter = 109;
//Strings
var AppName = "";
var strHRzones = "";
var strSunset = "";
var strSunrise = "";
	
var bgColor = Gfx.COLOR_WHITE;
var fgColor = Gfx.COLOR_BLACK;


function postMsg(identifier){
	var time = Sys.getClockTime();
	if (time != null){
		Sys.println(Lang.format("$1$:$2$:$3$   $4$",[time.hour.format("%2.2d"),time.min.format("%2.2d"),time.sec.format("%2.2d"),identifier]));
	}
}

var minMem = 100000;
function postMem(identifier){
	var freemem = Sys.getSystemStats().freeMemory;
	if (freemem != null && freemem < minMem){
		minMem = freemem;
		postMsg(Lang.format("$1$ free, $2$ used, $3$ total - $4$",[freemem,Sys.getSystemStats().usedMemory,Sys.getSystemStats().totalMemory,identifier]));
	}
}

var LAPs = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]];//0...5
var LapsDone = 0;
var overrun = 0;
function addLap(){
	if (LapsDone > 5){
		overrun = 1;
		//postMsg("copyLap");
		LAPs[0] = LAPs[1];
		LAPs[1] = LAPs[2];
		LAPs[2] = LAPs[3];
		LAPs[3] = LAPs[4];
		LAPs[4] = LAPs[5];
		//for (var i = 0; i< 5; i++){
		//LAPs[i] = LAPs[i+];
		//}
		LapsDone = 5;  
	}
	var i = 0;
	if (LapsDone > 0){
		i = LAPs[LapsDone-1][0]+1;
	}	
	LAPs[LapsDone] = [i,elaTime,dist,asc];
	//postMsg(LAPs[LapsDone]);
	//postMsg(getLap(LapsDone));	
	LapsDone = LapsDone+1; 
}
function getLap(lap){
	if (lap == 0){
		var ln = "";
		if (overrun > 0){
			ln = "-";
		}else{
			ln = LAPs[lap][0];
		}
		return Lang.format("$1$: $2$, $3$, $4$",[ln,timestr(LAPs[lap][1]), convertDistance(LAPs[lap][2]), convertElevation(LAPs[lap][3]) ]);
	}else{
		return Lang.format("$1$: $2$, $3$, $4$",[LAPs[lap][0],timestr(LAPs[lap][1]-LAPs[lap-1][1]),  convertDistance(LAPs[lap][2]-LAPs[lap-1][2]), convertElevation(LAPs[lap][3]-LAPs[lap-1][3]) ]);
	}
}

//Convert Speed to selected unit
function convertSpeed(speed){ //[m/s]
	var outSpeed = 0;
	var outPace = 0;

    if (speed == null or speed <= 0.0){
		outSpeed = "0";
     	outPace = "0";
     }
     else{
     	speed = speed + 0.0001; //Prevent div by 0 
		if(Sys.UNIT_METRIC == Sys.getDeviceSettings().paceUnits){
	    	outSpeed = (speed*3.6);// [km/h]
	 		outPace = (60/(speed*3.6)).format("%1.1f"); //[min/km]  
	 	}else{
	 		outSpeed = (speed*2.2369);// [mls/h]
	 		outPace = (60/(speed*2.2369)).format("%1.1f"); //[min/mls]
	 	}
	 	if (outSpeed > 99.0){
			outSpeed = outSpeed.format("%d");
		} else {
			outSpeed = outSpeed.format("%1.1f");
	   	}    
   	}
 	return [outSpeed,outPace];
}
     		
function convertElevation(elev){
     	if (elev == null){
     		elev = "0";
     	}else{
	 		if(Sys.UNIT_METRIC == Sys.getDeviceSettings().elevationUnits){
	 			elev = elev.format("%i"); //m
	 		}else{
	 			elev = (elev * 3.28084).format("%i"); //feet
	 		}
 		}
 		return elev;
}

function convertDistance(dist){
     	if (dist == null){
     		disp = "0";
     	} else {
	 		if(Sys.UNIT_METRIC == Sys.getDeviceSettings().distanceUnits){
	 			dist = (dist/1000).format("%1.1f"); //km
	 		}else{
	 			dist = (dist * 0.000621371).format("%1.1f"); //miles
	 		}
	 	}
 		return dist;
}

//Seconds to minutes and seconds
function minsec(secs){
	var min = 0;
	if (secs > 60){
		min = (secs/60).toLong();
		secs = secs-(min*60); 
	}
	return [min.format("%2.2d"),secs.format("%2.2d"),Lang.format("$1$:$2$",[min.format("%2.2d"),secs.format("%2.2d")])];
}  

function timearr (msecs){
	var secs = 0;
	var min = 0;
	var hour = 0;
	if (msecs == null){
		msecs = 0;
	}
	else{
		secs = msecs/1000;
	}
	if (secs > 3600){
		hour = (secs/3600).toLong();
		secs = secs-(hour*3600); 
	}
	if (secs > 60){
		min = (secs/60).toLong();
		secs = secs-(min*60); 
	}
	return [hour.format("%d"),min.format("%2.2d"),secs.format("%2.2d")];
}    

function timestr(msecs){
	var arr =  timearr (msecs);
	return Lang.format("$1$:$2$:$3$",[arr[0],arr[1],arr[2]]);
}



var PageSelect = 0;
var PageMax = 6;
function PageUp(){
	PageSelect = PageSelect + 1;
	if (PageSelect >  PageMax){
		PageSelect = 0;
	}
	//postMsg(PageSelect);
}
function PageDown(){
	PageSelect = PageSelect - 1;
	if (PageSelect <  0){
		PageSelect = PageMax;
	}
	//postMsg(PageSelect);
}



function momentToString(moment) {
	//https://github.com/haraldh/SunCalc/blob/master/source/SunCalcView.mc
		if (moment == null) {
			return "--:--";
		}

   		var tinfo = Time.Gregorian.info(new Time.Moment(moment.value() + 30), Time.FORMAT_SHORT);
		var text;
		if (Sys.getDeviceSettings().is24Hour) {
			text = tinfo.hour.format("%02d") + ":" + tinfo.min.format("%02d");
		} else {
			var hour = tinfo.hour % 12;
			if (hour == 0) {
				hour = 12;
			}
			text = hour.format("%02d") + ":" + tinfo.min.format("%02d");
			if (tinfo.hour < 12 || tinfo.hour == 24) {
				text = text + " AM";
			} else {
				text = text + " PM";
			}
		}
		var now = Time.now();
		var days = (moment.value() / Time.Gregorian.SECONDS_PER_DAY).toNumber()
			- (now.value() / Time.Gregorian.SECONDS_PER_DAY).toNumber();

		if (days > 0) {
			text = text + " +" + days;
		}
		if (days < 0) {
			text = text + " " + days;
		}
		return text;
}

function getSettings(){	
		var lrhr = App.getApp().getProperty("rhr");
	    if (lrhr != null){
	    	postMsg(Lang.format("RHR: $1$",[lrhr]));
	    	RHR = lrhr;
   		}

		AutoBattOff = App.getApp().getProperty("AutoBattOff");
	    if (AutoBattOff == null){
			//postMsg("AutoBattOff == null");
			AutoBattOff = 0;	
	    }
	    else {
	    	postMsg(Lang.format("AutoBattOff: $1$",[AutoBattOff]));
   		}

		showPace = App.getApp().getProperty("showPace");
	    if (showPace == null){
			showPace = true;	
			postMsg(Lang.format("showPace: null"));
	    }else {
	    	postMsg(Lang.format("showPace: $1$",[showPace]));
   		}
   		   				
   		SoundOn = App.getApp().getProperty("Sound");
        if (SoundOn == null){
        	//postMsg("SoundOn == null");
        	SoundOn = false;
       	}
       	else{
       		postMsg(Lang.format("SoundOn: $1$",[SoundOn]));
       	}
       	
        VibrationOn = App.getApp().getProperty("Vibration");
        if (VibrationOn == null){
        	VibrationOn = true;
        	//postMsg("VibrationOn == null");
       	}
       	else{
       		postMsg(Lang.format("VibrationOn: $1$",[VibrationOn]));
       	}
       	
		BacklightOn = App.getApp().getProperty("Backlight");
        if (BacklightOn == null){
        	BacklightOn = false;
        	//postMsg("BacklightOn == null");
       	}
       	else{
       		postMsg(Lang.format("BacklightOn: $1$",[BacklightOn]));
       	} 
       	
       	SaveLastSportOn = App.getApp().getProperty("SaveLastSport");
        if (SaveLastSportOn == null){
        	SaveLastSportOn = false;
        	//postMsg("SaveLastSportOn == null");
       	}
       	else{
       		postMsg(Lang.format("SaveLastSportOn: $1$",[SaveLastSportOn]));
       		if (SaveLastSportOn == true){
	       		var SavedSport = App.getApp().getProperty("LastSport");
	        	if (SavedSport == null){
		        	//postMsg("SavedSport == null");
	       		}
	       		else {
	       			//postMsg(Lang.format("SavedSport: $1$",[SavedSport]));
	       			Sport.setSport(SavedSport);
	       		}
       		}
       	}      	       		
}

function getProfileData(){
       	var pZones = Profile.getHeartRateZones(Profile.getCurrentSport());
       	//postMsg(Lang.format("ZonesFromProfile: $1$",[pZones]));
       	//min zone 1, max zone 1, max zone 2, max zone 3, max zone 4, max zone 5 
       	//[112, 150, 160, 180, 190, 200]
       	var pRHR = Profile.getProfile().restingHeartRate;
       	//postMsg(Lang.format("RHRFromProfile: $1$",[pRHR]));
       	
		if (pRHR != null and pRHR > 0){
			RHR= pRHR;
		}
		z1bpm = pZones[0]; //lower bound
		z2bpm = pZones[1];
		z3bpm = pZones[2];
		z4bpm = pZones[3];
		z5bpm = pZones[4];
		maxHR = pZones[5];       	
}
       	
       	
class SportDef {
	//var SportName = "Walk";
	hidden var lSport = 1;  
	//1: walk, 2: Hike, 3: Climb, 4: Mountain, 5: Run, 6:Trailrun, 7: MTB, 8: Bike, 9: Skiing, 10: Skitouring, 21: Training, 22: IndoorClimbing
	//var subSport = "";
	function setSport(ns ){
		lSport = ns;
	}
	function getSport(){
		if (lSport == 1){
			return [Ui.loadResource(Rez.Strings.Walk), Record.SPORT_WALKING,Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 2){
			return [Ui.loadResource(Rez.Strings.Hike), Record.SPORT_HIKING,Record.SUB_SPORT_GENERIC,lSport];
		}	
		else if (lSport == 3){
			return [Ui.loadResource(Rez.Strings.Climb), Record.SPORT_MOUNTAINEERING, Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 4){
			return [Ui.loadResource(Rez.Strings.Mountaineering), Record.SPORT_MOUNTAINEERING,Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 5){
			return [Ui.loadResource(Rez.Strings.Run), Record.SPORT_RUNNING,Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 6){
			return [Ui.loadResource(Rez.Strings.TrailRun), Record.SPORT_RUNNING,Record.SUB_SPORT_TRAIL,lSport];
		}
		else if (lSport == 7){
			return [Ui.loadResource(Rez.Strings.MntnBike), Record.SPORT_CYCLING,Record.SUB_SPORT_MOUNTAIN,lSport];
		}
		else if (lSport == 8){
			return [Ui.loadResource(Rez.Strings.Bike), Record.SPORT_CYCLING,Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 9){
			return [Ui.loadResource(Rez.Strings.Skiing), Record.SPORT_ALPINE_SKIING,Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 10){
			return [Ui.loadResource(Rez.Strings.Skitour), Record.SPORT_ALPINE_SKIING , Record.SUB_SPORT_GENERIC ,lSport];
		}
		else if (lSport == 21){
			return [Ui.loadResource(Rez.Strings.Training), Record.SPORT_TRAINING ,Record.SUB_SPORT_GENERIC,lSport];
		}
		else if (lSport == 22){
			return [Ui.loadResource(Rez.Strings.IndoorClimb), Record.SPORT_TRAINING ,Record.SUB_SPORT_GENERIC,lSport];
		}
		else{
			return ["Walk", Record.SPORT_WALKING,Record.SUB_SPORT_GENERIC,lSport];
		}
	}
}
	
function vibrate(){
	if (VibrationOn){
       	var vibrateData = [new Attention.VibeProfile(50, 1000)];
       	attention.vibrate(vibrateData);
    }
}

function activateBacklight() {
	if (BacklightOn){
		BacklightTimer = 8;
		attention.backlight( true );
	}
} 

class SportMonitor extends App.AppBase {
	hidden var GPSon = false;
	
    function initialize() {
    	postMsg("--Start--");
    	AppBase.initialize();
    	AppName = Ui.loadResource(Rez.Strings.AppName);
        postMsg(Lang.format("App:initialize() $1$ v$2$",[AppName,Version]));
        Sport = new SportDef();
        //var settings = new cSettings();
        //settings.getSettings();
        //settings = null;
        getSettings();
        postMem("App:initialize()");
    }
      
	function getGPSon(){
		return GPSon;
	}
    function startGPS() {
    	if (GPSon == false){
    		postMsg("Start GPS");
        	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        	GPSon = true;
        }
    }
    function startSensor() {
    	postMsg("Start Sensor");
    	//postMsg("--Start--");
        Sensor.enableSensorEvents(method(:onSensor));
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE,Sensor.SENSOR_TEMPERATURE,Sensor.SENSOR_FOOTPOD, Sensor.SENSOR_BIKECADENCE, Sensor.SENSOR_BIKESPEED, Sensor.SENSOR_BIKEPOWER]); 
    }
    function stopGPS() {
    	postMsg("Stop GPS");
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    	GPSon = false;
    }
    function stopSensor() {
    	postMsg("Stop Sensor");
    	Sensor.enableSensorEvents();
    	Sensor.setEnabledSensors([]);
    }
        
    function onStart() {
		startGPS();
		startSensor(); 
        session = null;
        startBatt = Sys.getSystemStats().battery;
        startTime = Sys.getTimer();
    }

	function startRecording() {
			var aSport = Sport.getSport();
            session = Record.createSession({:name=>aSport[0], :sport=>aSport[1], :subSport=>aSport[2]});
            if(aSport[3] > 20){ //Indoor
            	stopGPS();
            }
            else{
            	startGPS();
            }
            session.start();
            LAPtimeStart = Sys.getTimer();
            //Ui.requestUpdate();
            iniSteps = null;
            postMsg("Start Recording"); 
            if (SoundOn){
            	attention.playTone(Attention.TONE_START);
            }
			vibrate();
			if (aSport[3] == 5 || aSport[3] == 6){ 
				PageSelect = 2;
			} else if (aSport[3] == 7 || aSport[3] == 8){ 
				PageSelect = 3;
			}
	}
	
    function stopRecording() {
        postMsg("stopRecording");
        if( session != null) {
        	if (session.isRecording()){ 
	            session.stop();
	            session.save();
	            session = null;
	            //Ui.requestUpdate();
	            postMsg("saved Session");
            }
            if (SoundOn){
    	    	attention.playTone(Attention.TONE_STOP);
    	    }
			vibrate();
        }
        postMsg("stoped Recording");
        //Sys.exit();
        //Ui.popView(Ui.SLIDE_UP);
        showEndView();
    }
    
    function discardRecording(){
    	if( session != null) {
	    	session.stop();
		    session.discard();
	        session = null;
	        //Ui.requestUpdate();
	        postMsg("discarded Recording (View)");
	        if (SoundOn){
	        	attention.playTone(Attention.TONE_STOP);
	        }
			vibrate();
	    }
	    //Sys.exit(); //Settings discarded!
	    Ui.popView(Ui.SLIDE_UP);
	    Ui.popView(Ui.SLIDE_UP);
	    Ui.popView(Ui.SLIDE_UP);
    }

	function saveSession(){
        stopRecording();
	}
	
	function discardSession(){
       	discardRecording();
	}
	
    function onStop() {
        if (BacklightOn == true){
        	attention.backlight( false );
        }
    	postMsg("AppOnStop");
		if( session != null) {
			stopRecording();
		}
        stopGPS();
	    stopSensor();
	    if (SaveLastSportOn){
	       	var spts= Sport.getSport()[3];
	       	postMsg(Lang.format("Save Sport: $1$",[spts]));
	       	setProperty("LastSport", spts);
	    }
	    Sport = null;
	    postMem("App:onStop()");
	    postMsg("--END--");
    }

	function askExit(){
		if (SoundOn){
			attention.playTone(Attention.TONE_STOP);
		}
		activateBacklight();
		vibrate();   
		Ui.pushView(new Rez.Menus.ExitMenu(), new exitMenuDelegate(), Ui.SLIDE_UP);
	}
	
    function getValues() {
    	//postMsg("getValues()");
        activityInfo = Act.getActivityInfo(); //Current Activity Info not ActivityMonitorInfo!!     	
        if (activityInfo != null){
        	elaTime = activityInfo.elapsedTime;
        	hr = activityInfo.currentHeartRate;
        	Kcal = activityInfo.calories;
			alt = activityInfo.altitude;
     		trainingEffect = activityInfo.trainingEffect;
		 	acc = activityInfo.currentLocationAccuracy;
		 	asc = activityInfo.totalAscent;
		 	dsc = activityInfo.totalDescent;
		    dist = activityInfo.elapsedDistance;
		    speed = activityInfo.currentSpeed;
		    avgSpeed = activityInfo.averageSpeed;
		    Cadence = activityInfo.currentCadence;
			avgCadence = activityInfo.averageCadence;
			averageHeartRate = activityInfo.averageHeartRate;
			maxHeartRate = activityInfo.maxHeartRate;
        } 
                	
        if (elaTime != null){
        	elaTimeArr = timearr(elaTime);
        }else{
        	elaTimeArr = null;
        }
        //Values
        time = Sys.getClockTime();    

		if ( LAPtimeStart != null){
			var t = Sys.getTimer();
			if (t != null){
				LAPtime = t - LAPtimeStart;	
			}
		}
	
		var amoninfo =  AMon.getInfo();
		if (amoninfo != null){
	        steps = amoninfo.steps;
	        if (steps == null){
	        	steps = 0;
	        }            	
	        if (iniSteps == null){
	        	iniSteps = steps;
	        }
	        actSteps = steps - iniSteps;
        }
        //hr = 184;
        //postMsg(Lang.format("hr main: $1$",[hr]));
        if (hr == null){
        	hr = 0;
        	HRperc = 0;
        }
        else {
        	HRperc = (hr.toFloat()/maxHR)*100;
        }
        //postMsg(Lang.format("hr main: $1$",[hr]));
        HRzone = 2;
		HRcol = fgColor;
		HRcolbg = bgColor;

		if (hr < z1bpm){
			HRzone = 0;
			HRcolbg = Gfx.COLOR_BLUE;
			tz0 = tz0+1;
		}
		else if (hr >= z1bpm and hr < z2bpm){
			HRzone = 1.0+((hr-z1bpm.toFloat())/(z2bpm.toFloat()-z1bpm));
			//postMsg(Lang.format("hr diff: $1$",[(hr.toFloat()-z1bpm)/(z2bpm-z1bpm)]));
 		 	if (HRzone > 1.9) {
    			HRzone = 1.9;
  			}
  			HRcolbg = Gfx.COLOR_GREEN;
  			tz1 = tz1+1;
		}
		else if (hr >= z2bpm and hr < z3bpm){
			  HRzone = 2.0+((hr-z2bpm.toFloat())/(z3bpm.toFloat()-z2bpm));   
			  if (HRzone > 2.9) {
			    HRzone = 2.9;
			  }
			  HRcolbg = Gfx.COLOR_YELLOW;
			  tz2 = tz2+1;
		}
		else if (hr >= z3bpm and hr < z4bpm){
			  HRzone = 3.0+((hr-z3bpm.toFloat())/(z4bpm.toFloat()-z3bpm));
			  if (HRzone > 3.9) {
			    HRzone = 3.9;
			  }
			  HRcolbg = Gfx.COLOR_DK_GREEN;
			  tz3 = tz3+1;
		}
		else if (hr >= z4bpm and hr < z5bpm){
			  HRzone = 4.0+((hr-z4bpm.toFloat())/(z5bpm.toFloat()-z4bpm));
			  if (HRzone > 4.9) {
			    HRzone = 4.9;
			  }
			  HRcolbg = Gfx.COLOR_ORANGE;
			  tz4 = tz4+1;
		}
		else if (hr >= z5bpm){
  			HRzone = 5.0+((hr-z5bpm.toFloat())/(maxHR.toFloat()-z5bpm));
			  HRcolbg = Gfx.COLOR_RED;
			  tz5 = tz5+1;
		}
		       
     	if (Kcal == null){
     		Kcal = 0;
     	} 
        if (alt == null){
        	alt = 0.0;
        	dispElev = 0;
     	} else {
     		dispElev = convertElevation(alt);
     	}
     	
     	if (trainingEffect == null){
     		trainingEffect = "0.0";
     	}else {
     		trainingEffect = trainingEffect.format("%1.1f");
     	}

        if (acc == null){
        	acc = 0;
     	}

     	if (asc == null){
     		asc = 0.0;
     		dispAsc = "0";
     	} else {
     		dispAsc = convertElevation(asc);
     	}

     	if (dsc == null){
     		dsc = 0;
     		dispDsc = "0";
     	}else {
     		dispDsc = convertElevation(dsc);
     	}

     	if (dist == null){
     		dist = 0;
     		dispDist = "0";
     	} else {
     		dispDist = convertDistance(dist);
     	}

    	if (speed == null or speed <= 0.0){
			speed = 0;
	    }  		
   		var tempSpeed = convertSpeed(speed);
   		dispSpeed = tempSpeed[0];
   		dispPace  = tempSpeed[1];		 

   		tempSpeed = convertSpeed(avgSpeed);
   		dispAvgSpeed = tempSpeed[0];
   		dispAvgPace  = tempSpeed[1];
     	   
     	batt = Sys.getSystemStats().battery;
     	//batt = 10;
     	if (batt == null){
     		batt = 42;
     	}
     	colBatt = Gfx.COLOR_GREEN;
     	if (batt < 70){
     		colBatt = Gfx.COLOR_BLUE;
     	}
     	if (batt < 50){
     		colBatt = Gfx.COLOR_ORANGE;
     	}
     	if (batt < 35){
     		colBatt = Gfx.COLOR_RED;
     	}
     	
		temp = 0;                     	
        if (sensorInfo != null){
        	temp = sensorInfo.temperature;
       	}
    	if (temp == null){
    		dispTemp = "..";
    	}
        else{
        	if(Sys.UNIT_METRIC == Sys.getDeviceSettings().temperatureUnits){
	     		dispTemp = temp.format("%i"); //[°C] 
     		}else{
	     		dispTemp = (temp*1.8+32).format("%i"); //[°F]
     		}
        }
        if (Cadence == null){
        	Cadence = 0;
        }
        if (averageHeartRate == null){
        	averageHeartRate = 0;
        }
        if (maxHeartRate == null){
        	maxHeartRate = 0;
        }
        //postMsg(Lang.format("Cadence: $1$",[Cadence]));
        if (avgCadence == null){
        	avgCadence = 0;
        }
                
		//if (sunrise == null && position != null && position.accuracy != Position.QUALITY_NOT_AVAILABLE) {
		if (sunrise == null && position != null && acc > 1) {
		    var sc = new SunCalc();
		    var loc = position.position.toRadians();
		    sunrise = momentToString(sc.calculate(new Time.Moment(Time.now().value()), loc[0], loc[1], SUNRISE));
		    sunset =  momentToString(sc.calculate(new Time.Moment(Time.now().value()), loc[0], loc[1], SUNSET));
		    postMsg(Lang.format("Sunset: $1$",[sunset]));
		}
        return true;     	     	
    }
        
    function update(){
    	getValues();
        if ( BacklightTimer > 0 ){
    		//attention.backlight( true );
    		BacklightTimer = BacklightTimer -1;
    	}
    	else if ( BacklightTimer <= 0 and BacklightTimer != -1){
    		attention.backlight( false );
    		BacklightTimer = -1;
    		//postMsg("turn off BackLight");
    	}
    	if (batt != null && batt < AutoBattOff && session != null && session.isRecording() ){
    		postMsg(Lang.format("Batt empty ($1$%) -> Exit",[batt]));
     		stopRecording();
     		//Sys.exit();
     		Ui.popView(Ui.SLIDE_UP);
     		Ui.popView(Ui.SLIDE_UP);	
     	}
    	Ui.requestUpdate();
    }

    function onPosition(info) {
    	position = info;
    }
    
    function onSensor(info) {
    	sensorInfo = info;
    	update();
    }
     
    function getInitialView() { 	
        return [new SMstartView(), new BaseInputDelegate() ];
    }
    
    function showView(){
    	getProfileData(); 
    	//getValues(); 
    	Ui.switchToView(new SMmainView() ,new BaseInputDelegate(), Ui.SLIDE_DOWN);
    }
    function showEndView(){
    	stopSensor();
    	stopGPS();
        Ui.switchToView(new SMendView() ,new EndViewDelegate(), Ui.SLIDE_DOWN);
    }
    
}
