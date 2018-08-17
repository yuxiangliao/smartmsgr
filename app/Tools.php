<?php
namespace App;
/**
 * Created by PhpStorm.
 * User: liao
 * Date: 2018-08-13
 * Time: 02:49 PM
 */

class Tools
{
    protected static $file_exists_cache = array();

    /**
     * 获取消息提示信息
     */
    public function get(){
        return 'hello facade';
    }

    public function findIDEx($STRING, $ID)
    {
        $ID = "[{$ID}]";
        if ( strpos( $STRING, $ID )===False )
        {
            return False;
        }
        else
            return True;

    }

    public function getMessageBox($TITLE,$CONTENT,$STYLE="")
    {
        $WIDTH = strlen($CONTENT)*10 + 140;
        $WIDTH = $WIDTH>500 ? 500 : $WIDTH;
        if($STYLE=="blank")
            $WIDTH -= 70;

        if($STYLE=="")
        {
            if($TITLE=="错误")
                $STYLE="error";
            else if($TITLE=="警告")
                $STYLE="warning";
            else if($TITLE=="停止")
                $STYLE="stop";
            else if($TITLE=="禁止")
                $STYLE="forbidden";
            else if($TITLE=="帮助")
                $STYLE="help";
            else
                $STYLE="info";
        }
        $MSG = "<table class=\"MessageBox\" align=\"center\" width=\"{$WIDTH}\"><tr><td class=\"msg {$STYLE}\">";
        if($TITLE!="")
            $MSG .= "<h4 class=\"title\">{$TITLE}</h4>";
        $MSG .= "<div class=\"content\" style=\"font-size:12pt;color:#36434E;\">{$CONTENT}</div></td></tr></table>";
        if (config('settings._PAGE_NAME_')=="formsex")
            $MSG = "<div region=\"center\" class=\"mainbody\" >{$MSG}</div>" ;
        return $MSG;
    }

    /*************************************************
    两个日期时间的扩展函数, 用于支持2038年后的时间值
     *************************************************/
    /*
       用途:传时间秒数,所到一个年月日时分秒数组
       原型:array myTime(int $t);
    */
    public function DateTimeEx($t)
    {
        //2147483647 = 2^16-1; 为php接受的最大整数
        if($t <= 2147483647){
            return explode(',',  date('Y,m,d,H,i,s',$t));
        }
        $t -=   2145888000; // 2038-1-1 0:00:00
        $ds = floor($t / 86400);//天数
        $year=2038;
        $month=1;
        $date=1;
        $is_366=false;
        while($ds>=365){
            $is_366 = (0==($year & 3) && $year%100)|| 0==($year%400);
            if($is_366){//闰年
                if($ds>=366)$ds -= 366;
                else break;
            }else{
                $ds -= 365;
            }
            $year++;
        }
        $days_of_month=array(31,28,31,30,31,30,31,31,30,31,30,31);
        if($is_366){
            $days_of_month[1]=29;
        }
        for($i=0;$i<12;$i++){
            if($ds>=$days_of_month[$i]){
                $month++;
                $ds -= $days_of_month[$i];
            }else{
                $date +=$ds;
                break;
            }
        }

        $mod = $t % 86400;
        $H = floor($mod / 3600);//时
        $mod = $mod % 3600;
        $M = floor($mod / 60);//分
        $S = $mod % 60;//秒
        return array($year,$month,$date,$H,$M,$S);
    }

    public function getWeek()
    {
        switch(date("w"))
        {
            case 0:
                return  __('messages.Sunday');
            case 1:
                return __('messages.Monday');
            case 2:
                return __('messages.Tuesday');
            case 3:
                return __('messages.Wednesday');
            case 4:
                return __('messages.Thursday');
            case 5:
                return __('messages.Friday');
            case 6:
                return __('messages.Saturday');
        }
    }
}