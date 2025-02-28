using Gtk;
using Cairo;

public class Tile {
	public Cairo.Surface surface {get;private set;}
	public int size {get;private set;}
	public bool visible = true;
	public bool hover = false;

	public Tile (int size) {
		this.size = size;
		surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, size, size);
	}

	public bool collisio_with_point (double x, double y) {
		return x >= this.x && x <= this.x + size && y >= this.y && y <= this.y + size;
	}

	public void swap (Tile other) {
		int tmp_x = this.x;
		int tmp_y = this.y;
		this.x = other.x;
		this.y = other.y;
		other.x = tmp_x;
		other.y = tmp_y;
	}

	public void paint (Gdk.Pixbuf pixbuf, int x, int y) {
		var ctx = new Cairo.Context(this.surface); 

		Gdk.cairo_set_source_pixbuf (ctx, pixbuf, -x, -y);
		ctx.rectangle (0, 0, size, size);
		ctx.fill();
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
			cr.rectangle (x, y, size, size);
			cr.set_source_rgba (0, 0, 0, 0.2);
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
