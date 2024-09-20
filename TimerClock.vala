
public class TimerClock {
	double time_max = 1800; //30 minutes (1800 seconds)
	public TimerClock () {
		label = new Gtk.Label ("30:00") {
			css_classes = {"h1"}
		};
		timer = new GLib.Timer ();
		timer.stop();
	}

	public async void update () {
		while (true) {
			// time begin by 30:00 and decrease
			double seconds_total;
			seconds_total = timer.elapsed ();
			if (seconds_total >= time_max)
				onEnd();

			int seconds = (int) (time_max - seconds_total) % 60;
			int minutes = (int) (time_max - seconds_total) / 60;

			label.label = "%d:%d".printf (minutes, seconds);
			Idle.add (update.callback);
			yield;
		}
	}

	public signal void onEnd (); 

	public void start () {
		if (is_starting)
			return;
		timer.start ();
		update.begin ();
	}

	public bool is_starting = false;
	public Gtk.Label label;
	private GLib.Timer timer;
}

