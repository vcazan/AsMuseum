package ru.inspirit.surf_example 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.Style;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;

	/**
	 * FlashSURF Examples Base class
	 * 
	 * @author Eugene Zatepyakin
	 * @link http://blog.inspirit.ru
	 * @link http://code.google.com/p/in-spirit/source/browse/#svn/trunk/projects/FlashSURF
	 */
	
	[SWF(width='1040',height='520',frameRate='33',backgroundColor='0x000000')]
	
	public class FlashSURFExample extends Sprite 
	{
		
		public var p:Panel;
		
		protected var fps_txt:Label;
		protected var _timer:uint;
		protected var _fps:uint;
		protected var _ms:uint;
		protected var _ms_prev:uint;
		
		public function FlashSURFExample()
		{
			initStage();
			initPanel();
			
			addEventListener(Event.ENTER_FRAME, countFrameTime);
		}
		
		protected function initPanel():void
		{
			p = new Panel(this);
			p.width = stage.stageWidth;
			p.height = 40;

			Style.PANEL = 0x333333;
			Style.BUTTON_FACE = 0x333333;
			Style.LABEL_TEXT = 0xF6F6F6;

			fps_txt = new Label(p, 10, 5);
			fps_txt.name = 'fps_txt';
		}		

		protected function countFrameTime(e:Event = null):void
		{
			_timer = getTimer();
			if( _timer - 1000 >= _ms_prev )
			{
				_ms_prev = _timer;

				fps_txt.text = 'FPS: ' + _fps + ' / ' + stage.frameRate +  "\nMEM: " + Number((System.totalMemory * 0.000000954).toFixed(3));
				_fps = 0;
			}

			_fps ++;
			_ms = _timer;
		}
		
		protected function initStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;

			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();


			var copyr:ContextMenuItem = new ContextMenuItem("© inspirit.ru", true, false);
			myContextMenu.customItems.push(copyr);

			contextMenu = myContextMenu;
		}
	}
}
