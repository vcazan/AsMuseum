package ru.inspirit.surf_example 
{
	import flash.utils.getTimer;
	import ru.inspirit.surf.HomographyMatrix;

	/**
	 * Helper class to get average value of several Homography matrices
	 * you can specify how many matrices will be used
	 * 
	 * @author Eugene Zatepyakin
	 */
	public class AverageHomographyMatrix extends HomographyMatrix 
	{
		public static var maxLength:int = 4;
		public static var maxMatrixLife:int = 1500; // time in ms
		
		public var matrices:Vector.<HomographyMatrix>;
		public var inliers:Vector.<int>;
		public var oldest:Vector.<int>;
		public var lastIndex:int;
		
		public function AverageHomographyMatrix(data:Vector.<Number> = null) 
		{
			super(data);
			
			lastIndex = 0;
			matrices = new Vector.<HomographyMatrix>();
			inliers = new Vector.<int>();
			oldest = new Vector.<int>();
		}

		public function addMatrix(matrix:HomographyMatrix, inliersN:int):void 
		{
			matrices[lastIndex] = matrix;
			inliers[lastIndex] = inliersN;
			oldest[lastIndex] = getTimer();
			
			var n:int = matrices.length;
			var m:HomographyMatrix;
			
			m11 = m22 = m33 = m12 = m13 = m21 = m23 = m31 = m32 = 0;
			
			for(var i:int = 0; i < n; ++i) 
			{
				m = matrices[i];
				
				m11 += m.m11;
				m12 += m.m12;
				m13 += m.m13;
				m21 += m.m21;
				m22 += m.m22;
				m23 += m.m23;
				m31 += m.m31;
				m32 += m.m32;
				m33 += m.m33;
			}
			
			var invDel:Number = 1 / n;
			m11 *= invDel;
			m12 *= invDel;
			m13 *= invDel;
			m21 *= invDel;
			m22 *= invDel;
			m23 *= invDel;
			m31 *= invDel;
			m32 *= invDel;
			m33 *= invDel;
			
			if(++lastIndex > maxLength)
			{
				removeWorstOne();
				--lastIndex;
			}
		}
		
		public function removeWorstOne():void
		{
			var t:int = getTimer();
			var n:int = matrices.length;
			var nn:int, rem:int, remt:int;
			var min:int = 1000;
			var old:int = 0;
			for(var i:int = 0; i < n; ++i)
			{
				nn = inliers[i];
				if(nn < min)
				{
					min = nn;
					rem = i;
				}
				nn = t - oldest[i];
				if(nn > old)
				{
					old = nn;
					remt = i;
				}
			}
			if(rem == remt)
			{
				matrices.splice(rem, 1);
				inliers.splice(rem, 1);
			}
			else if(old > maxMatrixLife)
			{
				matrices.splice(remt, 1);
				inliers.splice(remt, 1);
			}
			else 
			{
				matrices.splice(rem, 1);
				inliers.splice(rem, 1);
			}
		}
	}
}
