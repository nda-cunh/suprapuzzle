using Gtk;



public class Tiles : Gtk.Frame {
	public Tiles (string label) {
		drag_source = new Gtk.DragSource ();
		drag_target = new Gtk.DropTarget (this.get_type (), Gdk.DragAction.COPY);

		image = new Gtk.Image.from_file (label);
		filename = label;
		
		
		/*************************************/
		/*************   Source   ************/
		/*************************************/

		drag_source.prepare.connect ((x, y) => {
			print("Source Preparation\n");
			drag_source.set_icon(Gdk.Texture.from_filename (this.image.file), (int)x, (int)y);
			this.image.file = null;
			return new Gdk.ContentProvider.for_value(this);
		});

		drag_source.drag_begin.connect (()=> {
		});

		drag_source.drag_end.connect (()=> {
			if (this.image.file == null) {
				this.image.file = this.filename;
			}
		});

		/*************************************/
		/*************   Target  *************/
		/*************************************/

		drag_target.on_drop.connect((drag)=>{
			Tiles drop = (Tiles)drag.get_object ();

			var tmp = drop.filename;

			drop.image.file = this.image.file;
			drop.filename = this.image.file;
			this.image.file = tmp;
			this.filename = tmp;
			return true;
		});

		base.set_child (image);
		base.add_controller (drag_source);
		base.add_controller (drag_target);
	}

	Gtk.DragSource drag_source;
	Gtk.DropTarget drag_target;
	Gtk.Image image;
	string filename;
}



public class Puzzle : Gtk.Grid{
	public Puzzle () {
		hexpand = true;
		vexpand = true;
		row_homogeneous = true;
		column_homogeneous = true;
		base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t1.png"), 0, 0, 1, 1);
		base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t2.png"), 0, 1, 1, 1);
		base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t3.png"), 1, 1, 1, 1);
		base.attach(new Tiles("/nfs/homes/nda-cunh/Pictures/Screenshots/t4.png"), 1, 0, 1, 1);
	}

} 





public class ExampleApp : Gtk.Application {
	public ExampleApp () {
		Object (application_id: "com.example.App");
	}

	public override void activate () {
		var win = new Gtk.ApplicationWindow (this);
		win.set_size_request (1000, 1000);

		var img = "/nfs/homes/nda-cunh/Pictures/Wallpapers/yourname.png";
		var img_surface = new Cairo.ImageSurface.from_png (img);
		// var surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, 50, 50);
		var surface = new Cairo.ImageSurface(img_surface.get_format (), 1000, 1000);

		Cairo.Context ctx = new Cairo.Context(surface);
		ctx.set_source_surface (img_surface, -500, -500);
		ctx.paint();


		print("%d\n", surface.get_stride());
		print("%d\n", surface.get_width());
		print("%d\n", surface.get_height());


		int size = surface.get_stride() * surface.get_height();
		var m =  new Gdk.MemoryTexture (1000, 1000, Gdk.MemoryFormat.B8G8R8A8, new Bytes(surface.get_data ()[0:size]), surface.get_stride ());
		var image = new Image.from_paintable (m);
		win.child = image;

		// win.child =  new Puzzle();
		win.present ();
	}

}

public int main (string[] args) {
	var app = new ExampleApp ();
	return app.run (args);
}
