package 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.quasimondo.bitmapdata.CameraBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.core.mx_internal;
	
	import ru.inspirit.surf.ASSURF;
	import ru.inspirit.surf.IPoint;
	import ru.inspirit.surf.SURFOptions;
	import ru.inspirit.surf_example.FlashSURFExample;
	import ru.inspirit.surf_example.MatchElement;
	import ru.inspirit.surf_example.MatchList;
	import ru.inspirit.surf_example.utils.QuasimondoImageProcessor;
	import ru.inspirit.surf_example.utils.RegionSelector;
	import ru.inspirit.surf_example.utils.SURFUtils;
	
	[SWF(width='960',height='570',frameRate='33')]

	public class DynamicMatchesWithSaveAndLoadRefs extends FlashSURFExample 
	{
		public static const SCALE:Number = 1.5;
		public static const INVSCALE:Number = 1 / SCALE;
		
		public static const SCALE_MAT:Matrix = new Matrix(1/SCALE, 0, 0, 1/SCALE, 0, 0);
		public static const ORIGIN:Point = new Point();
		
		public var surf:ASSURF;
		public var surfOptions:SURFOptions;
		public var quasimondoProcessor:QuasimondoImageProcessor;
		public var buffer:BitmapData;
		public var autoCorrect:Boolean = false;
		
		public var matchList:MatchList;
		public var regionSelect:RegionSelector;
		
		protected var view:Sprite;
		protected var camera:CameraBitmap;
		protected var overlay:Shape;
		protected var screenBmp:Bitmap;
		protected var matchView:Sprite;
		
		protected var stat_txt:Label;
		
		private var matchId:int;
		
		private var red1:MovieClip = new RedCircle() as MovieClip;
		private var poster1:MovieClip = new poster() as MovieClip;
		private var MiniMap1:MovieClip = new MiniMap() as MovieClip;
		private var statusbar1:MovieClip = new statusbar() as MovieClip;		

		private var contentwindow1:MovieClip = new contentwindow() as MovieClip;
		private var frenchmusketcontent:MovieClip = new frenchmusketcontent_mc() as MovieClip;

		
		public function DynamicMatchesWithSaveAndLoadRefs() 
		{
			statusbar1.button_back.addEventListener(MouseEvent.CLICK, button_backMouseDownHandler);
			statusbar1.button_refresh.addEventListener(MouseEvent.CLICK, button_refreshMouseDownHandler);
			statusbar1.button_magglass.addEventListener(MouseEvent.CLICK, button_magglassMouseDownHandler);
			
			super();
			init();
		}
		
		private function init(e:Event = null):void
		{		
		
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stat_txt = new Label(p, 100, 5);
			
			var sl:HUISlider = new HUISlider(p, 340, 6, 'POINTS THRESHOLD', onThresholdChange);
			sl.setSliderParams(0.001, 0.01, 0.003);
			sl.labelPrecision = 4;
			sl.width = 250;
			
			sl = new HUISlider(p, 340, 19, 'MATCH FACTOR     ', onMatchFactorChange);
			sl.setSliderParams(0.3, 0.65, 0.55);
			sl.labelPrecision = 2;
			sl.width = 250;
			
			new CheckBox(p, 230, 11, 'CORRECT LEVELS', onCorrectLevels);
			
			new CheckBox(p, 100, 11, 'Debug', debug);
 
			var pb:PushButton;
			
			pb = new PushButton(p, 590, 6, 'SELECT REGION', onSelectRegion);
			pb.height = 16;
			pb = new PushButton(p, 590, 21, 'CLEAR MATCHES', onClearList);
			pb.height = 16;
			
			pb = new PushButton(p, 700, 6, 'SAVE MATCHES', onSaveList);
			pb.height = 16;
			pb = new PushButton(p, 700, 21, 'LOAD MATCHES', onLoadList);
			pb.height = 16;
		
			view = new Sprite();
			view.y = 40;
			
			screenBmp = new Bitmap();
			view.addChild(screenBmp);
			
			matchView = new Sprite();
			matchView.x = 320;
			view.addChild(matchView);
			
			overlay = new Shape();
			view.addChild(overlay);
			
			regionSelect = new RegionSelector(new Rectangle(0, 0, 320,240 ));
			view.addChild(regionSelect);
			
			camera = new CameraBitmap(320, 240, 33, false);
			
			screenBmp.bitmapData = camera.bitmapData;
			
			surfOptions = new SURFOptions(int(320 / SCALE), int(240/ SCALE), 200, 0.003, true, 4, 4, 2);
			surf = new ASSURF(surfOptions);
			
			surf.pointMatchFactor = 5.5;
			
			buffer = new BitmapData(surfOptions.width, surfOptions.height, false, 0x00);
			buffer.lock();
			
			quasimondoProcessor = new QuasimondoImageProcessor(buffer.rect);
			
			addChild(view);
			
			addChild(red1);	
			addChild(poster1);
			addChild(MiniMap1);
			addChild(statusbar1);

			poster1.gotoAndStop(1);
			
			matchList = new MatchList(surf);
			
			camera.addEventListener(Event.RENDER, render);
			
		}
		
		protected function debug(e:Event):void 
		{
			camera.removeEventListener(Event.RENDER, render);

			removeChild(view);
	
			screenBmp = new Bitmap();
			view.addChild(screenBmp);
			
			matchView = new Sprite();
			matchView.x = 640;
			view.addChild(matchView);
			
			overlay = new Shape();
			view.addChild(overlay);
			
			regionSelect = new RegionSelector(new Rectangle(0, 0, 640,480 ));
			view.addChild(regionSelect);
			
			camera = new CameraBitmap(640,480 , 15, false);
			
			screenBmp.bitmapData = camera.bitmapData;
			
			surfOptions = new SURFOptions(int(640 / SCALE), int(480/ SCALE), 200, 0.003, true, 4, 4, 2);
			surf = new ASSURF(surfOptions);
			
			surf.pointMatchFactor = 5.5;
			
			buffer = new BitmapData(surfOptions.width, surfOptions.height, false, 0x00);
			buffer.lock();
			
			quasimondoProcessor = new QuasimondoImageProcessor(buffer.rect);
			
			addChild(view);
			
			removeChild(red1);	
			removeChild(MiniMap1);
						
			matchList = new MatchList(surf);
			
			camera.addEventListener(Event.RENDER, render);
		}
		
		protected function onSaveList(e:Event):void 
		{
			SURFUtils.savePointsData( matchList.saveListToByteArray() );
		}
		
		protected function onLoadList(e:Event):void 
		{
			SURFUtils.openPointsDataFile(loadPointsDone);
		}
		
		protected function loadPointsDone(data:ByteArray):void 
		{
			matchList.initListFromByteArray(data);
		}
		
		protected function render( e:Event ) : void
		{
			var gfx:Graphics = overlay.graphics;
			var oldMatch:int;
			
			buffer.draw(camera.bitmapData, SCALE_MAT);
			
			var ipts:Vector.<IPoint> = surf.getInterestPoints(buffer);
			gfx.clear();
			//SURFUtils.drawIPoints(gfx, ipts, SCALE);
			
			var matched:Vector.<MatchElement> = matchList.getMatches();
			oldMatch = matchId;
			matchId = matchList.getMatchId();
			
			
			if (matchId != 999 && oldMatch != matchId){
			poster1.gotoAndStop((matchId)+2);
			MiniMap1.gotoAndPlay(2);
			red1.visible = false;
			poster1.match1.addEventListener(MouseEvent.CLICK, matchFind_MouseDownHandler);
			}
			
			switch (matchId){
				
				case 0:
					statusbar1.casename.htmlText = "Darth Maul";
					statusbar1.exhibitname.htmlText = "Match Number One";
					break;
				
				case 1:
					statusbar1.casename.htmlText = "Darth Vader";
					statusbar1.exhibitname.htmlText = "Match Number Two";
					break;
				
				case 2:
					statusbar1.casename.htmlText = "Luke Skywalker";
					statusbar1.exhibitname.htmlText = "Match Number Three";
					break;
				default:
					statusbar1.casename.htmlText = " ";
					statusbar1.exhibitname.htmlText = "Waiting for a match";

			}
			if (matchId == 999){
				MiniMap1.gotoAndStop(1);
				poster1.gotoAndStop(1);
				red1.visible = true;
				poster1.match1.removeEventListener(MouseEvent.CLICK, matchFind_MouseDownHandler);
			}
			
			//SURFUtils.drawMatchedBitmaps(matched, matchView);
		
			stat_txt.text = 'FOUND POINTS: ' + surf.currentPointsCount + '\nPOINTS TO MATCH: ' + matchList.pointsCount;
		}
		
		protected function onSelectRegion(e:Event = null):void
		{
			if(!regionSelect.visible)
			{
				regionSelect.init();
				camera.active = false;
				PushButton(e.currentTarget).label = 'ADD REGION';
			} else
			{
				if(regionSelect.rect.width > 20 && regionSelect.rect.height > 20)
				{
					var bmp:BitmapData = new BitmapData(regionSelect.rect.width, regionSelect.rect.height, false, 0x00);
					bmp.copyPixels(camera.bitmapData, regionSelect.rect, new Point(0, 0));
					
					regionSelect.rect.x *= INVSCALE;
					regionSelect.rect.y *= INVSCALE;
					regionSelect.rect.width *= INVSCALE;
					regionSelect.rect.height *= INVSCALE;
					
					matchList.addRegionAsMatch(regionSelect.rect, bmp);
				}
				
				regionSelect.uninit();
				camera.active = true;
				PushButton(e.currentTarget).label = 'SELECT REGION';
			}
		}
		
		private function matchFind_MouseDownHandler(event:MouseEvent):void {
			trace(matchId);
			this.addChild(contentwindow1);
			contentwindow1.gotoAndPlay(1);
			this.addChild(frenchmusketcontent);
			frenchmusketcontent.gotoAndPlay(1);
			
			contentwindow1.menu1.addEventListener(MouseEvent.CLICK, menu1DownHandler);
			contentwindow1.menu2.addEventListener(MouseEvent.CLICK, menu2DownHandler);
			contentwindow1.menu3.addEventListener(MouseEvent.CLICK, menu3DownHandler);
			contentwindow1.menu4.addEventListener(MouseEvent.CLICK, menu4DownHandler);
			contentwindow1.menu5.addEventListener(MouseEvent.CLICK, menu5DownHandler);
			camera.active = false;

		}
	
		private function menu1DownHandler(event:MouseEvent):void {
			trace("hit");
			frenchmusketcontent.gotoAndPlay("content1");
			
		}
		private function menu2DownHandler(event:MouseEvent):void {
			trace("hit");
			frenchmusketcontent.gotoAndPlay("content2");
			
		}
		private function menu3DownHandler(event:MouseEvent):void {
			trace("hit");
			frenchmusketcontent.gotoAndPlay("content3");
			
		}
		private function menu4DownHandler(event:MouseEvent):void {
			trace("hit");
			frenchmusketcontent.gotoAndPlay("content4");
			
		}
		private function menu5DownHandler(event:MouseEvent):void {
			trace("hit");
			frenchmusketcontent.gotoAndPlay("content5");
			
		}
		private function button_refreshMouseDownHandler(event:MouseEvent):void {
			
		}
		private function button_backMouseDownHandler(event:MouseEvent):void {
			camera.active = true;

			removeChild(contentwindow1);	
			removeChild(frenchmusketcontent);

		}
		private function button_magglassMouseDownHandler(event:MouseEvent):void {
			
		}
		protected function onClearList(e:Event):void 
		{
			matchList.clear();
		}
		
		protected function onCorrectLevels(e:Event):void
		{
			autoCorrect = CheckBox(e.currentTarget).selected;
			surf.imageProcessor = autoCorrect ? quasimondoProcessor : null;
		}
		
		protected function onThresholdChange(e:Event):void
		{
			surf.pointsThreshold = HUISlider(e.currentTarget).value;
		}
		
		protected function onMatchFactorChange(e:Event):void
		{
			surf.pointMatchFactor = HUISlider(e.currentTarget).value;
		}
	}
}
