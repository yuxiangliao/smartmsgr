<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Functions extends Model
{
    protected $table='sys_functions';
    //主键
    protected $primaryKey='ID';
    public $timestamps = false;
    protected $guarded=[];
    //主键不是自增模式
    public $incrementing = false;
    
    public function searchByFee($appID)
    {
        //$sql = "SELECT ID,Name,Description,LangID FROM {$this->table} WHERE ID LIKE '{$appID}%' AND Type='A' AND PayFee='Y' ORDER BY OrderNo";
        //return Db::getInstance()->ExecuteS($sql);
    }
    /**
     * call back function for generalCache
     */
    private function callbackGC($parentID,$level,&$cache1,&$cache2,&$cache3)
    {
        $sql = "SELECT * FROM {$this->table} WHERE ParentID='?' AND Actived=1 ORDER BY OrderNo";
        $cusor = DB::select($sql,[$parentID]);
        
        foreach ($cusor as $ROW)
        {
            $funcName=str_replace("\\","/",$ROW["FunctionName"]);
            $funcName=str_replace("\"","\\\"",$funcName);
            $funcName=strtolower($funcName);
            
            $id = $ROW["ID"];
            $type = $ROW["Type"];
            
            //$name = $ROW["NAME"];
            $indexName = $type.$id;
            $cache1 .= "   \"{$indexName}\" => array(\"ID\" => \"{$id}\",\"NAME\" => \"{$ROW['Name']}\",";
            $cache1 .= "\"PID\" => \"{$ROW['ParentID']}\",";
            $cache1 .= "\"DESCRIPTION\" => \"{$ROW['Description']}\",";
            $cache1 .= "\"TYPE\" => \"{$type}\",";
            $cache1 .= "\"FUNC_NAME\" => \"{$funcName}\",";
            $cache1 .= "\"LANG_ID\" => \"{$ROW['LangID']}\",";
            $cache1 .= "\"IMAGE\" => \"{$ROW['Image']}\",";
            $cache1 .= "\"OPEN_WIN\" => \"{$ROW['OpenWindow']}\",";
            $cache1 .= "\"PARAMS\" => \"{$ROW['Parameters']}\",";
            $cache1 .= "\"ACTIONS\" => \"{$ROW['Actions']}\",";
            $cache1 .= "\"LEVEL\" => \"{$level}\"";
            $cache1 .= "),\n";
            
            $cache2 .= "   \"{$id}\" => \"{$funcName}\",\n";
            
            if ($type=="A" && $funcName!="")
            {
                $cache3 .= "   \"{$funcName}\" => array(\"ID\" => \"{$id}\",\"NAME\" => \"{$ROW['Name']}\",";
                $cache3 .= "\"DESCRIPTION\" => \"{$ROW['Description']}\",";
                $cache3 .= "\"LANG_ID\" => \"{$ROW['LangID']}\",";
                $cache3 .= "\"IMAGE\" => \"{$ROW['Image']}\",";
                $cache3 .= "\"OPEN_WIN\" => \"{$ROW['OpenWindow']}\"";
                $cache3 .= "),\n";
            }
            
            $this->callbackGC($id,$level+1,$cache1,$cache2,$cache3);
        }
    }
    
    /**
     * general cache file for systemFunctions
     */
    public function generalCache()
    {
        $cache1 = "";
        $cache2 = "";
        $cache3 = "";
        $this->callbackGC("",0,$cache1,$cache2,$cache3);
        
        $cache1 ="<?\n\$SYS_FUNCTIONS = array(\n".substr($cache1,0,-2)."\n);\n?>";
        $cache2 ="<?\n\$SYS_FUNCTIONS = array(\n".substr($cache2,0,-2)."\n);\n?>";
        $cache3 ="<?\n\$SYS_FUNCTIONS_A = array(\n".substr($cache3,0,-2)."\n);\n?>";
        $cache_file_1 =config("settings._IM_INC_DIR_")."sys_function_all.php";
        $cache_file_2 =config("settings._IM_INC_DIR_")."sys_function.php";
        $cache_file_3 =config("settings._IM_INC_DIR_")."sys_function_a.php";
        if(!file_exists($cache_file_1) || is_writable($cache_file_1))
        {
//            $cache1 = $cache1;//.utf8_encode($cache1);
//            $cache2 = $cache1;//.utf8_encode($cache1);
//            $cache1 = "\xEF\xBB\xBF".$cache1;//.utf8_encode($cache1);
            file_put_contents($cache_file_1, $cache1);
            file_put_contents($cache_file_2, $cache2);
            file_put_contents($cache_file_3, $cache3);
        }
        else
        {
//          Message("错误","不能写入缓存文件，请设置OA安装目录\webroot\inc目录的权限");
        }
    }
}
