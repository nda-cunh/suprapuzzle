using Gtk;

/***********************************************
** Menu class is a custom widget with the timer
************************************************/
public class Menu : Gtk.Box {

	private Revealer revealer;
	private TimerClock timer;
	private Button button;
	private Box box_menu;
	private Password password;
	private bool is_animating = false;

	construct {
		orientation = Gtk.Orientation.HORIZONTAL;
		password = new Password ();
		password.onGoodPassword.connect (this.finish);
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
		button = new Button () {
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
		var label_title = new Label ("SupraPuzzle") {
			css_classes = {"h1"}
		};

		// Box menu right
		box_menu = new Box (Orientation.VERTICAL, 10){
			name = "menu_right",
		};
		// add title and timer
		box_menu.append(label_title);
		box_menu.append(timer.label);
		box_menu.append(password);

		// Animation of box_menu
		revealer = new Revealer () {
			reveal_child = true,
			transition_duration = 300,
			transition_type = RevealerTransitionType.SLIDE_LEFT,
			child = box_menu
		};

		// When timer is finished call finish function
		timer.onEnd.connect (finish);
	}

	public void swap(){
		if (is_animating)
			return;
		if (revealer.reveal_child) {
			close.begin();
		} else {
			open.begin();
		}
	}


	/* Close the menu (wait animation) */
	public async void close () {
		is_animating = true;
		timer.start();
		revealer.reveal_child = false;
		Timeout.add(revealer.transition_duration, close.callback);
		yield;
		base.set_visible (false);
		is_animating = false;
	}

	/* Open the menu (wait animation) */
	public async void open () {
		is_animating = true;
		base.set_visible (true);
		revealer.reveal_child = true;
		Timeout.add(revealer.transition_duration, open.callback);
		yield;
		is_animating = false;
	}


	private void finish () {
		this.onFinish();
	}

	/** Signal emitted when the menu is closed */
	public signal void onFinish();
}


class  Password : Box {
	private Label label;
	private Entry entry;

	construct {
		orientation = Gtk.Orientation.VERTICAL;
		spacing = 10;
		valign = Gtk.Align.END;
		vexpand = true;
	}

	public async void test_password (string password) {
		init_sodium();
		var t = new Thread<int> ("sodium-verify", ()=> {
			int val = 0;
			val = Sodium.Crypto.PwHash.str_verify (Config.PASSWORD, password, entry.text.length);
			Idle.add (test_password.callback);
			return val;
		});
		yield;
		int val = t.join ();
		if (val == 0) {
			this.onGoodPassword();
		}
	}

	private bool is_init_sodium = false;
	private void init_sodium () {
		if (is_init_sodium == false) {
			if (Sodium.init () < 0) {
				warning ("Failed to initialize libsodium");
			}
			is_init_sodium = true;
		}
	}

	private uint id_timeout = 0;
	public Password () {
		label = new Label ("Password") {
			css_classes = {"h3"}
		};
		entry = new Entry () {
			visibility = false,
			activates_default = true,
			max_length = Config.PASSWORD.length,
			width_chars = 32,
			input_purpose = InputPurpose.NUMBER
		};
		entry.changed.connect (()=> {
			if (id_timeout != 0)
				Source.remove (id_timeout);
			id_timeout = Timeout.add (300, ()=> {
				id_timeout = 0;
				test_password.begin (entry.text.dup());
				return false;
			});
		});

		append(label);
		append(entry);
	}

	public signal void onGoodPassword();
}
