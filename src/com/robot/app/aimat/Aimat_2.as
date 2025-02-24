package com.robot.app.aimat
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.GeomUtil;
   
   public class Aimat_2 extends BaseAimat
   {
      private var speedPos:Point;
      
      private var ui:MovieClip;
      
      private var ui2:MovieClip;
      
      private var _sound:Sound;
      
      private var _sounds:SoundChannel;
      
      private var _soundt:SoundTransform = new SoundTransform(0.5);
      
      private var _sounde:Sound;
      
      private var _soundse:SoundChannel;
      
      public function Aimat_2()
      {
         super();
      }
      
      override public function execute(info:AimatInfo) : void
      {
         super.execute(info);
         this.ui = AimatController.getResEffect(_info.id);
         this.ui.x = _info.startPos.x;
         this.ui.y = _info.startPos.y;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         this.ui.rotation = GeomUtil.pointAngle(_info.endPos,_info.startPos);
         MapManager.currentMap.depthLevel.addChild(this.ui);
         this.speedPos = GeomUtil.angleSpeed(_info.endPos,_info.startPos);
         this.ui.addFrameScript(this.ui.totalFrames - 1,this.onEnter);
         if(AimatXMLInfo.getSoundStart(_info.id) == 0)
         {
            return;
         }
         this._sound = AimatController.getResSound(_info.id);
         this._sounds = this._sound.play(0,1,this._soundt);
         this._sounds.addEventListener(Event.SOUND_COMPLETE,this.compSoundHandler);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
         }
         this.speedPos = null;
         if(Boolean(this.ui2))
         {
            this.onEnd();
         }
      }
      
      private function compSoundHandler(e:Event) : void
      {
         this._sounds.removeEventListener(Event.SOUND_COMPLETE,this.compSoundHandler);
         this._sounds.stop();
         this._sound = null;
      }
      
      private function compSoundEndHandler(e:Event) : void
      {
         this._soundse.removeEventListener(Event.SOUND_COMPLETE,this.compSoundEndHandler);
         this._soundse.stop();
         this._sounde = null;
      }
      
      private function onEnter() : void
      {
         var obj:DisplayObject = null;
         if(AimatXMLInfo.getSoundEnd(_info.id) == 1)
         {
            this._sounde = AimatController.getResSound(_info.id,"_1");
            this._soundse = this._sound.play(0,1,this._soundt);
            this._soundse.addEventListener(Event.SOUND_COMPLETE,this.compSoundEndHandler);
         }
         this.ui.addFrameScript(this.ui.totalFrames - 1,null);
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         this.ui2 = AimatController.getResEffect(_info.id,"_1");
         this.ui2.x = _info.endPos.x;
         this.ui2.y = _info.endPos.y;
         this.ui2.mouseEnabled = false;
         this.ui2.mouseChildren = false;
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,this.onEnd);
         MapManager.currentMap.depthLevel.addChild(this.ui2);
         var list:Array = MapManager.getObjectsPointRect(_info.endPos,30,[IAimatSprite]);
         for each(obj in list)
         {
            if(obj is IAimatSprite)
            {
               IAimatSprite(obj).aimatState(_info);
            }
         }
      }
      
      private function onEnd() : void
      {
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui2);
         this.ui2 = null;
      }
   }
}

