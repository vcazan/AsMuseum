package ru.inspirit.surf_example.utils {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Eugene Zatepyakin
	 */
	public class RegionSelector extends Sprite 
	{
		public var gfx:Graphics;
		
		public var rect:Rectangle = new Rectangle(0, 0, 0, 0);
		public var bounds:Rectangle = new Rectangle(0, 0, 640, 480);
		
		public function RegionSelector(bounds:Rectangle)
		{			
			gfx = this.graphics;
			
			this.bounds = bounds;
			
			visible = false;
		}
		
		public function init():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startSelection);
			
			visible = true;
		}
		public function uninit():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, startSelection);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endSelection);
			
			rect = new Rectangle(0, 0, 0, 0);
			
			gfx.clear();
			visible = false;
		}
		
		protected function startSelection(e:Event):void
		{
			if(bounds.contains(mouseX, mouseY))
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, endSelection);
				
				rect.topLeft = new Point(mouseX, mouseY);
				
				gfx.clear();
			}
		}

		protected function onMouseMove(e:Event):void
		{
			rect.bottomRight = new Point( mouseX, mouseY );
			
			draw(rect);
		}
		
		protected function endSelection(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endSelection);
			
			var rr:Rectangle = new Rectangle( rect.width < 0 ? rect.x + rect.width : rect.x, rect.height < 0 ? rect.y + rect.height : rect.y, Math.abs(rect.width), Math.abs(rect.height));
			rect = rr;
		}
		
		protected function draw(r:Rectangle):void
		{
			var rr:Rectangle = new Rectangle( r.width < 0 ? r.x + r.width : r.x, r.height < 0 ? r.y + r.height : r.y, Math.abs(r.width), Math.abs(r.height));
			gfx.clear();
			gfx.lineStyle(1, 0xFFFFFF, .6);
			gfx.beginFill(0x333333, 0.5);
			gfx.drawRect(rr.x, rr.y, rr.width, rr.height);
			gfx.endFill();
		}
	}
}
