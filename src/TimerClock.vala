/**
 *
 * TimerClock component
 * 
 * a simple widget that shows a timer clock begining by 30 minutes
 */
public class TimerClock : Object {

	// 30 minutes (1800 seconds)
	const double time_max = 1800;

	public TimerClock () {
		label = new Gtk.Label ("30:00") {
			css_classes = {"h1"}
		};
		timer = new GLib.Timer ();
		timer.stop();
	}

	/** 
	 * Update the label every second
	 */
	public async void update () {
		while (true) {
			double seconds_total;
			seconds_total = timer.elapsed ();
			if (seconds_total >= time_max) {
				onEnd();
				break;
			}

			int seconds = (int) (time_max - seconds_total) % 60;
			int minutes = (int) (time_max - seconds_total) / 60;

			label.label = "%d:%d".printf (minutes, seconds);
			Timeout.add(800, update.callback, Priority.LOW);
			yield;
		}
	}


	/**
	 * Start the timer
	 */
	public void start () {
		if (is_starting)
			return;
		is_starting = true;
		timer.start ();
		update.begin ();
	}
	
	/**
	 * Signal
	 */
	public signal void onEnd (); 

	public Gtk.Label label;
	private GLib.Timer timer;
	private bool is_starting = false;
}

