/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 23:17
 * To change this template use File | Settings | File Templates.
 */
package {
public interface IVideoPlayer {

    function pause(value:Boolean):void;
    function rewindTo(position:int):void;
    function setVolume(value:Number):void;
    function mute(mute:Boolean):void;
    function fullScreen(value:Boolean):void;
    function screenRotation(number:Number):void;
}
}
