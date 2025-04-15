public errordomain GnomeError {
	NOT_FOUND = 1,
}

public class GnomeExtension : Object {
	SettingsSchema s;
	Settings schemas;


	public GnomeExtension () throws Error {
		s = SettingsSchemaSource.get_default()?.lookup("org.gnome.shell", true);
		if (s == null || s.has_key("disable-user-extensions") == false) {
			print ("Schema not found\n");
			throw new GnomeError.NOT_FOUND ("Schema not found");
		}
		schemas = new Settings.full (s, null, null);
	}

	public void disable () {
		schemas.set_boolean("disable-user-extensions", true);
		schemas.apply();
		Settings.sync ();
	}

	public void enable () {
		schemas.set_boolean("disable-user-extensions", false);
		schemas.apply();
		Settings.sync ();
	}
}
