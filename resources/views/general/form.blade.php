<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <title>{{$title}}</title>
    <link rel="shortcut icon" href="/smart/images/inhe.ico"/>
    <link rel="stylesheet" type="text/css" media="screen" href="/smart/themes/1/ui.general.css"/>
    <script src="/smart/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
    <script src="/smart/js/md5.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript" src="/smart/js/datepicker/WdatePicker.js"></script>
    <script src="/smart/js/GlobalClass.js" type="text/javascript"></script>
    <script src="/smart/js/ckeditor/ckeditor.js"></script>

</head>
<body class="{{$bodyClass}}" onkeydown="evtKeyDown()">
@if($act=="")
{{$ErrMessages}}
@else

    <div id="va_progress" style="position: absolute;z-index:99999;display:none;"><img src="/smart/images/loading_bg.gif" /></div>
    @if($resizeBody)
        <div id="mainbody" class="databody"></div>
    @else
    <div id="mainbody"></div>
    @endif
@endif
</body>
<script>
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': '{{csrf_token()}}'
        }
    });
    globalClass.langSendFailed = "{{__("LG_COMMON.cliSendFailed")}}";
    globalClass.langSendOK = "{{__("LG_COMMON.cliSendOK")}}";
    globalClass.langOK = "{{__("LG_COMMON.cliOK")}}";
    globalClass.langCancel = "{{__("LG_COMMON.cliCancel")}}";
    globalClass.langNotice = "{{__("LG_COMMON.Notice")}}";
    globalClass.langConfirm = "{{__("LG_COMMON.Confirm")}}";
    globalClass.currModuleID = "{{$CURR_MODULE_ID}}";
    var thisModuleID = "{{$module_action}}";
    jQuery().ready(function(){
        globalClass.showProgress("va_progress");
        $("#mainbody").load("{!! $actURL !!}",{},function(){
            globalClass.showProgress("va_progress",false)
        });
    });

</script>
</html>