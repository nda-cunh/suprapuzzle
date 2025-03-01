using Gtk;
using Cairo;

string []count_resource () throws Error {
	var strv = resources_enumerate_children ("/data", GLib.ResourceLookupFlags.NONE);
	string []tabb_jpeg = {};
	foreach (unowned var i in strv) {
		if (i.has_suffix (".jpg")) {
			tabb_jpeg += i;
		}
	}
	return tabb_jpeg;
}

public class Puzzle : Gtk.DrawingArea {
	private int cols = 7;
	private int rows = 4;
	private Gdk.Pixbuf pixbuf; 
	private Tile[] tab_tiles;
	private Gtk.EventControllerMotion motion_controller = new Gtk.EventControllerMotion ();
	private Gtk.GestureClick click_gesture = new Gtk.GestureClick ();
	private unowned Tile? selected_tile = null;
	private double grab_x = 0;
	private double grab_y = 0;
	private bool have_border = true;
	private double grab_padding_x = 0.0;
	private double grab_padding_y = 0.0;

	public Puzzle (int id, string? img_path, int nb_x, int nb_y) throws Error {
		cols = nb_x;
		rows = nb_y;

		set_draw_func (draw_func);

		{
			if (id != 0) {
				var img_randomize = count_resource ();
				if (id > img_randomize.length || id < 0)
					throw new FileError.ACCES(@"id: ($id) not found");
				pixbuf = new Gdk.Pixbuf.from_resource (@"/data/" + img_randomize[id - 1]);
				change_size_tile (img_randomize[id - 1]);
			}
			else if (img_path != null) {
				pixbuf = new Gdk.Pixbuf.from_file (img_path);
				change_size_tile (img_path);
			}
			else {
				var img_randomize = count_resource ();
				var nb_random = Random.int_range (0, img_randomize.length);
				pixbuf = new Gdk.Pixbuf.from_resource ("/data/" + img_randomize[nb_random]);
				change_size_tile (img_randomize[nb_random]);
			}
		}

		add_controller (motion_controller);
		add_controller (click_gesture);
		motion_controller.motion.connect (onMove);
		click_gesture.pressed.connect (pressed);
		click_gesture.released.connect (released);

		this.onFinish.connect (() => {
			have_border = false;
			queue_draw ();
		});
	}

	private void change_size_tile (string path) {
		int index = path.index_of_char (':');
		if (index != -1) {
			unowned string ptr = path.offset(index);
			print ("path: %s\n", ptr);
			ptr.scanf (":%d_%d", out cols, out rows);
			print (@"cols: $cols, rows: $rows\n");
			if (cols < 1 || rows < 1) {
				cols = 7;
				rows = 4;
			}
		}
	}


	private void pressed (int button, double x, double y) {
		foreach (unowned var tile in tab_tiles) {
			if (tile.collisio_with_point (x, y)) {
				selected_tile = tile;
				tile.visible = false;
				grab_padding_x = x - selected_tile.x;
				grab_padding_y = y - selected_tile.y;
				grab_x = selected_tile.x;
				grab_y = selected_tile.y;
				queue_draw ();
			}
		}
	}
	
	private void onMove (double x, double y) {
		if (selected_tile != null) {
			grab_x = x - grab_padding_x;
			grab_y = y - grab_padding_y;
		}
		else {
			foreach (unowned var tile in tab_tiles) {
				tile.hover = tile.collisio_with_point (x, y);
			}
		}
		queue_draw ();
	}

	private void released (int button, double x, double y) {
		if (selected_tile != null) {
			selected_tile.visible = true;
			foreach (unowned var tile in tab_tiles) {
				if (tile.collisio_with_point (x, y)) {
					tile.swap(selected_tile);
				}
			}
			queue_draw ();
			selected_tile = null;
			foreach (unowned var tile in tab_tiles) {
				if (!tile.is_sort ()) {
					return;
				}
			}
			onFinish();
		}
	}

	public signal void onFinish ();


	public void init_puzzle (int width, int height) {
		// Obtenir les dimensions de chaque sous-image
		int padding_center_x = 0;
		int padding_center_y = 0;
		int piece_width = width / cols;
		int piece_height = height / rows;

		int piece_size = int.min(piece_width, piece_height);

		// calculer le padding pour centrer les pieces
		if (piece_width < piece_height) {
			padding_center_y = ((piece_height * rows) - (piece_size * rows)) / 2;
		}
		if (piece_height < piece_width) {
			padding_center_x = ((piece_width * cols) - (piece_size * cols)) / 2;
		}

		// Redimensionner l'image pour qu'elle s'adapte à la taille de la fenêtre
		Gdk.Pixbuf scaled_pixbuf = pixbuf.scale_simple (piece_size * cols, piece_size * rows, Gdk.InterpType.BILINEAR);

		tab_tiles = new Tile[cols * rows];
		
		for (int i = 0; i < tab_tiles.length; ++i)
		{
			tab_tiles[i] = new Tile (piece_size);
		}

		// Dessiner chaque sous-image
		for (int row = 0; row < rows; ++row) {
			for (int col = 0; col < cols; ++col) {
				int tile = row * cols + col;
				// Dessiner chaque sous-image
				int x = col * piece_size;
				int y = row * piece_size;
				tab_tiles[tile].paint (scaled_pixbuf, x, y);
				// Positionner chaque sous-image
				{
					int p_x = padding_center_x + x;
					int p_y = padding_center_y + y;
					tab_tiles[tile].init_point (p_x, p_y);
				}
			}
		}
		shuffle();
	}

	private void shuffle () {
		var tab_len = tab_tiles.length;
		for (int i = 0; i < 4200; ++i)
		{
			int r1 = Random.int_range (0, tab_len);
			int r2 = Random.int_range (0, tab_len);
			tab_tiles[r1].swap(tab_tiles[r2]);
		}
	}

	private void draw_func (DrawingArea drawing_area, Context cr, int width, int height) {
		foreach (unowned var tile in tab_tiles) {
			tile.draw (cr, have_border);
		}

		if (selected_tile != null) {
			cr.set_source_surface (selected_tile.surface, grab_x, grab_y);
			cr.paint ();
		}
	}
}


