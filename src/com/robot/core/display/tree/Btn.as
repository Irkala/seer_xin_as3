package com.robot.core.display.tree
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class Btn extends EventDispatcher
   {
      private var _display:Sprite;
      
      private var _name:String;
      
      private var _marked:Boolean;
      
      private var _data:INode;
      
      private var _item:DisplayObject;
      
      public function Btn(name:String, item:DisplayObject, data:INode)
      {
         super();
         this._data = data;
         this._item = item;
         this._name = name;
         this._display = new Sprite();
         this._display.mouseChildren = false;
         this._display.buttonMode = true;
         this._display.addChild(item);
         this.addListeners();
         this.unmark();
      }
      
      private function addListeners() : void
      {
         this._display.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this._display.addEventListener(MouseEvent.ROLL_OVER,this.onRollover,false,0,true);
         this._display.addEventListener(MouseEvent.ROLL_OUT,this.onRollout,false,0,true);
      }
      
      private function onRollout(event:MouseEvent = null) : void
      {
         if(!this._marked)
         {
            (this._item["bg"] as MovieClip).gotoAndStop(1);
         }
      }
      
      private function onRollover(event:MouseEvent = null) : void
      {
         if(!this._marked)
         {
            (this._item["bg"] as MovieClip).gotoAndStop(2);
         }
      }
      
      public function mark() : void
      {
         this.onRollover();
         if(!(this._data as StatefulNode).hasOpenChilds())
         {
            if((this._data as StatefulNode).children.length > 0)
            {
               (this._item["bg"] as MovieClip).gotoAndStop(1);
            }
            else
            {
               (this._item["bg"] as MovieClip).gotoAndStop(3);
            }
         }
         else
         {
            (this._item["bg"] as MovieClip).gotoAndStop(3);
         }
         this._marked = true;
      }
      
      public function unmark() : void
      {
         this._marked = false;
         this.onRollout();
      }
      
      private function onClick(event:MouseEvent) : void
      {
         dispatchEvent(event.clone());
      }
      
      public function get display() : DisplayObject
      {
         return this._display;
      }
      
      public function get nameID() : String
      {
         return this._name;
      }
      
      public function get data() : *
      {
         return this._data.data;
      }
   }
}

