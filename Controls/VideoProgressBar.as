/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 23:27
 * To change this template use File | Settings | File Templates.
 */
package Controls {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class VideoProgressBar extends Sprite{
    private var _background:Sprite;
    private var _totalBar:Sprite;
    private var _bufferBar:Sprite;
    private var _slider:Sprite;

    private var _isDragged:Boolean;

    private var SIZE:Rectangle = new Rectangle(0,0,300,60);

    public function VideoProgressBar():void{
        _init();
    }

    private function _init():void {
        //_background = new Sprite();
        _totalBar = new Sprite();
        _bufferBar = new Sprite();
        _slider = new Sprite();

        /*
        _background.graphics.beginFill(0xAAAAAA);
        _background.graphics.drawRect(SIZE.x,  SIZE.y,  SIZE.width, SIZE.height);
        _background.graphics.endFill();
         */

        _slider.addEventListener(MouseEvent.MOUSE_DOWN, _sliderMouseDownHandler)
        _slider.addEventListener(MouseEvent.MOUSE_UP, _sliderMouseUpHandler)

        _totalBar.addEventListener(MouseEvent.CLICK, _barClickHandler)

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);

        //addChild(_background);
        addChild(_totalBar);
        addChild(_bufferBar);
        addChild(_slider);

        drawbar();
    }

    private function drawbar():void{

        _totalBar.graphics.clear();
        _bufferBar.graphics.clear();
        _slider.graphics.clear();

        _totalBar.graphics.beginFill(0xBB9999);
        _totalBar.graphics.drawRect(SIZE.x,  SIZE.y,  SIZE.width, 10);
        _totalBar.graphics.endFill();

        _bufferBar.graphics.beginFill(0x99BB99)
        _bufferBar.graphics.drawRect(SIZE.x,  SIZE.y,  SIZE.width, 10);
        _bufferBar.graphics.endFill();

        _bufferBar.mouseEnabled = false;

        _slider.graphics.beginFill(0x7777FF);
        _slider.graphics.drawCircle(0,0,10);
        _slider.graphics.endFill();
    }

    private function _barClickHandler(event:MouseEvent):void {
        dispatchEvent(new VideoHudEvent(VideoHudEvent.REWIND, event.localX/SIZE.width));
    }

    private function onRemoveFromStage(event:Event):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, _sliderMouseUpHandler)
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(MouseEvent.MOUSE_UP, _sliderMouseUpHandler)
    }

    private function _sliderMouseUpHandler(event:MouseEvent):void {
        if(_isDragged){
            _slider.stopDrag();
            _isDragged = false;
            dispatchEvent(new VideoHudEvent(VideoHudEvent.REWIND, _slider.x / SIZE.width));
        }
    }

    private function _sliderMouseDownHandler(event:MouseEvent):void {
        if(!_isDragged){
            _isDragged = true;
            _slider.startDrag(false, new Rectangle(0,0,SIZE.width, 0))
        }
    }

    public function setProgress(value:Number):void{
        if(!_isDragged){
            _slider.x = SIZE.width * value;
        }
    }

    public function setBuffered(value:Number):void {
        _bufferBar.width = SIZE.width * value;
    }

    override public function set width(value:Number):void {
        //super.width = value;

        if(value < 20) value = 20;

        var tempSliderPos:Number = _slider.x/width;
        var tempBufferSizePos:Number = _slider.x/width;

        SIZE.width = value;

        drawbar();

        setBuffered(tempBufferSizePos);
        setProgress(tempSliderPos);
    }
}
}
