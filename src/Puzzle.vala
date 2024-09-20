using Gtk;

public class Puzzle : Gtk.Grid{

	private Tiles []tab;

	public Puzzle () throws Error {
		init_puzzle (7, 4);
	}

	private void init_puzzle (int row, int col) throws Error {
	
		{
			var bytes = resources_lookup_data (@"/data/img$(Random.int_range (1, 8)).png", ResourceLookupFlags.NONE);
			FileUtils.open_tmp ("my_tmpXXXXXX.png", out img_puzzle);
			print(img_puzzle);
			FileUtils.set_data (img_puzzle, bytes.get_data ());
		}
		var img_surface = new Cairo.ImageSurface.from_png (img_puzzle);

		int height = img_surface.get_height();
		int width = img_surface.get_width();

		int size_w = width / row;
		int size_h = height / col;



		tab = {};
		var i = 0;
		var j = 0;
		var n = 0;
		while (j != col) {
			var ig = create_image_from_offset (img_surface, size_w * i, size_h * j, size_w, (size_h));
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
		for (int i = 0; i < 100; ++i)
		{
			int r1 = Random.int_range (0, tab.length);
			int r2 = Random.int_range (0, tab.length);
			tab[r1].swap(tab[r2]);
		}
	}

	private Image create_image_from_offset (Cairo.ImageSurface img_surface, int x, int y, int w, int h) {
		var surface = new Cairo.ImageSurface(img_surface.get_format (), w, h);

		Cairo.Context ctx = new Cairo.Context(surface);
		ctx.set_source_surface (img_surface, -x, -y);
		ctx.paint();

		int size = surface.get_stride() * surface.get_height();
		var m =  new Gdk.MemoryTexture (w, h, Gdk.MemoryFormat.B8G8R8A8, new Bytes(surface.get_data ()[0:size]), surface.get_stride ());
		var image = new Image.from_paintable (m);
		return image;
	} 

} 
