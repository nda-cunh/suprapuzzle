using Gtk;

public class Tiles : Gtk.Box {

	public Tiles (Gtk.Image image, int id) {
		this.id = id;
		this.image = image;
		image.hexpand = true;
		image.vexpand = true;

		// DragNDrop
		drag_source = new Gtk.DragSource ();
		drag_target = new Gtk.DropTarget (this.get_type (), Gdk.DragAction.COPY);

		// Init the events
		init_event_source ();
		init_event_target ();

		// Add the image widget to the box
		base.append(image);

		// connect the events controller
		base.add_controller (drag_source);
		base.add_controller (drag_target);
	}


	/*************************************/
	/*************   Source   ************/
	/*************************************/

	private void init_event_source () {
		// Prepare the DragNDrop
		// set the icon of the drag
		drag_source.prepare.connect ((x, y) => {
			drag_source.set_icon(this.image.paintable, (int)x, (int)y);
			paintable_tmp = this.image.paintable;
			this.image.paintable = null;
			inibhit_system_shortcuts ();
			return new Gdk.ContentProvider.for_value(this);
		});

		// DragNDrop when the drag is finished
		// when the tiles is dropped out of the window
		drag_source.drag_end.connect (()=> {
			if (this.paintable_tmp != null)
				this.image.paintable = this.paintable_tmp;
			inibhit_system_shortcuts ();
		});
	}

	/**
	* Swap the tiles with the target
	*/
	public void swap(Tiles target) {
		// if the target is grabed block the swap
		if (target.image.paintable == null || this.image.paintable == null)
			return;

		// Swap ID
		int tmp_id = this.id;
		this.id = target.id;
		target.id = tmp_id;

		var tmp1 = target.image.paintable;
		target.image.paintable = null;

		var tmp2 = this.image.paintable;
		this.image.paintable = null;

		// Swap Paintable Reference
		target.image.paintable = tmp2;
		this.image.paintable = tmp1;

		onMove();
	}


	/*************************************/
	/*************   Target  *************/
	/*************************************/

	private void init_event_target () {

		// When the tiles is dropped on another target
		drag_target.on_drop.connect((drag)=>{
			var drop = (Tiles)drag.get_object ();

			var tmp = drop.paintable_tmp;
			drop.paintable_tmp = null;
			drop.image.paintable = tmp;

			this.swap(drop);

			return true;
		});
	}

	/* Signal when the tiles is moved */
	public signal void onMove ();

	public int id {get; set;}
	private Gtk.DragSource drag_source;
	private Gtk.DropTarget drag_target;
	private Gtk.Image image;
	private Gdk.Paintable? paintable_tmp = null;
}
