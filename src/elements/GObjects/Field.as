package elements.GObjects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.sampler.getSize;
	import flash.ui.Mouse;
	import flash.display.Graphics;
	
	import elements.Config;
	
	/**
	 *  Класс описывающий ировое поле
	 */
	public class Field extends Sprite
	{
		/**
		 * координаты клика
		 */
		private var ClickX:int = 0;
		private var ClickY:int = 0;
		/**
		 * цвет фона
		 */
		private var color:int = 0x330099;
		/**
		 * начальные координаты
		 */
		private var x0:int = 0;
		private var y0:int = 0;
		/**
		 * максимальное значение горизонтали
		 */
		private var xMax:int = 1920;
		/**
		 * максимальное значение вертикали
		 */
		private var yMax:int = 1080;
		/**
		 * переменная состояния игрового поля
		 */
		private var init:int = 0;
		/**
		 *  параметр реакции столкновения
		 */
		private var pow:int = 8;
		
		/**
		 *  инициализация
		 */
		public function Field()
		{
			xMax = elements.Config.WWidth;
			yMax = elements.Config.WHeight;
			graphics.beginFill(color);
			graphics.drawRect(x0,y0,xMax,yMax);
		}
		/**
		 *  получение параметра реакции
		 */
		public function getPow():int
		{
			return pow;
		}
		/**
		 *  событие зажатой клавиши
		 */
		public function onMouseDown(event:MouseEvent):void {
			init = 1;
			ClickX = event.localX;
			ClickY = event.localY;
		}
		
		public function onMouseUp(event:MouseEvent):void {
			
			init = 0;
		}

		public function onMouseMove(event:MouseEvent):void
		{
			ClickX=event.localX;
			ClickY = event.localY;
		}
		/**
		 *  обновление поля
		 */
		public function Update(event:Event):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRect(x0,y0,xMax,yMax);
		}
		/**
		 *  очистка поля и удаление его со stage
		 */
		public function removeAllChildren():void {
			while(this.numChildren!=0)
				this.removeChildAt(0);
		}
	}
}