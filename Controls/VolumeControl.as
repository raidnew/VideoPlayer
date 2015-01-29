/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 29.01.15
 * Time: 2:08
 * To change this template use File | Settings | File Templates.
 */
package Controls {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class VolumeControl extends Sprite{
    private var _volumeBar:Sprite;
    private var _slider:Sprite;

    private var _isDragged:Boolean;

    private var SIZE:Rectangle = new Rectangle(0,0,40,100);

    public function VolumeControl() {
        _init();
    }


    private function _init():void {
        //_background = new Sprite();
        _volumeBar = new Sprite();
        _slider = new Sprite();

        _volumeBar.graphics.beginFill(0x99BB99)
        _volumeBar.graphics.drawRect(SIZE.x,  SIZE.y,  10, SIZE.height);
        _volumeBar.graphics.endFill();

        _slider.graphics.beginFill(0x7777FF);
        _slider.graphics.drawCircle(0,0,10);
        _slider.graphics.endFill();

        _slider.addEventListener(MouseEvent.MOUSE_DOWN, _sliderMouseDownHandler)
        _slider.addEventListener(MouseEvent.MOUSE_UP, _sliderMouseUpHandler)

        //addChild(_background);
        addChild(_volumeBar);
        addChild(_slider);
    }

    private function _sliderMouseUpHandler(event:MouseEvent):void {
        _slider.stopDrag();
        _isDragged = false;
        dispatchEvent(new VideoHudEvent(VideoHudEvent.VOLUME, (SIZE.height - _slider.y) / SIZE.height));
    }

    private function _sliderMouseDownHandler(event:MouseEvent):void {
        _isDragged = true;
        _slider.startDrag(false, new Rectangle(0,0,0, SIZE.height))
    }

    public function setVolume(value:Number):void{
        if(!_isDragged){
            _slider.y = SIZE.height - SIZE.height * value;
        }
    }

}
}
