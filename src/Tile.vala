using Gtk;
using Cairo;

public class Tile : Object {
	public Cairo.Surface surface {get;private set;}
	private int size; 
	public bool visible = true;
	public bool hover = false;

	public Tile (int size) {
		this.size = size;
	}

	public bool collisio_with_point (double x, double y) {
		return x >= this.x && x <= this.x + size && y >= this.y && y <= this.y + size;
	}

	public void swap (Tile other) {
		int tmp = this.x;
		this.x = other.x;
		other.x = tmp;
		tmp = this.y;
		this.y = other.y;
		other.y = tmp;
	}

	public void paint (Gdk.Pixbuf pixbuf, int x, int y) {
		surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, size, size);
		var ctx = new Cairo.Context(this.surface); 

		var tmp_pixbuf = new Gdk.Pixbuf (pixbuf.colorspace, false, pixbuf.bits_per_sample, size, size);
		pixbuf.copy_area (x, y, size, size, tmp_pixbuf, 0, 0);
		// charge toute l'image en ENTIERE
		Gdk.cairo_set_source_pixbuf (ctx, tmp_pixbuf, 0, 0);
		ctx.paint();
	}

	public void draw (Context cr, bool border = false) {
		if (!visible) {
			return;
		}
		const double margin = 2;
		cr.set_source_surface (this.surface, x, y);
		cr.paint ();
		if (border == false)
			return;
		if (hover) {
			cr.set_source_rgba (0, 0, 0, 0.2);
			cr.rectangle (x, y, size, size);
			cr.fill ();
		}
		cr.rectangle (x, y, size, size);
		cr.set_source_rgb (0, 0, 0);
		cr.set_line_width (margin);
		cr.stroke ();
	}
	
	public bool is_sort () {
		return x == default_x && y == default_y;
	}

	private int default_x = 0;
	private int default_y = 0;

	public void init_point (int x, int y) {
		default_x = x;
		default_y = y;
		this.x = x;
		this.y = y;
	}

	public int x;
	public int y;
} 
