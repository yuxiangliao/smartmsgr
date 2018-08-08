<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Models\Dictionary;
class IndexController extends Controller
{
    //
    public function Index(Request $request,Dictionary $dictionary){
        $RAND_NUM = rand();
        $RAND_NUM = md5($RAND_NUM);
        $request->session()->put("LG_RAND",$RAND_NUM);

        //session_write_close();

        $result = $dictionary->loadDictionaries("INTERFACE","","");

        foreach ($result as $row)
        {
            $$row->Code = $row->Description;
        }

        $AUTOCOMPLETE = "autocomplete=\"off\"";
        $USER_NAME_COOKIE = $_COOKIE['VA_USER_CODE'];
        if ( $USER_NAME_COOKIE == "" )
        {
            $FOCUS = "USERNAME";
        }
        else
        {
            $FOCUS = "PASSWORD";
        }

        $JAVA_SCRIPT = "<script>function CheckForm(){";
        $JAVA_SCRIPT.= "sUser = $('#USERNAME').val();sUser=sUser.toUpperCase();";
        $JAVA_SCRIPT.= "sPwd = $('#PASSWORD').val();sPwd=hex_md5(sUser+sPwd);sPwd=hex_md5(sPwd+'{$RAND_NUM}');$('#PASSWORD').val(sPwd);";
        $JAVA_SCRIPT.= "return true;}</script>";
        $ON_SUBMIT = "return CheckForm();";
        $HtmlData = array([
            "title" =>$APP_TITLE,
            "javascript"=>$JAVA_SCRIPT,
            "focus_filed"=>$FOCUS,
            "autocomplete"=>$AUTOCOMPLETE,
            "form_submit" =>$ON_SUBMIT,
            "logo_img"=>$LOGO_IMG,
            "username_cookie"=>$USER_NAME_COOKIE,
            "ui"=>$UI_SELECT,
            "antivirus_script"=>$ANTIVIRUS_SCRIPT,
            "tips"=>$TIPS,
            "lg_username"=>'User Name',
            "lg_password"=>'Password',
            "lg_login"=>'Login',
            "language"=>$LANGUAGE]);


/*
        $ANTIVIRUS_SCRIPT = file_get_contents( $ROOT_PATH."/include/antivirus.txt" );


        if ( file_exists( $ROOT_PATH.( "/templates/".$TEMPLATE."/index.html" ) ) )
        {
            $OUTPUT_HTML = file_get_contents( $ROOT_PATH.( "/templates/".$TEMPLATE."/index.html" ) );
        }
        else
        {
            $OUTPUT_HTML = file_get_contents( $ROOT_PATH."/templates/default/index.html" );
        }

        $langs = TLanguage::getLanguages();
        $LANGS = "";
        foreach ($langs as $lang)
        {
            if ($lang['id_lang']== _USER_ID_LANG_)
                $LANGUAGES .= "<li class=\"selected_language\"><img src=\"/images/l/{$lang['id_lang']}.jpg\" alt=\"{$lang['name']}\" width=\"16\" height=\"11\"/></li>";
            else
                $LANGUAGES .= "<li ><a href=\"?id_lang={$lang['id_lang']}\" title=\"{$lang['name']}\" ><img src=\"/images/l/{$lang['id_lang']}.jpg\" alt=\"{$lang['name']}\" width=\"16\" height=\"11\"/></a></li>";
        }
        $OUTPUT_HTML = str_replace( array("{title}","{javascript}","{focus_filed}","{autocomplete}","{form_submit}","{logo_img}","{username_cookie}","{ui}","{antivirus_script}","{tips}","{lg_username}","{lg_password}","{lg_login}","{language}"),array($APP_TITLE,$JAVA_SCRIPT,$FOCUS,$AUTOCOMPLETE,$ON_SUBMIT,$LOGO_IMG,$USER_NAME_COOKIE,$UI_SELECT,$ANTIVIRUS_SCRIPT,$TIPS,$LG_COMMON['username'],$LG_COMMON['userpass'],$LG_COMMON['login'],$LANGUAGES), $OUTPUT_HTML );

        echo $OUTPUT_HTML;
        echo "<script type=\"text/javascript\">";
        echo "self.moveTo(0,0);";
        echo "self.resizeTo(screen.availWidth,screen.availHeight);";
        echo "self.focus();";
        echo "</script>";
*/
        return view('index',$HtmlData);
    }

    public function getUser(){
        $data = User::all();
        foreach ($data as $row){
            dd($row->Code);
        }
    }
}
