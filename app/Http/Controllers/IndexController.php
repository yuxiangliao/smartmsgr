<?php

namespace App\Http\Controllers;

use App\Models\SysLang;
use App\Models\User;
use App\Models\UserOnline;
use Illuminate\Http\Request;
use App\Models\Dictionary;
use App\Models\Branch;
use App\Models\Role;
use App\includeFunc;

use Illuminate\Support\Facades\Cookie;
use Illuminate\Support\Facades\Session;

class IndexController extends Controller
{
    private $dictionary;
    private $useronline;
    private $user;
    private $branch;

    public function __construct(Dictionary $dictionary,
        UserOnline $useronline,User $user,Branch $branch)
    {
        $this->dictionary = $dictionary;
        $this->useronline = $useronline;
        $this->user = $user;
        $this->branch = $branch;
    }
    
    public function Index(Request $request,$langID=1){
        $RAND_NUM = rand();
        $RAND_NUM = md5($RAND_NUM);
        $request->session()->put("LG_RAND",$RAND_NUM);

        //session_write_close();

        $result = $this->dictionary->loadDictionaries("INTERFACE","","");

        foreach ($result as $row)
        {
            ${$row['Code']} = $row['Description'];
        }

        $AUTOCOMPLETE = "autocomplete=\"off\"";
        $USER_NAME_COOKIE =$request->cookie('VA_USER_CODE'); //$_COOKIE['VA_USER_CODE'];
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

        $script=<<<eof
        <script type=\"text/javascript\">
            self.moveTo(0,0);
            self.resizeTo(screen.availWidth,screen.availHeight);
            self.focus();
        </script>
eof;
        $languages = SysLang::all();
        $HtmlData = array(
            "title" =>$APP_TITLE,
            "javascript"=>$JAVA_SCRIPT,
            "focus_filed"=>$FOCUS,
            "autocomplete"=>$AUTOCOMPLETE,
            "form_submit" =>$ON_SUBMIT,
            //"logo_img"=>$LOGO_IMG,
            "username_cookie"=>$USER_NAME_COOKIE,
            //"ui"=>$UI_SELECT,
            "antivirus_script"=>'',//$ANTIVIRUS_SCRIPT,
            //"tips"=>$TIPS,
            "lg_username"=>__('messages.lg_username'),
            "lg_password"=>__('messages.lg_password'),
            "lg_login"=>__('messages.lg_login'),
            "languages"=>$languages,
            'script'=>$script,
        );
/*
        $ANTIVIRUS_SCRIPT = file_get_contents( $ROOT_PATH."/include/antivirus.txt" );
*/
        return view('index',$HtmlData);
    }
    
    public function Login(Request $request){

        $USER_NAME = $request->input('USERNAME');
        $PASS_WORD = $request->input('PASSWORD');
        $CUR_TIME = date("Y-m-d H:i:s",time());
        $USER_NAME = trim($USER_NAME);
        $this->useronline->clearOnlineStatus();
        $LOGIN_MSG='';
        $loginError='';
        if ($this->useronline->checkOnlineStatus($USER_NAME))
        {
            $RAND_NUM = Session::get('LG_RAND');
            $LOGIN_MSG = $this->user->checkLogin($USER_NAME,$PASS_WORD,$RAND_NUM);
            if ($LOGIN_MSG==0 && $this->user->IpLimit == "Y")
            {
                /*$branchClient = TBranchClient::getInstance();
                if (!$branchClient->loadEx($clientIP,"Y","BranchCode"))
                {
                    $LOGIN_MSG = -2107;
                    return ;
                }
                //Try to change the department
                if ($User->AutoDept == "Y")
                {
                    $branch = TBranch::getInstance();
                    if (!$branch->loadEx($branchClient->BranchCode,"DeptCode"))
                    {
                        $LOGIN_MSG = -2107;
                        return;
                    }
                    $User->refreshDept($User->Code,$branch->DeptCode);
                    //reload the details for user
                    $User->Load($User->Code);
                }
        
                $branchClient->refreshVisitor($clientIP,$User->Code);*/
        
            }
            if ($LOGIN_MSG==0)
            {//取得用户所在售电点
                $branchCode = $this->branch->getCodeByDept($this->user->DeptID);
                if ($branchCode=="")
                    $branchCode = $this->branch->getCodeByDept($this->user->AdminDept);
                Session::put("LG_BRNACH",$branchCode);
            }
        }
        else
        {/*
            $LOGIN_MSG = -2108;
            $event = Event::getInstance();
            if ($event->LoadByUser($USERNAME,"IP,EventTime"))
            {
                $event->msgItem["IP"] = $event->IP;
                $event->msgItem["TIME"] = $event->EventTime;
            }
        */
            $LOGIN_MSG = -2108;
            $loginError = \Tool::getMessageBox(__('messages.LoginFailed'),$LOGIN_MSG,"error");
        }
        if ($LOGIN_MSG==0)
        {
            //验证成功
            $RoleIDs = $this->user->RoleIDOthers;
            $RoleIDs = str_replace("][",",",$RoleIDs);
            $RoleIDs = str_replace("[","",$RoleIDs);
            $RoleIDs = str_replace("]","",$RoleIDs);
            if ( (\Tool::findIDEx( $this->user->RoleIDOthers, $this->user->RoleID )) && $this->user->RoleID!="")
            {
                if ($RoleIDs=="")
                    $RoleIDs .= $this->user->RoleID;
                else
                    $RoleIDs .= ",".$this->user->RoleID;
            }
            $LG_FUNCs = "";
            $LG_ACTs = "";
            $Role = new Role();
            $roleArray = $Role->loadFunctions($RoleIDs,$LG_FUNCs,$LG_ACTs);
            Session::put("LG_ID",$this->user->Code);
            Session::put("LG_NAME",$this->user->Name);
            Session::put("LG_DESCRIPTION",$this->user->Description);
            Session::put("LG_THEME",$this->user->Theme);
            Session::put("LG_FUNCs",$LG_FUNCs);
            Session::put("LG_ACTs",$LG_ACTs);
            Session::put("LG_ADMIN_DEPT",$this->user->AdminDept);
            Session::put("LG_DEPT_ID",$this->user->DeptID);
            Session::put("LG_TIME",time());
            Session::put("REG_INFO","");
            $this->useronline->refreshOnlineStatus($this->user->Code,time(),session_id());
            $this->useronline->clearOnlineStatus();
            //Event::addEvent($this->user->Code,1);
            Cookie::queue("VA_SID_".$this->user->Code,dechex(crc32(session_id())),time()+60*60*24*1000);
            Cookie::queue("VA_USER_CODE",$this->user->Code);
        }
        else
        {
            //验证失败
            switch ($LOGIN_MSG)
            {

                case -2103:
                    $LOGIN_MSG = str_replace("[minutes]",$SEC_RETRY_MINS,__("messages.{$LOGIN_MSG}"));

                    break;

                case -2105:
                    $LOGIN_MSG = str_replace("[username]",$this->user->Code,__("messages.{$LOGIN_MSG}"));//"the user ".$userCode." is refused to login the system!";
                    break;
                default:
                    $LOGIN_MSG = __("messages.{$LOGIN_MSG}");

            }

        }
        list($CUR_YEAR,$CUR_MON,$CUR_DAY,$CUR_HOUR,$CUR_MINITE,$CUR_SECOND) = \Tool::DateTimeEx(hexdec(dechex(time())));
        $TIME_STR="$CUR_YEAR,$CUR_MON-1,$CUR_DAY,$CUR_HOUR,$CUR_MINITE,$CUR_SECOND";

        $lastTime = $this->user->LastVisitTime;//TEventTime::getInstance()->getLastTime();
        if ($lastTime=="")
            $MSG = __('messages.SysNotUsed')."<br> ";
        else
            $MSG = __('messages.LastUsedTime').": {$lastTime} .<br> ";

        $MSG .= __('messages.CurrTimeIs').":<br> ";

        $MSG .= "<div id=\"banner_time\" style='color: #FF0000;' align=\"center\"><span class=\"time_left\">";
        $MSG .= "<span class=\"time_right\">";
        $MSG .= "<span id='header_date' title=''></span>&nbsp;&nbsp;&nbsp;";
        $MSG .= "<span id=\"header_time\">20:19:10</span>&nbsp&nbsp;&nbsp;<b>";
        $MSG .= \Tool::getWeek();
        $MSG .= "</b></span></span>";
        $MSG .= " </div>";
        $MessageBox = \Tool::getMessageBox(__('messages.ConfirmTime') ,$MSG,"info");

        return view('confirm',[
            'LOGIN_MSG' => $LOGIN_MSG,
            'CUR_YEAR' => $CUR_YEAR,
            'CUR_MON' => $CUR_MON,
            'CUR_DAY' => $CUR_DAY,
            'CUR_HOUR' => $CUR_HOUR,
            'CUR_MINITE' => $CUR_MINITE,
            'CUR_SECOND' => $CUR_SECOND,
            'TIME_STR' => $TIME_STR,
            'loginError' =>$loginError,
            'MessageBox' => $MessageBox,
            'VA_UI' => "general/mainframe",
            'LastVisitTime'=>$this->user->LastVisitTime,
            'Weeks'=>\Tool::getWeek(),
        ]);
    }

    public function main(Request $request){
        $checkLicence = false;
        //include_once("include/auth.php");
        /*if ($iso = \Tool::getValue('isolang') AND Validate::isLanguageIsoCode($iso) AND ($id_lang = intval(Language::getIdByIso($iso))))
        {
            $_GET['id_lang'] = $id_lang;
        }*/
        $result = $this->dictionary->loadDictionaries("INTERFACE","","APP_TITLE");
        foreach ($result as $row)
        {
            ${$row['Code']} = $row['Description'];
            //dd(${$row['Code']});
        }


        $CURR_THEME = Session::get("LG_THEME");
        $CURR_THEME = $CURR_THEME==""?"1":$CURR_THEME;
//**********************add by cz
        $operacode = Session::get("LG_ID");
        $this->user->loadbyCode($operacode);
//**********************add by cz 150325 ¿ØÖÆÐÞ¸ÄÃÜÂë
        $PWD = md5(strtoupper($operacode));
        if ($this->user->PWD==$PWD)
        {
           return view("general.public.pswd");
        }

        $result = $this->dictionary->loadDictionaries("SYS_PARAM","","PWDEXPIRY");
        foreach ($result as $row)
        {
            ${$row['Code']} = $row['V2'];
        }

        if (isset($PWDEXPIRY) && ($PWDEXPIRY !="") && ($PWDEXPIRY !="0"))
        {
            if (!\TDateTime::daysBetween($this->user->PWDExpiry,$PWDEXPIRY))
            {
                return view('general.public.pswd');
            }
        }
        return view('general.mainframe',[
            'APP_TITLE' => $APP_TITLE,
            'CURR_THEME'=>'1',
        ]);
    }

    public function default(SysLang $lang){
        $checkLicence = false;

        $result = $this->dictionary->loadDictionaries("INTERFACE","","APP_TITLE");
        foreach ($result as $row)
        {
            ${$row['Code']} = $row['Description'];
        }
        $iso = strtolower($lang->getIsoById(Cookie::get('id_lang') ? intval(Cookie::get('id_lang')) : 1));
        return view('general.default',[
            'APP_TITLE' => $APP_TITLE,
            'iso' =>$iso,
        ]);

    }
    
    public function forms(Request $request,$action){
        //use IncludeFunction->s;
        $act = strtolower($action);
        $LANG_MODULES = array('function');
        //('config/config.inc.php');
        //include_once('init.php');
    
        $CURR_THEME = $request->session("LG_THEME");
        $CURR_THEME = $CURR_THEME==""?"1":$CURR_THEME;
    
        $actArray = array(
            "nav_menu" => array("URL"=>"navigator/menu" ,"BODYCLS"=>"leftmenubody"),
            "nav_header" => array("URL"=>"/general/navigator/header" ,"BODYCLS"=>"headerbody"),
            "nav_shortcut" => array("URL"=>"navigator/shortcut" ,"BODYCLS"=>"shortcutbody"),
            "nav_statusbar" => array("URL"=>"navigator/statusbar" ,"BODYCLS"=>"statusbar"),
            "nav_desktop" => array("URL"=>"desktop/main" ,"BODYCLS"=>"tablebody"),
        );

        //include_once(config("settings._IM_INC_DIR_")."sys_function_a.php");
        $SYS_FUNCTIONS_A = config("sys_function_a");
        $title = "";
        $titleImg = "/smart/images/outbox.gif";
        if (isset($hideTitle))
        {
            $showTitle = "N";
            $bodyClass = "";
        }
        else
        {
            $showTitle = "Y";
            $bodyClass = "mainbody";
        }
        $resizeBody = true;
        $CURR_MODULE_ID ="";


        if (array_key_exists($act,$actArray))
        {
            $bodyClass = $actArray[$act]['BODYCLS'];
            if ($bodyClass=="")
                $bodyClass = "mainbody";
            $showTitle = "N";
            $resizeBody = false;
            $act = $actArray[$act]['URL'];
        }
        else if (array_key_exists($act,$SYS_FUNCTIONS_A))
        {
            if ($showTitle=="Y")
            {
                $title = $SYS_FUNCTIONS_A[$act]['LANG_ID'];
                    //$title = $LG_FUNC[$title.'T'];
                if ($title=="")
                    $title = $SYS_FUNCTIONS_A[$act]['DESCRIPTION'];
                if ($SYS_FUNCTIONS_A[$act]['IMAGE'] !="")
                    $titleImg = "/smart/images/menu/".$SYS_FUNCTIONS_A[$act]['IMAGE']."gif";
            }
            $CURR_MODULE_ID = $SYS_FUNCTIONS_A[$act]['ID'];
        }
        $actURL = $act;
        $params = \Tool::getArgsStr("a");
        if ($params != "")
            $actURL .="?".$params;


        return view('general.form',[
            'title'=>$title,
            'resizeBody'=>$resizeBody,
            'act' => $act,
            'bodyClass' => $bodyClass,
            'CURR_MODULE_ID' => "",
            'module_action' => "",
            'actURL' => $actURL,
            'ErrMessages'=>\Tool::getMessageBox(__('LG_COMMON.NOTICE_ERROR'),__('LG_COMMON.INVALID_PARAMETER')),
        ]);
    }

    public function header(){

        $result = $this->dictionary->loadDictionaries("INTERFACE");
        foreach ($result as $row)
        {
            ${$row['Code']} = $row['Description'];
        }

        $languages = SysLang::all();
        list($CUR_YEAR,$CUR_MON,$CUR_DAY,$CUR_HOUR,$CUR_MINITE,$CUR_SECOND) = \Tool::DateTimeEx(hexdec(dechex(time())));
        $TIME_STR="$CUR_YEAR,$CUR_MON,$CUR_DAY,$CUR_HOUR,$CUR_MINITE,$CUR_SECOND";
        $CUR_WEEK = \Tool::getWeek();
        $HEAD_TITLE = htmlspecialchars($HEAD_TITLE);
        return view('general.navigator.header',[
            'TIME_STR'=>$TIME_STR,
            'CUR_WEEK'=>$CUR_WEEK,
            'LANGS'=>$languages,
        ]);
    }
}
