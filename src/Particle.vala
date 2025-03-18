using Gtk;
using Cairo;

public struct Particle {
	double x;
	double y;
	double radius;
	double r;
	double g;
	double b;
	double velocity_y;
    double gravity;

	public Particle() {
		var rand = new Rand();

        for (int i = 0; i < 100; ++i) {
            x = rand.double_range(0, WIDTH_MONITOR);
            y = rand.double_range(-800, 0);
            radius = rand.double_range(2, 9);
            r = rand.next_double();
            g = rand.next_double();
            b = rand.next_double();
			velocity_y = rand.double_range(1, 5);
			gravity = 0.4;
        }
	}

	public void draw (Cairo.Context ctx) {
		ctx.set_source_rgb(r, g, b);
		ctx.arc(x, y, radius, 0, 2 * Math.PI);
		ctx.fill();

		velocity_y += gravity;
		y += velocity_y;

		if (y > HEIGHT_MONITOR - radius) {
			velocity_y *= -0.62;
			y = HEIGHT_MONITOR - radius;
		}
	}
}

public class Confetit : Gtk.DrawingArea {
	Particle[] tab = new Particle[1000];

	public Confetit () {
		set_draw_func (draw_func);
		for (int i = 0; i < tab.length; ++i) {
			tab[i] = Particle();
		}
		Timeout.add (1, () => {
			queue_draw();
			return true;
		});
	}

	public void draw_func (DrawingArea drawing_area, Cairo.Context ctx, int width, int height) {
		var tab_len = tab.length;
		for (int i = 0; i < tab_len; ++i) {
			tab[i].draw(ctx);
		}
	}
}
