/**
  * SMARTvendX class, SMARTvendX.js
  * Clobal Object and Variant management
  *
  * @author smart prepayment
  * @copyright inhemeter
  * @license 
  * @version 0.1
  *
  */
  
//1、命名空间注册工具类
if (typeof(Namespace)!="object")
{
    var Namespace = new Object();
    
    Namespace.register = function(path) {
        var arr = path.split(".");
        var ns = "";
        for ( var i = 0; i < arr.length; i++) {
            if (i > 0)
                ns += ".";
            ns += arr[i];
            eval("if(typeof(" + ns + ") == 'undefined') " + ns + " = new Object();");
        }
    }
}
//2、注册命名空间 
Namespace.register("INHE.spms");

//3、使用命名空间
INHE.spms.SMARTvendX = function()
{
    this.hasSVX_CRTL = false;
    this.readEvent = null;
    this.SVX_CRTL = null;
    
    this.detectSVX = function()
    {
        try 
        {
           var comActiveX = new ActiveXObject('SMARTvendX.SmartX'); // 判断IE是否已经安装插件
        } 
        catch (e) 
        {
            return false;
        }
        comActiveX = null;
        return true;
        
    }
    this.createSVX = function()
    {
        var myObject = document.createElement('object');
        document.body.appendChild(myObject);
        
        myObject.id = "SVX_CRTL";
        myObject.classid= "clsid:5E9A9D76-DA15-4447-AE3B-1771674099E6";
        
        SVX_CRTL.visible = false;
        this.SVX_CRTL = SVX_CRTL;    
    }
    this.destroySVX = function()
    {
        this.SVX_CRTL = null;                
    }
    
    this.startMagcard = function(){
        if (!this.hasSVX_CRTL) return;
       
        this.SVX_CRTL.ActiveMagcard = true;
    }
    
    this.stopMagcard = function()
    {
        if (!this.hasSVX_CRTL) return;
        this.SVX_CRTL.ActiveMagcard = false;
    }     
    this.resetMagcard = function()
    {
        if (!this.hasSVX_CRTL) return;
        this.SVX_CRTL.ResetMagcard();
    }
    
    this.readMagcard = function(mode,readEvent){
        if (!this.hasSVX_CRTL) return;
        this.readEvent = readEvent;
        this.SVX_CRTL.readMagcard(mode);
    }
    
    this.ReadMagcardEvent = function (data)
    {
        this.readEvent(data);
    }
    
    this.MessageEvent = function (msgID,msgData)
    {
        message = "";
        switch (msgID)
        {
            case -1000:
                message = "Invalid Card Number.\n"+msgData;        
                break;
            case -1001:
                message = "The card has expired.\n"+msgData;        
                break;
                
        }
       alert(message);   
    }
    
    this.enumCommPort = function()
    {
        if (!this.hasSVX_CRTL) return "";
        return this.SVX_CRTL.EnumCommPort();
    }
    
    this.getMCOptionsEx = function()
    {
        if (!this.hasSVX_CRTL) return "";
        return this.SVX_CRTL.GetMCOptionsEx();
    }
    
    this.setMCOptions = function(actived,commPort,baudRate)
    {
        if (!this.hasSVX_CRTL) return false;
        this.SVX_CRTL.SetMCOptions(actived,commPort,baudRate);
        return true;
    }
};





