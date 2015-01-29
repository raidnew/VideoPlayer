/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 28.01.15
 * Time: 0:51
 * To change this template use File | Settings | File Templates.
 */
package {
import Controls.VideoHudEvent;
import Controls.VideoProgressBar;
import Controls.VolumeControl;

import flash.display.Sprite;
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

    public function VideoControl(videoScreen:IVideoPlayer) {
        _screen = videoScreen;
        init();
    }

    public function init():void{
        _container = new Sprite();

        _currentTime = 0;
        _totalDuration = 0;

        _progressBar = new VideoProgressBar();
        _progressBar.y = 280;
        _progressBar.x = 50;

        _volumeControl = new VolumeControl();
        _volumeControl.y = 100;
        _volumeControl.x = 340;

        _rotationScreen = new VolumeControl();
        _rotationScreen.y = 280;
        _rotationScreen.x = 450;

        _progressBar.addEventListener(VideoHudEvent.REWIND, _onRewindHandler)
        _volumeControl.addEventListener(VideoHudEvent.VOLUME, _onVolumeHandler)
        _rotationScreen.addEventListener(VideoHudEvent.VOLUME, _onRotationHandler)

        _selectResolution = new SelectResolution(setResolution);
        _selectResolution.y = 40;
        _selectResolution.x = 380;

        _playBtn = new Sprite();
        _playBtn.graphics.beginFill(0xAAFFAA);
        _playBtn.graphics.drawCircle(0,0,20);
        _playBtn.x = 20;
        _playBtn.y = 280;
        _playBtn.addEventListener(MouseEvent.CLICK, playClickHandler);

        _pauseBtn = new Sprite();
        _pauseBtn.graphics.beginFill(0xFFAAAA);
        _pauseBtn.graphics.drawCircle(0,0,20);
        _pauseBtn.x = 20;
        _pauseBtn.y = 280;
        _pauseBtn.addEventListener(MouseEvent.CLICK, pauseClickHandler);

        _fullScreenBtn = new Sprite();
        _fullScreenBtn.graphics.beginFill(0x000000);
        _fullScreenBtn.graphics.drawRect(0,0,50,50);
        _fullScreenBtn.x = 380;
        _fullScreenBtn.y = 260;
        _fullScreenBtn.addEventListener(MouseEvent.CLICK, fullScreenHandler);

        _container.addChild(_volumeControl);
        _container.addChild(_rotationScreen);
        _container.addChild(_progressBar);
        _container.addChild(_selectResolution);
        _container.addChild(_playBtn);
        _container.addChild(_pauseBtn);
        _container.addChild(_fullScreenBtn);


    }

    private function _onRotationHandler(event:VideoHudEvent):void {
        _screen.screenRotation(event.data * 360);
    }

    private function fullScreenHandler(event:MouseEvent):void {
        _screen.fullScreen(true);
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
}
}
