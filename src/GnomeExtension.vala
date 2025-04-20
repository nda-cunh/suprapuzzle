public errordomain GnomeError {
	NOT_FOUND = 1,
}

public class GnomeExtension : Object {
	SettingsSchema gnome_shell;
	Settings schemas_gnome;
	SettingsSchema wm_keybindings;
	Settings schemas_wm_keybindings;
	SettingsSchema mutter;
	Settings schemas_mutter;
	SettingsSchema desktop_interface;
	Settings schemas_desktop_interface;


	public GnomeExtension () throws Error {
		unowned var ?settings = SettingsSchemaSource.get_default();

		gnome_shell = settings?.lookup("org.gnome.shell", true);
		wm_keybindings = settings?.lookup("org.gnome.desktop.wm.keybindings", true);
		mutter = settings?.lookup("org.gnome.mutter", true);
		desktop_interface = settings?.lookup("org.gnome.desktop.interface", true);

		if (gnome_shell == null || wm_keybindings == null || mutter == null || desktop_interface == null) {
			throw new GnomeError.NOT_FOUND ("Schema not found");
		}

		schemas_gnome = new Settings.full (gnome_shell, null, null);
		schemas_mutter = new Settings.full (mutter, null, null);
		schemas_desktop_interface = new Settings.full (desktop_interface, null, null);
		schemas_wm_keybindings = new Settings.full (wm_keybindings, null, null);
	}

	List<SupraArray> all_wm_keybindings = new List<SupraArray> ();
	string mutter_overlay_key;
	bool hot_corner_key;

	public void disable () {
		// WmKeybindings
		foreach (unowned var i in wm_keybindings.list_keys ()) {
			all_wm_keybindings.append (new SupraArray(schemas_wm_keybindings.get_strv(i)));
			schemas_wm_keybindings.set_strv(i, null);
		}
		schemas_wm_keybindings.apply();

		// Mutter
		mutter_overlay_key = schemas_mutter.get_string("overlay-key");
		schemas_mutter.set_string("overlay-key", "");
		schemas_mutter.apply();

		// DesktopInterface
		hot_corner_key = schemas_desktop_interface.get_boolean("enable-hot-corners");
		schemas_desktop_interface.set_boolean("enable-hot-corners", hot_corner_key);
		schemas_desktop_interface.apply();

		// GnomeShell
		schemas_gnome.set_boolean("disable-user-extensions", true);
		schemas_gnome.apply();

		Settings.sync ();
	}

	public void enable () {
		// WmKeybindings
		int index = 0;
		foreach (unowned var i in wm_keybindings.list_keys ()) {
			schemas_wm_keybindings.set_strv(i, all_wm_keybindings.nth_data(index).array);
			++index;
		}
		schemas_wm_keybindings.apply();

		// Mutter
		schemas_mutter.set_string("overlay-key", mutter_overlay_key);
		schemas_mutter.apply();

		// DesktopInterface
		schemas_desktop_interface.set_boolean("enable-hot-corners", hot_corner_key);
		schemas_desktop_interface.apply();

		// GnomeShell
		schemas_gnome.set_boolean("disable-user-extensions", false);
		schemas_gnome.apply();

		Settings.sync ();
	}
}

class SupraArray {
	public string [] array;
	public SupraArray (owned string [] array) {
		this.array = array;
	}
}
