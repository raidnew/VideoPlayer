/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 29.01.15
 * Time: 0:29
 * To change this template use File | Settings | File Templates.
 */
package {

import flash.display.Sprite;

public class SelectResolution extends Sprite{

    private var _buttonList:Array;
    private var _callback:Function;

    public function SelectResolution(callback:Function) {
        _callback = callback;
    }

    public function setResolutionList(res:Array):void{
        _buttonList = new Array();
        for(var i:int = 0;i<res.length;i++){
            var btn:BtnResolution = new BtnResolution(onSelect, res[i]);
            btn.y = i * 32;
            addChild(btn);
            _buttonList.push(btn);
        }
    }

    private function onSelect(res:int):void {
        _callback(res);
    }
}
}
