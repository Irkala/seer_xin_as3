package com.robot.core.skeleton
{
   import com.robot.core.config.xml.DoodleXMLInfo;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISkeletonSprite;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.taomee.utils.DisplayUtil;
   
   public class EmptySkeletonStrategy implements ISkeleton
   {
      protected var _people:ISkeletonSprite;
      
      protected var skeletonMC:MovieClip;
      
      protected var composeMC:MovieClip;
      
      protected var nameTxt:TextField;
      
      private var _isPlaying:Boolean = false;
      
      private var clothPrev:SkeletonClothPreview;
      
      protected var _clickBtn:SimpleButton;
      
      private var _info:UserInfo;
      
      protected var _shadowMc:MovieClip;
      
      public function EmptySkeletonStrategy()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this.skeletonMC = UIManager.getMovieClip("empty_body");
         this.skeletonMC.mouseChildren = false;
         this.skeletonMC.cacheAsBitmap = true;
         this.composeMC = this.skeletonMC["compose"];
         this.composeMC.mouseChildren = false;
         this.nameTxt = this.skeletonMC["name_txt"];
         this._clickBtn = this.skeletonMC["clickBtn"];
         this._shadowMc = this.skeletonMC["q_mc"];
         this.nameTxt.mouseEnabled = false;
         this.nameTxt.autoSize = TextFieldAutoSize.CENTER;
         this.skeletonMC.mouseEnabled = false;
         this.skeletonMC.cacheAsBitmap = true;
         DisplayUtil.removeForParent(this.nameTxt);
      }
      
      public function set info(info:UserInfo) : void
      {
         this._info = info;
         this._people.changeCloth(this._info.clothes,false);
         this.changeColor(this._info.color);
         if(this._info.texture != 0)
         {
            this.changeDoodle(DoodleXMLInfo.getSwfURL(this._info.texture));
         }
      }
      
      public function get shadowMc() : MovieClip
      {
         return this._shadowMc;
      }
      
      public function getSkeletonMC() : MovieClip
      {
         return this.skeletonMC;
      }
      
      public function getBodyMC() : MovieClip
      {
         return this.composeMC;
      }
      
      public function play() : void
      {
         if(this._isPlaying)
         {
            return;
         }
         this._isPlaying = true;
         this.clothPrev.play();
         this._people.sprite.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function stop() : void
      {
         this._isPlaying = false;
         this._people.sprite.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.clothPrev.stop();
      }
      
      public function onEnterFrame(e:Event) : void
      {
         if(!this._isPlaying)
         {
            return;
         }
         this.clothPrev.onEnterFrame();
      }
      
      public function changeDirection(dir:String) : void
      {
         this.clothPrev.changeDirection(dir);
      }
      
      public function changeCloth(clothArray:Array) : void
      {
         this.clothPrev.changeCloth(clothArray);
      }
      
      public function takeOffCloth() : void
      {
         this.clothPrev.takeOffCloth();
      }
      
      public function changeColor(color:uint, isTexture:Boolean = true) : void
      {
         this.clothPrev.changeColor(color,isTexture);
      }
      
      public function changeDoodle(url:String) : void
      {
         this.clothPrev.changeDoodle(url);
      }
      
      public function specialAction(peopleMode:BasePeoleModel, id:int) : void
      {
         this.clothPrev.specialAction(peopleMode,id);
      }
      
      public function get people() : ISkeletonSprite
      {
         return this._people;
      }
      
      public function set people(i:ISkeletonSprite) : void
      {
         this._people = i;
         this._people.clearOldSkeleton();
         this._people.sprite.addChild(this.skeletonMC);
         this.clothPrev = new SkeletonClothPreview(this.composeMC,this._people);
         this.clothPrev.changeDefaultCloth();
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.skeletonMC);
         this.skeletonMC = null;
         this.composeMC = null;
         this.nameTxt = null;
         this._clickBtn = null;
         this.clothPrev.destroy();
         this.clothPrev = null;
         this._people = null;
      }
   }
}

