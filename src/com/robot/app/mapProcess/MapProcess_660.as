package com.robot.app.mapProcess
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_660 extends BaseMapProcess
   {
      private var _b:Boolean;
      
      public function MapProcess_660()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      override public function destroy() : void
      {
      }
      
      public function onFirstHit() : void
      {
      }
      
      private function onFrameHandler(e:Event) : void
      {
         if(conLevel["third"]["mc2"].totalFrames == conLevel["third"]["mc2"].currentFrame)
         {
            conLevel["third"]["mc2"]["mc"].buttonMode = true;
            conLevel["third"]["mc2"].removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
            conLevel["third"]["mc2"]["mc"].addEventListener(MouseEvent.CLICK,this.onThirdHit);
         }
      }
      
      public function onSecondHit() : void
      {
      }
      
      public function onThirdHit(e:MouseEvent) : void
      {
         (e.currentTarget as MovieClip).visible = false;
      }
      
      private function onTalkEventHandler(e:Event) : void
      {
         setTimeout(function():void
         {
            NpcTipDialog.show("可恶的叛徒，你又来做什么？我不会怕你的！",function():void
            {
               NpcTipDialog.show("我想这是你们要的东西……",function():void
               {
                  var panel:MovieClip = null;
                  panel = MapLibManager.getMovieClip("XinpianPanel");
                  LevelManager.appLevel.addChild(panel);
                  DisplayUtil.align(panel,null,AlignType.MIDDLE_CENTER);
                  panel["confirmBtn"].addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
                  {
                     panel.removeEventListener(MouseEvent.CLICK,arguments.callee);
                     DisplayUtil.removeForParent(panel);
                     panel = null;
                     NpcTipDialog.show("这个核心芯片难道是？",function():void
                     {
                        NpcTipDialog.show("......",function():void
                        {
                           depthLevel["npc_mc"].gotoAndPlay(45);
                           TasksManager.complete(72,2,function(bool:Boolean):void
                           {
                              if(bool)
                              {
                                 conLevel["third"].visible = false;
                              }
                           });
                        },NpcTipDialog.DIEN_1,-60,null,null,false);
                     },NpcTipDialog.SEER,-60,null,null,false);
                  });
               },NpcTipDialog.DIEN_1,-60,null,null,false);
            },NpcTipDialog.SEER,-60,null,null,false);
         },2000);
      }
   }
}

