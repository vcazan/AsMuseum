package ru.inspirit.surf_example.utils 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * Simple image (plane) distortion class
	 * 
	 * @author Eugene Zatepyakin
	 */
	public class DistortImage 
	{
		protected var _w:uint, _h:uint;
		protected var _res:uint;
		
		protected var vertices:Vector.<Number>;  
		protected var indices:Vector.<int>;    
		protected var uvtData:Vector.<Number>;
		
		public var smoothing:Boolean = true;

		/**
		 * @param	w			Width of the image to be processed
		 * @param	h			Height of image to be processed
		 * @param	resolution	Precision
		 */
		public function DistortImage(w:uint, h:uint, resolution:uint = 10):void 
		{
			_w = w;
			_h = h;
			_res = resolution;
			
			_init();
		}


		/**
		 * Tesselates the area into triangles.
		 */
		protected function _init():void 
		{			
			var indStep:int = 0;		
			var hStep:Number = _w / _res;			
			var vStep:Number = _h / _res;
			var vi:int = -1;
			var ui:int = -1;
			var ii:int = -1;
						
			vertices = new Vector.<Number>( _res * _res * 8, true );
		    uvtData = new Vector.<Number>( _res * _res * 8, true );		     
		    indices = new Vector.<int>( _res * _res * 6, true );
		    
			for(var j:int = 0; j < _res; ++j)
			{				
				for(var i:int = 0; i < _res; ++i)
				{
					
					vertices[++vi] = i*hStep;
					vertices[++vi] = j*vStep;
					vertices[++vi] = (i+1)*hStep;
					vertices[++vi] = j*vStep;
					vertices[++vi] = (i+1)*hStep;
					vertices[++vi] = (j+1)*vStep;
					vertices[++vi] = i*hStep;
					vertices[++vi] = (j+1)*vStep;
					
					uvtData[++ui] = i/_res;
					uvtData[++ui] = j/_res;
					uvtData[++ui] = (i+1)/_res;
					uvtData[++ui] = j/_res;
					uvtData[++ui] = (i+1)/_res;
					uvtData[++ui] = (j+1)/_res;
					uvtData[++ui] = i/_res;
					uvtData[++ui] = (j+1)/_res;
				
					indices[++ii] = indStep;
					indices[++ii] = indStep+1;
					indices[++ii] = indStep+3;
					indices[++ii] = indStep+1;
					indices[++ii] = indStep+2;
					indices[++ii] = indStep+3;
					
					indStep += 4;
				}							
			}
		}


		/**
		 * Distorts the provided BitmapData according to the provided Point instances and draws it onto the provided Graphics.
		 *
		 * @param	graphics	Graphics on which to draw the distorted BitmapData
		 * @param	bmd			The undistorted BitmapData
		 * @param	tl			Point specifying the coordinates of the top-left corner of the distortion
		 * @param	tr			Point specifying the coordinates of the top-right corner of the distortion
		 * @param	br			Point specifying the coordinates of the bottom-right corner of the distortion
		 * @param	bl			Point specifying the coordinates of the bottom-left corner of the distortion
		 *
		 */
		public function setTransform(graphics:Graphics, bmd:BitmapData, tl:Point, tr:Point, br:Point, bl:Point):void 
		{
			var len:int = vertices.length >> 1;
			var ni:int = -1;
			var vi:int = -1;
						
			var verVecLeftX:Number = bl.x - tl.x;
			var verVecLeftY:Number = bl.y - tl.y;
			
			var verVecRightX:Number = br.x - tr.x;
			var verVecRightY:Number = br.y - tr.y;
				
			var curVert:Point = new Point();
			var curPointLeft:Point = new Point();
			var curPointRight:Point = new Point();
			var newVert:Point = new Point();
			var curYCoeff:Number;
			var curXCoeff:Number;
			var newVertices:Vector.<Number> = new Vector.<Number>(len << 1, true);
			
			for(var k:int = 0; k < len; ++k)
			{
				curVert.x = vertices[++vi];
				curXCoeff = uvtData[vi];
				curVert.y = vertices[++vi];
				curYCoeff = uvtData[vi];
				
				curPointLeft.x = tl.x + curYCoeff*verVecLeftX;
				curPointLeft.y = tl.y + curYCoeff*verVecLeftY;
				
				curPointRight.x = tr.x + curYCoeff*verVecRightX;
				curPointRight.y = tr.y + curYCoeff*verVecRightY;
				
				newVert.x = curPointLeft.x + (curPointRight.x - curPointLeft.x)*curXCoeff;						
				newVert.y = curPointLeft.y + (curPointRight.y - curPointLeft.y)*curXCoeff;
				
				newVertices[++ni] = newVert.x;
				newVertices[++ni] = newVert.y;						
			}
			
			vertices = newVertices.concat();
			
			_render(graphics, bmd);
		}

		protected function _render(graphics:Graphics, bmd:BitmapData):void 
		{
			graphics.beginBitmapFill(bmd, null, false, smoothing);
			graphics.drawTriangles(vertices, indices, uvtData);
			graphics.endFill();
		}


		/**
		 * Sets the size of this DistortImage instance and re-initializes the triangular grid.
		 *
		 * @param	width	New width.
		 * @param	height	New height.
		 */
		public function setSize(width:uint, height:uint):void 
		{
			this._w = width;
			this._h = height;
			this._init();
		}
		/**
		 * Width of this DistortImage instance.
		 */
		public function get width():uint 
		{
			return _w;
		}
		/**
		 * Height of this DistortImage instance.
		 */
		public function get height():uint 
		{
			return _h;
		}
		/**
		 * Precision of this DistortImage instance.
		 */
		public function get precision():uint 
		{
			return _res;
		}
		/**
		 * Sets the precision of this DistortImage instance and re-initializes the triangular grid.
		 */
		public function set precision(resolution:uint):void
		{
			this._res = resolution;
			this._init();
		}
	}
}
