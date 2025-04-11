public class GnomeExtension {
	SettingsSchema s;
	Settings schemas;

	public GnomeExtension () {
		s = SettingsSchemaSource.get_default().lookup("org.gnome.shell", true);
		if (s == null || s.has_key("disable-user-extensions") == false) {
			print ("Schema not found\n");
			return;
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

