<div>hello</div>
<table class="topbar" height=50 width="100%" border=0 cellspacing=2 cellpadding=2>
    <tr height=40>
        @if($HEAD_IMG != "")

        echo "<td width=\"{$HEAD_IMG_W}\" align=\"center\"><img src=\"/attachment/{$HEAD_IMG}\" width=\"{$HEAD_IMG_W}\" height=\"{$HEAD_IMG_H}\" align=\"absmiddle\"></td>";
        @endif
        @if($HEAD_TITLE!="")

        echo "<td nowrap><span id=\"banner_text\" style=\"{$HEAD_STYLE}\">&nbsp;{$HEAD_TITLE}</span></td>";
        @endif
        <td valign="top">
            <div id="banner_time"><span class="time_left">
        <span class="time_right">
          <span id='header_date' title='2010年9月13日'></span>
          <b><label id="header_week" style="margin-left: 7px;"></label></b>
          <img src="/smart/images/time.gif" align="absmiddle" />
        <span id="header_time"></span>&nbsp;
      </span></span>
            </div>
            <div id="languages_block_top" style="margin-top:7px;float:right" align="right">

            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    $('ul#first-languages li:not(.selected_language)').css('opacity', 0.3);
    $('ul#first-languages li:not(.selected_language)').hover(function(){
        $(this).css('opacity', 1);
    }, function(){
        $(this).css('opacity', 0.3);
    });
</script>
<script>
    var SYS_TIME = new Date({{$TIME_STR}});
</script>
