<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <title>{$title}</title>
    <link rel="shortcut icon" href="/smart/images/inhe.ico"/>
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/{$CURR_THEME}/ui.general.css"/>
    <script src="/smart/js/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript" src="/smart/js/jquery.json-2.3.min.js"></script>
    <script src="/smart/js/md5.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript" src="/smart/js/datepicker/WdatePicker.js"></script>
    <script src="/smart/js/GlobalClass.js" type="text/javascript"></script>
    <script src="/smart/js/ckeditor/ckeditor.js"></script>
    <script>
        globalClass.langSendFailed = "{{__("common.cliSendFailed")}}";
        globalClass.langSendOK = "{{__("common.cliSendOK")}}";
        globalClass.langOK = "{{__("common.cliOK")}}";
        globalClass.langCancel = "{{__("common.cliCancel")}}";
        globalClass.langNotice = "{{__("common.Notice")}}";
        globalClass.langConfirm = "{{__("common.Confirm")}}";
        globalClass.currModuleID = "{{$CURR_MODULE_ID}}";
        var thisModuleID = "{{$module_action}}";
        jQuery().ready(function(){
            globalClass.showProgress("va_progress");
            $("#mainbody").load("{$actURL}",{},function(){
                globalClass.showProgress("va_progress",false)
            });
        });

        function refreshTitle(titleName,titleImg)
        {
            document.title = titleName ;
            return ;
			            if (typeof(titleImg)=="undefined" || titleImg=="")
			                titleImg = "/images/outbox.gif";
			            title = $("#maintitle_img");
			            if (title.length = 0) return;
			            title = title[0];
			            title.src = titleImg;
			            if (typeof(titleName)=="undefined" || titleName=="")
			                titleImg = "unname";
			            title = $("#maintitle_a");
			            if (title.length = 0) return;
			            title = title[0];
			            title.innerHTML = titleName;
			        }
			        window.onfocus   =   function()   {
			           doFocus();
			        }
			        function doFocus()
			        {
			        }
			        window.onunload = function()
			        {
			           doUnload();
			        }
			        window.onblur = function()
			        {
			        }
			function doUnload()
			        {
			        }
        function doBodyResize() {

		@if ($resizeBody)
            dh = document.documentElement.clientHeight;//document.body.clientHeight;
            A = $("#maintitle");
            if (A.length ==0 )
                h = 0;
            else
            {
                h = A[0].clientHeight;
            }
            if(dh >h)
            {
            	$("#mainbody").css("height",dh-h-10+"px");
            }
		@endif
        }
    </script>
</head>
<body class="{{$bodyClass}}" onkeydown="evtKeyDown()">

@if($act=="")
{{$ErrMessages}}
@else

    <div id="va_progress" style="position: absolute;z-index:99999;display:none;"><img src="/images/loading_bg.gif" /></div>
    @if($resizeBody)
        <div id="mainbody" class="databody"></div>
    @else
    <div id="mainbody"></div>
    @endif
@endif
</body></html>