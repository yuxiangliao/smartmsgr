<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Dictionary extends Model
{
    //
    protected $table='sys_dictionary';
    //主键
    protected $primaryKey=['TableName', 'ParentCode','Code'];

    protected $guarded=[];
    //主键不是自增模式
    public $incrementing = false;
    //关闭掉create_date和update_date字段
    public $timestamps = false;

    public function loadDictionaries($TableName,$parent_code="",$code="",$fields="*"){
        $where = [];
        if($TableName !="")
            $where['TableName'] = $TableName;
        if($parent_code!="")
            $where['ParentCode'] = $parent_code;
        if($code!="")
            $where['Code'] = $code;
        DB::enableQueryLog();
        $res = $this->where($where)->get([$fields]);
        //dd(DB::getQueryLog());
        return $res;
    }
}
