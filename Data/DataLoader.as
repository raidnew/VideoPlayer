/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 27.01.15
 * Time: 23:24
 * To change this template use File | Settings | File Templates.
 */
package Data {
import Data.VideoData;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class DataLoader {

    private var _loader:URLLoader;
    private var _callback:Function;

    public function DataLoader(callback:Function) {

        _callback = callback;
        _loader = new URLLoader();
        _loader.addEventListener(Event.COMPLETE, _onDataLoaded);
    }

    public function load(url:String):void{
        _loader.load(new URLRequest(url));
    }

    private function _onDataLoaded(event:Event):void {
        _callback(VideoData.parseJSON(_loader.data));
    }

}
}
