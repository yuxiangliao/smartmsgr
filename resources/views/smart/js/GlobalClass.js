/**
  * GlobalClass class, Global.js
  * Clobal Object and Variant management
  *
  * @author smart prepayment
  * @copyright inhemeter
  * @license 
  * @version 0.1
  *
  */


/**
* 删除左右两端的空格
*/

String.prototype.replaceAll = function(search, replace)
{  
	var regex = new RegExp(search, "g");  
	return this.replace(regex, replace);  
}  
String.prototype.trim=function()
{
    return this.replace(/(^\s*)|(\s*$)/g, '');
}
/**
* 删除左边的空格
*/
String.prototype.ltrim=function()
{
     return this.replace(/(^\s*)/g,'');
}
/**
* 删除右边的空格
*/
String.prototype.rtrim=function()
{
     return this.replace(/(\s*$)/g,'');
}

//屏蔽鼠标右键、Ctrl+N、Shift+F10、F5刷新、退格键
function evtKeyDown()
{
    //alert(window.event.keyCode)
    if ((window.event.altKey)&&
        ((window.event.keyCode==37)|| //屏蔽 Alt+ 方向键 ←
        (window.event.keyCode==39))){ //屏蔽 Alt+ 方向键 →
        event.returnvalue=false;
    }
    
    /* 注：这还不是真正地屏蔽 Alt+ 方向键，
    因为 Alt+ 方向键弹出警告框时，按住 Alt 键不放，
    用鼠标点掉警告框，这种屏蔽方法就失效了。以后若
    有哪位高手有真正屏蔽 Alt 键的方法，请告知。*/
    
    if ((event.keyCode == 8) &&
    (event.srcElement.type != "text" &&
    event.srcElement.type != "textarea" &&
    event.srcElement.type != "password") || //屏蔽退格删除键
    (event.keyCode ==116)|| //屏蔽 F5 刷新键
    (event.ctrlKey && event.keyCode==82)){ //Ctrl + R
    event.keyCode=0;
    event.returnvalue=false;
    }
    if ((event.ctrlKey)&&(event.keyCode==78)) //屏蔽 Ctrl+n
    event.returnvalue=false;
    if ((event.shiftKey)&&(event.keyCode==121)) //屏蔽 shift+F10
    event.returnvalue=false;
    if (window.event.srcElement.tagName == "A" && window.event.shiftKey)
    window.event.returnvalue = false; //屏蔽 shift 加鼠标左键新开一网页
    if ((window.event.altKey)&&(window.event.keyCode==115)){ //屏蔽Alt+F4
    window.showModelessDialog("about:blank","","dialogWidth:1px;dialogheight:1px");
    return false;}
    
}        


//格式化日期时间  
Date.prototype.format = function(format) //author: add by cz 
{ 
  var o = { 
    "M+" : this.getMonth()+1, //month 
    "d+" : this.getDate(),    //day 
    "h+" : this.getHours(),   //hour 
    "m+" : this.getMinutes(), //minute 
    "s+" : this.getSeconds(), //second 
    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter 
    "S" : this.getMilliseconds() //millisecond 
  } 
  if(/(y+)/.test(format)) format=format.replace(RegExp.$1, 
    (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
  for(var k in o)if(new RegExp("("+ k +")").test(format)) 
    format = format.replace(RegExp.$1, 
      RegExp.$1.length==1 ? o[k] : 
        ("00"+ o[k]).substr((""+ o[k]).length)); 
  return format; 
} 
//格式化字符串
String.prototype.format = function(args) {
    var result = this;
    if (arguments.length > 0) {    
        if (arguments.length == 1 && typeof (args) == "object") {
            for (var key in args) {
                if(args[key]!=undefined){
                    var reg = new RegExp("({" + key + "})", "g");
                    result = result.replace(reg, args[key]);
                }
            }
        }
        else {
            for (var i = 0; i < arguments.length; i++) {
                if (arguments[i] != undefined) {
                    var reg = new RegExp("({[" + i + "]})", "g");
                    result = result.replace(reg, arguments[i]);
                }
            }
        }
    }
    return result;
}
 //两种调用方式
 //var template1="我是{0}，今年{1}了";
 //var template2="我是{name}，今年{age}了";
 //var result1=template1.format("loogn",22);
 //var result2=template2.format({name:"loogn",age:22});
 //两个结果都是"我是loogn，今年22了"
 

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
Namespace.register("INHE.spms.global");

//3、使用命名空间
INHE.spms.global.GlobalClass = function() {
    
    this.XMLHEAD = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";

    this._XMLDoc = null;
    this._parameters = null;
    try
    {
        if (parent.globalClass==null)
           this.mainFrame = parent.parent;
        else
           this.mainFrame = parent.globalClass.mainFrame;
    }
    catch(e)
    {
        this.mainFrame = null;
    }
    
    this.langSendFailed = "send data failed,please try again!";
    this.langSendOK = "send data successful!";
    this.langOK = "OK";
    this.langCancel = "Cancel";
    this.langNotice = "Information";
    this.langConfirm = "Confirm";
    
    this.currModuleID = "";

    //Get A XMLDocument
    this.xmlDoc = function() {
        try //Internet Explorer
        {
          this._XMLDoc = new ActiveXObject("Microsoft.XMLDOM");
          this._XMLDoc.async="false";
        }
        catch(e)
        {
            try //Firefox, Mozilla, Opera, etc.
            {
                parser=new DOMParser();
                this._XMLDoc = parser.parseFromString(text,"text/xml");
            }
            catch(e) {alert(e.message)}
        }       
        return this._XMLDoc; 
    }
    //create a default xml text with xmlHead
    this.xmlDefaultHead = function()
    {
        return this.XMLHEAD+"<xml/>";
    }
    //create a child node for parent node;
    this.CreateXMLNode = function(xmlDoc,parentNode,nodeName,nodeValue)
    {
        
        var xmlNode, xmlNode1;
        xmlNode = xmlDoc.createElement(nodeName);
        if (nodeValue != null && nodeValue != "") 
        {
            xmlNode1 = xmlDoc.createTextNode(nodeValue);
            xmlNode.appendChild(xmlNode1);
        }
        parentNode.appendChild(xmlNode);
        return xmlNode;
    }
    //create a arribute node for parent node;
    this.CreateXMLAttribute = function (xmlDoc,xmlRoot,nodeName,nodeValue)
    {
        var Result = xmlDoc.createAttribute(nodeName);
        Result.nodeValue = nodeValue;
        xmlRoot.attributes.setNamedItem(Result);
        return Result;
    }

    this.CreateXMLCondition = function(xmlDoc,xmlRoot,sFiled,sValue,sSymbol,sFlag)
    {
        if (typeof(sSymbol)=="undefined")
            sSymbol = "=";
        if (typeof(sFlag)=="undefined")
            sFlag = "";
        Result = this.CreateXMLNode(xmlDoc, xmlRoot, 'condition', null);
        this.CreateXMLAttribute(xmlDoc, Result, 'field', sFiled);
        this.CreateXMLAttribute(xmlDoc, Result, 'flag', sFlag);
        this.CreateXMLAttribute(xmlDoc, Result, 'symbol', sSymbol);
        this.CreateXMLAttribute(xmlDoc, Result, 'value', sValue);
        return Result;
    }
    
    this.createJSONCondition = function (sFiled,sValue,sSymbol,sFlag)
    {
        condition = {};
        if (typeof(sSymbol)=="undefined")
            sSymbol = "=";
        if (typeof(sFlag)=="undefined")
            sFlag = "";
        condition.field = sFiled;
        condition.flag = sFlag;
        condition.symbol = sSymbol;
        condition.value = sValue;
        return condition;
    }
    
    this.enumCommPort = function()
    {
        if (this.mainFrame != null )
        {
            return this.mainFrame.SMARTvendX.enumCommPort();
        }
    }
    
    this.getSMARTvendX = function()
    {
        if (this.mainFrame != null )
        {
            return this.mainFrame.SMARTvendX;
        }
        return null;
    }
    
    this.readMagcard = function (mode,readEvent)
    {
        
        if (this.mainFrame != null )
        {
            this.mainFrame.SMARTvendX.startMagcard();
            this.mainFrame.SMARTvendX.readMagcard(mode,readEvent);
            return;   
        }
    }
    this.resetMagcard = function ()
    {
        if (this.mainFrame != null )
        {
            this.mainFrame.SMARTvendX.resetMagcard();
            this.mainFrame.SMARTvendX.stopMagcard();
            return;   
        }
    }
    
    this.changeLanguage = function(lang)
    {
        if (this._parameters != null)
            this._parameters.LANGUAGE = lang;
    }
    
    this.redirectURL = function(sUrl)
    {
        window.location = sUrl;
    }
    //NOTICE THE TEXT TO USER
    this.noticeText = function (sText,lifeTime,sType)
    {
        if (typeof(lifeTime)=="undefined")
            lifeTime=0;
        
        sText = this.toHTML(sText);
        if (this.mainFrame != null  && this.mainFrame.globalClass != this)
            this.mainFrame.globalClass.noticeText(sText,lifeTime,sType);
        else
        {
            //$.messager.progress();
           // return;
            $.messager.show({
				title:this.langNotice,
            	msg:sText,
                width: 300,
                height: 180,

            	timeout:lifeTime,
            	showType:'slide'
 			});
        }
    }
    this.toHTML = function (sText)
    {
        return String(sText).replace("\n","<br />")
    }
    
    this.toJSON = function (o){
       var r = [];
       if(typeof o == "string" || o == null) {
         return o;
       }
       if(typeof o == "object"){
         if(!o.sort){
           r[0]="{"
           for(var i in o){
             r[r.length]=i;
             r[r.length]=":";   
             r[r.length]=this.toJSON(o[i]);
             r[r.length]=",";
           }
           r[r.length-1]="}"
         }else{
           r[0]="["
           for(var i =0;i<o.length;i++){
             r[r.length]=this.toJSON(o[i]);
             r[r.length]=",";
           }
           r[r.length-1]="]"
         }
         return r.join("");
       }
       return o.toString();
    }
    
    this.alert = function(sText,fsIcon,fsCallBack)
    {
        //warning,question,error,info
        if (typeof(fsIcon)=="undefined" || fsIcon==null ||  fsIcon=="")
            fsIcon = "info";
        
        sText = this.toHTML(sText);
        if (this.mainFrame != null  && this.mainFrame.globalClass != this)
            this.mainFrame.globalClass.alert(sText,fsIcon,fsCallBack);
        else
        {
            if ($.messager!=null)
            {
                $.messager.alert(this.langNotice,sText,fsIcon,fsCallBack);
                ctrls = $("a[class='l-btn']");
                if ( ctrls.length > 0)
                {
                    ctrls.focus();
                };
            }
            else
                alert(sText);
        }
        
    }
    this.confirm = function(sText,fsCallBack)
    {
        if (this.mainFrame != null && this.mainFrame.globalClass != this)
            this.mainFrame.globalClass.confirm(sText,fsCallBack);
        else
        {   
			$.messager.confirm('Confirm', sText, function(result){
				if (result){
					fsCallBack();
				}
			});
            ctrls = $("a[class='l-btn']");
            if ( ctrls.length > 0)
            {
                ctrls[0].focus();
            };
            
        }
    }
    this.prompt = function(sTitle,sText,fsCallBack)
    {
        if (this.mainFrame != null && this.mainFrame.globalClass != this)
            this.mainFrame.globalClass.prompt(sTitle,sText,fsCallBack);
        else
        {
			$.messager.prompt(sTitle, sText, fsCallBack);
        }
    }
    
    this.execDialog = function(id,title,W,H,lock,okCallback,cancelCallback)
    {
        if (H==null) H = 400;
        addWin = new Ext.Window({ 
            id: 'addRoleWin', 
            //contentEl:'dlgCstRegContent',
            title: title, 
            autoScroll :true,
            width: W, 
            height: H, 
            //背景遮罩 
            modal: true, 
            //重置大小 
            resizable: true, 
            html:'<div id = "'+id+'Content"></div>',
            plain: true, 
            buttonAlign: 'center', 
            buttons: 
            [ 
                { text: this.langOK, handler: function (){
                    if (okCallback())
                        Ext.getCmp('addRoleWin').hide(); 
                    }
                }, 
                { text: this.langCancel,handler: function() { Ext.getCmp('addRoleWin').hide(); }  } 
            ] 
        }); 
        addWin.show(); 
        
    }
    this.execDialogEx = function(url,title,W,H,lock,okCallback,cancelCallback,extraParams)
    {
        if (this.mainFrame != null && this.mainFrame.globalClass != this)
            this.mainFrame.globalClass.execDialogEx(url,title,W,H,lock,okCallback,cancelCallback,extraParams);
        else
        {
            
            if (H==null) H = 400;
            $('#mydialog_1').window({
				title: title,
				width: W,
                minimizable:false,
                height: H,
				modal: true,
				shadow: false,
				closed: false,
                onClose:function()
                {
                    $("#btndialog_ok").unbind("click");    
                    $("#btndialog_cancel").unbind("click");
                }
			});
            
            bodyW = document.body.offsetWidth;
            bodyH = document.body.offsetHeight;
            bodyH = bodyH > 0 ? bodyH : document.body.clientHeight;
            bodyW = parseInt(bodyW/2 - W/2);
            bodyH = parseInt(bodyH/2 - H/2);
            $('#mydialog_1').window('resize',{width:W,height:H,left:bodyW,top:bodyH});
            $('#mydialog_1').window('open');
            $('#btndialog_ok').focus();
            
            $("#test12").load(url+"?timeID="+Math.random(),extraParams);
            $("#btndialog_ok").bind("click", function(){
                if (doDialogOK(okCallback))
                {
                    $('#mydialog_1').window('close');
                    $("#test12").empty();  
                }
            });
            $("#btndialog_cancel").bind("click", function(){
                $('#mydialog_1').window('close');
                $("#test12").empty();  
            })
        }
    }
    
    //covert Datetime To String
    this.FormatDateTime = function(fmt,dateTime)
    {
        var o = { 
            "M+" : dateTime.getMonth()+1,                 //月份 
            "d+" : dateTime.getDate(),                    //日 
            "h+" : dateTime.getHours(),                   //小时 
            "m+" : dateTime.getMinutes(),                 //分 
            "s+" : dateTime.getSeconds(),                 //秒 
            "q+" : Math.floor((dateTime.getMonth()+3)/3), //季度 
            "S"  : dateTime.getMilliseconds()             //毫秒 
        }; 
        if(/(y+)/.test(fmt)) 
        fmt=fmt.replace(RegExp.$1, (dateTime.getFullYear()+"").substr(4 - RegExp.$1.length)); 
        for(var k in o) 
            if(new RegExp("("+ k +")").test(fmt)) 
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
        return fmt; 
    }
    
    //covert bool to string as "Y" or "N"
    this.BoolToStr = function (value){
        if (typeof(value)=="undefined")
            return "N";
        if (value)
            return "Y";
        else
            return "N";
    }
    
    //covert string of "Y" or "N" to bool as true or false
    this.StrToBool = function(value)
    {
        return (value=="Y");
    }
    
    //covert string to float value
    this.StrToFloat = function (value)
    {
        if (typeof(value)=="undefined")
            return 0;
        var result = parseFloat(value);
        if (isNaN(result))
            return 0;
        return result;
        
    }

    //covert string to int value
    this.StrToInt = function (value)
    {
        if (typeof(value)=="undefined")
            return 0;
        var result = parseInt(value);
        if (isNaN(result))
            return 0;
        return result;
    }
    this.hoverRow = function(sender,isOver,clsName)
    {
        if (typeof(sender)=="undefined") return;
        if (typeof(isOver)=="undefined") return;
        if (typeof(clsName)=="undefined" || clsName == "") 
            clsName = "TableHover";
            
        if (isOver)
            $(sender).addClass(clsName);
        else 
            $(sender).removeClass(clsName);
    }
    this.showProgress = function(objName,showed)
    {
        if (typeof(objName)=="undefined" || objName == "") 
        {
            objName = "va_progress";
        }
        if (typeof(showed)=="undefined")
            showed = true;
        
        obj = $("#"+objName);
        if (obj.length == 0) return;
        if (showed)
        {
            obj.css("z-index","2000");
            sw = document.body.clientWidth / 2 - 20;
            obj.css("left",sw);
            sw = document.documentElement.clientHeight / 2 - 20;
            obj.css("top",sw);
            obj.css("display","");
        }
        else
            obj.css("display","none");
        
    }
    
    this.showControl = function(objName,sCtrl)
    {
        if (typeof(objName)=="undefined" || objName == "") return;
        if (typeof(sCtrl)=="undefined")
            sCtrl = true;               
        else 
        if (typeof(sCtrl)=="boolean")
        {
                           
        } 
        else
        if (typeof(sCtrl)=="string" & (sCtrl != "hide" && sCtrl != "")) 
            sCtrl = true;
        else
            sCtrl = false;
            
        obj = $("#"+objName);
        if (obj.length == 0) return;
        if (sCtrl)
           sCtrl = "";
        else
           sCtrl = "none";
        
        obj.css("display",sCtrl);
    }
    this.showhideControl = function(objName)
    {
        if (typeof(objName)=="undefined" || objName == "") return;
        obj = $("#"+objName);
        if (obj.length == 0) return;
        obj.toggleClass("hide");
    }
    this.clearValue = function (objNames)
    {
        objArray = objNames.split(",");
        for (i in objArray)
        {
            $("#"+objArray[i]).val("");
        }
    }
    this.prepareReport = function(rptFile,rptParams,rptType)
    {
        
        if (typeof(rptType)=="undefined")
            rptType = 2;
        if (this.mainFrame != null && this.mainFrame.globalClass != this)
        {
            return this.mainFrame.globalClass.prepareReport(rptFile,rptParams,rptType);
        }
        try 
        {
            with (globalClass._parameters)
            {
                if (LANGUAGE=="")
                    LANGUAGE = "en";
                    
                if (rptParams=="")
                    rptParams = "LANG="+LANGUAGE;
                else
                    rptParams += "|LANG="+LANGUAGE;
                switch (rptType)
                {
                    case 0:
                    case 2://Report ActiveX by Internet Explorer,without previewer
                        if (rptType==0)
                        {
                            try
                            {
                                
                                printer = new ActiveXObject("RptViewer.ReportViewer");
                                printer.HostAddress = document.domain;
                                printer.InitReport(RPT_HOST,parseInt(RPT_PORT),'','',RPT_TYPE);
            
                                isOK = printer.PrintReport(rptFile,rptParams);
                                printer = null;
                                return isOK;
                            }
                            catch (e)
                            {
                            }
                        }
                        break;
                    case 1://New Dialog for ActiveX
                        try
                        {
                            printer = new ActiveXObject("RptViewer.ReportViewer");
                            printer = null;
                            sURL = "report/rptViewer.php?rptFile="+rptFile+"&rptParams="+rptParams;
                            globalClass.showDialog(sURL,null,null,true);
                            return true;      
                        }
                        catch (e)
                        {
                        }
                        break;
                }
                //New Dialog for HTML previewer
                rptParams = rptParams.replace(/\|/g,"&");
                rptFile = RPT_TYPE+"/"+rptFile;
                sURL = "http://"+RPT_HOST ;
                if (RPT_PORT != "80") 
                    sURL += ":"+RPT_PORT;
                sURL += "/result?report="+rptFile+"&mulipage=0&"+rptParams;
                sTime = new Date(); 
                sURL += "&"+sTime.getSeconds()+""+ sTime.getMilliseconds();
                globalClass.showDialog(sURL,null,null,true);      
                return true;      
                
            } 
          
        }
        catch(e)
        {
          globalClass.alert(e.message)
        }       
    }
    
    this.showDialog = function(sURL,w,h,newDialog)
    {
        /*
        if (typeof(w)=="undefined")
            w = 800;
        if (typeof(h)=="undefined")
            h = 500;
        if (typeof(newDialog)=="undefined")
            newDialog = 'editorDlg';
        else
            newDialog = '_brank';
        */
        if (typeof(newDialog)=="undefined" || !newDialog)
            window.location = sURL;
        else
            window.open(sURL,"_brank","height="+h+",width="+w+",location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes");
        return; 
        if (this.mainFrame != null)
        {
           window.parent.open(sURL,newDialog,"height="+h+",width="+w+",location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes");
//            this.mainFrame.open(sURL,newDialog,"height="+h+",width="+w+",location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes");
        }                         
        else
            window.open(sURL,newDialog,"height="+h+",width="+w+",location=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes");
    }
    this.closeDialog = function()
    {
        window.close();
    }
    
    this.selectRow = function(sender,varObj,evtObj)
    {
        if (typeof(varObj)=="undefined") return;
        
        if (varObj.row == sender)
        {
            return;            
        } 
        if (varObj.row != null)
        {
            $(varObj.row).removeClass("TableSelected");
        }
        varObj.row = sender;
        if (sender != null)
        {
            $(sender).addClass("TableSelected");
        }
        if (typeof(evtObj)=="function")
            evtObj();
    }

    this.checkKpMeterNum = function(num)
    {
        arrNum = num.split("");
        if (arrNum.length != 11) return false;
        LSum = 0;
        for (i=0;i<11;i++)
        {
            LDigit = arrNum[i];
            LDigit = LDigit * (1+( i % 2));
            LSum = LSum + parseInt(LDigit / 10) + (LDigit % 10);
        }
        return LSum % 10 == 0;
    }
    
    this.enableControl = function (objName,isReadOnly,isDisabled)
    {
        if (objName.indexOf("*") > -1 )
        {
            objName = objName.replace("*","");
            AObj = $("[id^='"+objName+"']");
            if (AObj.length == 0)
            {
                AObj = $("input[name^='"+objName+"']");
            }
        }
        else 
            AObj = $("#"+objName);
        if (AObj.length==0) return;
        AObj.removeClass();
        if (isReadOnly!=null)
        {
            if (isReadOnly)
            {
                AObj.toggleClass("BigStatic");
                AObj.attr("readonly",true);
            }
            else
            {
                AObj.toggleClass("BigInput");
                AObj.attr("readonly",false);
            }
        }
        
        if (isDisabled!=null) 
        {
            if (isDisabled)
            {
                AObj.toggleClass("BigStatic");
                AObj.attr("disabled",true);
            }
            else
            {
                AObj.toggleClass("BigInput");
                AObj.attr("disabled",false);
            }
            
        }
    }
    
    this.attachDTCtrls = function(obj,dtFormat)
    {
        return;
        $(obj).bind("focus", function(){
            displayCalendar(this,'yyyy-mm-dd',this);
        });
        $(obj).bind("blur", function(){
            closeCalendar();
        });
        
        //obj.onfocus = "displayCalendar(this,'yyyy-mm-dd',this)";            
         
        //obj.onblur = closeCalendar();            
         
    }
    
    this.fillValue = function(value,len,spos,fValue)
    {
        if (typeof(spos)=="undefined") spos="l";
        if (typeof(fValue)=="undefined") fillValue=" ";
        
        clen = value.length;
        if (clen >= len) return value;
        
        for (var i=clen;i<len;i++)
        {
            if (spos=="l")
                value = fValue+value;
            else   
                value = value+fValue;
        }
        return value;
    }
    
    
    this.sendData = function(sendUrl,data,successFunc,errFunc,receiveXML,isAsync,isNotice)
    {
        if (typeof(successFunc)=="undefined")
            successFunc = null;
        if (typeof(errFunc)=="undefined")
            errFunc = null;
        if (typeof(receiveXML)=="undefined")
            receiveXML = false;

        if (typeof(isAsync)=="undefined")
            isAsync = true;
        
        if (typeof(isNotice)=="undefined")
            isNotice = true;        
        
        $.ajax({
           _successFunc:successFunc,
           _errFunc:errFunc,
           _receiveXML:receiveXML,
           _notice:isNotice,
           type: "POST",
           url: sendUrl,
           async : isAsync,
           data: data,
           dataType : "application/x-www-form-urlencoded",
           error:function()
           {
                globalClass.showProgress("",false);
                if (this._errFunc == null)
                {
                    if (this._notice)
                        globalClass.alert(globalClass.langSendFailed);
                }
                else
                if (typeof(this._errFunc)=="function")
                    this._errFunc();
                else
                    globalClass.alert(this._errFunc);    
           },
           success: function(data){
                globalClass.showProgress("",false);
                if (this._receiveXML)
                {
                    try
                    {
                        xmlDoc = globalClass.xmlDoc();
                        xmlDoc.loadXML(data);
                        xmlRoot = xmlDoc.documentElement;
                        if (xmlRoot.attributes.getNamedItem('state').nodeValue!="0")
                        {
                            globalClass.alert(xmlRoot.attributes.getNamedItem('message').nodeValue);
                        }
                        else
                        {
                            if (this._successFunc == null)
                            {
                                if (this._notice)
                                    globalClass.alert(globalClass.langSendOK);
                            }
                            else
                            if (typeof(this._successFunc)=="function")
                                this._successFunc(xmlRoot);
                            else
                                globalClass.alert(this._successFunc);
                        }
                    }
                    catch(e)
                    {
                        globalClass.alert(e.number+"\n"+e.description+"\nDATA:"+data); 
                    }
                }
                else
                {
                    if (this._successFunc == null)
                    {
                        if (this._notice)
                            globalClass.alert(globalClass.langSendOK);
                    }
                    else
                    if (typeof(this._successFunc)=="function")
                        this._successFunc(data);
                    else
                        globalClass.alert(this._successFunc);
                }    
                    
           }
        });
    }
    
    this.sendXMLData = function(sendUrl,xmlData,successFunc,errFunc,isAsync,isNotice)
    {
        if (typeof(successFunc)=="undefined")
            successFunc = null;
        if (typeof(errFunc)=="undefined")
            errFunc = null;
        if (typeof(isAsync)=="undefined")
            isAsync = true;

        if (typeof(isNotice)=="undefined")
            isNotice = true;        

        $.ajax({
           _successFunc:successFunc,
           _errFunc:errFunc,
           type: "POST",
           url: sendUrl,
           async : isAsync,
           data: xmlData,
           dataType : "application/x-www-form-urlencoded",
           processData: false,
           error:function()
           {
                globalClass.showProgress("",false);
                if (this._errFunc == null)
                {
                    if (this._notice)
                        globalClass.alert(globalClass.langSendFailed);
                }
                else
                if (typeof(this._errFunc)=="function")
                    this._errFunc();
                else
                    globalClass.alert(this._errFunc);    
           },
           success: function(xml){
                globalClass.showProgress("",false);
                try
                {
                    xmlDoc = globalClass.xmlDoc();
                    xmlDoc.loadXML(xml);
                    xmlRoot = xmlDoc.documentElement;
                    if (xmlRoot.attributes.getNamedItem('state').nodeValue!="0")
                    {
                        globalClass.alert(xmlRoot.attributes.getNamedItem('message').nodeValue);
                    }
                    else
                    {
                        
                        if (this._successFunc == null)
                        {
                            if (this._notice)
                                globalClass.alert(globalClass.langSendOK);
                        }
                        else
                        if (typeof(this._successFunc)=="function")
                            this._successFunc(xmlRoot);
                        else
                            globalClass.alert(this._successFunc);
                    }
                }
                catch(e)
                {
                    globalClass.alert(e.number+"\n"+e.description+"\nDATA:"+xml); 
                }
           }
        });
    }
    
    this.sendJSONData = function(sendUrl,jsonData,successFunc,errFunc,isAsync,isNotice,focusCtrls)
    {
        if (typeof(successFunc)=="undefined")
            successFunc = null;
        if (typeof(errFunc)=="undefined")
            errFunc = null;
        if (typeof(focusCtrls)=="undefined")
            focusCtrls = null;
                    
        if (typeof(isAsync)=="undefined")
            isAsync = true;

        if (typeof(isNotice)=="undefined")
            isNotice = true;        
        
        $.ajax({
           _successFunc:successFunc,
           _errFunc:errFunc,
           _notice:isNotice,
           type: "POST",
           url: sendUrl,
           async : isAsync,
           data: jsonData,
           dataType:'json',
           error:function(httpObj, textStatus, errorString)
           {
                globalClass.showProgress("",false);
                if (this._errFunc == null)
                {
                    if (this._notice)
                        globalClass.alert(globalClass.langSendFailed+"\n"+errorString);
                }
                else
                if (typeof(this._errFunc)=="function")
                {
                    globalClass.alert(globalClass.langSendFailed+"\n"+errorString);
                    this._errFunc(errorString);
                }
                else
                    globalClass.alert(this._errFunc);    
           },
           success: function(jsonData){
                try
                {
                    globalClass.showProgress("",false);
                    if (jsonData.state !="0")
                    {
                        globalClass.alert(jsonData.message,null,function(){
                            if (focusCtrls!=null) 
                                focusCtrls.focus();    
                        });
                        
                    }
                    else
                    {
                        if (this._successFunc == null)
                        {
                            if (this._notice)
                                globalClass.alert(globalClass.langSendOK);
                        }
                        else
                        if (typeof(this._successFunc)=="function")
                            this._successFunc(jsonData);
                        else
                            globalClass.alert(this._successFunc,null,function(){
                                if (focusCtrls!=null) 
                                    focusCtrls.focus();    
                            });
                    }
                }
                catch(e)
                {
                    globalClass.alert(e.number+"\n"+e.description); 
                }
           }
        });
    }
    
    this.initialize = function()
    {
        //读系统参数
        params = {};
        params.ACTION = 5;
        sUrl = "ControlPanel/exchange.php";
            
        globalClass.sendJSONData(sUrl,params,function(jsonData){
            globalClass._parameters = jsonData.parameters;
            if (globalClass._parameters.RPT_HOST=="")
                globalClass._parameters.RPT_HOST = document.domain; 
        },null,true)
        //
    }
    
    this.checkEnterNumber = function(sender)
    {
        if ( !(((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) 
            || (window.event.keyCode == 13) || (window.event.keyCode == 46) 
            || (window.event.keyCode == 45)))
        {
            window.event.keyCode = 0 ;
        }
        else
        if (window.event.keyCode == 46 && typeof(sender)!="undefined")
        {
            if (sender.value.indexOf(".",0)>=0)
                window.event.keyCode = 0 ;
            
        }
        
    }
    
    
    this.checkEnterInt = function()
    {
        if ( !(((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) 
            || (window.event.keyCode == 13) || (window.event.keyCode == 45)))
        {
            window.event.keyCode = 0 ;
        }
    }
    
    this.checkEnterHex = function()
    {
        //if ( !(((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) 
        //    || (window.event.keyCode == 13) || (window.event.keyCode == 45)
        //    || (window.event.keyCode >=65 && window.event.keyCode <=70)
            //))
        if ((window.event.keyCode >= 48 && window.event.keyCode <= 57)
            || (window.event.keyCode >=65 && window.event.keyCode <=70)
            || (window.event.keyCode >=97 && window.event.keyCode <=102)
            )
        {
            if (window.event.keyCode >=97 && window.event.keyCode <=102)
                window.event.keyCode = window.event.keyCode-32;
        }
        else
            window.event.keyCode = 0 ;        
    }
    
    this.formatMoney = function(sender,nDot)
    {
        if ($(sender).attr("readonly")) return;
        
        if (typeof(nDot)=="undefined")
            nDot = 2;
        dAMT = sender.value;
        if (dAMT == "") dAMT=0;
        dAMT = parseFloat(dAMT);
        sender.value = this.formatNumber(dAMT,nDot); 
    }
    
    this.formatDecimal = function(sender,nDot)
    {
        if ($(sender).attr("readonly")) return;
        if (typeof(nDot)=="undefined")
            nDot = "";
        dAMT = sender.value;
        if (dAMT == "") dAMT=0;
        dAMT = parseFloat(dAMT);
        if (nDot!="")
        {
            alert(nDot);
            d = Math.pow(10,nDot);
            dAMT = Round(dAMT*d)/d;
        }
        sender.value = dAMT; 
    }

    
    this.formatNumber = function (srcStr,nAfterDot){
        srcStr = parseFloat(srcStr);
    　　var srcStr,nAfterDot;
    　　var resultStr,nTen;
        srcStr = ""+srcStr+"";
    　　strLen = srcStr.length;
    　　dotPos = srcStr.indexOf(".",0);
    　　if (dotPos == -1){
    　　　　resultStr = srcStr+".";
    　　　　for (i=0;i<nAfterDot;i++){
    　　　　　　resultStr = resultStr+"0";
    　　　　}
            return resultStr;
    　　}
    　　else{
    　　　　if ((strLen - dotPos - 1) >= nAfterDot){
    　　　　　　nAfter = dotPos + nAfterDot + 1;
    　　　　　　nTen =1;
    　　　　　　for(var j=0;j<nAfterDot;j++){
    　　　　　　　　nTen = nTen*10;
    　　　　　　}
    　　　　　　resultStr = Math.round(parseFloat(srcStr)*nTen)/nTen;
                return resultStr;
    　　　　}
    　　　　else{
    　　　　　　resultStr = srcStr;
    　　　　　　for (var i=0;i<(nAfterDot - strLen + dotPos + 1);i++){
    　　　　　　　　resultStr = resultStr+"0";
    　　　　　　}
                return resultStr;
    　　　　}
    　　}
    }
    
    this.checkEmail = function(email)
    {
    	 var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/; 
    	 if (filter.test(email)) 
    	   return true; 
    	 else 
    	 	 return false;
    }
    
    this.checkIsEmpty = function(objNames)
    {
        objArray = objNames.split(",");
        
        for (i in objArray)
        {
            var aControl = $("#"+objArray[i]);
            
            if (aControl.length >0 && aControl != null && (aControl.val()=="" || aControl.val()==null))
            {
                return aControl;
            }
        }
        return null;
    }
    
    this.fetchOffset =  function(obj) {
    	var left_offset = obj.offsetLeft;
    	var top_offset = obj.offsetTop;
    	while((obj = obj.offsetParent) != null) {
    		left_offset += obj.offsetLeft;
    		top_offset += obj.offsetTop;
    	}
    	return { 'left' : left_offset, 'top' : top_offset };
    }
    
    this.st_addItem = function(objSelect,objValue,objText)
    {
        var oOption = document.createElement("OPTION");
        oOption.text=objText; 
        oOption.value=objValue; 
        objSelect.options.add(oOption);                 
    }
    this.st_itemExists = function(objSelect,objValue)
    {
        for (var i = 0; i < objSelect.options.length;i++)
        {
            if (objSelect.options[i].value == objValue)
            {
                return true;
            }
        }
        return false;
    }
    this.st_selectItem = function(objSelect,objValue)
    {
        for (var i = 0; i < objSelect.options.length;i++)
        {
            if (objSelect.options[i].value == objValue)
            {
                objSelect.options[i].selected = true;
                return true;
            }
        }
        return false;
    }
    
    this.gridClickChk= function(sender,isMutiSelect)
    {
        if (sender==null) return;
        if (typeof(isMutiSelect)=="undefined")
            isMutiSelect = true;
        
        var trNode = sender.parentNode.parentNode;
        var gridName = $(trNode).attr("name");
        var chkName = $(sender).attr("name");
        if (!isMutiSelect)
        {
            selectObjects = $("tr[name='"+gridName+"'][selected='Y']");
            selectObjects.attr("selected","N");
            selectObjects.removeClass("TableSelected");
            selectObjects = $("input:checked[name='"+chkName+"']");
            
            selectObjects.each(function(){
                if (this==sender) return;
                this.checked = false;
            })
        }
        trObj = sender.parentNode.parentNode;
        if (sender.checked)
        {
            trObj.selected = "Y";
            $(trNode).addClass("TableSelected");
        }
        else
        {
            trObj.selected = "N";
            $(trNode).removeClass("TableSelected");
        }    
        return;
        
    }
    
    this.gridClickAllChk= function(sender,rowName,chkName)
    {
        if (sender==null) return;
        if (typeof(rowName)=="undefined")
            rowName = "ReadListData";
        if (typeof(chkName)=="undefined")
            chkName = "chkField";
        
        if (sender.checked)
        {
            selectObjects = $("tr[name='"+rowName+"'][selected='N']");
            selectObjects.attr("selected","Y");
            selectObjects.addClass("TableSelected");
            
        }
        else
        {
            selectObjects = $("tr[name='"+rowName+"'][selected='Y']");
            selectObjects.attr("selected","N");
            selectObjects.removeClass("TableSelected");
        }
        selectObjects = $("input[name='"+chkName+"']");
        selectObjects.each(function(){
            this.checked = sender.checked;
        })
        
    }
    
    this.gridClearRows = function (rowName)
    {
        if (typeof(rowName)=="undefined")
            rowName = "ReadListData";
        selectObjects = $("tr[name='"+rowName+"'][selected='N']");
        selectObjects.remove(); 
    }
    this.gridCheckExists = function(code,rowName)
    {
        if (typeof(rowName)=="undefined")
            rowName = "ReadListData";
        selectObjects = $("tr[name='"+rowName+"'][code='"+code+"']");
        return selectObjects.length > 0;
    }
}

INHE.spms.global.Navigator = function(goFirst,goPiror,goNext,goLast,pageShower,pageRecords,pagePos) {
    
    this.goFirst = $('a[name=\''+goFirst+'\']');
    this.goPiror = $('a[name=\''+goPiror+'\']');
    this.goNext  =  $('a[name=\''+goNext+'\']');
    this.goLast  =  $('a[name=\''+goLast+'\']');
    this.pageShower = $('span[name=\''+pageShower+'\']');
    this.pageRecords = $('span[name=\''+pageRecords+'\']');
    this.pagePos = $('span[name=\''+pagePos+'\']');

    this.recCount = 0;
    this.pageIndex = 1;
    this.pageCount = 10;
    this.pageIndex = 0;
    this.pageSize = 0;

    this.initNavigator = function(){
        if (this.goFirst.length > 0)
        {
            if (this.pageIndex > 1)
            {
                this.goFirst.removeClass(); 
                this.goFirst.addClass("pageFirst"); 
            }
            else
            {
                this.goFirst.removeClass(); 
                this.goFirst.addClass("pageFirstDisable"); 
            }
        }
        if (this.goPiror.length > 0)
        {
            if (this.pageIndex > 1)
            {
                this.goPiror.removeClass(); 
                this.goPiror.addClass("pagePrevious"); 
            }
            else
            {
                this.goPiror.removeClass(); 
                this.goPiror.addClass("pagePreviousDisable"); 
            }
        }
        if (this.goNext.length > 0)
        {
            if (this.pageIndex < this.pageCount)
            {
                this.goNext.removeClass(); 
                this.goNext.addClass("pageNext"); 
            }
            else
            {
                this.goNext.removeClass(); 
                this.goNext.addClass("pageNextDisable"); 
            }
        }
        if (this.goLast.length > 0)
        {
            if (this.pageIndex < this.pageCount)
            {
                this.goLast.removeClass(); 
                this.goLast.addClass("pageLast"); 
            }
            else
            {
                this.goLast.removeClass(); 
                this.goLast.addClass("pageLastDisable"); 
            }
        }
        pageInfo = this.pageIndex+"/"+this.pageCount;
        this.pageShower.each(function(){
            this.innerHTML  = pageInfo;
        })
        pageInfo = this.recCount;
        this.pageRecords.each(function(){
           this.innerHTML = pageInfo;   
        });

        FRecNoTo = this.pageIndex*this.pageSize;
        if (FRecNoTo==0)
            FRecNoFrom = 0;
        else
            FRecNoFrom = FRecNoTo-this.pageSize+1;
        if (FRecNoTo > this.recCount)
            FRecNoTo = this.recCount;
        
        pageInfo = FRecNoFrom+" - "+FRecNoTo;
        this.pagePos.each(function(){
            this.innerText = pageInfo;   
        });
    }
    
    this.navigator = function(sender,objNumber){
        if (typeof(sender)=="undefined") return false;
        if (this.goFirst.index(sender)>=0)
        {
            if (this.pageIndex == 1) return false;
            this.pageIndex = 1;
        }
        else
        if (this.goPiror.index(sender)>=0)
        {
            if (this.pageIndex == 1) return false;
            this.pageIndex = parseInt(this.pageIndex)- 1;
        }
        else
        if (this.goNext.index(sender)>=0)
        {
          if (this.pageIndex == this.pageCount) return false;
            this.pageIndex = parseInt(this.pageIndex) + 1;
        }
        else
        if (this.goLast.index(sender)>=0)
        {
            if (this.pageIndex == this.pageCount) return false;
            this.pageIndex = this.pageCount;
        }
        else
        {
            
            if (typeof(objNumber)=="undefined") return false;
            objNumber = $("#"+objNumber);
            if (objNumber.length==0) return false;
            return this.gotoPage(objNumber[0].value);
            
        }
       return true;
    }
    
    this.gotoPage = function(pageNo)
    {
        if (typeof(pageNo)=="undefined") return false;
        if (pageNo=="") return false;
       
        if (pageNo < 1 || pageNo>this.pageCount) 
        {
            this.pageIndex = this.pageCount;
            //alert("1-"+this.pageCount);
            return true;   
        } 
        
        if (pageNo == this.pageIndex) return false;
        
        this.pageIndex = pageNo;
        return true;
    }
}



// Array prototype ,for IE 5
if (!Array.prototype.push){
    Array.prototype.push = function (Item){
        this[this.length] = Item;
        return this.length;
    };
}

// Array prototype ,for IE 5
if (!Array.prototype.push){
    Array.prototype.push = function (Item){
        this[this.length] = Item;
        return this.length;
    };
}
INHE.spms.global.marquee = function(Name){
    // default
    this.Speed = 60;        // scroll speed
    this.Delay = 60000;      // delay timeout
    this.Rows = 1;          // rows of keep
    this.Cols = 1;          // cols of keep
    this.Height = 18;       // height of block
    this.Width = '100%';       // width of block
    this.Direct = 'up';     // up,down,left,right

    this.Id = 0;
    this.Name = Name;       // marquee box name,ascii
    this.Content = new Array();
    this.DelayInterval = null;
    this.ScrollInterval = null;
    eval('window.' + this.Name + '= this;');
};
// internal function
INHE.spms.global.marquee.prototype.setDelay = function(Delay){
    this.Delay=Delay;
};
// internal function
INHE.spms.global.marquee.prototype.getObj = function(objId){
    return document.getElementById(objId);
};
// drawing
INHE.spms.global.marquee.prototype.init = function(content){
    this.Content = content;
    this.getObj(this.Name+"_container").innerHTML = '<div id="' + this.Name + '" style="overflow:hidden;height:' + this.Rows * this.Height + 'px;width:' + this.Cols * this.Width + 'px;">'
                                                  + '<div style="overflow:hidden;height:' + this.Height + 'px;width:' + this.Width + 'px;">' + this.Content[this.Id] + '</div></div>';
    this.getObj(this.Name).onmouseover = function(){
        if (this.id != ''){
            var Obj = document.getElementById(this.id);
            clearInterval(Obj.DelayInterval);
        }
    };
    this.getObj(this.Name).onmouseout = function(){
        if (this.id != ''){
            var Obj = document.getElementById(this.id);
            Obj.DelayInterval = setInterval(Obj.Name + ".start()",Obj.Delay);
        }
    };
    this.DelayInterval = setInterval(this.Name + ".start()",this.Delay);

};

INHE.spms.global.marquee.prototype.start = function(){
    var marqueeBox = this.getObj(this.Name);
    this.Id++;
    if(this.Id > this.Content.length - 1) this.Id = 0;
    if(marqueeBox.childNodes.length <= this.Rows) {
        var nextLine = document.createElement('DIV');
        nextLine.style.overflow = 'hidden';
        nextLine.style.height = this.Height;
        nextLine.style.width = this.Width;
        nextLine.innerHTML = this.Content[this.Id];
        marqueeBox.appendChild(nextLine);
    } else {
        marqueeBox.childNodes[0].innerHTML = this.Content[this.Id];
        marqueeBox.appendChild(marqueeBox.childNodes[0]);
        marqueeBox.scrollTop = 0;
    }
    clearInterval(this.ScrollInterval);
    this.ScrollInterval = setInterval(this.Name + ".scroll()",this.Speed);
};
INHE.spms.global.marquee.prototype.scroll = function(){
    this.getObj(this.Name).scrollTop++;
    if(this.getObj(this.Name).scrollTop % this.Height == (this.Height - 1)){
        clearInterval(this.ScrollInterval);
    }
};


var globalClass = new INHE.spms.global.GlobalClass();
