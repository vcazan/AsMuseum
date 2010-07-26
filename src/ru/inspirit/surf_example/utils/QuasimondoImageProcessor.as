package ru.inspirit.surf_example.utils 
{
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import ru.inspirit.surf.ImageProcessor;

	import com.quasimondo.geom.ColorMatrix;

	import flash.display.BitmapData;

	/**
	 * @author Eugene Zatepyakin
	 */
	public class QuasimondoImageProcessor extends ImageProcessor 
	{
		public var cm:ColorMatrix = new ColorMatrix();
		public var cmf:ColorMatrixFilter = new ColorMatrixFilter();
		
		public function QuasimondoImageProcessor(rect:Rectangle)
		{
			imageRect = rect;
		}

		override public function preProcess(input:BitmapData, output:BitmapData):void
		{
			cm.reset();
			cm.autoDesaturate(input, imageRect, false, true);
			
			cmf.matrix = cm.matrix;
			output.applyFilter( input, imageRect, ORIGIN, cmf );
		}
	}
}
