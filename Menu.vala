using Gtk;

public class Menu : Gtk.Box {

	private Gtk.Revealer revealer;
	private Gtk.Box box_menu;
	private Gtk.Button button;

	construct {
		orientation = Gtk.Orientation.VERTICAL;
		timer = new TimerClock();
		name = "menu";
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
		revealer = new Gtk.Revealer ();
		box_menu = new Gtk.Box (Gtk.Orientation.VERTICAL, 10){
			name = "menu_right",
		};
		box_menu.append(new Gtk.Label ("SupraPuzzle") {
			css_classes = {"h1"}
		});
		box_menu.append(timer.label);
		var button_start = new Gtk.Button.with_label ("Start");
		button_start.clicked.connect (()=> {
			button_start.set_visible (false);
			this.close.begin();
		});
		box_menu.append(button_start);
		timer.onEnd.connect (end);
		revealer.reveal_child = true;
		revealer.transition_duration = 300;
		revealer.transition_type = RevealerTransitionType.SLIDE_LEFT;
		revealer.set_child (box_menu);
	}

	public Menu () {
		Object (orientation: Gtk.Orientation.HORIZONTAL);
		init_menu_right ();
		init_button_left ();
		base.append(button);
		base.append(revealer);
	}


	public async void close () {
		timer.start();
		revealer.reveal_child = false;
		Timeout.add(revealer.transition_duration, close.callback);
		yield;
		base.hide();
	}

	public async void open () {
		base.set_visible (true);
		revealer.reveal_child = true;
		Timeout.add(revealer.transition_duration, open.callback);
		yield;
	}


	private void end () {
		this.onEnd();
	}

	public signal void onEnd();
	private TimerClock timer;
}

