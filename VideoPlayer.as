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
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.system.System;
import flash.utils.Timer;

public class VideoPlayer extends Sprite implements IVideoPlayer{

    private var _netConnection:NetConnection;

    private var _container:Sprite;
    private var _videoURL:String;
    private var _video:Video;
    private var _hud:IVideoControl;
    private var _attachedStram:VideoStream;

    private var _refreshTimer:Timer;
    private var _dataVideo:VideoData;
    private var _startTime:Number;

    private var _isPause:Boolean;

    public function VideoPlayer() {
        _container = new Sprite();
        _video = new Video();
        addChild(_container);
        _container.addChild(_video);
        _hud = new VideoControl(this);
        _refreshTimer = new Timer(0.1);
        _refreshTimer.addEventListener(TimerEvent.TIMER, _onTimerHanlder);
        addChild(_hud.getInterface());

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    function fullScreenRedraw(event:FullScreenEvent):void
    {
        if (event.fullScreen)
        {
            _video.width = stage.stageWidth;
            _video.height = stage.stageHeight;
        }
        else
        {
            _video.width = 320;
            _video.height = 240;
        }
    }

    private function onAddedToStage(e:Event):void{
        stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
    }

    private function onRemovedFromStage(e:Event):void{
        stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
    }

    private function _onTimerHanlder(event:TimerEvent):void {
        _hud.setProgress(_attachedStram.getTime());
        _hud.setBuffered(_attachedStram.getBuffered());
    }

    public function pause(value:Boolean):void {
        if(value) _attachedStram.getStream().pause();
        else _attachedStram.getStream().resume();
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
            _attachedStram.destoy();
        }

        var stream:VideoStream = new VideoStream();
        stream.setCallback(_streamStartPlay, _streamStopPlay);
        stream.startStream(url);
        _attachedStram = stream;
        _video.attachNetStream(_attachedStram.getStream());
        _hud.setVolume(_attachedStram.getVolume());

        if(_isPause){
            pause(true);
        }
    }

    private function _streamStopPlay():void {

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

        var containerBounds:Rectangle = _container.getBounds(_container);
        _container.x -= containerBounds.x;
        _container.y -= containerBounds.y;
    }
}
}

