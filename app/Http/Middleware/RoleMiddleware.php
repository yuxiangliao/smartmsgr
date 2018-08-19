<?php

namespace App\Http\Middleware;

use Closure;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next,$funcID,$action)
    {
        //$action = $request->session("LG_ACTs");
        if ($request->session('LG_ID') == "admin" )
        {
            $USER_FUNC_ID_STR="[011][01101][011011][011012][011013][011014][01122]";
            if (\Tool::findIDEx($USER_FUNC_ID_STR, $funcID))
                return $next($request);
        }
    
        $arrAct = explode(",",$action);
        foreach ($arrAct as $act)
        {
            $actStr = $funcID."-".$act;
            $USER_FUNC_ID_STR = $request->session("LG_ACTs");
            if (\Tool::findIDEx($USER_FUNC_ID_STR,$actStr))
                return $next($request);
        }
        return \Tool::getMessageBox(__("messages.infoWarn"),__("messages.-90002"));
        
    }
}
