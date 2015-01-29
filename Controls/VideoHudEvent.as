/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 29.01.15
 * Time: 0:03
 * To change this template use File | Settings | File Templates.
 */
package Controls {
import flash.events.Event;

public class VideoHudEvent extends Event{

    public static var REWIND:String = "rewind";
    public static var VOLUME:String = "volume";

    private var _data:Number;

    public function VideoHudEvent(type:String,data:Number){
        super(type,bubbles,cancelable);
        _data = data;
    }

    public function get data():Number {
        return _data;
    }
}
}
