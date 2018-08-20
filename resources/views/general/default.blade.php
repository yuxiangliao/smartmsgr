<html>
    <head>
     <title>{{$APP_TITLE}}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="shortcut icon" href="smart/images/inhe.ico"/>
    <script>
        if ((parent != null)&&(parent.globalClass!=null))
        {

           parent.globalClass.changeLanguage("{{$iso}}");
        }
    </script>
    </head>
   <frameset rows="50,*,25"  cols="*" frameborder="no" border="0" framespacing="0" id="frame1">
      <frame name="banner" id="banner" scrolling="no" noresize="noresize" src="forms.php?a=nav_header" frameborder="0">
      <frameset rows="*"  cols="200,*" frameborder="no" border="0" framespacing="0" id="frame2">
          <frame name="leftmenu" id="leftmenu" scrolling="no" noresize="noresize" src="forms.php?a=nav_menu" frameborder="0">
         <frameset rows="28,*"  cols="*" frameborder="NO" border="0" framespacing="0">
              <frame name="shortcut" scrolling="no" noresize src="forms.php?a=nav_shortcut" frameborder="0">
              <frame name="main" scrolling="auto" noresize src="forms.php?a=nav_desktop" frameborder="0">
          </frameset>
       </frameset>
       <frame name="status_bar" id="status_bar" scrolling="no" noresize="noresize" src="forms.php?a=nav_statusbar" frameborder="0">
    </frameset>
   </html>
