package {

import Data.DataLoader;
import Data.VideoData;
import Data.VideoStream;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.FullScreenEvent;
import flash.text.TextField;

import org.osmf.layout.ScaleMode;

public class Main extends Sprite {
    public function Main() {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        new DataLoader(_dataLoaded).load("http://mu57di3.org/file.json");
    }

    private function _dataLoaded(data:VideoData):void{
        var videoScreen:VideoPlayer = new VideoPlayer();
        videoScreen.setData(data);
        addChild(videoScreen);
    }
}
}
