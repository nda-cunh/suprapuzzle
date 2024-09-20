using Gtk;

/***********************************************
** Menu class is a custom widget with the timer
************************************************/
public class Menu : Gtk.Box {

	private Revealer revealer;
	private TimerClock timer;
	private Button button;
	private Box box_menu;

	construct {
		orientation = Gtk.Orientation.HORIZONTAL;
		timer = new TimerClock();
		name = "menu";
	}

	public Menu () {
		init_menu_right ();
		init_button_left ();

		base.append(button);
		base.append(revealer);
	}

	private void init_button_left() {
		button = new Gtk.Button () {
			css_classes = {"none"},
			has_frame = false,
			opacity = 0,
			hexpand = true,
			vexpand = true
		};
		button.clicked.connect (this.close);
	}

	private void init_menu_right () {
		// SupraPuzzle title
		var label_title = new Gtk.Label ("SupraPuzzle") {
			css_classes = {"h1"}
		};

		// Box menu right
		box_menu = new Gtk.Box (Gtk.Orientation.VERTICAL, 10){
			name = "menu_right",
		};
		// add title and timer
		box_menu.append(label_title);
		box_menu.append(timer.label);

		// Animation of box_menu
		revealer = new Gtk.Revealer () {
			reveal_child = true,
			transition_duration = 300,
			transition_type = RevealerTransitionType.SLIDE_LEFT,
			child = box_menu
		};

		// When timer is finished call finish function
		timer.onEnd.connect (finish);
	}


	/* Close the menu (wait animation) */
	public async void close () {
		timer.start();
		revealer.reveal_child = false;
		Timeout.add(revealer.transition_duration, close.callback);
		yield;
		base.set_visible (false);
	}

	/* Open the menu (wait animation) */
	public async void open () {
		base.set_visible (true);
		revealer.reveal_child = true;
		Timeout.add(revealer.transition_duration, open.callback);
		yield;
	}


	private void finish () {
		this.onFinish();
	}

	/** Signal emitted when the menu is closed */
	public signal void onFinish();
}

