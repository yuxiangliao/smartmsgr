<?php
namespace App\Providers;

use App\Tools;
use App\Facades\ToolFacade;
use Illuminate\Support\ServiceProvider;

class ToolServiceProvider extends ServiceProvider
{
    public function boot()
    {

    }

    public function register()
    {
        $this->app->singleton('tools',function(){
            return new Tools;
        });

    }
}