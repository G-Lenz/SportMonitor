using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;


class settingsMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :Light) {
        	Ui.pushView(new SettingsView(:Light), new SettingsViewDelegate(:Light),Ui.SLIDE_DOWN);
        } else if (item == :Sound) {
        	//Ui.popView(Ui.SLIDE_UP);
            //Sys.println("back");
            Ui.pushView(new SettingsView(:Sound), new SettingsViewDelegate(:Sound),Ui.SLIDE_DOWN);
        }
        else if (item == :Vibration) {
        	//Ui.popView(Ui.SLIDE_UP);
            //Sys.println("back");
            Ui.pushView(new SettingsView(:Vibration), new SettingsViewDelegate(:Vibration),Ui.SLIDE_DOWN);
        }else if (item == :SaveSport) {
        	//Ui.popView(Ui.SLIDE_UP);
            //Sys.println("back");
            Ui.pushView(new SettingsView(:SaveSport), new SettingsViewDelegate(:SaveSport),Ui.SLIDE_DOWN);
        }
        return true;      
    }
}


class sportMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :walk) {
            //Sys.println("walk");
            //Sport.setSport(Name = "Walk";
            Sport.setSport(1);
            Ui.requestUpdate();
        } else if (item == :climb) {
            //Sys.println("climb");
            //Sport.setSport(Name = "Climb";
            Sport.setSport(3);
            Ui.requestUpdate();
        } else if (item == :hike) {
            //Sys.println("Hike");
            Sport.setSport(2);
            //Sport.setSport(Name = "Hike";
            Ui.requestUpdate();
        } else if (item == :run) {
            Sys.println("Run");
            Sport.setSport(5);
            //Sport.setSport(Name = "Run";
            Ui.requestUpdate();
        } else if (item == :trail) {
            //Sys.println("TrailRun");
            Sport.setSport(6);
            //Sport.setSport(Name = "TrailRun";
            Ui.requestUpdate();
        } else if (item == :mntn) {
            //Sys.println("Mountaineering");
            //Sport.setSport(Name = "Mountaineering";
            Sport.setSport(4);
            Ui.requestUpdate();
        } else if (item == :mtb) {
            //Sys.println("MTB");
            //Sport.setSport(Name = "Mountainbike";
            Sport.setSport(7);
            Ui.requestUpdate();
        } else if (item == :bike) {
            //Sys.println("Bike");
            //Sport.setSport(Name = "Cycling";
            Sport.setSport(8);
            Ui.requestUpdate();
        } else if (item == :ski) {
        	//Sys.println("Ski");
            //Sport.setSport(Name = "Skiing";
            Sport.setSport(9);
            Ui.requestUpdate();
        } else if (item == :skit) {
            //Sys.println("SkiTour");
            //Sport.setSport(Name = "Skitour";
            Sport.setSport(10);
            Ui.requestUpdate();
        } else if (item == :training) {
            //Sys.println("Training");
            //Sport.setSport(Name = "Training";
            Sport.setSport(21);
            Ui.requestUpdate();
        }
         else if (item == :indClimb) {
            //Sys.println("IndoorClimbing");
            //Sport.setSport(Name = "IndoorClimbing";
            Sport.setSport(22);
            Ui.requestUpdate();
        }
        return true;
        //1: walk, 2: Hike, 3: Climb, 4: Mountain, 5: Run, 6:Trailrun, 7: MTB, 8: Bike, 9: Skiing, 10: Skitouring, 21: Training, 22: IndoorClimbing
    }
 }  
 
class discardMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :discard) {
            //Sys.println("discard");
            //App.getApp().discardSession();
            App.getApp().discardRecording();
            //Ui.popView(Ui.SLIDE_UP);
            //Ui.popView(Ui.SLIDE_UP);
            //Ui.popView(Ui.SLIDE_UP);
        } else if (item == :back) {
        	Ui.popView(Ui.SLIDE_UP);
        	//Ui.popView(Ui.SLIDE_UP);
        	//App.getApp().showView();
            //Sys.println("back");
        }
        return true;
    }

}
   
class exitMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :back) {
            //App.getApp().showView();
            //Ui.popView(Ui.SLIDE_UP);
        } else if (item == :discard) {
            Ui.pushView(new Rez.Menus.DiscardMenu(), new discardMenuDelegate(), Ui.SLIDE_UP);
        } else if (item == :save) {
            App.getApp().stopRecording();
        }
        return true;
    }

}