<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Branch extends Model
{
    protected $table='tp_branch';
    //主键
    protected $primaryKey='Code';

    public $timestamps = false;

    protected $guarded=[];

    public $incrementing = false;

    public function getCodeByDept($deptID){
        $res = $this->where('DeptCode','=',$deptID)->first();
        return $res->Code;
    }
}
