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
	int count_resource () throws Error {
		var strv = resources_enumerate_children ("/data", GLib.ResourceLookupFlags.NONE);
		var count = 0;
		foreach (unowned var i in strv) {
			if (i.has_prefix ("img") && i.has_suffix (".png")) {
				++count;
			}
		}
		return count;
	}

	private void init_puzzle (int row, int col, string? img_path, int id) throws Error {
		init_screen_size ();
		Cairo.ImageSurface img_surface;
		{
			FileUtils.open_tmp ("my_tmpXXXXXX.png", out img_puzzle);
			if (id != 0) {
				var bytes = resources_lookup_data (@"/data/img$id.png", ResourceLookupFlags.NONE);
				FileUtils.set_data (img_puzzle, bytes.get_data ());
				img_surface = new Cairo.ImageSurface.from_png (img_puzzle);
			}
			else if (img_path != null) {
				img_surface = new Cairo.ImageSurface.from_png (img_path);
			}
			else {
				int count = count_resource ();
				var bytes = resources_lookup_data (@"/data/img$(Random.int_range (1, count + 1)).png", ResourceLookupFlags.NONE);
				FileUtils.set_data (img_puzzle, bytes.get_data ());
				img_surface = new Cairo.ImageSurface.from_png (img_puzzle);
			}
		}

		int width_img = img_surface.get_width();
		int height_img = img_surface.get_height();

		int width_tile = width_img / row;
		int height_tile = height_img / col;

		int W = (int)screen_width / row;
		int H = (int)screen_height / col;

		ratio_x = screen_width / width_img;
		ratio_y = screen_height / height_img;

		tab = {};
		var i = 0;
		var j = 0;
		var n = 0;
		while (j != col) {
			var ig = create_image_from_offset (img_surface, width_tile * i, height_tile * j, W, H);
			var tiles = new Tiles(ig, n);
			base.attach(tiles, i, j, 1, 1);
			tab += tiles;
			++i;
			++n;
			if (i == row) {
				i = 0;
				j++;
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

	private Image create_image_from_offset (Cairo.ImageSurface img_surface, int x, int y, int w, int h) {
		var surface = new Cairo.ImageSurface(img_surface.get_format (), w, h);

		Cairo.Context ctx = new Cairo.Context(surface);
		ctx.scale (ratio_x, ratio_y);
		ctx.set_source_surface (img_surface, -x, -y);
		ctx.paint();

		int size = surface.get_stride() * surface.get_height();
		var m =  new Gdk.MemoryTexture (w, h, Gdk.MemoryFormat.B8G8R8A8, new Bytes(surface.get_data ()[0:size]), surface.get_stride ());
		var image = new Image.from_paintable (m);
		return image;
	} 

} 

public void init_screen_size () {
	var display = Gdk.Display.get_default();
	var monitor = (Gdk.Monitor)display.get_monitors ().get_item (0);
	var rect = monitor.get_geometry ();
	screen_width = (double)rect.width;
	screen_height = (double)rect.height;
}
