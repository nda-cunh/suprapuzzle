using Gtk;

public class Puzzle : Gtk.Grid{


	public Puzzle () {
		init_puzzle (7, 4);
	}

	private void init_puzzle (int row, int col) {
		var img = "/nfs/homes/nda-cunh/Pictures/Wallpapers/yourname.png";
		var img_surface = new Cairo.ImageSurface.from_png (img);

		int height = img_surface.get_height();
		int width = img_surface.get_width();

		int size_w = width / row;
		int size_h = height / col;

		var i = 0;
		var j = 0;
		var n = 0;
		while (j != col) {
			var ig = create_image_from_offset (img_surface, size_w * i, size_h * j, size_w, (size_h));
			base.attach(new Tiles(ig, n), i, j, 1, 1);
			++i;
			if (i == row) {
				i = 0;
				j++;
			}
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
