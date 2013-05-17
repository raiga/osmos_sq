package elements.GObjects
{

		import flash.events.Event;
		import flash.trace.Trace;
		import org.osmf.elements.compositeClasses.SerialElementSegment;
		
		import elements.Config;
		
		/**
		 *  Класс npc объектов
		 */
		public class Enemy extends Circle
		{
			/**
			 * npc начинают движение к случайно выбранному объекту меньшего размера
			 */
			private var Xpoint:Number=-1;
			private var Ypoint:Number=-1;
			
			/**
			 * инициализация
			 */
			public function Enemy(X:Number, Y:Number) {
				super(X, Y);
				Xpoint=-1;
				Ypoint = -1;
				CMaxspeed=Math.random()*2+0.1;
			}
			/**
			 * отрисовка
			 */
			public override function Draw():void
			{
				this.main.CField.graphics.beginFill(elements.Config.npcColor(this.main.getPlayerSize(),this.getSize()));
				this.main.CField.graphics.drawCircle(this.x, this.y, this.getSize()/10);
			}
			/**
			 * столкновения
			 */
			private function collisionCheck(X:Number, Y:Number, Radius:Number):Boolean
			{
				var ax:Number = this.x - X;
				var ay:Number = this.y - Y;
				var sizenpc:Number =Math.sqrt(ax*ax+ay*ay)+Radius;
				return sizenpc < this.getSize();
			}
			/**
			 * реализация движения
			 */
			public override function Move():void
			{
				/**
				 * Если координаты цели и текущего объекта не равны, то тогда
				 */
				if(this.x!=this.Xpoint||this.y!=this.Ypoint||(this.Xpoint==-1&&this.Ypoint==-1))
				{
					if(this.Xpoint==-1&&this.Ypoint==-1)
					{
						this.Xpoint = Math.random() * (elements.Config.WWidth-this.getSize())+this.getSize();
						this.Ypoint = Math.random() * (elements.Config.WHeight-this.getSize())+this.getSize();
					}
					else
					{

						var ax:Number, ay:Number;
						ax = this.Xpoint-this.x;
						ay = this.Ypoint-this.y;

						if(ax*ax+ay*ay>CMaxspeed)
						{

							var n:Number = ay/ax;

							var axt:Number = Math.sqrt(CMaxspeed/(n*n+1));
							if(ax>0) {
							}
							else
								axt = -axt;
							var ayt:Number=axt*n;
							if(ay>0){
								ayt = Math.abs(ayt);
							}
							else
								ayt = -Math.abs(ayt);
							ax = axt;
							ay = ayt;

							this.x+=ax;
							this.y+=ay;
							this.CprevX=ax;
							this.CprevY=ay;

						}
						else
						{

							this.x = this.Xpoint;
							this.y = this.Ypoint;
							if(this!=null)
								this.Xpoint = Math.random() * elements.Config.WWidth;
							if(this!=null)
								this.Ypoint = Math.random() * elements.Config.WHeight;
						}
					}
				}
			}
			
	}
}