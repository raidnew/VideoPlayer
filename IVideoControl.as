/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 23:17
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Sprite;

public interface IVideoControl {

    function disable():void;
    function enable():void;

    function pause():void;
    function playing():void;

    function setDuration(value:Number):void;
    function setProgress(value:Number):void;
    function setBuffered(buffered:Number):void;
    function setVolume(value:Number):void;
    function setFullScreen(value:Boolean):void;

    function getInterface():Sprite;

    function setAvalibleResolurion(resArray:Array):void;
    function setCallbackOnSetResolution(setResolution:Function):void;

    function finish():void;
}
}
