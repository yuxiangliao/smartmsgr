<?php
use App\Models\Dictionary;
use App\Models\SysLang;
//load all of interface parameters to Varaints
$Dictionary = new Dictionary();
$result = $Dictionary->loadDictionaries("INTERFACE");
foreach ($result as $row)
{
    ${$row['Code']} = $row['Description'];
}
//...

$langs = SysLang::all();
$LANGS = "";
foreach ($langs as $lang)
{
    if ($lang['id_lang']== _USER_ID_LANG_)
        $LANGUAGES .= "<li class=\"selected_language\"><img src=\"/images/l/{$lang['id_lang']}.jpg\" alt=\"{$lang['name']}\" width=\"16\" height=\"11\"/></li>";
    else
        $LANGUAGES .= "<li ><a href=\"javascript:parent.window.location.replace('/general/default.php?id_lang={$lang['id_lang']}');\" title=\"{$lang['name']}\" ><img src=\"/images/l/{$lang['id_lang']}.jpg\" alt=\"{$lang['name']}\" width=\"16\" height=\"11\"/></a></li>";
}

list($CUR_YEAR,$CUR_MON,$CUR_DAY,$CUR_HOUR,$CUR_MINITE,$CUR_SECOND) = Tools::DateTimeEx(hexdec(dechex(time())));
$TIME_STR="$CUR_YEAR,$CUR_MON,$CUR_DAY,$CUR_HOUR,$CUR_MINITE,$CUR_SECOND";
$CUR_WEEK = Tools::getWeek();

?>
<script language="JavaScript">
    var SYS_TIME = new Date(<?=$TIME_STR?>);
    var TIME_ERROR = header_time_error();
    var tickCount = 0;
    function header_time_error()
    {
        var currTime  = new Date();
        currTime = (currTime.getTime()- SYS_TIME.getTime())/1000;
        return parseInt(currTime);
    }
    function header_showDate(sYear,sMonth,sDay,sWeek)
    {

        document.getElementById("header_date").innerHTML = sYear+"-"+sMonth+"-"+sDay;
        document.getElementById("header_week").innerHTML = " "+sWeek+" ";
    }
    function header_checkTime()
    {
        window.setTimeout( "header_checkTime()", 10000 );
    }
    function header_showTime()
    {
        /*
        var curr_error = header_time_error();
        if ( curr_error != TIME_ERROR)
        {
            SYS_TIME.setSeconds(SYS_TIME.getSeconds()+(curr_error-TIME_ERROR));
            tickCount += curr_error-TIME_ERROR;
        }
        else*/
        tickCount += 1;
        timestr = globalClass.FormatDateTime("hh:mm:ss",SYS_TIME);
        //timestr=SYS_TIME.toLocaleString();
        // timestr=timestr.substr(timestr.indexOf(":")-2, 8);
        document.getElementById("header_time").innerHTML = timestr;
        SYS_TIME.setSeconds(SYS_TIME.getSeconds()+1);
        window.setTimeout( "header_showTime()", 1000 );
        if (tickCount==20)
        {
            var condition = {ACTION:2};

            condition.sysTime = SYS_TIME;
            condition.sysTime.setMonth(SYS_TIME.getMonth()-1);
            condition.sysTime = globalClass.FormatDateTime("yyyy,MM,dd,hh,mm,ss",condition.sysTime);
            tickCount = 0;
        }
    }

    //    SMARTvendX = new INHE.spms.SMARTvendX();

    jQuery().ready(function (){
        header_showDate("<?=$CUR_YEAR?>","<?=$CUR_MON?>","<?=$CUR_DAY?>","<?=$CUR_WEEK?>");
        header_showTime();
        window.setTimeout( "header_checkTime()", 10000 );
        /*
        SMARTvendX.hasSVX_CRTL = SMARTvendX.detectSVX();
        if (SMARTvendX.hasSVX_CRTL)
        {
            SMARTvendX.createSVX();
            //SMARTvendX.startMagcard();
        }
        */

    });
</script>

<table class="topbar" height=50 width="100%" border=0 cellspacing=2 cellpadding=2>
    <tr height=40>
        <?
        if ($HEAD_IMG != "")
        {
            echo "<td width=\"{$HEAD_IMG_W}\" align=\"center\"><img src=\"/attachment/{$HEAD_IMG}\" width=\"{$HEAD_IMG_W}\" height=\"{$HEAD_IMG_H}\" align=\"absmiddle\"></td>";
        }
        if ($HEAD_TITLE !="")
        {
            $HEAD_TITLE = htmlspecialchars($HEAD_TITLE);
            echo "<td nowrap><span id=\"banner_text\" style=\"{$HEAD_STYLE}\">&nbsp;{$HEAD_TITLE}</span></td>";
        }
        ?>
        <td valign="top">
            <div id="banner_time"><span class="time_left">
        <span class="time_right">
          <span id='header_date' title='2010年9月13日'></span>
          <b><label id="header_week" style="margin-left: 7px;"></label></b>
          <img src="/images/time.gif" align="absmiddle" />
        <span id="header_time"></span>&nbsp;
      </span></span>
            </div>
            <div id="languages_block_top" style="margin-top:7px;float:right" align="right">
                <ul id="first-languages"><?=$LANGUAGES?></ul>
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


