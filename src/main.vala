using Gtk;

public int WIDTH_MONITOR;
public int HEIGHT_MONITOR;

private Gtk.ApplicationWindow win; // main window
public string? img_puzzle = null; // image path

public class SupraApplication : Gtk.Application {
	GnomeExtension gnome_extension;
	construct {
		try {
			gnome_extension = new GnomeExtension ();
		}
		catch (Error e) {
			gnome_extension = null;
		}
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


	private void close_puzzle () {
#if IS_BLOCKED
		gnome_extension?.enable();
#endif
		print(
"╭─────────────────────────────────────────────────────────╮\n" + 
"│ Si tu aimes mon Puzzle laisse une étoile sur Github !!! │\n" + 
"│ Link: \033[1;94mhttps://github.com/nda-cunh/suprapuzzle\033[;0m           │\n" +
"│ Merci !!!                                               │\n" +
"╰─────────────────────────────────────────────────────────╯\n"
);
		base.quit ();
	}
	public void init_after_realize () throws Error {
		// Create the Window fullscreen
		var overlay = new Gtk.Overlay();

		var my_puzzle = new Puzzle (id_gresource, img_path, nb_x, nb_y);
		unowned var display = Gdk.Display.get_default ();
		var monitor = display.get_monitor_at_surface (win.get_surface ());
		var geometry = monitor.get_geometry ();
		WIDTH_MONITOR = geometry.width;
		HEIGHT_MONITOR = geometry.height;
		my_puzzle.init_puzzle (geometry.width, geometry.height);

		var menu = new Menu ();

		menu.onFinish.connect (()=> {
			close_puzzle ();
			base.quit ();
		});

		overlay.add_overlay (my_puzzle);
		overlay.add_overlay (menu);
		var event_controller = new Gtk.EventControllerMotion ();

		event_controller.motion.connect ((x, y) => {
			inibhit_system_shortcuts ();
		});

		// event mousse key releass controller
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

		my_puzzle.onFinish.connect (() => {
			var conf = new Confetit ();
			overlay.add_overlay (conf);

			Timeout.add (6000, () => {
				close_puzzle ();
				return false;
			});
		});

		win.child = overlay;
	}
	/**
	** Init the overlay
	**/
	public void init_overlay () throws Error {

		win = new Gtk.ApplicationWindow (this) {
			default_width=1920,
			default_height=1080,
			fullscreened = true,
			decorated = false,
			handle_menubar_accel = false,
			mnemonics_visible = false,
			show_menubar = false,
			resizable = false,
		};

		((Widget)win).realize.connect (() => {
			try {
				init_after_realize ();
			}
			catch (Error e) {
				printerr (e.message);
				base.quit();
			}
		});


		init_css ();



#if IS_BLOCKED
		Widget win_widget = win as Widget;
		win_widget.realize.connect (() => {
			unowned var display = Gdk.Display.get_default () as Gdk.X11.Display;
			if (display == null) {
				return;
			}
			unowned var x11_d = display.get_xdisplay ();

			var native = ((Widget)win).get_native ();
			if (native == null) {
				return;
			}

			var surface = native.get_surface () as Gdk.X11.Surface;

			// wait for the window to be realized
			Timeout.add (1000, () => {
				// Set the focus on the window every 50ms
				var x11_w = surface.get_xid ();
				Timeout.add (100, () => {
					x11_d.set_input_focus (x11_w, X.RevertTo.PointerRoot, (int)X.CURRENT_TIME);
					x11_d.map_raised(x11_w);
					inibhit_system_shortcuts ();
					return true;
				});

				// type to splash
				var property = display.get_xatom_by_name ("_NET_WM_WINDOW_TYPE");
				var p_data = display.get_xatom_by_name ("_NET_WM_WINDOW_TYPE_SPLASH");
				var data = (uchar[])&p_data;
				// Set the window type to menu
				x11_d.change_property (x11_w, property, X.XA_ATOM, 32, X.PropMode.Replace, data, 1);
				return false;
			});
		});
#endif

		win.present ();
	}

	/**
	** Activate the application
	**/
	public override void activate () {
		try {
#if IS_BLOCKED
			gnome_extension?.disable();
#endif
			init_overlay ();
		} catch (Error e) {
			printerr (e.message);
		}
	}

	private static bool version;
	private static string? img_path;
	private static int id_gresource;
	private static int nb_x = 7;
	private static int nb_y = 4;

	private const GLib.OptionEntry[] options = {
		{ "version", 'v', OptionFlags.NONE, OptionArg.NONE, ref version, "Display version number", null },
		{ "img", '\0', OptionFlags.NONE, OptionArg.STRING, ref img_path, "path of the image", "path" },
		{ "id", '\0', OptionFlags.NONE, OptionArg.INT, ref id_gresource, "id of gresource image (random by default)", "id" },
		{ "id", '\0', OptionFlags.NONE, OptionArg.INT, ref id_gresource, "id of gresource image (random by default)", "id" },
		{ "x", 'x', OptionFlags.NONE, OptionArg.INT, ref nb_x, "number of tiles on x (default 7)", "nb-x" },
		{ "y", 'y', OptionFlags.NONE, OptionArg.INT, ref nb_y, "number of tiles on y (default 4)", "nb-y" },
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
#if IS_BLOCKED
	unowned var native = ((Widget)win).get_native ();
	if (native == null) {
		return;
	}
	unowned var surface = native.get_surface ();
	if (surface is Gdk.Toplevel) {
		surface.inhibit_system_shortcuts (null);
		surface.fullscreen_mode = Gdk.FullscreenMode.ALL_MONITORS;
	}
#endif
}
