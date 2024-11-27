using Gtk;

public double screen_width;
public double screen_height;

public class Puzzle : Gtk.Grid{

	private Tiles []tab;

	public Puzzle (int id, string? img_path) throws Error {
		init_puzzle (7, 4, img_path, id);
	}

	double ratio_x;
	double ratio_y;


	// count resource in /data
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

	private void init_puzzle (int row, int col, string? img_path, int id) throws Error {
		init_screen_size ();
		// Cairo.ImageSurface img_surface;
		Gdk.Pixbuf pixbuf;
		{
			if (id != 0)
				pixbuf = new Gdk.Pixbuf.from_resource (@"/data/img$id.jpg");
			else if (img_path != null)
				pixbuf = new Gdk.Pixbuf.from_file (img_path); 
			else {
				var img_randomize = count_resource ();
				var nb_random = Random.int_range (0, img_randomize.length);
				pixbuf = new Gdk.Pixbuf.from_resource ("/data/" + img_randomize[nb_random]);
			}
		}


		int width	= pixbuf.get_width ();
		int height	= pixbuf.get_height ();

		int width_tile = width / row;
		int height_tile = height / col;

		int W = (int)screen_width / row;
		int H = (int)screen_height / col;

		ratio_x = screen_width / width;
		ratio_y = screen_height / height;

		tab = {};
		var i = 0;
		var j = 0;
		var n = 0;
		while (j != col) {
			var ig = create_image_from_offset (pixbuf, width_tile * i, height_tile * j, W, H);
			var tiles = new Tiles(ig, n);
			base.attach(tiles, i, j, 1, 1);
			tab += tiles;
			++i;
			++n;
			if (i == row) {
				i = 0;
				++j;
			}
		}
		foreach (var e in tab) {
			e.onMove.connect(test);
		}

		shuffle.begin ();

	}

	// test if the puzzle is finish (all tiles )
	public void test () {
		int tmp_max = 0;
		foreach (var t in tab) {
			if (tmp_max == t.id) {
				++tmp_max;
			}
			else
				return ;
		}
		onFinish ();
	}

	public signal void onFinish ();

	private async void shuffle () {
		for (int i = 0; i < 150; ++i)
		{
			int r1 = Random.int_range (0, tab.length);
			int r2 = Random.int_range (0, tab.length);
			tab[r1].swap(tab[r2]);
			Timeout.add(8, shuffle.callback);
			yield;
		}
	}

	private Image create_image_from_offset (Gdk.Pixbuf pixbuf, int x, int y, int w, int h) {
		var surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, w, h);

		Cairo.Context ctx = new Cairo.Context(surface);
		ctx.scale (ratio_x, ratio_y);
		Gdk.cairo_set_source_pixbuf (ctx, pixbuf, -x, -y);
		ctx.paint();

		int size = surface.get_stride() * surface.get_height();

		var texture =  new Gdk.MemoryTexture (w, h, Gdk.MemoryFormat.B8G8R8A8, new Bytes(surface.get_data ()[0:size]), surface.get_stride ());
		return (new Image.from_paintable (texture));
	} 

} 

public void init_screen_size () {
	var display = Gdk.Display.get_default();
	var monitor = (Gdk.Monitor)display.get_monitors ().get_item (0);
	var rect = monitor.get_geometry ();
	screen_width = (double)rect.width;
	screen_height = (double)rect.height;
}
