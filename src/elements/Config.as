package elements
{
	import flash.display.Stage;
	import com.developmentarc.core.datastructures.utils.HashTable;
	import com.json.*;
	
	public class Config {
		/**
		 * цвета из конфига
		 */
		public static var colorJSON:String ="";
		/**
		 * данные цветов
		 */
		public static var color:HashTable;
		/**
		 * максимально возможный размер
		 */
		public static var Sizemax:int=0;
		/**
		 * игровое окно
		 */
		public static var WHeight:int = 0;
		public static var WWidth:int = 0;
		/**
		 * координаты в начале
		 */
		public static var CSituate:Array;
		/**
		 * количество объектов
		 */
		public static var CObjectNum:int=0;
		/**
		 * минимальный для удаления размер
		 */
		public static var CMinSize:int = 8;
		/**
		 * коэффициент изменения при поглощении
		 */
		public static var CChange:int = 2;
		/**
		 * коэффициент сопротивления среды
		 */
		public static var CResistance:Number = 0.8;
		
		public static var stage:Stage;
		/**
		 * скорость пользователя
		 */
		public static var CUSpeed:Number = 1.5;
		/**
		 * максимальное ускорение
		 */
		public static var CUMaxSpeeding:Number = 1.6;
		/**
		 * настройка состояния звука
		 */
		public static var Sound:Boolean=true;

		
		/**
		 * инициализация
		 */
		public function Config(colors:String,npc:int) {
			/**
			 * генерация цветов локально
			 */
			if(colors=="")
				LocalConfigColor();
			SetPositions(npc);
			
			var conf:Object = com.json.JSON.decode(colorJSON);
			color = new HashTable();
			color.addItem("user",conf.user);
			color.addItem("enemy",conf.enemy);
		}
		

		public static function SetStage(_stage:Stage):void
		{
			stage = _stage;
		}
		
		/**
		 * генерируем цвета при отсутствии интернета
		 */
		public static function LocalConfigColor():void
		{
			colorJSON='{"user": {"color": [102, 88, 110]}, "enemy": {';
			var j:int, i:int;
			j = 0;
			i = 0;
			for(i=27;i<100;i++)
			{
			j++;
			colorJSON+='"color'+j.toString()+'" :['+ i.toString()+", 27,244],";
			}
			colorJSON=colorJSON.substr(0,colorJSON.length-1);
			colorJSON+='}}';
		}
		
		/**
		 * расстановка
		 */
		public static function SetPositions(num:int):void
		{
			CObjectNum=num;
			CSituate=[];
			for(var i:int=0;i<CObjectNum;i++)
			{
				var arr:HashTable=new HashTable();
				var X:Number = Math.round(Math.random()*Config.WWidth);
				var Y:Number = Math.round(Math.random()*Config.WHeight);
				var R:Number = Math.round(Math.random()*100)+10;
				while(!Posibility(X, Y, R))
				{
					X = Math.round(Math.random()*Config.WWidth);
					Y = Math.round(Math.random()*Config.WHeight);
					R = Math.round(Math.random()*100)+10;
				}
				arr.addItem("X",X);
				arr.addItem("Y",Y);
				arr.addItem("R",R);
				
				CSituate.push(arr);
			}
			
		}
		
		/**
		 * возможно ли вставить объект
		 */
		private static function Posibility(X:Number, Y:Number, Radius:Number):Boolean
		{
			var flag:Boolean=true;
			for(var i:int=0;i<CSituate.length;i++)
			{
				if(!Collision(CSituate[i].getItem("X")-X, CSituate[i].getItem("Y")-Y, CSituate[i].getItem("R")+Radius))
				{
					flag = false;
					break;
				}
			}
			return flag;
		}
		
		/**
		 * наложение (поглощение объектов)
		 */
		private static function Collision(aX:Number, aY:Number, Radius:Number):Boolean
		{
			return Math.sqrt(aX * aX + aY * aY) - Radius > 0;
		}
		
		/**
		 * подсчет объектов на поле
		 */
		public static function npcCount():int
		{
			
			var obj:Object=color.getItem("enemy");
			var colorsCount:int=0;
			for(var npc in obj)
			{
				colorsCount++;
			}
			return colorsCount;
		}
		/**
		 * цвета объектов
		 */
		public static function npcColor(user:int, enemy:int):int
		{
			var obj:Object=color.getItem("enemy");
			var colorsCount:int=npcCount();
			
			var colorNumber:int = Math.round(colorsCount*enemy/getMaxSize());
			colorNumber=Math.round(colorsCount/2+user-enemy);
			if(colorNumber<=0)
				colorNumber=1;
			if(colorNumber>=colorsCount)
				colorNumber=colorsCount-1;
			return toColorConverter(obj["color"+colorNumber.toString()]);
		}
		/**
		 * цвет шара игрока
		 */
		public static function userColor():int
		{
			var User:Object = color.getItem("user");
			var colorArray:Array=User.color;
			return toColorConverter(colorArray);
		}
		/**
		 * получение цвета из массива
		 */
		public static function toColorConverter(array:Array):int
		{
			var colorR:int = array[0]<<16;
			var colorG:int = array[1]<<8;
			var colorB:int = array[2];
			var colorInt:int = colorR+colorG+colorB;
			return colorInt;
		}
		/**
		 * получение параметра максимального размера
		 */
		public static function getMaxSize():int
		{
			return Sizemax;
		}
		/**
		 * установка максимального размера
		 */
		public static function setMaxSize(size:int):void
		{
			Sizemax=size;
		}
		/**
		 * проверка размера бъекта
		 */
		public static function checkSize(checkSize:int):void
		{
			if(getMaxSize()<checkSize)
			{
				setMaxSize(checkSize);
			}
			
		}
		
	}
}