<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

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

    private static $_checkedLangs;
    private static $_LANGUAGES;

    static public function getLanguages($active = true)
    {
        $languages = array();
        foreach (self::$_LANGUAGES AS $language)
            if (!$active OR ($active AND intval($language['active'])))
                $languages[] = $language;
        return $languages;
    }

    static public function getLanguage($id_lang)
    {
        if (!array_key_exists(intval($id_lang), self::$_LANGUAGES))
            return false;
        return self::$_LANGUAGES[intval($id_lang)];
    }

    /**
     * Return iso code from id
     *
     * @param integer $id_lang Language ID
     * @return string Iso code
     */
    static public function getIsoById($id_lang)
    {
        if (isset(self::$_LANGUAGES[intval($id_lang)]['iso_code']))
            return self::$_LANGUAGES[intval($id_lang)]['iso_code'];
        return false;
    }

    /**
     * Return id from iso code
     *
     * @param string $iso_code Iso code
     * @return integer Language ID
     */
    static public function getIdByIso($iso_code)
    {
        //if (!Validate::isLanguageIsoCode($iso_code))
        //    die(\Tool::displayError());
        $query = "select id_lang from sys_lang where iso_code = ? ";
        $result = DB::select($query,[strtolower($iso_code)]);

        if (count($result)>0)
            return intval($result[0]['id_lang']);
    }

    /**
     * Return array (id_lang, iso_code)
     *
     * @param string $iso_code Iso code
     * @return array  Language (id_lang, iso_code)
     */
    static public function getIsoIds()
    {
        $result = DB::select('
		SELECT `id_lang`, `iso_code`
		FROM `sys_lang`');

        return $result;
    }


    /**
     * Load all languages in memory for caching
     */
    static public function loadLanguages()
    {
        self::$_LANGUAGES = array();
        $query = 'SELECT `id_lang`, `name`, `iso_code`, `active` FROM {$this->table}' ;
        DB::select($query);
        $result = DB::select('
		SELECT `id_lang`, `name`, `iso_code`, `active` 
		FROM `sys_lang`');
        foreach ($result AS $row)
            self::$_LANGUAGES[intval($row['id_lang'])] = array('id_lang' => intval($row['id_lang']), 'name' => $row['name'], 'iso_code' => $row['iso_code'], 'active' => intval($row['active']));
    }

}
