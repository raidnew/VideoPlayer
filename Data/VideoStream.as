/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 22:59
 * To change this template use File | Settings | File Templates.
 */
package Data {
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.Rectangle;
import flash.media.SoundTransform;
import flash.net.NetConnection;
import flash.net.NetStream;

public class VideoStream {

    private var _stream:NetStream;
    private var _connection:NetConnection;
    private var _streamURL:String;
    private var _onStopCallBack:Function;
    private var _onStartCallBack:Function;
    private var _onMetaStreamCallback:Function;

    private var _info:Object;

    public function VideoStream() {
    }

    private function _initNetConnection():void{
        _connection = new NetConnection();
        _connection.addEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler);
        _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
        _connection.connect(null);
    }

    private function _netStatusHandler(event:NetStatusEvent):void {

        //trace(event.info.code);

        switch (event.info.code) {
            case "NetConnection.Connect.Success":
                _connectStream();
                break;
            case "NetStream.Play.StreamNotFound":
                trace("Stream not found: " + _streamURL);
                break;
            case "NetStream.Play.Start":
                _streamStartPlay();
                break;
            case "NetStream.Play.Stop":
                _streamStopPlay();
                break;
        }
    }

    private function _streamStopPlay():void {
        _onStopCallBack();
    }

    private function _streamStartPlay():void {
        _onStartCallBack();
    }

    private function _securityErrorHandler(event:SecurityErrorEvent):void {
        trace("_securityErrorHandler: " + event);
    }

    private function _connectStream():void {
        _stream = new NetStream(_connection);
        _stream.addEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler);
        _stream.client = this;
        _stream.play(_streamURL);
    }

    public function startStream(url:String):void{
        _streamURL = url;
        destroy();
        _initNetConnection();
    }

    public function getStream():NetStream {
        return _stream;
    }

    public function getTime():Number{
        return _stream.time;
    }

    public function getBuffered():Number {
        return _stream.bytesLoaded/_stream.bytesTotal;
    }

    public function destroy():void {
        if(_stream != null){
            _stream.removeEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler);
            _stream.close();
        }

        if(_connection != null){
            _connection.removeEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler);
            _connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler);
            _connection.close();
        }
    }

    public function setCallback(callbackStart:Function, callbackStop:Function, callbackMeta:Function):void {
        _onStartCallBack = callbackStart;
        _onStopCallBack = callbackStop;
        _onMetaStreamCallback = callbackMeta;
    }

    public function setVolume(volume:Number):void{
        var videoVolumeTransform:SoundTransform = new SoundTransform();
        videoVolumeTransform.volume = volume;
        _stream.soundTransform = videoVolumeTransform;
    }

    public function getVolume():Number{
        return _stream.soundTransform.volume;
    }

    public function getScreenSize():Rectangle {
        return getSize();

    }

    public function onMetaData(info:Object):void {
        _info = info;
        _onMetaStreamCallback();
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

    public function getSize():Rectangle {
        if(_info == null){
            return null;
        }
        return new Rectangle(0,0,_info.width, _info.height);
    }
}
}

