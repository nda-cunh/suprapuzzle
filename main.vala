using Gtk;

private const string css = """
box{ background-color:black; }
box:hover { opacity:0.9; background-color:black; }
""";

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
		var win = new Gtk.ApplicationWindow (this) {
			fullscreened=true,
			default_width=1920,
			default_height=1080,
		};

		init_css ();

		// win.close_request.connect (()=> {
			// return true;
		// });
		// win.fullscreen();

		win.child = new Puzzle();
		win.present ();
	}

}

public int main (string[] args) {
	var app = new SupraPuzzle ();
	return app.run (args);
}

