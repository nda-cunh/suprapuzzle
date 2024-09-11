using Gtk;

private const string css = """
box{ background-color:black; }
box:hover { opacity:0.9; background-color:black; }
""";

public unowned Gtk.ApplicationWindow window; 

public class SupraPuzzle : Gtk.Application {
	construct {
		application_id = "com.SupraPuzzle.App";
	}

	private void init_css () {
		var provider = new Gtk.CssProvider ();
		provider.load_from_data (css.data);
		Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), provider, 0);
	}

	public override void activate () {
		// Create the Window fullscreen 

		var my_puzzle = new Puzzle ();

		var win = new Gtk.ApplicationWindow (this) {
			fullscreened=true,
			default_width=1920,
			default_height=1080,
		};
		window = win;


		init_css ();

		// event mousse key releass controller

		var event_controller = new Gtk.EventControllerMotion ();

		event_controller.motion.connect ((x, y) => {
			print("motion \n");
			var native = ((Widget)window).get_native ();
			var surface = native.get_surface ();
			var toplevel = surface as Gdk.Toplevel; 
			toplevel.inhibit_system_shortcuts (null);
		});

		var event_controller_key = new Gtk.EventControllerKey ();

		event_controller_key.key_pressed.connect (() => {
			print("key pressed\n");
			var native = ((Widget)window).get_native ();
			var surface = native.get_surface ();
			var toplevel = surface as Gdk.Toplevel; 
			toplevel.inhibit_system_shortcuts (null);
			return true;
		});

		((Widget)win).add_controller (event_controller_key);
		((Widget)win).add_controller (event_controller);

		Idle.add (()=> {
			message("Idle inhibit");
			var native = ((Widget)win).get_native ();
			var surface = native.get_surface ();
			var toplevel = surface as Gdk.Toplevel; 
			toplevel.inhibit_system_shortcuts (null);
			return false;
		});


		Timeout.add (500, ()=> {
			window.maximize ();
			window.fullscreen ();
			return true;
		});
		window.close_request.connect (()=> {
			return true;
		});

		my_puzzle.onFinish.connect (()=> {
			win.close ();
			win.dispose ();
		});

		win.child = my_puzzle;
		win.present ();
	}

}

public int main (string[] args) {
	var app = new SupraPuzzle ();
	return app.run (args);
}

