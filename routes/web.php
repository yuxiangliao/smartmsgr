<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/','IndexController@Index');
Route::get('/lang/{langID?}','IndexController@Index');
Route::get('/user','IndexController@getUser');
Route::post('/checkin','IndexController@Login');
Route::group(['middleware' => 'licence'], function (){
    Route::any('/general/mainframe','IndexController@Main');
    Route::any('/general/default','IndexController@default');
    Route::any('/forms/{action}','IndexController@forms');
    Route::any('/general/navigator/header','IndexController@header');

});

Route::any('/testpage',function (){
   return __("common.BTN_REGISTER_AGAIN");
});

Route::get('/lang/{lang}',function ($lang){
    $curr_lang = App::getLocale();
    App::setLocale($lang);
    if(App::isLocale($lang))
        $lang = __('messages.welcome');
    return $curr_lang."|".$lang;
});