<!doctype html>
<html>
<head>
    <title>{{$APP_TITLE}}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="shortcut icon" href="/smart/images/inhe.ico"/>

    <style type="text/css">

        #loading-mask{
            background-color:white;
            height:100%;
            position:absolute;
            left:0;
            top:0;
            width:100%;
            z-index:20000;
            background: #d3e1ee  top center no-repeat;
        }
        #loading{
            height:auto;
            position:absolute;
            left:35%;
            top:40%;
            padding:2px;
            z-index:20001;
            background: #d3e1ee  top center no-repeat;

        }
        #loading a {
            color:#225588;
        }
        #loading .loading-indicator{
            color:#444;
            font:bold 13px Helvetica, Arial, sans-serif;
            height:auto;
            margin:0;
            padding:10px;
            background: #d3e1ee  top center no-repeat;
        }

        #loading-msg {
            font-size: 10px;
            font-weight: normal;
        }

        li {
            list-style: inherit !important;
        }
        #mainframe{

        }

    </style>
</head>
<body STYLE='OVERFLOW:HIDDEN;OVERFLOW-Y:HIDDEN'>
<div id="loading-mask" style=""></div>
<div id="loading">
    <div class="loading-indicator">
        <img src="/smart/images/extanim32.gif" width="32" height="32" style="margin-right:8px;float:left;vertical-align:top;"/>Smart Messenger Anywhere - <a href="http://www.inhemeter.com">INHEMETER</a>
        <br /><span id="loading-msg">Loading styles and images...</span>
    </div>
</div>
<div class="mainframe">
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/{{$CURR_THEME}}/ui.general.css"/>
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/{{$CURR_THEME}}/ui.icons.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/{{$CURR_THEME}}/jstree/style.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/{{$CURR_THEME}}/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/{{$CURR_THEME}}/icon.css"/>

    <script type="text/javascript">document.getElementById('loading-msg').innerHTML = 'Loading Core API...';</script>

    <script type="text/javascript" src="/smart/js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="/smart/js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/smart/js/SMARTvendX.js"></script>
    <script type="text/javascript" src="/smart/js/GlobalClass.js" ></script>
    <script language="javascript" type="text/javascript" src="/smart/js/datepicker/WdatePicker.js"></script>

    <script type="text/javascript">document.getElementById('loading-msg').innerHTML = 'Loading UI Components...';</script>
    <script type="text/javascript">document.getElementById('loading-msg').innerHTML = 'Initializing...';</script>

    <div id="mydialog_1" class="easyui-window" title="dialog" closed="true" modal="true" iconCls="icon-search" style="width:700px;height:400px;padding:2px;background: #fafafa;">
        <div class="easyui-layout" fit="true">
            <div id="test12" region="center" border="false" style="padding:1px;background:#fff;border:0px solid #ccc;">
            </div>
            <div region="south" border="false" style="text-align:right;height:30px;line-height:30px; padding-top:3px;">
                <a id="btndialog_ok" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" >{{__("messages.cliOK")}}</a>
                <a id="btndialog_cancel" class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" >{{__("messages.cliCancel")}}</a>
            </div>
        </div>
    </div>
    <script type="text/javascript">

        SMARTvendX = new INHE.spms.SMARTvendX();

        jQuery().ready(function (){
            globalClass.initialize();

            var hideMask = function () {

                myDiv = $('#loading')[0];
                myDiv.parentNode.removeChild(myDiv);
                myDiv = $('#loading-mask')[0];
                myDiv.parentNode.removeChild(myDiv);

            };

            window.setTimeout(hideMask,250);
            SMARTvendX.hasSVX_CRTL = SMARTvendX.detectSVX();

            if (SMARTvendX.hasSVX_CRTL)
            {
                SMARTvendX.createSVX();
                //SMARTvendX.startMagcard();
            }

        });
    </script>
    <script language="javascript" for="SVX_CRTL" event="OnMessage(msgID,msgData);">
        SMARTvendX.MessageEvent(msgID,msgData);
    </script>
    <script language="javascript" for="SVX_CRTL" event="OnReadMagcard(data);">
        SMARTvendX.ReadMagcardEvent(data)

    </script>

    <iframe id="mainframe" frameborder="0" scrolling="no"  src="default.php" width="100%" height="100%"></a>
    </iframe></div>
</body>
</html>
