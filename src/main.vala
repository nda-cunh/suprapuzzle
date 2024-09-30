using Gtk;

private unowned Gtk.ApplicationWindow window; // main window
public string? img_puzzle = null; // image path

public class SupraApplication : Gtk.Application {
	construct {
		application_id = "com.SupraPuzzle.App";
	}

	/**
	** Load the css style
	**/
	private void init_css () {
		var provider = new Gtk.CssProvider ();
		provider.load_from_resource ("/data/style.css");
		Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), provider, 0);
	}

	/**
	** Init the overlay
	**/
	public void init_overlay () throws Error {

		// Create the Window fullscreen
		var overlay = new Gtk.Overlay();

		var my_puzzle = new Puzzle (id_gresource, img_path);
		var menu = new Menu ();

		menu.onFinish.connect (()=> {
			base.quit ();
		});


		overlay.add_overlay (my_puzzle);
		overlay.add_overlay (menu);

		var win = new Gtk.ApplicationWindow (this) {
			default_width=1920,
			default_height=1080,
			fullscreened = true,
			decorated = false,
			handle_menubar_accel = false,
			mnemonics_visible = false,
			show_menubar = false,
			resizable = false,
		};

		window = win;

		init_css ();

		// event mousse key releass controller

		var event_controller = new Gtk.EventControllerMotion ();

		event_controller.motion.connect ((x, y) => {
			inibhit_system_shortcuts ();
		});

		var event_controller_key = new Gtk.EventControllerKey ();

		event_controller_key.key_pressed.connect ((keyval, keycode) => {
			// Escape touch
			if (keyval == Gdk.Key.Escape || keyval == Gdk.Key.Super_L) {
				menu.swap();
			}
			inibhit_system_shortcuts ();
			return true;
		});

		((Widget)win).add_controller (event_controller_key);
		((Widget)win).add_controller (event_controller);


		window.close_request.connect (() => {
			menu.open.begin();
			return false;
		});

		my_puzzle.onFinish.connect (() => {
			win.close ();
			win.dispose ();
		});

		// Gdk.X11.Surface.lookup_for_display (Gdk.Display.get_default (), win.get_native ().get_surface ());
		win.child = overlay;
		win.present ();
	}

	/**
	** Activate the application
	**/
	public override void activate () {
		try {
			init_overlay ();
		} catch (Error e) {
			printerr (e.message);
		}
	}

	private static bool version;
	private static string? img_path;
	private static int id_gresource;

	private const GLib.OptionEntry[] options = {
		{ "version", 'v', OptionFlags.NONE, OptionArg.NONE, ref version, "Display version number", null },
		{ "img", '\0', OptionFlags.NONE, OptionArg.STRING, ref img_path, "path of the image", "path" },
		{ "id", '\0', OptionFlags.NONE, OptionArg.INT, ref id_gresource, "id of gresource image (random by default)", "id" },
		{ null }
	};

	public static int main (string[] args) {
		try {
			var opt_context = new OptionContext ("- SupraPuzzle help");
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (options, null);
			opt_context.parse (ref args);

			if (version)
			{
				print ("SupraPuzzle\n");
				print ("Version %s\n", Config.VERSION);
				return 0;
			}
		}
		catch (Error e) {
			printerr (e.message);
			return 1;
		}

		var app = new SupraApplication ();
		return app.run (args);
	}
}

public void inibhit_system_shortcuts () {
	var native = ((Widget)window).get_native ();
	var surface = native.get_surface ();
	if (surface is Gdk.Toplevel) {
		surface.inhibit_system_shortcuts (null);
		surface.fullscreen_mode = Gdk.FullscreenMode.ALL_MONITORS;
	}
}
