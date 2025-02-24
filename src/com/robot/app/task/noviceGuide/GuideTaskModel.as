package com.robot.app.task.noviceGuide
{
   import com.robot.app.newspaper.NewsPaper;
   import com.robot.app.task.taskUtils.baseAction.GetTaskBuf;
   import com.robot.app.task.taskUtils.baseAction.SetTaskBuf;
   import com.robot.app.task.taskUtils.manage.TaskUIManage;
   import com.robot.core.CommandID;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   
   public class GuideTaskModel
   {
      private static var iconMc:SimpleButton;
      
      private static var bufTmp:String;
      
      private static var _loader:MCLoader;
      
      public static var statusAry:Array = [0,1,0,1,1];
      
      public static var bAcptTask:Boolean = false;
      
      public static const NOVICE_TASK_COMPLETE:String = "noviceTaskComplete";
      
      public static var bDone:Boolean = true;
      
      private static var PATH:String = "resource/task/novice.swf";
      
      public static var bTaskDoctor:Boolean = false;
      
      public static var bReadMonBook:Boolean = false;
      
      public static var bReadFlyBook:Boolean = false;
      
      public function GuideTaskModel()
      {
         super();
      }
      
      public static function checkTaskStatus() : void
      {
         var arr:Array = TasksManager.taskList;
         if(TasksManager.taskList[1] == 3 && TasksManager.taskList[2] == 0)
         {
            DoGuideTask.doTask();
            return;
         }
         if(TasksManager.taskList[2] == 0 || TasksManager.taskList[3] == 3)
         {
            return;
         }
         if(_loader == null)
         {
            loadGuideTaskUI();
         }
         else
         {
            getTaskBuf();
         }
      }
      
      private static function loadGuideTaskUI() : void
      {
         _loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在加载新手任务资源");
         _loader.addEventListener(MCLoadEvent.SUCCESS,onComplete);
         _loader.doLoad();
      }
      
      private static function onComplete(event:MCLoadEvent) : void
      {
         _loader.removeEventListener(MCLoadEvent.SUCCESS,onComplete);
         var app:ApplicationDomain = event.getApplicationDomain();
         TaskUIManage.loadHash.add(4,event.getLoader());
         if(iconMc == null)
         {
            iconMc = TaskUIManage.getButton("guideTaskIcon",4);
            iconMc.addEventListener(MouseEvent.CLICK,showTaskPanel);
            TaskIconManager.addIcon(iconMc);
            ToolTipManager.add(iconMc,"新船员任务");
         }
         getTaskBuf();
      }
      
      private static function onSetTaskBufOk(e:Event) : void
      {
         EventManager.removeEventListener(SetTaskBuf.SET_BUF_OK,onSetTaskBufOk);
         checkTaskStatus();
      }
      
      private static function getTaskBuf() : void
      {
         GetTaskBuf.taskId = 3;
         GetTaskBuf.getBuf();
         EventManager.addEventListener(GetTaskBuf.GET_TASK_BUF_OK,onGetBufOk);
      }
      
      private static function showTaskPanel(e:MouseEvent) : void
      {
         GuideTaskController.showPanel();
      }
      
      public static function submitTask() : void
      {
         bDone = true;
         for(var i:int = 0; i < statusAry.length; i++)
         {
            if(statusAry[i] != 1)
            {
               bDone = false;
               break;
            }
         }
         if(bDone && bReadMonBook)
         {
            SocketConnection.send(CommandID.COMPLETE_TASK,3,1);
         }
      }
      
      public static function removeIcon() : void
      {
         if(Boolean(iconMc))
         {
            TaskIconManager.delIcon(iconMc);
            ToolTipManager.remove(iconMc);
         }
      }
      
      public static function setGuideTaskBuf(index:uint, buf:String) : void
      {
         if(statusAry[index] == 1)
         {
            return;
         }
         if(TasksManager.taskList[2] == 1)
         {
            statusAry[index] = 1;
            setTaskBuf(buf);
         }
         if(TasksManager.taskList[0] != 3 && statusAry[0] == 1)
         {
            (NewsPaper.timeIcon["ball"] as MovieClip).play();
            (NewsPaper.timeIcon["ball"] as MovieClip).visible = true;
         }
      }
      
      public static function setTaskBuf(buf:String) : void
      {
         GetTaskBuf.taskId = 3;
         GetTaskBuf.getBuf();
         EventManager.addEventListener(GetTaskBuf.GET_TASK_BUF_OK,onChangeBuf);
         bufTmp = buf;
      }
      
      private static function onChangeBuf(e:Event) : void
      {
         EventManager.removeEventListener(GetTaskBuf.GET_TASK_BUF_OK,onChangeBuf);
         SetTaskBuf.taskId = 3;
         bufTmp += GetTaskBuf.taskBuf.buf;
         SetTaskBuf.buf = bufTmp;
         SetTaskBuf.setBuf();
         EventManager.addEventListener(SetTaskBuf.SET_BUF_OK,onSetTaskBufOk);
      }
      
      private static function onGetBufOk(e:Event) : void
      {
         EventManager.removeEventListener(GetTaskBuf.GET_TASK_BUF_OK,onGetBufOk);
         var bufStr:String = GetTaskBuf.buf;
         for(var i:int = 0; i < statusAry.length; i++)
         {
            if(bufStr.indexOf((i + 1).toString()) != -1)
            {
               statusAry[i] = 1;
            }
         }
         if(bufStr.indexOf("9") != -1)
         {
            bAcptTask = true;
         }
         if(bufStr.indexOf("8") != -1)
         {
            bTaskDoctor = true;
            statusAry[2] = 1;
         }
         if(bufStr.indexOf("7") != -1)
         {
            bReadMonBook = true;
         }
         if(bufStr.indexOf("6") != -1)
         {
            bReadFlyBook = true;
         }
         if(TasksManager.taskList[0] == 3)
         {
            statusAry[0] = 1;
         }
         if(TasksManager.taskList[0] != 3 && statusAry[0] == 1)
         {
            (NewsPaper.timeIcon["ball"] as MovieClip).visible = true;
            (NewsPaper.timeIcon["ball"] as MovieClip).play();
         }
      }
   }
}

