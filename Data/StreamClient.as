/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 23:05
 * To change this template use File | Settings | File Templates.
 */
package Data {
public class StreamClient {

    private var _info:Object;

    public function StreamClient() {
    }

    public function onMetaData(info:Object):void {
        _info = info;
        //trace("onMetaData: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }

    public function onCuePoint(info:Object):void {
        //trace("onCuePoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }

    public function onPlayStatus(info:Object):void {
        //trace("onPlayStatus: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }

    public function getDuration():Number {
        return _info.duration;
    }
}
}
