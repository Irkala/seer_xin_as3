package com.robot.app.task.noviceGuide
{
   import com.robot.app.task.taskUtils.manage.TaskUIManage;
   import com.robot.app.task.taskUtils.taskDialog.TaskBaseDialog;
   import flash.display.MovieClip;
   
   public class ShiperUnReadDialog
   {
      private static var sDialog:MovieClip;
      
      private static var _fun:Function;
      
      public function ShiperUnReadDialog()
      {
         super();
      }
      
      public static function show(str:String = "", fun:Function = null) : void
      {
         sDialog = TaskUIManage.getMovieClip("shiperUnread",4);
         TaskBaseDialog.dialogMC = sDialog;
         TaskBaseDialog.showNpcImgDialog(str,fun);
      }
   }
}

