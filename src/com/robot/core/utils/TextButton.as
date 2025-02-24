package com.robot.core.utils
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextButton extends Sprite
   {
      private var _txt:TextField;
      
      private var _maskMc:Sprite;
      
      private var _bgMc:Sprite;
      
      private const DEFAULT_OUT_COLOR:uint = 65280;
      
      private const DEFAULT_OVER_COLOR:uint = 16711680;
      
      private const DEFAULT_SIZE:uint = 15;
      
      private const DEFAULT_BG_COLOR:uint = 0;
      
      private var _handler:Function;
      
      private var _textSize:uint;
      
      private var _textFormat:TextFormat;
      
      private var _bgColor:uint = 0;
      
      private var _over_color:uint;
      
      private var _out_color:uint;
      
      public function TextButton()
      {
         super();
         this._textSize = this.DEFAULT_SIZE;
         this._bgColor = this.DEFAULT_BG_COLOR;
         this._over_color = this.DEFAULT_OVER_COLOR;
         this._out_color = this.DEFAULT_OUT_COLOR;
         this._textFormat = new TextFormat();
         this._textFormat.underline = true;
         this._textFormat.size = this._textSize;
         this._txt = new TextField();
         this._bgMc = new Sprite();
         this._maskMc = new Sprite();
      }
      
      public function set overColor(color:uint) : void
      {
         this._over_color = color;
      }
      
      public function set outColor(color:uint) : void
      {
         this._out_color = color;
         this._txt.textColor = this._out_color;
      }
      
      public function set handler(fun:Function) : void
      {
         this._handler = fun;
      }
      
      public function set textSize(size:uint) : void
      {
         this._textSize = size;
         this._textFormat.size = this._textSize;
         this._txt.setTextFormat(this._textFormat);
      }
      
      public function set textFormat(textFormat:TextFormat) : void
      {
         this._textFormat = textFormat;
         this._txt.setTextFormat(this._textFormat);
         this._txt.width = this._txt.textWidth + 3;
         this._txt.height = this._txt.textHeight + 3;
         this.addBg(this._txt.width,this._txt.height);
         this.addMask(this._txt.width,this._txt.height);
      }
      
      public function set bgColor(color:uint) : void
      {
         this._bgColor = color;
         this._bgMc.graphics.clear();
         this._bgMc.graphics.lineStyle(1,0);
         this._bgMc.graphics.beginFill(this._bgColor);
         this._bgMc.graphics.drawRect(0,0,this._txt.width,this._txt.height);
         this._bgMc.graphics.endFill();
         this._bgMc.alpha = 0;
      }
      
      public function show(txt:String, textSize:uint = 15, handler:Function = null) : void
      {
         this._textSize = textSize;
         this._textFormat.size = this._textSize;
         this.showTxt(txt);
         this.addBg(this._txt.width,this._txt.height);
         this.addMask(this._txt.width,this._txt.height);
      }
      
      private function addBg(w:Number, h:Number) : void
      {
         this.addChildAt(this._bgMc,this.getChildIndex(this._txt));
         this._bgMc.graphics.clear();
         this._bgMc.graphics.lineStyle(1,0,0);
         this._bgMc.graphics.beginFill(this._bgColor);
         this._bgMc.graphics.drawRect(0,0,w,h);
         this._bgMc.graphics.endFill();
         this._bgMc.alpha = 0;
      }
      
      private function addMask(w:Number, h:Number) : void
      {
         this.addChild(this._maskMc);
         this._maskMc.graphics.clear();
         this._maskMc.graphics.lineStyle(1,0,0);
         this._maskMc.graphics.beginFill(0);
         this._maskMc.graphics.drawRect(0,0,w,h);
         this._maskMc.alpha = 0;
         this._maskMc.buttonMode = true;
         this._maskMc.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this._maskMc.addEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         this._maskMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function showTxt(txt:String) : void
      {
         this.addChild(this._txt);
         this._txt.textColor = this._out_color;
         this._txt.htmlText = txt;
         this._txt.setTextFormat(this._textFormat);
         this._txt.width = this._txt.textWidth + 3;
         this._txt.height = this._txt.textHeight + 3;
      }
      
      private function onOverHandler(e:MouseEvent) : void
      {
         if(Boolean(this._bgMc))
         {
            this._bgMc.alpha = 0.5;
         }
         if(Boolean(this._txt))
         {
            this._txt.textColor = this._over_color;
         }
      }
      
      private function onOutHandler(e:MouseEvent) : void
      {
         if(Boolean(this._bgMc))
         {
            this._bgMc.alpha = 0;
         }
         if(Boolean(this._txt))
         {
            this._txt.textColor = this._out_color;
         }
      }
      
      private function onClickHandler(e:MouseEvent) : void
      {
         if(this._handler != null)
         {
            this._handler();
         }
      }
      
      public function clear() : void
      {
         if(Boolean(this._maskMc))
         {
            this._maskMc.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
            this._maskMc.addEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
            this._maskMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.visible = false;
      }
      
      public function destroy() : void
      {
         this.clear();
         this._txt = null;
         this._maskMc = null;
         this._bgMc = null;
         this._handler = null;
         this._textFormat = null;
      }
   }
}

