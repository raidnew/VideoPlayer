/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 0:51
 * To change this template use File | Settings | File Templates.
 */
package {
import Controls.SelectResolution;
import Controls.VideoHudEvent;
import Controls.VideoProgressBar;
import Controls.VolumeControl;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.utils.Timer;

public class VideoControl implements IVideoControl{

    private var _currentTime:Number;
    private var _totalDuration:Number;
    private var _playBtn:Sprite;
    private var _pauseBtn:Sprite;
    private var _progressBar:VideoProgressBar;
    private var _volumeControl:VolumeControl;
    private var _rotationScreen:VolumeControl;

    private var _selectResolution:SelectResolution;

    private var _container:Sprite;
    private var _screen:IVideoPlayer;

    private var _duration:Number;
    private var _progress:Number;
    private var _callbackSetResolution:Function;

    private var _fullScreenBtn:Sprite;
    private var _fullscreenMode:Boolean;

    public function VideoControl(videoScreen:IVideoPlayer) {
        _screen = videoScreen;
        init();
    }

    public function init():void{
        _container = new Sprite();

        _currentTime = 0;
        _totalDuration = 0;

        _progressBar = new VideoProgressBar();

        _volumeControl = new VolumeControl();

        _rotationScreen = new VolumeControl();

        _progressBar.addEventListener(VideoHudEvent.REWIND, _onRewindHandler)
        _volumeControl.addEventListener(VideoHudEvent.VOLUME, _onVolumeHandler)
        _rotationScreen.addEventListener(VideoHudEvent.VOLUME, _onRotationHandler)

        _selectResolution = new SelectResolution(setResolution);

        _playBtn = new Sprite();
        _playBtn.graphics.beginFill(0xAAFFAA);
        _playBtn.graphics.drawCircle(0,0,20);
        _playBtn.addEventListener(MouseEvent.CLICK, playClickHandler);

        _pauseBtn = new Sprite();
        _pauseBtn.graphics.beginFill(0xFFAAAA);
        _pauseBtn.graphics.drawCircle(0,0,20);
        _pauseBtn.addEventListener(MouseEvent.CLICK, pauseClickHandler);

        _fullScreenBtn = new Sprite();
        _fullScreenBtn.graphics.beginFill(0x000000);
        _fullScreenBtn.graphics.drawRect(0,0,50,50);
        _fullScreenBtn.addEventListener(MouseEvent.CLICK, fullScreenHandler);

        _container.addChild(_volumeControl);
        _container.addChild(_rotationScreen);
        _container.addChild(_progressBar);
        _container.addChild(_selectResolution);
        _container.addChild(_playBtn);
        _container.addChild(_pauseBtn);
        _container.addChild(_fullScreenBtn);

        _container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        _container.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);

    }

    private function onRemoveFromStage(event:Event):void {
        _container.stage.removeEventListener(Event.RESIZE, _onStageResize);
    }

    private function onAddedToStage(event:Event):void {
        _container.stage.addEventListener(Event.RESIZE, _onStageResize);
        alignControls();
    }

    private function _onStageResize(event:Event):void {
        alignControls();
    }

    private function alignControls():void {

        var width:int = _container.stage.stageWidth;
        var height:int = _container.stage.stageHeight;

        _playBtn.x = _pauseBtn.x = 30;
        _playBtn.y = _pauseBtn.y = height - 40;

        _progressBar.width = width - 300;
        _progressBar.x = _playBtn.x + _playBtn.width ;
        _progressBar.y = height - 40;

        _fullScreenBtn.x = _progressBar.x + _progressBar.width + 10;
        _fullScreenBtn.y = height - 60;

        _selectResolution.x = _fullScreenBtn.x + _fullScreenBtn.width + 10;
        _selectResolution.y = height - _selectResolution.height;

        _volumeControl.x = _selectResolution.x + _selectResolution.width + 10;
        _volumeControl.y = height - _volumeControl.height;

        _rotationScreen.x = _volumeControl.x + _volumeControl.width + 10;
        _rotationScreen.y = height - _rotationScreen.height;
    }

    private function _onRotationHandler(event:VideoHudEvent):void {
        _screen.screenRotation(event.data * 360);
    }

    private function fullScreenHandler(event:MouseEvent):void {
        _screen.fullScreen(_fullscreenMode?false:true);
    }

    private function playClickHandler(event:MouseEvent):void {
        _screen.pause(false);
    }

    private function pauseClickHandler(event:MouseEvent):void {
        _screen.pause(true);
    }

    private function _onVolumeHandler(event:VideoHudEvent):void {
        _screen.setVolume(event.data);
    }

    private function _onRewindHandler(event:VideoHudEvent):void {
        _screen.rewindTo(_duration * event.data);
    }

    public function disable():void {
    }

    public function enable():void {
    }

    public function pause():void {
        _pauseBtn.visible = false;
        _playBtn.visible = true;
    }

    public function playing():void {
        _pauseBtn.visible = true;
        _playBtn.visible = false;
    }

    public function setDuration(value:Number):void {
        _duration = value;
    }

    public function setProgress(value:Number):void {
        _progress = value;
        _progressBar.setProgress(_progress / _duration);
    }

    public function setBuffered(value:Number):void {
        _progressBar.setBuffered(value);
    }

    public function setFullScreen(value:Boolean):void {
        _fullscreenMode = value;
    }

    public function getInterface():Sprite {
        return _container;
    }

    public function setAvalibleResolurion(resArray:Array):void {
        _selectResolution.setResolutionList(resArray);
    }

    public function setResolution(res:int):void{
        _callbackSetResolution(res);
    }

    public function setCallbackOnSetResolution(setResolution:Function):void {
        _callbackSetResolution = setResolution;
    }

    public function setVolume(value:Number):void{
        _volumeControl.setVolume(value);
    }

    public function finish():void {
    }

}
}
