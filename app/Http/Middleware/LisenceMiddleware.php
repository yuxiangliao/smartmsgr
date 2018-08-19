<?php

namespace App\Http\Middleware;

use Closure;
use App\Register;
class LisenceMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $licence = $request->session("REG_INFO");
        $regInfo = Register::getInstance();
        /*if ($licence==NULL)
        {
            //未验证
            $appClient = new AppClient(0);
            $appClient->init(_AS_SERVER_,_AS_PORT_);
            $licence = "";
        
            if ($appClient->open())
            {
                $licence = $appClient->checkRegister();
                if ( $licence < 0 )
                {
                    $result = $licence;
                }
                else
                {
                    $result = 0;
                }
                $appClient->close();
            }
            else
            {
                $result = -1;
            }
            if($result!=0)
            {
                include_once("general/sys/register.php");
                exit;
            }
            $regInfo->parseJSON($licence);
        
            $_SESSION["REG_COMPANY"] = $register->CompanyName;
            $_SESSION["REG_INFO"] = $licence;
        
        }
        else
        {
            $regInfo->parseJSON($licence);
        
        }
        if ($regInfo->isExpiry())
        {
            $_SESSION["REG_COMPANY"] = "";
            $_SESSION["REG_INFO"] = "";
            include_once("general/sys/register.php");
            exit;
        }
    
        //add by sdh 添加IP地址限制，单机版只允许本机访问
        $ClientIP=$_SERVER['REMOTE_ADDR'];
    
        if (($regInfo->VerType != "W") && ($ClientIP != "127.0.0.1"))
        {
            //echo "不支持网络用户登录";
            echo Tools::getMessageBox($LG_COMMON['infoWarn'],$LG_MSG['-90002']);
            exit;
        }*/
        return $next($request);
    }
}
