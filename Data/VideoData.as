/**
 * Created with IntelliJ IDEA.
 * User: Oleg
 * Date: 27.01.15
 * Time: 23:36
 * To change this template use File | Settings | File Templates.
 */
package Data {
import com.adobe.serialization.json.JSON;

public class VideoData {

    private var _title:String;
    private var _description:String;
    private var _duration:uint;
    private var _date:Number;
    private var _viewCount:int;
    private var _imagel:String;
    private var _images:String;
    private var _videos:Vector.<VideoUrl>

    public function VideoData() {
    }

    private static function fixKeyQuotes(data:String):String{
        var fixedStr:String = "";

        var quotesOpened:Boolean = false;
        var quotesAdding:Boolean = false;
        var newPair:Boolean = false;

        for(var i:int = 0;i<data.length;i++){
            var char:String = data.charAt(i);

            //trace(data.charCodeAt(i)+"->"+data.charAt(i)+"<");

            if(!quotesOpened){
                if(char == "{" || char == ","){
                    newPair = true;
                }
            }

            if((data.charCodeAt(i) == 32 || data.charCodeAt(i) == 13 || data.charCodeAt(i) == 10 || data.charAt(i) == " " || data.charAt(i) == ":") && quotesAdding){
                quotesAdding = false;
                fixedStr += "\"";
            }

            if(data.charCodeAt(i) != 32 && data.charCodeAt(i) != 13 && data.charCodeAt(i) != 10 && data.charAt(i) != " " && data.charAt(i) != "{" && data.charAt(i) != "," && newPair){
                fixedStr += "\"";
                quotesAdding = true;
                newPair = false;
            }

            if(data.charAt(i) == "'"){
                fixedStr += "\"";
            }else{
                fixedStr += data.charAt(i);
            }
        }

        trace(data);
        trace(fixedStr);

        return fixedStr;
    }

    public static function parseJSON(dataString:String):VideoData{

        var data:Object = com.adobe.serialization.json.JSON.decode(fixKeyQuotes(dataString));

        var retData:VideoData = new VideoData();

        retData._title = data.title;
        retData._description = data.description;
        retData._duration = data.duration;
        retData._date = data.date;
        retData._imagel = data.photo_320;
        retData._images = data.photo_130;
        retData._viewCount = data.views;

        retData._videos = new Vector.<VideoUrl>();

        for(var name:String in data.files){
            var newFile:VideoUrl = new VideoUrl();

            newFile.name = name;
            newFile.res = int(name.replace("mp4_", ""));
            newFile.url = data.files[name];

            retData._videos.push(newFile);
        }

        return retData;
    }

    public function getAllowedResolution():Array{

        var retArray:Array = new Array();

        for(var i:int = 0;i<_videos.length;i++){
            retArray.push(_videos[i].res);
        }

        return retArray;
    }

    public function getVideoUrlByResolution(res:int):String{
        for(var i:int = 0;i< _videos.length;i++){
            if(_videos[i].res == res){
                return _videos[i].url;
            }
        }

        return null;
    }

    public function get title():String {
        return _title;
    }

    public function get description():String {
        return _description;
    }

    public function get duration():uint {
        return _duration;
    }

    public function get date():Number {
        return _date;
    }

    public function get viewCount():int {
        return _viewCount;
    }

    public function get():String{
        return _imagel;
    }

    public function get videos():Vector.<VideoUrl> {
        return _videos;
    }
}
}
