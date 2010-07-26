// CameraBitmap Class v1.0
//
// released under MIT License (X11)
// http://www.opensource.org/licenses/mit-license.php
//
// Author: Mario Klingemann
// http://www.quasimondo.com

/*
Copyright (c) 2009 Mario Klingemann

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.quasimondo.bitmapdata 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class CameraBitmap extends EventDispatcher 
	{
		
		[Event(name="Event.RENDER", type="flash.events.Event")]
		
		private const CAMERA_DELAY:int = 100;
		private const origin:Point = new Point();
		
		public var bitmapData:BitmapData;
		
		private var _width:int;
		private var _height:int;
		
		private var _cam:Camera;
		private var _video:Video;
		
		private var _refreshRate:int;
		private var _timer:Timer;
		private var _drawMatrix:Matrix;
		private var _smooth:Boolean;
		private var _flip:Boolean;
		private var _colorTransform:ColorTransform;
		private var _colorMatrix:Array;
		private var _colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
		
		public function CameraBitmap( width:int, height:int, refreshRate:int = 15, flip:Boolean = false, cameraWidth:int = -1, cameraHeight:int = -1 )
		{
			_width  = width;
			_height = height;
			
			bitmapData = new BitmapData( width, height, false, 0 );
			
			_cam = Camera.getCamera();
			if ( cameraWidth == -1 || cameraHeight == -1 )
			{
				_cam.setMode( width, height, refreshRate, true );
			} else {
				_cam.setMode( cameraWidth, cameraHeight, refreshRate, true );
			}
			_refreshRate = refreshRate;
			_flip = flip;
			
			setTimeout( cameraInit, CAMERA_DELAY );
		}
		
		public function set active( value:Boolean ):void
		{
			if ( value ) _timer.start(); else _timer.stop();
		}

		public function close():void
		{
			active = false;
			_video.attachCamera(null);
			_video = null;
			_cam = null;
		}
		public function set refreshRate( value:int ):void
		{
			_refreshRate = value;
			_timer.delay = 1000 / _refreshRate;
		}
		
		public function set cameraColorTransform( value:ColorTransform ):void
		{
			_colorTransform = value;
		}
		
		public function set colorMatrix( value:Array ):void
		{
			_colorMatrixFilter.matrix = _colorMatrix = value;
		}
		
		private function cameraInit():void
		{
			_video = new Video( _cam.width, _cam.height );
			_video.attachCamera( _cam );
			
			if(_flip) {
				_drawMatrix = new Matrix( -_width / _cam.width, 0, 0, _height / _cam.height, _width, 0 );
			} else {
				_drawMatrix = new Matrix( _width / _cam.width, 0, 0, _height / _cam.height, 0, 0 );
			}
			
			_smooth = _drawMatrix.a != 1 || _drawMatrix.d != 1;
			
			_timer = new Timer( 1000 / _refreshRate );
			_timer.addEventListener( TimerEvent.TIMER, draw );
			_timer.start(); 
		}
		
		private function draw( event:TimerEvent = null ):void
		{
			bitmapData.lock();
			bitmapData.draw ( _video, _drawMatrix, _colorTransform, "normal", null, _smooth );
			if ( _colorMatrix != null )
			{
				bitmapData.applyFilter( bitmapData, bitmapData.rect, origin, _colorMatrixFilter );
			}
			bitmapData.unlock();
			dispatchEvent( new Event( Event.RENDER ) );
		}
	}
}
