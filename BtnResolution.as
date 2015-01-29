/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 29.01.15
 * Time: 0:33
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

public class BtnResolution extends Sprite{

    public var _resolution:int;
    private var _callback:Function;

    public function BtnResolution(callback:Function, res:int) {
        _resolution = res;
        _callback = callback;

        var bkg:Sprite = new Sprite();
        bkg.graphics.beginFill(0xAAAAAA);
        bkg.graphics.drawRect(0,0,60,30);

        var label:TextField = new TextField();
        label.text = String(res);
        label.mouseEnabled = false;

        addChild(bkg);
        addChild(label);

        addEventListener(MouseEvent.CLICK, onClickHanlder);
    }

    private function onClickHanlder(event:MouseEvent):void {
        _callback(_resolution);
    }
}
}
