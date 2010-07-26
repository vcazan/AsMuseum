package ru.inspirit.surf_example.utils {
	import ru.inspirit.surf.IPoint;
	import ru.inspirit.surf.IPointMatch;
	import ru.inspirit.surf_example.MatchElement;

	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * @author Eugene Zatepyakin
	 */
	public class SURFUtils 
	{
		public static const SURF_POINTS_FILTER:FileFilter = new FileFilter ("FlashSURF Data file","*.fsurf");
		
		private static var fileReference:FileReference = new FileReference();
		private static var onOpenFile:Function;
		
		public static function drawMatches(gfx:Graphics, ipts:Vector.<IPointMatch>, scale:Number = 1, offset:Number = 0):void
		{
			var l:int = ipts.length;
			var pt:IPointMatch;
			gfx.lineStyle(1, 0x0000FF);
			
			for(var i:int = 0; i < l; ++i)
			{
				pt = ipts[i];
				var x1:Number = pt.currX * scale;
				var y1:Number = pt.currY * scale;
				var x2:Number = pt.refX + offset;
				var y2:Number = pt.refY;
				
				gfx.moveTo(x2, y2);
				gfx.lineTo(x1, y1);
			}
		}
		
		public static function drawMotionVectors(gfx:Graphics, ipts:Vector.<IPointMatch>, scale:Number = 1):void
		{
			var l:int = ipts.length;
			var pt:IPointMatch;			
			gfx.lineStyle(1, 0xFFFFFF);
			
			for(var i:int = 0; i < l; i+=4)
			{
				pt = ipts[i];
				var x1:Number = pt.currX * scale;
				var y1:Number = pt.currY * scale;
				var x2:Number = pt.refX * scale;
				var y2:Number = pt.refY * scale;
				
				var dx:Number = x1 - x2;
				var dy:Number = y1 - y2;
				var speed:Number = Math.sqrt(dx*dx+dy*dy);
				if (speed > 5 && speed < 30)
				{
					drawArrow(gfx, x1, y1, dx, dy, speed*2);
				}
			}
		}
		
		public static function drawIPoints(gfx:Graphics, ipts:Vector.<IPoint>, scale:Number = 1):void
		{
			var l:int = ipts.length;
			var ip:IPoint;
			
			for(var i:int = 0; i < l; ++i)
			{
				ip = ipts[i];
				var s:Number = ip.scale * scale;
				var x1:Number = ip.x * scale;
				var y1:Number = ip.y * scale;
	            var x2:Number = s * Math.cos(ip.orientation) + x1;
	            var y2:Number = s * Math.sin(ip.orientation) + y1;

				if(ip.orientation) {
					gfx.lineStyle(1, 0x00FF00);
	            	gfx.moveTo(x1, y1);
	            	gfx.lineTo(x2, y2);
				} else {
					gfx.beginFill(0x00FF00);
					gfx.drawCircle(x1, y1, 1);
					gfx.endFill();
				}
				if(ip.laplacian > 0) {
					gfx.lineStyle(1, 0x0000FF);
					gfx.drawCircle(x1, y1, s);
				} else {
					gfx.lineStyle(1, 0xFF0000);
					gfx.drawCircle(x1, y1, s);
				}
			}
		}
		
		public static function drawArrow(graphics:Graphics, stx:Number, sty:Number, dirx:Number = -1, diry:Number = -1, length:Number = 50, arrowSize:int = 6, angle:Number = -1):void
		{
			var endx:Number;
			var endy:Number;
			if(dirx == -1 && diry == -1){
				endx = stx + Math.cos(angle) * length;
				endy = sty + Math.sin(angle) * length;
			} else {
				var mag:Number = 1 / Math.sqrt(dirx * dirx + diry * diry);
				endx = dirx * mag * length + stx;
				endy = diry * mag * length + sty;
			}
            
			graphics.moveTo(stx, sty);
			graphics.lineTo(endx, endy);
            
			var diffx:Number = endx - stx;
			var diffy:Number = endy - sty;
			var ln:Number = Math.sqrt(diffx * diffx + diffy * diffy);
			
			if (ln <= 0) return;
			
			diffx = diffx / ln;
			diffy = diffy / ln;
			graphics.moveTo(endx, endy);
			graphics.lineTo(endx - arrowSize * diffx - arrowSize * -diffy, endy - arrowSize * diffy - arrowSize * diffx);
			graphics.moveTo(endx, endy);
			graphics.lineTo(endx - arrowSize * diffx + arrowSize * -diffy, endy - arrowSize * diffy + arrowSize * diffx);
		}
		
		public static function drawMatchedBitmaps(matches:Vector.<MatchElement>, sp:Sprite):void
		{
			var n:int = matches.length;
			var w:int = 200;
			var h:int = 0;
			
			while(sp.numChildren)
			{
				sp.removeChildAt(0);
			}
			
			sp.scaleX = sp.scaleY = 1;
			
			for(var i:int = 0; i < n; ++i)
			{
				var b:Bitmap = new Bitmap(matches[i].bitmap);
				if(b.width > w)
				{
					b.width = w;
					b.scaleY = b.scaleX;
				}
				b.y = h;
				
				h += b.height + 10;
				 
				sp.addChild(b);
			}
			
			if(sp.height > 480)
			{
				sp.height = 480;
				sp.scaleX = sp.scaleY;
			}
		}
		
		public static function savePointsData(pointsData:ByteArray):void
		{
			fileReference.save(pointsData, 'points.fsurf');
		}
		
		public static function openPointsDataFile(onOpen:Function):void
		{
			onOpenFile = onOpen;
			
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.COMPLETE, onFileLoadComplete);
			
			fileReference.browse( [ SURF_POINTS_FILTER ] );
		}
		
		protected static function onFileSelect(e:Event):void
		{
			fileReference.load();
		}
		
		protected static function onFileLoadComplete(e:Event):void
		{
			fileReference.removeEventListener(Event.SELECT, onFileSelect);
			fileReference.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			
			onOpenFile(fileReference.data);
		}
	}
}
