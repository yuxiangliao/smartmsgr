<!DOCTYPE html>
<html>
<head>
    <title>{{$title}}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="{{asset('smart/templates/default/index.css')}}"/>
    <link rel="shortcut icon" href="{{asset('smart/images/inhe.ico')}}"/>
    <script src="{{asset('smart/js/jquery-1.4.3.min.js')}}" type="text/javascript"></script>
    <script src="{{asset('smart/js/md5-min.js')}}" type="text/javascript"></script>
    {!! $javascript !!}
</head>

<body onload="javascript:document.form1.{{$focus_filed}}".focus();">
<div align="center">
    <form name="form1" method="post" action="{{url('checkin')}}" {!!$autocomplete!!} onsubmit="{{$form_submit}}">
        {{ csrf_field() }}
        <div id="languages_block_top" style="margin-top:355px;">
            <ul id="first-languages">
                @foreach($languages as $item)
                <li ><a href="/{{$item->id_lang}}" title="" ><img src="{{asset('smart/images/l')}}/{{$item->id_lang}}.jpg" alt="{{$item->name}}" width="16" height="11"/></a></li>
                @endforeach
            </ul>
        </div><br/>
        <div class="login_div" align="center" style="margin-top: 15px;">
            {{$lg_username}} <input type="text" class="text" id="USERNAME" name="USERNAME" maxlength="20" onmouseover="this.focus()" onfocus="this.select()" value="{{$username_cookie}}" />&nbsp;&nbsp;
            {{$lg_password}} <input type="password" class="text" id="PASSWORD" name="PASSWORD" onmouseover="this.focus()" onfocus="this.select()" value="" />&nbsp;&nbsp;
            <input type="submit" class="submit" value="{{$lg_login}}" />
        </div>
        <br/>
        <br/>
    </form>
{!! $script !!}
</div>
<script type="text/javascript">
    $('ul#first-languages li:not(.selected_language)').css('opacity', 0.3);
    $('ul#first-languages li:not(.selected_language)').hover(function(){
        $(this).css('opacity', 1);
    }, function(){
        $(this).css('opacity', 0.3);
    });
</script>

</body>
</html>