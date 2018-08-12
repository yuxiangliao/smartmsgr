<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $table='sys_user';
    //主键
    protected $primaryKey='Code';

    public $timestamps = false;

    protected $guarded=[];

    //主键不是自增模式
    public $incrementing = false;
    
    public function checkLogin($userCode,$password,$randNum="",$times=0)
    {
        if ($userCode=="") return -2101;
        
        $VA_LOGIN_TIME_RANGE = "00:00:00 ~ 23:59:59";
        /*if($userCode != "admin" && !Tools::checkTimeRange($VA_LOGIN_TIME_RANGE))
            return -2102;
        
        $clientIP = Tools::getClientIP();
        //get the parameters
        $Dictionary =  TDictionary::getInstance();
        $result = $Dictionary->loadDictionaries("SYS_PARAM",NULL,"'SEC_RETRY','SEC_RETRY_TIMES','SEC_RETRY_MINS'");
        foreach ($result as $row)
        {
            $$row['Code'] = $row['V2'];
        }
        //..
        if ($SEC_RETRY=="Y")
        {
            $loginTimes = Event::checkLoginTimes($userCode,$SEC_RETRY_MINS);
            
            if ($loginTimes >= $SEC_RETRY_TIMES)
                return -2103;
        }*/
        $result = $this->where('Code','=',$userCode)->get();
        if ($result->isEmpty())
        {
            //Event::addEvent($userCode,2,"USERNAME=($userCode)");
            //return -2104;//"the user name entered is incorrect!";
        }
        
        
        if ($result[0]->NotLogin!="N")
        {
            return -2105;
        }
        
        $PWD = "";
        if ($times>0)
        {
            $PWD = $result[0]->PWD;
            for ($i=1;$i<$times;$i++)
            {
                $PWD = md5($PWD.$randNum);
            }
        }
        else
        {
            
            $PWD = md5($result[0]->PWD.$randNum);
        }
        
        if($password != $PWD)
        {
            //$password=Tools::maskstr($password,2,1);
            //Event::addEvent($userCode,$clientIP,3,$password);
            return -2106;
        }
        //IP限制(以后增加)
        /*if ($this->IpLimit == "Y" && trim($this->IpAddress))
        {
            $ips = explode("\n",$this->IpAddress);
            if(!in_array($clientIP,$ips))
                return -2107;
        }*/
        return 0;
    }
    
    
}
