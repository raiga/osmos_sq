package elements.GUI
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	/**
	 *  Класс обрабатывающий события меню
	 */
	public class Menu extends Sprite {
		/**
		 *  переменные событий меню
		 */
		public var Restart:Button;
		public var Pause:Button;
		/**
		 *  массив объектов на поле
		 */
		private var objects:Array;
		private var main:Main;
		public static var Loaded:Boolean=false;

		
		/**
		 *  инициализация
		 */
		public function Menu(_main:Main) {
			main = _main;
			var button:Button=new Button(0);
			button.addEventListener(MouseEvent.CLICK, GameRestart);
			Restart = button;
			this.addChild(button);
			button=new Button(1);
			button.addEventListener(MouseEvent.CLICK, GamePause);
			Pause = button;
			this.addChild(button);
			super();
		}
		
		
		/**
		 * рестарт
		 */
		public function GameRestart(event:MouseEvent):void
		{
			main.Loading();
		}
		
		/**
		 * пауза
		 */
		public function GamePause(event:MouseEvent):void
		{
			main.Pause();
		}
		
		/**
		 * вывод меню
		 */
		public function Draw(graphics:Graphics):void
		{
			graphics.clear();


		}
			
		
		
	}
}