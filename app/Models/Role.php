<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    protected $table='sys_roles';
    //主键
    protected $primaryKey=['Code'];

    protected $guarded=[];
    //主键不是自增模式
    public $incrementing = false;
    //关闭掉create_date和update_date字段
    public $timestamps = false;

    public function loadFunctions($IDs,&$FUNCs,&$ACTs)
    {
        if ($IDs=="")
            $IDs="0";
        $query = "";
        if($IDs!="")
            $result = $this->whereIn("Code",[$IDs])->orderBy('OrderNo','ASC')->get(['permissions','Actions']);
        else
            $result = $this->orderBy('OrderNo','ASC')->get(['permissions','Actions']);

        foreach ($result as $row)
        {
            $FUNC_STR = $row['permissions'];
            $FUNC_STR = str_replace("][",",",$FUNC_STR);
            $FUNC_STR = str_replace("[","",$FUNC_STR);
            $FUNC_STR = str_replace("]","",$FUNC_STR);
            $MY_ARRAY = explode( ",", $FUNC_STR );
            $ARRAY_COUNT = sizeof( $MY_ARRAY );
            if ( $MY_ARRAY[$ARRAY_COUNT - 1] == "" )
            {
                --$ARRAY_COUNT;
            }
            $I = 0;
            for ( ;	$I < $ARRAY_COUNT;	++$I	)
            {
                if ( !Tools::findIDEx( $FUNCs, $MY_ARRAY[$I] ) )
                {
                    $FUNCs .= "[".$MY_ARRAY[$I]."]";
                }
            }
            $FUNC_STR = $row['Actions'];

            $FUNC_STR = str_replace("][",",",$FUNC_STR);
            $FUNC_STR = str_replace("[","",$FUNC_STR);
            $FUNC_STR = str_replace("]","",$FUNC_STR);
            $MY_ARRAY = explode( ",", $FUNC_STR );
            $ARRAY_COUNT = sizeof( $MY_ARRAY );
            if ( $MY_ARRAY[$ARRAY_COUNT - 1] == "" )
            {
                --$ARRAY_COUNT;
            }
            $I = 0;
            for ( ;	$I < $ARRAY_COUNT;	++$I	)
            {
                if ( !Tools::findIDEx( $ACTs, $MY_ARRAY[$I] ) )
                {
                    $ACTs .= "[".$MY_ARRAY[$I]."]";
                }
            }

        }
    }

}
