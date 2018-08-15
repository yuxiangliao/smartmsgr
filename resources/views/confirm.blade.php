<html>
<head>
    <title>Login the system</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="smart/templates/default/checkin.css"/>
    <link rel="shortcut icon" href="smart/images/inhe.ico"/>
</head>
<body topmargin="5">
<br><br>
@if($LOGIN_MSG != 0)
    {!! $loginError !!}
    <div align="center">
        <input type="button" value="{{__('messages.Relogin')}}" class="BigButton" onclick="location='/'"/>
    </div>

@else
    <div align="center">
        {!! $MessageBox !!}
        <div align="center">
            <input type="button" value="{{__('messages.EnterSystem')}}" class="BigButton" onclick="goto_va();"/>&nbsp;&nbsp;
            <input type="button" value="{{__('messages.Return')}}" class="BigButton" onclick="location='/'"/>
        </div>
    </div>


    <script>
        var SYS_TIME = new Date('{{$TIME_STR}}');
        function goto_va()
        {
            location="{{$VA_UI}}";
        }

        function header_showDate()
        {
            document.getElementById("header_date").innerHTML ="{{$CUR_YEAR}}-{{$CUR_MON}}-{{$CUR_DAY}}"
        }
        function header_showTime()
        {
            timestr=SYS_TIME.toLocaleString();
            timestr=timestr.substr(timestr.indexOf(":")-2, 8);
            document.getElementById("header_time").innerHTML = timestr;
            SYS_TIME.setSeconds(SYS_TIME.getSeconds()+1);
            window.setTimeout( "header_showTime()", 1000 );
        }

        window.onload=function(){
            header_showDate();
            header_showTime();
        }
    </script>
@endif
</body>
</html>