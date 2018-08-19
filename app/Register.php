<?php
namespace App;

class Register
{
    public $Header ;
    public $CompanyName;
    public $VerType;
    public $Version;
    public $Funcs;
    public $Experience;
    public $ExperienceDays;
    public $Customers;
    public $Users;
    public $RemainDays;
    
    public	function __construct()
    {
    }
    
    public function parse($licence)
    {
        $arrLicence = explode("|",$licence);
        $this->CompanyName = $arrLicence[0];
        $this->VerType = $arrLicence[1];
        $this->Version = $arrLicence[2];
        $this->Funcs = $arrLicence[3];
        $this->Experience = $arrLicence[4];
        $this->ExperienceDays = $arrLicence[5];
        $this->Customers = $arrLicence[6];
        $this->Users = $arrLicence[7];
        $this->RemainDays = $arrLicence[8];
        
    }
    public function parseJSON($licence)
    {
        $myclass = json_decode($licence);
        
        $this->Header = $myclass->header;
        $this->CompanyName = $myclass->company;
        $this->VerType = $myclass->verType;
        $this->Version = $myclass->ver;
        $this->Funcs = $myclass->funcs;
        $this->Experience = $myclass->experience;
        $this->ExperienceDays = $myclass->experienceDays;
        $this->Customers = $myclass->ccst;
        $this->Users = $myclass->cuser;
        $this->RemainDays = $myclass->remainDays;
        
    }
    
    public function isExpiry()
    {
        return $this->Experience=="Y" && $this->RemainDays <=0;
    }
    private static $_instance;
    public static function getInstance()
    {
        if(!isset(self::$_instance))
            self::$_instance = new TRegister();
        return self::$_instance;
    }
    
}

?>