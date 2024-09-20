using Gtk;

private unowned Gtk.ApplicationWindow window;
public string? img_puzzle = null;

public void inibhit_system_shortcuts () {
	// var native = ((Widget)window).get_native ();
	// var surface = native.get_surface ();
	// if (surface is Gdk.Toplevel) {
	// surface.inhibit_system_shortcuts (null);
	// surface.fullscreen_mode = Gdk.FullscreenMode.ALL_MONITORS;
	// }
}

public class SupraPuzzle : Gtk.Application {
	construct {
		application_id = "com.SupraPuzzle.App";
	}

	private void init_css () {
		var provider = new Gtk.CssProvider ();
		provider.load_from_resource ("/data/style.css");
		Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), provider, 0);
	}

	public override void activate () {
		// Create the Window fullscreen

		var overlay = new Gtk.Overlay();

		try {
			var my_puzzle = new Puzzle ();
			var menu = new Menu ();

			menu.onEnd.connect (()=> {
				base.quit ();
			});


			overlay.add_overlay (my_puzzle);
			overlay.add_overlay (menu);

			var win = new Gtk.ApplicationWindow (this) {
				default_width=1920,
				default_height=1080,
				fullscreened = true,
			};

			window = win;
			win.decorated = false;
			win.handle_menubar_accel = false;
			window.mnemonics_visible = false;
			win.show_menubar = false;
			win.resizable = false;
			win.decorated = false;

			init_css ();

			// event mousse key releass controller

			var event_controller = new Gtk.EventControllerMotion ();

			event_controller.motion.connect ((x, y) => {
				inibhit_system_shortcuts ();
			});

			var event_controller_key = new Gtk.EventControllerKey ();

			event_controller_key.key_pressed.connect (() => {
				inibhit_system_shortcuts ();
				return true;
			});

			((Widget)win).add_controller (event_controller_key);
			((Widget)win).add_controller (event_controller);



			window.notify["is_active"].connect (() => {
				printerr("maximized\n");
				window.fullscreen ();
			});

			window.close_request.connect (()=> {
				menu.open.begin();
				return true;
			});

			my_puzzle.onFinish.connect (()=> {
				win.close ();
				win.dispose ();
			});

			win.child = overlay;
			win.present ();
		}
		catch (Error e) {
			printerr("Error: %s\n", e.message);
		}
	}

}

public int main (string[] args) {
	var app = new SupraPuzzle ();
	return app.run (args);
}

