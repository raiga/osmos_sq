
package elements.GUI {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.text.TextField;
import flash.display.Graphics;

public class Button extends Sprite {
    private var BWidth:Number = 50;
    private var BHeight:Number = 30;
	public var but:SimpleButton;

    public function Button(type:int) {
        but = new SimpleButton;
        but.upState = Draw(0xDAD8F3,type);
        but.overState = Draw(0x4F42C6,type);
        but.downState = Draw(0xDDF2FF,type);
        but.hitTestState = Draw(0xDDF2FF,type);
        but.useHandCursor = true;
		but.width = 80;
		but.height = 60;
        this.addChild(but);
    }
	
    /**
     * кнопки
     */
    private function Draw(color:uint,t:int):Sprite {
        var sprite:Sprite = new Sprite();
        if(t == 0)
        {

            sprite.graphics.beginFill(color);
            sprite.graphics.drawRect(0,0,BWidth,BHeight);
			var but0label:TextField=new TextField();
			but0label.x = 5;
			but0label.y = 10;
			but0label.selectable = false;
			but0label.text = "Restart";
			sprite.addChild(but0label);
        }
        if(t == 1)
        {

            sprite.graphics.beginFill(color);
            sprite.graphics.drawRect(55,0,BWidth,BHeight);
			var but1label:TextField=new TextField();
			but1label.x = 65;
			but1label.y = 10;
			but1label.selectable = false;
			but1label.text = "Pause";
			sprite.addChild(but1label);
        }
        return sprite;
    }

}
}
