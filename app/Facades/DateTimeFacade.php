<?php
namespace App\Facades;
use Illuminate\Support\Facades\Facade;

/**
 * Created by PhpStorm.
 * User: liao
 * Date: 2018-08-13
 * Time: 03:17 PM
 */

class DateTimeFacade extends Facade{

    protected static function getFacadeAccessor()
    {
        return 'datetime';
    }
}