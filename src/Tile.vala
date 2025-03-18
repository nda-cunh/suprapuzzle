using Gtk;
using Cairo;

[Compact]
public class Tile {
	public Gdk.Pixbuf pixbuf; 
	public int size; 
	public bool visible = true;
	public bool hover = false;
	public int default_x = 0;
	public int default_y = 0;
	public int x;
	public int y;

	public Tile (int size) {
		this.size = size;
	}

	public inline bool collisio_with_point (double x, double y) {
		return x >= this.x && x <= this.x + size && y >= this.y && y <= this.y + size;
	}

	public inline void swap (Tile other) {
		int tmp = this.x;

		this.x = other.x;
		other.x = tmp;
		tmp = this.y;
		this.y = other.y;
		other.y = tmp;
	}

	public void paint (Gdk.Pixbuf image, int x, int y) {
		pixbuf = new Gdk.Pixbuf (image.colorspace, false, image.bits_per_sample, size, size);
		image.copy_area (x, y, size, size, pixbuf, 0, 0);
	}

	public void draw (Context cr, bool border = false) {
		if (!visible) {
			return;
		}
		const double margin = 2;
		Gdk.cairo_set_source_pixbuf (cr, pixbuf, x, y);
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
	
	public inline bool is_sort () {
		return x == default_x && y == default_y;
	}

	public void init_point (int x, int y) {
		default_x = x;
		default_y = y;
		this.x = x;
		this.y = y;
	}
} 
