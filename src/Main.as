package {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.text.TextField;
	
	import com.developmentarc.core.datastructures.utils.HashTable;
	
	import com.json.JSON;
	
	import elements.GObjects.Circle;
	import elements.Config;
	import elements.GObjects.Enemy;
	import elements.GObjects.Field;
	import elements.GUI.Menu;
	import elements.GObjects.Player;
	
	[SWF(backgroundColor="0x330099")]
	public class Main extends Sprite {
		/**
		 * игровое поле
		 */
		public var CField:Field;
		/**
		 * нпц
		 */
		private var CCircles:Array;
		/**
		 * пометка на удаление
		 */
		private var CUsed:Array;
		/**
		 * максимальное количество в начале (значение подгружается из внешнего конфига в конструкторе, здесь есть на всякий случай)
		 */
		private var CNpcAppear:Number=40;
		/**
		 * очки
		 */
		private var CScore:Number;
		/**
		 * системные сообщения
		 */
		private var CLoadMess:TextField;
		/**
		 * запрос
		 */
		private var CRequest:URLRequest;
		/**
		 * флаг загрузки цветового конфига
		 */
		public var CLColors:Boolean=false;
		/**
		 * флаг загрузки количество нпц
		 */
		public var CLNpc:Boolean=false;
		/**
		 * состояние "steady","play","pause","win","lose"
		 */
		private var CGState:String = "steady";
		/**
		 * меню
		 */
		private var CMenu:Menu;
		/**
		 * состояние нажатия
		 */
		private var CAction:Boolean=false;
		/**
		 * сигнал поглощения
		 */
		public var CConsump:Sound;
		/**
		 * сигнал победы
		 */
		public var CDone:Sound;
		


		public function Main() {

			Security.loadPolicyFile("http://raigaproject.p.ht/crossdomain.xml");

			ColorLoading("http://raigaproject.p.ht/colors.conf");

			ObjectConfigLoading("http://raigaproject.p.ht/enemies.conf");
			
			/**
			 * вывод сообщения о загрузке
			 */
			CLoadMess=new TextField();
			CLoadMess.text="Loading...";
			CLoadMess.x = stage.stageWidth*0.4;
			CLoadMess.y = stage.stageHeight*0.45;
			this.addChild(CLoadMess);
			
			/**
			 * загрузка звуков
			 */
			CRequest = new URLRequest("http://raigaproject.p.ht/1380.mp3");
			CConsump = new Sound(CRequest);
			CRequest = new URLRequest("http://raigaproject.p.ht/0703.mp3");
			CDone = new Sound(CRequest);
			
			stage.frameRate = 40;
			var _cloader:URLLoader;
			var _crequest:URLRequest;
			this.addEventListener(Event.ENTER_FRAME,_loading);
			
			/**
			 * загрузка цветового конфига
			 */
			function ColorLoading(url:String):void
			{
				_cloader = new URLLoader();
				_crequest = new URLRequest(url);
				_crequest.method = URLRequestMethod.POST;
				_cloader.addEventListener(Event.COMPLETE, DoneColorLoading);
				_cloader.addEventListener(IOErrorEvent.IO_ERROR, ErrorLoad);
				_cloader.addEventListener(IOErrorEvent.NETWORK_ERROR, ErrorLoad);
				_cloader.addEventListener(IOErrorEvent.DISK_ERROR, ErrorLoad);
				_cloader.load(_crequest);
			}
			

			function DoneColorLoading(e:Event):void
			{
				Config.colorJSON= e.target.data;
				CLColors=true;
				Menu.Loaded = true;

				if(CLNpc&&Menu.Loaded)
					Play();
			}
			
			function ErrorLoad(e:Event):void
			{
				trace("error in loading from server");
			}
			
			
			function ObjectConfigLoading(url:String):void
			{
				_cloader = new URLLoader();
				_crequest = new URLRequest(url);
				_crequest.method = URLRequestMethod.POST;
				_cloader.addEventListener(Event.COMPLETE, DoneObjectConfigLoading);
				_cloader.addEventListener(IOErrorEvent.IO_ERROR, ErrorLoad);
				_cloader.addEventListener(IOErrorEvent.NETWORK_ERROR, ErrorLoad);
				_cloader.addEventListener(IOErrorEvent.VERIFY_ERROR, ErrorLoad);
				_cloader.addEventListener(IOErrorEvent.DISK_ERROR, ErrorLoad);
				_cloader.load(_crequest);
			}
			
			function DoneObjectConfigLoading(e:Event):void
			{
				this.CNpcAppear= parseInt(e.target.data);
				CLNpc=true;
				Menu.Loaded = true;
				
				if(CLColors&&Menu.Loaded)
					Play();
			}
			
		}
		
		public function onMouseDown(event:MouseEvent):void
		{
			this.CAction = true;
		}
		
		public function onMouseUp(event:MouseEvent):void
		{
			this.CAction = false;
		}
		
		public function Loading():void
		{

			this.CField.removeAllChildren();
			Config.SetPositions(CNpcAppear);

			/**
			 * начало игры
			 */
			CGState = "Play";
			
			CCircles = new Array();
			CUsed=new Array();
			
			/**
			 * генерация
			 */
			var obj:Circle;
			var i:int = 0;
			for(i=0;i<Config.CSituate.length-1;i++)
			{
				var X:int=HashTable(Config.CSituate[i]).getItem("X"),Y:int=HashTable(Config.CSituate[i]).getItem("Y"),R:int=HashTable(Config.CSituate[i]).getItem("R");
				obj = new Enemy(X,Y);
				obj.main = this;
				obj.setSize(R);
				CCircles.push(obj);
			}
			
			obj = new Player(HashTable(Config.CSituate[Config.CSituate.length-1]).getItem("X"), HashTable(Config.CSituate[Config.CSituate.length-1]).getItem("Y"));
			obj.main = this;
			CCircles.push(obj);
			
			
		}
		
		private function _loading(e:Event):void
		{

		}
		public function onError(e:ErrorEvent):void
		{
			trace(e);
		}
		
		/**
		 * основная логика действий в на поле
		 */
		private function MainLogic(event:Event):void
		{
			
			if (CGState =="Play") {
				CField.Update(event);
				var i:int = 0;
				
				if(CAction)
				{
					MoveCircle(new MouseEvent("type"));
				}
				i = 0;
				if(CUsed.length>0)
				{
					for(i=0;i<CUsed.length;i++)
					{
						var j:int=CCircles.indexOf(CUsed[i]);
						CCircles.splice(j, 1);
						j = 0;
					}
					Cleaning(CUsed);
				}
				
				var userSize:Number = getPlayerSize();
				for each(var object:Circle in CCircles)
				{
					object.Move();
					if(!(object is Player))
					{
						var Size:Number = object.getSize();
						if(Size<userSize)
						{
							object.DrawTarget();
						}
						else
						{
							if(Size>userSize)
							{
								object.DrawDanger();
							}
						}
					}
					object.Draw();

					CollisionCheck(object);
				}
			} else if (CGState == "Pause") {
				
				CField.Update(event);
				for each(var object:Circle in CCircles)
				{
					object.Draw();
				}
				CField.graphics.beginFill(0x000000,0.5);
				CField.graphics.drawRect(0,0,stage.width, stage.height);
				
			} else if (CGState == "Win") {

				CField.graphics.clear();
				CField.graphics.beginFill(0xFFFFFF,1);
				CField.graphics.drawRect(150,140,stage.width/2, stage.height/2);

				
			} else if (CGState == "Lose") {

				CField.graphics.clear();
				CField.graphics.beginFill(0xFF0000,1);
				CField.graphics.drawRect(150,140,stage.width/2, stage.height/2);

				
			} else if (CGState == "Steady") {

				PlaceMenu();
			}
		}
		
		/**
		 * подготовка игровой области
		 */
		public function Play():void
		{
			this.removeEventListener(Event.ENTER_FRAME,_loading);
			while(this.numChildren!=0)
				removeChildAt(0);

			var config:Config;
			var sndloop:Sound;
			sndloop = new Sound(new URLRequest("http://raigaproject.p.ht/corsica.mp3")); 
			sndloop.play(1, 10000000);
			Config.WWidth=stage.stageWidth;
			Config.WHeight=stage.stageHeight;
			if(Config.colorJSON=="")
				config = new Config("",CNpcAppear);
			else
				config = new Config(Config.colorJSON,CNpcAppear);

			CField=new Field();
			Config.SetStage(this.stage);
			CField.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			CField.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE,MoveCircle);
			addEventListener(Event.ACTIVATE,continueG);
			addEventListener(Event.DEACTIVATE,stopG);
			addEventListener(Event.ENTER_FRAME,GameFinished);
			addChild(CField);
			
			this.CMenu=new Menu(this);
			this.addChild(CMenu);
			Loading();
			addEventListener(Event.ENTER_FRAME, MainLogic);
			stage.align = StageAlign.TOP;
			
		}
		
		/**
		 * пауза
		 */
		public function Pause():void
		{
			if(CGState=="Pause")
			{
				CGState="Play";
			}
			else
			{
				if(CGState=="Play")
				{
					CGState="Pause";
				}
			}
		}
		
		/**
		 * возобновление действий
		 */
		private function continueG(event:Event):void
		{
			if(CGState=="Pause")
				CGState = "Play";
			stage.frameRate=40;
		}
		
		/**
		 * остановка действий при деактивации
		 */
		private function stopG(event:Event):void
		{
			if(CGState=="Play")
				CGState = "Pause";
			stage.frameRate = 1;
		}
		
		/**
		 * универсальная очистка
		 */
		private function Cleaning(array:Array):void
		{
			while(array.length>0)
				array.pop();
		}
		
		
		/**
		 * окончание игры
		 */
		private function GameFinished(event:Event):void
		{
			if(CGState =="Play")
			{
				var end:Boolean=false,win:Boolean = false;
				var Size:Number = 0;
				var HasUser:Boolean=false;
				var Object:Circle;
				for each(Object in CCircles)
				{
					Size+=Object.getSize();
					if(Object.getType()==1)
					{
						HasUser=true;
					}
				}
				if(!HasUser)
				{
					end = true;
					win = false;
				}
				else
				{
					for each(Object in CCircles)
					{
						if(Size-Object.getSize()<=Object.getSize())
						{
							end=true;
							win = Object.getType() == 1;
							if (win == 1) {
							var winscore:Number = Object.getSize()*10;
							}
						}
					}
				}
				if(end)
				{
					var message:TextField = new TextField();
					if(win)
					{
						CGState ="Win";
						
						message.htmlText="<h2>YOU WIN!!</h2>\r\n<h5>YOUR SCORE IS "+winscore+"</h5>";
						message.x=stage.stageWidth/2.55;
						message.y=stage.stageHeight/2.3;
						message.width=250;
						CField.addChild(message);
						if(Config.Sound)
							CDone.play();
					}
					else
					{
						CGState = "Lose";
						message.htmlText="<h2>YOU LOSE!!\r\nPRACTICE MORE\r\nOR CALL BATMAN!!</h2>";
						message.x=stage.stageWidth/2.35;
						message.y=stage.stageHeight/2.1;
						message.width=250;
						CField.addChild(message);
					}
				}
			}
		}
		
		/**
		 * столкновения
		 */
		private function CollisionCheck(object:Circle):void
		{
			for each(var seekObject:Circle in CCircles)
			{

				if(seekObject!=object&&!seekObject.getAppear()&&!object.getAppear())
				{

					var ax:Number,ay:Number;
					ax=object.x-seekObject.x;
					ay=object.y-seekObject.y;
					

					var length:Number=Math.sqrt(ax*ax+ay*ay);

					if(length<(object.getSize()+seekObject.getSize())/10)
					{

						if(object.getType()==1||seekObject.getType()==1&&Config.Sound)
							CConsump.play();

						if(object.getSize()>seekObject.getSize())
						{
							seekObject.setSize(seekObject.getSize()-Config.CChange);
							if(seekObject.getSize()<=Config.CMinSize)
							{
								seekObject.setAppear();
								CUsed.push(seekObject);
								
							}
							object.setSize(object.getSize()+Config.CChange);
						}
						if(object.getSize()<seekObject.getSize())
						{
							seekObject.setSize(seekObject.getSize()+Config.CChange);
							object.setSize(object.getSize()-Config.CChange);
							if(object.getSize()<=Config.CMinSize)
							{
								object.setAppear();
								CUsed.push(object);
								
							}
						}
					}

					ax = 0;
					ay = 0;
					length = 0;
				}

				if(object.getAppear())
					break;
				
			}
		}
		private function MoveCircle(event:MouseEvent):void
		{

			if(CAction)
			{
				var angle:Number=0;
				var x:Number=this.mouseX;
				var y:Number=this.mouseY;

				for each(var object:Circle in CCircles)
				{
					if(object.getType()==1)
					{
						angle=Corn(object.x, object.y, x,y);
						var dx:Number, dy:Number;
						dx = -Math.cos(angle)*(Config.CUSpeed);
						dy = -Math.sin(angle)*(Config.CUSpeed);
						object.CXSpeeding=dx;
						object.CYSpeeding=dy;
					}
				}
				angle = 0;
			}
		}
		
		/**
		 * угол по вектору (радиан)
		 */
		private function Corn(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			return Math.atan2(y1-y0, x1-x0);
		}
		
		/**
		 * меню
		 */
		private function PlaceMenu():void
		{
			CMenu.Draw(CField.graphics);
		}
		
		public function getPlayerSize():int
		{
			var userSize:int=0;
			for each(var object:Circle in CCircles)
			{
				if(object.getType()==1)
				{
					userSize = object.getSize();
					return userSize;
				}
			}
			return userSize;
		}
	}
}
