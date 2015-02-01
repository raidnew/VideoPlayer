/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 0:15
 * To change this template use File | Settings | File Templates.
 */
package {
import Data.VideoData;
import Data.VideoStream;

import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.geom.Rectangle;
import flash.geom.Rectangle;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.system.System;
import flash.utils.Timer;

public class VideoPlayer extends Sprite implements IVideoPlayer{

    private var _netConnection:NetConnection;

    private var _container:Sprite;
    private var _video:Video;
    private var _hud:IVideoControl;
    private var _attachedStram:VideoStream;

    private var _refreshTimer:Timer;
    private var _dataVideo:VideoData;
    private var _startTime:Number;

    private var _isPause:Boolean;

    private var _currentVideoSize:Rectangle;

    public function VideoPlayer() {
        _container = new Sprite();
        _video = new Video();
        _currentVideoSize = new Rectangle();
        addChild(_container);
        _container.addChild(_video);
        _hud = new VideoControl(this);
        _refreshTimer = new Timer(0.1);
        _refreshTimer.addEventListener(TimerEvent.TIMER, _onTimerHanlder);
        addChild(_hud.getInterface());

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    public function fullScreenRedraw(event:FullScreenEvent):void
    {
        if (event.fullScreen)
        {
            _hud.setFullScreen(true);
        }
        else
        {
            _hud.setFullScreen(false);
        }
    }

    private function setVideoSize(newWidth:int, newHeight:int):void {
        var _streamSize:Rectangle = _attachedStram.getScreenSize();

        if(_streamSize != null && stage != null){
            var prop:Number = _streamSize.width/_streamSize.height;
            _video.width = newWidth;
            _video.height = newWidth/prop;
            if(_video.height > newHeight){
                _video.height = newHeight;
                _video.width = newHeight*prop;
            }
        }
    }

    private function onAddedToStage(e:Event):void{

        _currentVideoSize = new Rectangle(0,0,stage.stageWidth, stage.stageHeight);
        setVideoSize(_currentVideoSize.width, _currentVideoSize.height);

        stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
        stage.addEventListener(Event.RESIZE, onStageResize);
    }

    private function onRemovedFromStage(e:Event):void{
        stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
        stage.removeEventListener(Event.RESIZE, onStageResize);
    }

    private function onStageResize(event:Event):void {
        _currentVideoSize = new Rectangle(0,0,stage.stageWidth, stage.stageHeight);
        setVideoSize(_currentVideoSize.width, _currentVideoSize.height);

        screenRotation(_video.rotation);
    }

    private function _onTimerHanlder(event:TimerEvent):void {
        _hud.setProgress(_attachedStram.getTime());
        _hud.setBuffered(_attachedStram.getBuffered());
    }

    public function pause(value:Boolean):void {
        if(value){
            _hud.pause();
            _attachedStram.getStream().pause();
        }else{
            _hud.playing();
            _attachedStram.getStream().resume();
        }
        _isPause = value;
    }

    public function rewindTo(position:int):void {
        _attachedStram.getStream().seek(position);
    }

    public function setVolume(value:Number):void {
        _attachedStram.setVolume(value);
    }

    public function mute(mute:Boolean):void {
    }

    private function startStream(url:String):void{

        if(_attachedStram != null){
            _attachedStram.destroy();
        }

        var stream:VideoStream = new VideoStream();
        stream.setCallback(_streamStartPlay, _streamStopPlay, _onMetaDataRecieved);
        stream.startStream(url);
        _attachedStram = stream;
        _video.attachNetStream(_attachedStram.getStream());
        _hud.setVolume(_attachedStram.getVolume());

        if(_isPause){
            pause(true);
            _hud.pause();
        }else{
            _hud.playing();
        }

    }

    private function _onMetaDataRecieved():void {
        _currentVideoSize = new Rectangle(0,0,stage.stageWidth, stage.stageHeight);
        setVideoSize(_currentVideoSize.width, _currentVideoSize.height);
    }

    private function _streamStopPlay():void {
        _hud.finish();


    }

    private function _streamStartPlay():void{
        _hud.setProgress(_startTime)
        rewindTo(_startTime);
        _refreshTimer.start();
    }

    public function setData(data:VideoData):void {
        _dataVideo = data;
        _hud.setCallbackOnSetResolution(setResolution);
        _hud.setAvalibleResolurion(_dataVideo.getAllowedResolution());
        _hud.setDuration(_dataVideo.duration);
        _startTime = 0;
        _isPause = false;
        startStream(data.videos[0].url);
    }

    public function setResolution(resolution:int):void{
        var url:String = _dataVideo.getVideoUrlByResolution(resolution);
        if(url != null){
            _refreshTimer.stop();
            _startTime = _attachedStram.getTime();
            startStream(url);
        }
    }

    public function fullScreen(value:Boolean):void {

        if(stage == null){
            return;
        }

        if(value){
            stage.displayState = StageDisplayState.FULL_SCREEN;
        }else{
            stage.displayState = StageDisplayState.NORMAL;
        }
    }

    public function screenRotation(angle:Number):void {
        _video.rotation = angle;
        _container.x = 0;
        _container.y = 0;

        _container.scaleX = _container.scaleY = 1;

        var scalex:Number = _currentVideoSize.width / _container.width;
        var scaley:Number = _currentVideoSize.height / _container.height;

        var scale:Number = _container.scaleX = _container.scaleY = Math.min(scalex, scaley);

        var containerBounds:Rectangle = _container.getBounds(_container);
        _container.x -= containerBounds.x * scale;
        _container.y -= containerBounds.y * scale;

    }
}
}

