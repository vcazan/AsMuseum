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
     
	[SWF(width='960',height='590',frameRate='33')]

	public class AsMuseum extends FlashSURFExample 
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
		
		private var isMatched:Boolean;
		
		private var poster1:MovieClip = new poster() as MovieClip;
		private var MiniMap1:MovieClip = new MiniMap() as MovieClip;
		private var statusbar1:MovieClip = new statusbar() as MovieClip;	
		
		private var search:Boolean;

		private var frenchmusketcontent:MovieClip = new frenchmusketcontent_mc() as MovieClip;

		private var oldMatch:int; //Used for storing an instance of the last matchId


		public function AsMuseum() 
		{
			super();
			SURFUtils.openPointsDataFile(loadPointsDone);

			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{		
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Event Listeners for buttons
			
			statusbar1.button_back.addEventListener(MouseEvent.CLICK, button_backMouseDownHandler);
			statusbar1.button_refresh.addEventListener(MouseEvent.CLICK, button_refreshMouseDownHandler);
			statusbar1.button_magglass.addEventListener(MouseEvent.CLICK, button_magglassMouseDownHandler);
			
			stat_txt = new Label(p, 100, 5);
						 
			view = new Sprite();
			view.y = 299;
			view.x = 20;
			
			screenBmp = new Bitmap();
			view.addChild(screenBmp);
			
			matchView = new Sprite();
			matchView.x = 395;
			matchView.y = 199;

			this.addChild(matchView);
			
			overlay = new Shape();
			view.addChild(overlay);
			
			camera = new CameraBitmap(320, 240, 33, false);
			
			screenBmp.bitmapData = camera.bitmapData;
			
			surfOptions = new SURFOptions(int(320 / SCALE), int(240/ SCALE), 200, 0.003, true, 4, 4, 2); //Major surf options and camera size
			surf = new ASSURF(surfOptions);
			
			surf.pointMatchFactor = 5.5; //These are replacemnts for the HUD sliders that were here before
			surf.pointsThreshold = 0.001 //Numbers have been tested and seem the best for our application
			surf.pointMatchFactor = 0.45;
			
			buffer = new BitmapData(surfOptions.width, surfOptions.height, false, 0x00);
			buffer.lock();
			
			quasimondoProcessor = new QuasimondoImageProcessor(buffer.rect);
			
			addChild(view);
			
			this.addChild(MiniMap1); //Adding movieclips to the stage for future use
			this.addChild(statusbar1);
			this.addChild(matchView);
			this.addChild(frenchmusketcontent);
			
			matchList = new MatchList(surf);
			
			matchView.addEventListener(MouseEvent.CLICK, matchFind_MouseDownHandler); //Makes the images of the matches clickable

			isMatched = false; //Variable for checking wether or not there is a match on the screen (!= matchList.getMatchId();)

			search = false; //Checking if user is on the search screen
			
			camera.addEventListener(Event.RENDER, render); //Neverending loop rendering outputs

		}
		
		
		protected function render( e:Event ) : void
		{
			var gfx:Graphics = overlay.graphics;
			
			buffer.draw(camera.bitmapData, SCALE_MAT); //Draw recalculated data on the scrren
			
			var ipts:Vector.<IPoint> = surf.getInterestPoints(buffer); //Check for new interest points
			gfx.clear(); //Clear the graphics variables 
			
			//SURFUtils.drawIPoints(gfx, ipts, SCALE);
			
			var matched:Vector.<MatchElement> = matchList.getMatches(); //Get the list of possible matches
			
			oldMatch = matchId;//Set oldMatch to the matchId of the last id
			matchId = matchList.getMatchId();//Check for most recient matchId
			
			if (matchId != 999 && oldMatch == matchId){ //Major check for matches, it found add mouse listener to poster and go to the right frame
				poster1.gotoAndStop((matchId)+2);
				MiniMap1.gotoAndStop(11);
				poster1.match1.addEventListener(MouseEvent.CLICK, matchFind_MouseDownHandler);
			}
			if (matchId == 999){ //If no matches are found remove everything
				MiniMap1.gotoAndStop(1);
				poster1.gotoAndStop(1);
				poster1.match1.removeEventListener(MouseEvent.CLICK, matchFind_MouseDownHandler);
				return; //Makes match stay on screen
			}

			//Switch statment decides what info to be displayed for each case *****(THIS SHIOULD BE A FUNCTION)!!!****
			switch (matchId){
				
				case 0:
					statusbar1.casename.htmlText = "Nation States at War";
					statusbar1.exhibitname.htmlText = "";
					break;
				
				case 1:
					statusbar1.casename.htmlText = "War in the Industrial Age (cases 1 and 2)";
					statusbar1.exhibitname.htmlText = "";
					break;
				
				case 2:
					statusbar1.casename.htmlText = "Crossbow";
					statusbar1.exhibitname.htmlText = "";
					break;
				case 3:
					statusbar1.casename.htmlText = "New Weapons";
					statusbar1.exhibitname.htmlText = "";
					break;
				case 4:
					statusbar1.casename.htmlText = "Pike and Musket";
					statusbar1.exhibitname.htmlText = "";
					break;
				default:
					statusbar1.casename.htmlText = " ";
					statusbar1.exhibitname.htmlText = "Waiting for a match";

			}

			SURFUtils.drawMatchedBitmaps(matched, matchView); //Show matches on the screen.
		}
		
		private function matchFind_MouseDownHandler(event:MouseEvent):void { //Function used when a match is clicked, fade-in, fade-out

			isMatched = true;
			camera.active = false;
			removeChild(statusbar1);

			statusbar1.exhibitname.htmlText = "Video";
			frenchmusketcontent.gotoAndPlay(2); //Send user to the right content **Will be handled by a function**

			addChild(statusbar1);
			
			if (search){
				removeChild(poster1);
			}
		}

		private function button_refreshMouseDownHandler(event:MouseEvent):void { //Refresh button handler, **Will be handled by a function**

			if (isMatched){
				switch (matchId){
					
					case 0:
						frenchmusketcontent.gotoAndPlay(17);
						break;
					case 1:
						frenchmusketcontent.gotoAndPlay(47);
						break;
					case 2:
						frenchmusketcontent.gotoAndPlay(77);
						break;
					case 3:
						frenchmusketcontent.gotoAndPlay(2);
						break;
					case 4:
						frenchmusketcontent.gotoAndPlay(2);
						break;
				}

			}
		}
		private function button_backMouseDownHandler(event:MouseEvent):void {
			if (isMatched){
				frenchmusketcontent.gotoAndPlay(78);
				isMatched = false;
				camera.active = true;
			}

			if (search){
				addChild(poster1);
			}
		}
		private function button_magglassMouseDownHandler(event:MouseEvent):void {
			if (!isMatched){
				if (search == false){
					addChild(poster1);
					search = true;
				}
				else
				{
					search = false;
					removeChild(poster1);
				}
			}
		}
		
		protected function onLoadList(e:Event):void 
		{
			SURFUtils.openPointsDataFile(loadPointsDone);
		}
		
		protected function loadPointsDone(data:ByteArray):void 
		{		
			matchList.initListFromByteArray(data);
		}
	}
}