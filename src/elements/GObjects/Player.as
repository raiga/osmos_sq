package elements.GObjects
{
	import elements.Config;
	
	public class Player extends Circle
	{
		public function Player(X:Number, Y:Number){
			super(X, Y);
			this.setSize(50);
			this.CType=1;
		}
		public override function Draw():void
		{
			this.main.CField.graphics.beginFill(elements.Config.userColor());
			this.main.CField.graphics.drawCircle(this.x, this.y, this.getSize()/10);
			
		}
		
}
}