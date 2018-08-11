<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SysLang extends Model
{
    protected $table='sys_lang';
    //主键
    protected $primaryKey='id_lang';

    protected $guarded=[];
    //主键不是自增模式
    public $incrementing = false;
    //关闭掉create_date和update_date字段
    public $timestamps = false;
}
