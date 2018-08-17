<?php
namespace App;

class DateTime{

    function __construct()
    {
    }

    public function dateAdd ( $interval , $number , $date )
    {

        $date_time_array = getdate ( $date );
        $hours = $date_time_array [ "hours" ];
        $minutes = $date_time_array [ "minutes" ];
        $seconds = $date_time_array [ "seconds" ];
        $month = $date_time_array [ "mon" ];
        $day = $date_time_array [ "mday" ];
        $year = $date_time_array [ "year" ];
        switch ( $interval ) {
            case "yyyy" : $year += $number ; break ;
            case "q" : $month +=( $number *3); break ;
            case "m" : $month += $number ; break ;
            case "y" :
            case "d" :
            case "w" : $day += $number ; break ;
            case "ww" : $day +=( $number *7); break ;
            case "h" : $hours += $number ; break ;
            case "n" : $minutes += $number ; break ;
            case "s" : $seconds += $number ; break ;
        }
        $timestamp = mktime ( $hours , $minutes , $seconds , $month , $day , $year );
        return $timestamp ;
    }

    public function dateDiff ( $interval , $date1 , $date2, $includeCurrent=false ,$reset = ture)
    {
        $timedifference = $date2 - $date1 ;
        switch ( $interval ) {
            case "y" :
                $retval = date('Y',$date2)-date('Y',$date1);
                break;
            case "m" :
                $oY = date('Y',$date1);
                $oM = date('m',$date1);
                $oY = date('Y',$date2)-$oY;
                $retval = $oY * 12 - $oM + date('m',$date2);

                break;
            case "w" :
                if ($timedifference < 0)
                    $retval = -1;
                else
                    $retval = bcdiv ( $timedifference ,604800); break ;
            case "d" :
                if ($timedifference < 0)
                    $retval = -1;
                else
                    $retval = bcdiv ( $timedifference ,86400);
                break ;
            case "h" :
                if ($timedifference < 0)
                    $retval = -1;
                else
                    $retval = bcdiv ( $timedifference ,3600);
                break ;
            case "n" : $retval = bcdiv ( $timedifference ,60); break ;
            case "s" : $retval = $timedifference ; break ;
        }
        if ($includeCurrent)
            $retval ++;
        if ($reset && $retval < 0) $retval = 0;
        return $retval ;
    }

    public function firstMonthDay($date)
    {
        $year = date("Y",$date);
        $month = date("m",$date);
        return mktime(0,0,0,$month,1,$year);
    }
    public function firstYearDay($date)
    {
        $year = date("Y",$date);
        return mktime(0,0,0,1,1,$year);

    }

    public function isToday($date)
    {
        $date = strtotime($date);
        return (date("Ymd",$date) == date("Ymd"));
    }

    public function daysBetween($date,$day)
    {
        $dateTo = strtotime($date);
        $dateTo = TDateTime::dateAdd("d",$day,$dateTo);
        return date("Ymd",$dateTo) >= date("Ymd",Time());
    }

    public function partOf($part,$date)
    {

    }

    public function getResetMonth($date,$resetDay)
    {

        $date = strtotime($date);
        if (date("d",$date) < $resetDay)
        {
            $date =  TDateTime::dateAdd("m",-1,$date);
        }
        return date("Ym",$date);
    }
}


?>