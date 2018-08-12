<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cookie;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;

class UserOnline extends Model
{
    //
    protected $table='sys_user_online';
    //主键
    protected $primaryKey='UCode';
    
    public $timestamps = false;
    
    protected $guarded=[];
    
    //主键不是自增模式
    public $incrementing = false;
    
    public function clearOnlineStatus($userCode="")
    {
        global $ONLINE_REF_SEC;
        $currTime = time()-$ONLINE_REF_SEC-5 ;//清除二分种以前用户
        if (defined('_SESSION_DB_'))
        {
           /* $query = "UPDATE sys_sessions SET session_user = '' WHERE session_expires<'{$currTime}' ";
            if ($userCode != "")
                $query .= "OR session_user = '$userCode'";
            Db::getInstance()->Execute($query);*/
        }
        else
        {
            //$this->where('LoginTime','<',$currTime)->orWhere('UCode','=','');
            $sql = "delete from {$this->table} where (LoginTime < ?) OR (UCode = ? )";
            $deleted = DB::delete($sql,[$currTime,"''"]);
            if ($userCode!="")
            {
                $sql = "delete from {$this->table} where (UCode = ? )";
                $deleted = DB::delete($sql,[$this->table,$userCode]);
            }
        }
    }
    
    public function checkOnlineStatus($userCode="")
    {
        if (defined('_SESSION_DB_'))
        {
           /* if ($userCode=="")
                $userCode = Session::get('LG_ID');
            $query = "select session,session_ip from sys_sessions where session_user='{$userCode}'";
            $cursor = Db::getInstance()->ExecuteS($query);
            foreach($cursor as $ROW)
            {
                $SID=$ROW["session"];
                return (dechex(crc32($SID)) == $_COOKIE["VA_SID_".$userCode]);
            }*/
        }
        else
        {
            if ($userCode=="")
                $userCode = Session::get('LG_ID');
            $cursor = $this->where('UCode','=',$userCode)->get(['SID']);
           
            foreach($cursor as $ROW)
            {
                $SID=$ROW["SID"];
                return (dechex(crc32($SID)) == Cookie::get("VA_SID_".$userCode));
            }
            //$this->refreshOnlineStatus($userCode,time(),session_id());
        }
        return true;
    }
}
