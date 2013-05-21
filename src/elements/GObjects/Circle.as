package elements.GObjects
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	
	import elements.Config;
	
	public class Circle extends Sprite {
		
		/**
		 * тип
		 */
		protected var CType:Number = 0;
		/**
		 * размер
		 */
		private var CSize:Number=60;
		/**
		 * цвет
		 */
		private var CColor:Number=0;
		/**
		 * значение ускорения по х
		 */
		public var CXSpeeding:Number = 0;
		/**
		 * значение ускорения по у
		 */
		public var CYSpeeding:Number = 0;
		/**
		 * максимальная скорость
		 */
		protected var CMaxspeed:Number = 7;
		/**
		 * состояние объекта
		 */
		private var CDisappear:Boolean = false;
		/**
		 * значение x до передвижения
		 */
		protected var CprevX:Number = 0;
		/**
		 * значение y до передвижения
		 */
		protected var CprevY:Number = 0;

		public var main:Main;

		
		/**
		 * инициализатор
		 */
		public function Circle(X:Number, Y:Number) {
			this.x = X;
			this.y = Y;
		}
		
		/**
		 * получение х
		 */
		public function getX():Number
		{
			return this.x;
		}
		
		/**
		 * получение у
		 */
		public function getY():Number
		{
			return this.y;
		}
		
		/**
		 * получение типа объекта
		 */
		public function getType():Number
		{
			return this.CType;
		}
		
		/**
		 * размер объекта в 10 долях
		 */
		public function getSize():Number
		{
			return CSize;
		}
		
		/**
		 * задание размера
		 */
		public function setSize(size:Number):void
		{
			elements.Config.checkSize(size);
			this.CSize = size;
		}
		
		/**
		 * получение состояния объекта
		 */
		public function getAppear():Boolean
		{
			return CDisappear;
		}
		
		/**
		 * установка состояния объекта
		 */
		public function setAppear():void
		{
			CDisappear=true;
		}

		
		public function Draw():void
		{
			
		}
		
		/**
		 * Добыча
		 */
		public function DrawTarget():void
		{
			main.CField.graphics.beginFill(0xEEEEEE,0.8);
			main.CField.graphics.drawCircle(this.x, this.y, this.getSize()/10+1);
		}
		
		/**
		 * Опасные соперники
		 */
		public function DrawDanger():void
		{
			main.CField.graphics.beginFill(0xDD0000,0.6);
			main.CField.graphics.drawCircle(this.x, this.y, this.getSize()/10+1);
		}
		
		/**
		 * Движение
		 */
		public function Move():void
		{

			var Resistance:Number = elements.Config.CResistance;
			var ax:Number=CXSpeeding,ay:Number=CYSpeeding;

			if(Math.abs(CXSpeeding)>0.01)
			{

				this.x+=ax;

				if(this.x+ax-this.getSize()/10<0)
				{
					this.x=this.getSize()/10;
					this.CXSpeeding=-this.CXSpeeding;
				}
				if(this.x+ax+this.getSize()/10>elements.Config.WWidth)
				{
					this.x = elements.Config.WWidth-this.getSize()/10;
					this.CXSpeeding=-this.CXSpeeding;
				}
				this.CXSpeeding*=Resistance;
			}
			else
			{
				
				this.CXSpeeding=0.0;
			}

			if(Math.abs(CYSpeeding)>0.01)
			{

				this.y+=ay;

				if(this.y+ay-this.getSize()/10<0)
				{
					this.y=this.getSize()/10;
					this.CYSpeeding=-this.CYSpeeding;
				}
				if(this.y+ay+this.getSize()/10>elements.Config.WHeight)
				{
					this.y = elements.Config.WHeight-this.getSize()/10;
					this.CYSpeeding=-this.CYSpeeding;
				}
				this.CYSpeeding*=Resistance;
			}
			else
			{
				this.CYSpeeding=0.0;
			}
			this.CprevX=ax;
			this.CprevY=ay;
		}
		public function GoSpeeding(X:Number, Y:Number):void
		{
			if(Math.abs(this.CXSpeeding+X)<elements.Config.CUMaxSpeeding)
				this.CXSpeeding+=X;
			else
				this.CXSpeeding=elements.Config.CUMaxSpeeding*Math.abs(CXSpeeding)/CXSpeeding;
			if(Math.abs(this.CYSpeeding+Y)<elements.Config.CUMaxSpeeding)
				this.CYSpeeding+=Y;
			else
				this.CYSpeeding=elements.Config.CUMaxSpeeding*Math.abs(CYSpeeding)/CYSpeeding;
		}
	}
}