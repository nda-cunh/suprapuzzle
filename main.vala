using Gtk;



public class Tiles : Gtk.Frame {
	public Tiles (Gtk.Image image) {
		drag_source = new Gtk.DragSource ();
		drag_target = new Gtk.DropTarget (this.get_type (), Gdk.DragAction.COPY);

		this.image = image;
		// paintable_tmp = this.image.paintable;

		// image = new Gtk.Image.from_file (label);
		
		/*************************************/
		/*************   Source   ************/
		/*************************************/

		drag_source.prepare.connect ((x, y) => {
			print("Source Preparation\n");
			drag_source.set_icon(this.image.paintable, (int)x, (int)y);
			paintable_tmp = this.image.paintable;
			this.image.paintable = null;
			return new Gdk.ContentProvider.for_value(this);
		});

		drag_source.drag_begin.connect (()=> {

		});

		drag_source.drag_end.connect (()=> {
			if (this.paintable_tmp != null) {
				this.image.paintable = this.paintable_tmp;
			}
		});

		/*************************************/
		/*************   Target  *************/
		/*************************************/

		drag_target.on_drop.connect((drag)=>{
			var drop = (Tiles)drag.get_object ();

			var tmp = drop.paintable_tmp;
			drop.paintable_tmp = null;

			drop.image.paintable = this.image.paintable;

			this.image.paintable = tmp;

			return true;
		});

		base.set_child (image);
		base.add_controller (drag_source);
		base.add_controller (drag_target);
	}

	Gtk.DragSource drag_source;
	Gtk.DropTarget drag_target;
	Gtk.Image image;
	Gdk.Paintable? paintable_tmp = null;
}



public class Puzzle : Gtk.Grid{
	public Puzzle () {
		hexpand = true;
		vexpand = true;
		row_homogeneous = true;
		column_homogeneous = true;
		
		var img = "/nfs/homes/nda-cunh/Pictures/Wallpapers/yourname.png";
		var img_surface = new Cairo.ImageSurface.from_png (img);
		
		var img1 = create_image_from_offset (img_surface, 0, 0, 300, 300);
		var img2 = create_image_from_offset (img_surface, 300, 0, 300, 300);
		var img3 = create_image_from_offset (img_surface, 0, 300, 300, 300);
		var img4 = create_image_from_offset (img_surface, 300, 300, 300, 300);


		base.attach(new Tiles(img1), 0, 0, 1, 1);
		base.attach(new Tiles(img2), 0, 1, 1, 1);
		base.attach(new Tiles(img3), 1, 1, 1, 1);
		base.attach(new Tiles(img4), 1, 0, 1, 1);

		// base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t1.png"), 0, 0, 1, 1);
		// base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t2.png"), 0, 1, 1, 1);
		// base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t3.png"), 1, 1, 1, 1);
		// base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t4.png"), 1, 0, 1, 1);
	}

} 



public Image create_image_from_offset (Cairo.ImageSurface img_surface, int x, int y, int w, int h) {

	// var surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, 50, 50);
	var surface = new Cairo.ImageSurface(img_surface.get_format (), w, h);

	Cairo.Context ctx = new Cairo.Context(surface);
	ctx.set_source_surface (img_surface, -x, -y);
	ctx.paint();


	int size = surface.get_stride() * surface.get_height();
	var m =  new Gdk.MemoryTexture (w, h, Gdk.MemoryFormat.B8G8R8A8, new Bytes(surface.get_data ()[0:size]), surface.get_stride ());
	var image = new Image.from_paintable (m);
	return image;
} 


public class ExampleApp : Gtk.Application {
	public ExampleApp () {
		Object (application_id: "com.example.App");
	}

	public override void activate () {
		var win = new Gtk.ApplicationWindow (this);
		win.set_size_request (600, 600);


		// win.child = create_image_from_offset(img_surface, 0, 0, 200, 200);

		win.child =  new Puzzle();
		win.present ();
	}

}

public int main (string[] args) {
	var app = new ExampleApp ();
	return app.run (args);
}
