<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - AdGuardHome</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=adguardhome_&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<style>
.adguardhome_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.adguardhome_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.adguardhome_btn_update {
    font-size:10pt;
	  color: #FC0;
}
.adguardhome_btn_update:hover  {
    font-size:10pt;
	  color: #FC0;
}

input[type=button]:focus {
	outline: none;
}
.show-btn1, .show-btn2, .show-btn3 {
	border: 1px solid #222;
	border-bottom:none;
	background: linear-gradient(to bottom, #919fa4  0%, #67767d 100%); /* W3C */
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.45601%;
}
.show-btn1:hover, .show-btn2:hover, .show-btn3:hover, .active {
	background: #2f3a3e;
}
.input_adg_table{
	margin-left:2px;
	padding-left:0.4em;
	height:21px;
	width:158.2px;
	line-height:23px \9;	/*IE*/
	font-size:13px;
	font-family: Lucida Console;
	background-image:none;
	background-color: #576d73;
	border:1px solid gray;
	color:#FFFFFF;
}
.SimpleNote { padding:5px 10px;}
.input_option{
	height:25px;
	background-color:#576D73;
	border-top-width:1px;
	border-bottom-width:1px;
	border-color:#888;
	color:#FFFFFF;
	font-family: Lucida Console;
	font-size:13px;
}
</style>

<script>
var _responseLen;
var noChange = 0;
var noChange2 = 0;
var x = 5;
var $j = jQuery.noConflict();
var params_input = ["adguardhome_work_dir","adguardhome_update_dir", "adguardhome_port", "adguardhome_dns_port"];
function init() {
  show_menu();
  buildswitch();
  toggle_func();
  generate_link();
  set_show_status();
  set_show_dns();
  auto_bin_update();
  adguardhome_dnsmasq_set();
  adguardhome_perp_set();
  adguardhome_upx_set();
  adguardhome_shadowsocks_patch_set();
  setTimeout("get_adguardhome_status()", 1000);
  conf2obj();
}

function conf2obj(){
    var rrt = document.getElementById("switch");
    if (document.form.adguardhome_enable.value != "1") {
    document.getElementById('adguardhome_detail').style.display = "none";
        rrt.checked = false;
    } else {
    document.getElementById('adguardhome_detail').style.display = "";
        rrt.checked = true;
    }
}

function buildswitch(){
  $j("#switch").click(
  function(){
    if(document.getElementById('switch').checked){
      document.form.adguardhome_enable.value = 1;
      document.getElementById('adguardhome_detail').style.display = "";

    }else{
      document.form.adguardhome_enable.value = 0;
      document.getElementById('adguardhome_detail').style.display = "none";
    }
  });
}

function set_show_dns(){
    if(document.form.adguardhome_dns_enable.value == 1){
       document.getElementById('adguardhome_dns_port_tr').style.display="";
    }
}


function set_show_status(){
  var dbus = {};
  dbus["SystemCmd"] = "adguardhome_set_status.sh";
  dbus["action_mode"] = " Refresh ";
  dbus["current_page"] = "Module_adguardhome.asp";
  $j.ajax({
    type: "POST",
    url: '/applydb.cgi?p=adguardhome_',
    contentType: "application/x-www-form-urlencoded",
    dataType: 'text',
    data: dbus,
  });
}

function status_update(){
    set_show_status();
    setTimeout("location.reload(true);", 500);
}

function adguardhome_binary_update(){
  var dbus = {};
  dbus["SystemCmd"] = "adguardhome_bin_update.sh";
  dbus["action_mode"] = " Refresh ";
  dbus["current_page"] = "Module_adguardhome.asp";
  $j.ajax({
    type: "POST",
    url: '/applydb.cgi?p=adguardhome_',
    contentType: "application/x-www-form-urlencoded",
    dataType: 'text',
    data: dbus,
    success: function(response) {
        showAGHLoadingBar();
        noChange2 = 0;
        setTimeout("get_realtime_log()", 500);
    }
  });
}

function adguardhome_update(){
  var dbus = {};
  dbus["SystemCmd"] = "adguardhome_update.sh";
  dbus["action_mode"] = " Refresh ";
  dbus["current_page"] = "Module_adguardhome.asp";
  $j.ajax({
    type: "POST",
    url: '/applydb.cgi?p=adguardhome_',
    contentType: "application/x-www-form-urlencoded",
    dataType: 'text',
    data: dbus,
    success: function(response) {
        showAGHPluginLoadingBar();
        noChange2 = 0;
        setTimeout("get_realtime_log()", 500);
    }
  });
}

function onSubmitCtrl(o, s) {
  document.form.action_mode.value = s;
  showLoading(10);
  document.form.submit();
  noChange = 0;
  setTimeout("get_adguardhome_status()", 1000);
  setTimeout("location.reload(true);", 10000);
}


function reload_adguardhome_detail_table(){
  setTimeout("get_adguardhome_status()", 1000);
}


function generate_link() {
  document.getElementById("adguardhome_web").href = "http://" + '<% nvram_get("lan_ipaddr"); %>' + ":" + '<% dbus_get_def("adguardhome_port", "3000"); %>';
}

function showAGHLoadingBar(seconds) {
  if (window.scrollTo)
    window.scrollTo(0, 0);

  disableCheckChangedStatus();

  htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
  htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

  winW_H();

  var blockmarginTop;
  var blockmarginLeft;
  if (window.innerWidth)
    winWidth = window.innerWidth;
  else if ((document.body) && (document.body.clientWidth))
    winWidth = document.body.clientWidth;

  if (window.innerHeight)
    winHeight = window.innerHeight;
  else if ((document.body) && (document.body.clientHeight))
    winHeight = document.body.clientHeight;

  if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
    winHeight = document.documentElement.clientHeight;
    winWidth = document.documentElement.clientWidth;
  }

  if (winWidth > 1050) {

    winPadding = (winWidth - 1050) / 2;
    winWidth = 1105;
    blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
  } else if (winWidth <= 1050) {
    blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;

  }

  if (winHeight > 660)
    winHeight = 660;

  blockmarginTop = winHeight * 0.3 - 140

  document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop + "px";
  document.getElementById("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
  document.getElementById("loadingBarBlock").style.width = 770 + "px";
  document.getElementById("LoadingBar").style.width = winW + "px";
  document.getElementById("LoadingBar").style.height = winH + "px";

  loadingSeconds = seconds;
  progress = 100 / loadingSeconds;
  y = 0;
  LoadingAGHProgress(seconds);
}

function showAGHPluginLoadingBar(seconds) {
  if (window.scrollTo)
    window.scrollTo(0, 0);

  disableCheckChangedStatus();

  htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
  htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

  winW_H();

  var blockmarginTop;
  var blockmarginLeft;
  if (window.innerWidth)
    winWidth = window.innerWidth;
  else if ((document.body) && (document.body.clientWidth))
    winWidth = document.body.clientWidth;

  if (window.innerHeight)
    winHeight = window.innerHeight;
  else if ((document.body) && (document.body.clientHeight))
    winHeight = document.body.clientHeight;

  if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
    winHeight = document.documentElement.clientHeight;
    winWidth = document.documentElement.clientWidth;
  }

  if (winWidth > 1050) {

    winPadding = (winWidth - 1050) / 2;
    winWidth = 1105;
    blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
  } else if (winWidth <= 1050) {
    blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;

  }

  if (winHeight > 660)
    winHeight = 660;

  blockmarginTop = winHeight * 0.3 - 140

  document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop + "px";
  document.getElementById("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
  document.getElementById("loadingBarBlock").style.width = 770 + "px";
  document.getElementById("LoadingBar").style.width = winW + "px";
  document.getElementById("LoadingBar").style.height = winH + "px";

  loadingSeconds = seconds;
  progress = 100 / loadingSeconds;
  y = 0;
  LoadingAGHPluginProgress(seconds);
}


function LoadingAGHProgress(seconds) {
  document.getElementById("LoadingBar").style.visibility = "visible";
  document.getElementById("loading_block3").innerHTML = "AdGuardHome程序更新中 ..."
  document.getElementById("loading_block2").innerHTML = "<li><font color='#ffcc00'>尝试不同的DNS及拦截清单配置，可以达到最佳的效果哦...</font></li><li><font color='#ffcc00'>请等待日志显示完毕，并出现自动关闭按钮！</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>"
}

function LoadingAGHPluginProgress(seconds) {
  document.getElementById("LoadingBar").style.visibility = "visible";
  document.getElementById("loading_block3").innerHTML = "AdGuardHome插件更新中 ..."
  document.getElementById("loading_block2").innerHTML = "<li><font color='#ffcc00'>请等待日志显示完毕，并出现自动关闭按钮！</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>"
}

function hideAGHLoadingBar() {
  x = -1;
  E("LoadingBar").style.visibility = "hidden";
  checkss = 0;
  refreshpage();
}

function count_down_close() {
  if (x == "0") {
    hideAGHLoadingBar();
  }
  if (x < 0) {
    E("ok_button1").value = "手动关闭"
    return false;
  }
  E("ok_button1").value = "自动关闭（" + x + "）"
    --x;
  setTimeout("count_down_close();", 1000);
}

function E(e) {
  return (typeof(e) == 'string') ? document.getElementById(e) : e;
}

function get_realtime_log() {
  $j.ajax({
    url: '/cmdRet_check.htm',
    dataType: 'html',
    error: function(xhr) {
      setTimeout("get_realtime_log();", 1000);
    },
    success: function(response) {
      var retArea = E("log_content3");
      if (response.search("XU6J03M6") != -1) {
        retArea.value = response.replace("XU6J03M6", " ");
        E("ok_button").style.display = "";
        retArea.scrollTop = retArea.scrollHeight;
        x = 5;
        count_down_close();
        return true;
      } else {
        E("ok_button").style.display = "none";
      }
      if (_responseLen == response.length) {
        noChange2++;
      } else {
        noChange2 = 0;
      }
      if (noChange2 > 1000) {
        return false;
      } else {
        setTimeout("get_realtime_log();", 250);
      }
      retArea.value = response.replace("XU6J03M6", " ");
      retArea.scrollTop = retArea.scrollHeight;
      _responseLen = response.length;
    },
    error: function() {
      setTimeout("get_realtime_log();", 500);
    }
  });
}


function get_adguardhome_status(){
  var dbus = {};
  dbus["SystemCmd"] = "adguardhome_status.sh";
  dbus["action_mode"] = " Refresh ";
  dbus["current_page"] = "Module_adguardhome.asp";
  $j.ajax({
    type: "POST",
    url: '/applydb.cgi?p=adguardhome_',
    contentType: "application/x-www-form-urlencoded",
    dataType: 'text',
    data: dbus,
        error: function(xhr) {
          alert("error");
          },
        success: function(response) {
        checkCmdRet();
          }
  });
}


function checkCmdRet(){
  $j.ajax({
    url: '/res/adguardhome_check.htm',
    dataType: 'html',

    error: function(xhr){
      setTimeout("checkCmdRet();", 100);
    },
    success: function(response){
      var _cmdBtn = document.getElementById("cmdBtn");
      if(response.search("XU6J03M6") != -1){
        adguardhome_status = response.replace("XU6J03M6", " ");
        document.getElementById("status").innerHTML = adguardhome_status;
        setTimeout("get_adguardhome_status;", 1000);
        return true;
      }
      if(_responseLen == response.length){
        noChange++;
      }else{
        noChange = 0;
      }

      if(noChange > 100){
        noChange = 0;
        refreshpage();
      }else{
        setTimeout("checkCmdRet();", 400);
      }
      _responseLen = response.length;

    }
  });
}

function  auto_bin_update() {
      check_selected("adguardhome_bin_auto_update", db_adguardhome_.adguardhome_bin_auto_update);
}


function  adguardhome_dnsmasq_set() {
      check_selected("adguardhome_dnsmasq_set", db_adguardhome_.adguardhome_dnsmasq_set);
}

function  adguardhome_perp_set() {
      check_selected("adguardhome_perp_set", db_adguardhome_.adguardhome_perp_set);
}

function  adguardhome_upx_set() {
      check_selected("adguardhome_upx_set", db_adguardhome_.adguardhome_upx_set);
}

function  adguardhome_shadowsocks_patch_set() {
      check_selected("adguardhome_shadowsocks_patch_set", db_adguardhome_.adguardhome_shadowsocks_patch_set);
}

function check_selected(obj, m) {
    var o = document.getElementById(obj);
    for (var c = 0; c < o.length; c++) {
        if (o.options[c].value == m) {
            o.options[c].selected = true;
            break;
        }
    }
}


function toggle_func() {
	$j('.show-btn1').addClass('active');
	$j(".show-btn1").click(
		function() {
			$j('.show-btn1').addClass('active');
			$j('.show-btn2').removeClass('active');
			$j('.show-btn3').removeClass('active');
			E("adguardhome_detail_table1").style.display = "";
			E("adguardhome_detail_table2").style.display = "none";
			E("adguardhome_detail_table3").style.display = "none";
			E("warnnote1").style.display = "";
			E("warnnote2").style.display = "none";
			E("warnnote3").style.display = "none";
		});
	$j(".show-btn2").click(
		//dns pannel
		function() {
			$j('.show-btn1').removeClass('active');
			$j('.show-btn2').addClass('active');
			$j('.show-btn3').removeClass('active');
			E("adguardhome_detail_table1").style.display = "none";
			E("adguardhome_detail_table2").style.display = "";
			E("adguardhome_detail_table3").style.display = "none";
			E("warnnote1").style.display = "none";
			E("warnnote2").style.display = "";
			E("warnnote3").style.display = "none";
		});
	$j(".show-btn3").click(
		//dns pannel
		function() {
			$j('.show-btn1').removeClass('active');
			$j('.show-btn2').removeClass('active');
			$j('.show-btn3').addClass('active');
			E("adguardhome_detail_table1").style.display = "none";
			E("adguardhome_detail_table2").style.display = "none";
			E("adguardhome_detail_table3").style.display = "";
			E("warnnote1").style.display = "none";
			E("warnnote2").style.display = "none";
			E("warnnote3").style.display = "";
		});
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

</script>
</head>
<body onload="init();">
  <div id="TopBanner"></div>
  <div id="Loading" class="popup_bg"></div>
  <div id="LoadingBar" class="popup_bar_bg">
  <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock"  align="center">
    <tr>
      <td height="100">
      <div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
      <div id="loading_block2" style="margin:10px auto;width:95%;"></div>
      <div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
        <textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:#000;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
      </div>
      <div id="ok_button" class="apply_gen" style="background: #000;display: none;">
        <input id="ok_button1" class="button_gen" type="button" onclick="hideAGHLoadingBar()" value="确定">
      </div>
      </td>
    </tr>
  </table>
  </div>
  <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
  <form method="POST" name="form" action="/applydb.cgi?p=adguardhome_" target="hidden_frame">
  <input type="hidden" name="current_page" value="Module_adguardhome_.asp"/>
  <input type="hidden" name="next_page" value="Module_adguardhome_.asp"/>
  <input type="hidden" name="group_id" value=""/>
  <input type="hidden" name="modified" value="0"/>
  <input type="hidden" name="action_mode" value=""/>
  <input type="hidden" name="action_script" value=""/>
  <input type="hidden" name="action_wait" value=""/>
  <input type="hidden" name="first_time" value=""/>
  <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
  <input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="adguardhome_config.sh"/>
  <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
  <input type="hidden" id="adguardhome_enable" name="adguardhome_enable" value='<% dbus_get_def("adguardhome_enable", "0"); %>'/>
  <input type="hidden" id="adguardhome_dns_enable" name="adguardhome_dns_enable" value='<% dbus_get_def("adguardhome_dns_enable", "0"); %>'/>
  <table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td width="17">&nbsp;</td>
      <td valign="top" width="202">
        <div id="mainMenu"></div>
        <div id="subMenu"></div>
      </td>
      <td valign="top">
        <div id="tabMenu" class="submenuBlock"></div>
        <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
          <tr>
            <td align="left" valign="top">
              <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
                <tr>
                  <td bgcolor="#4D595D" colspan="3" valign="top">
                    <div>&nbsp;</div>
                    <div style="float:left;" class="formfonttitle">AdGuardHome</div>
                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div class="SimpleNote">
                         <li>AdGuard Home 是一款全网广告拦截与反跟踪软件。在您将其安装完毕后，它将保护您所有家用设备，同时您不再需要安装任何客户端软件。随着物联网与连接设备的兴起，掌控您自己的整个网络环境变得越来越重要。</li>
                    </div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div class="formfontdesc" id="cmdDesc"><i>当前插件版本：<% dbus_get_def("adguardhome_version", "0"); %></i>  <i><a type="button"  target="_blank" href="https://github.com/gshang2017/merlin-AdGuardHome"><em>【<u>插件主页</u>】</em></a></i> &nbsp;&nbsp;<a id="adguardhome_update" type="button" class="adguardhome_btn" style="cursor:pointer" onclick="adguardhome_update()">检查并更新</a> &nbsp;&nbsp;&nbsp;&nbsp;<i>当前adguardhome版本：<% dbus_get_def("adguardhome_bin_version", "0"); %></i> <i><a type="button"  target="_blank" href="https://github.com/AdguardTeam/AdGuardHome"><em>【<u>AdGuardHome程序主页</u>】</em></a> </i>  </div>
                    <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
                      <thead>
                      <tr>
                        <td colspan="2">开关设置</td>
                      </tr>
                      </thead>
                      <tr id="switch_tr">
                        <th>
                          <label>开关</label>
                        </th>
                        <td colspan="2">
                          <div class="switch_field" style="display:table-cell">
                            <label for="switch">
                              <input id="switch" class="switch" type="checkbox" onclick="reload_adguardhome_detail_table();" style="display: none;">
                              <div class="switch_container" >
                                <div class="switch_bar"></div>
                                <div class="switch_circle transition_style">
                                  <div></div>
                                </div>
                              </div>
                            </label>
                          </div>
                          <div id="adguardhome_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>
                        </td>
                      </tr>
                    </table>
					<div id="adguardhome_detail">
					  <div id="tablets">
						<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px"  id="adguardhome_detail_table">
							<tr width="235px">
								<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
									<input id="show-btn1" class="show-btn1" style="cursor:pointer"   type="button" value="基本设置" />
									<input id="show-btn2" class="show-btn2"  style="cursor:pointer"    type="button" value="DNS设置" />
									<input id="show-btn3" class="show-btn3"  style="cursor:pointer"    type="button" value="其它设置" />
								</td>
							</tr>
						</table>
					  </div>
					  <table id="adguardhome_detail_table1"  style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable"   >
						  <tr id="adguardhome_status">
                            <th>运行状态</th>
                            <td><span id="status">检测运行状态中 - Waiting..</span></td>
                          </tr>
                          <tr id="adguardhome_work_dir_tr" >
                            <th>工作目录</th>
                            <td>
                                <input type="text" class="input_adg_table" style="width:auto;" size="30" id="adguardhome_work_dir" name="adguardhome_work_dir" maxlength="" value="<% dbus_get_def("adguardhome_work_dir", "/tmp/adguardhome_workdir/"); %>" >
                                <small>&nbsp;&nbsp;默认: /tmp/adguardhome_workdir/ </small>
                            </td>
                          </tr>
                          <tr id="adguardhome_update_dir_tr" >
                            <th>更新目录</th>
                            <td>
                                <input type="text" class="input_adg_table" style="width:auto;" size="30" id="adguardhome_update_dir" name="adguardhome_update_dir" maxlength="" value="<% dbus_get_def("adguardhome_update_dir", "/tmp"); %>" >
                                <small>&nbsp;&nbsp;默认: /tmp </small>
                            </td>
                          </tr>
                          <tr id="adguardhome_port_tr" >
                            <th>访问端口</th>
                            <td>
                                <input type="text" class="input_adg_table" style="width:auto;" size="30" id="adguardhome_port" name="adguardhome_port" maxlength="" value="<% dbus_get_def("adguardhome_port", "3000"); %>" >
                                <small>&nbsp;&nbsp;默认: 3000 </small>
                            </td>
                          </tr>
                          <tr id="adguardhome_dns_port_tr" style="display: none;" >
                            <th>DNS端口</th>
                            <td>
                                <input type="text" class="input_adg_table" style="width:auto;" size="30" id="adguardhome_dns_port" name="adguardhome_dns_port" maxlength="" value="<% dbus_get_def("adguardhome_dns_port", "153"); %>" >
                                <small>&nbsp;&nbsp;默认: 153 ［<i>配置文件存在时才生效</i>］ </small>
                            </td>
                          </tr>

                          <tr id="adguardhome_bin_update_tr">
                                                    <th>WEB管理/程序更新</th>
                                                    <td>
                                                        <a type="button" id="adguardhome_web" class="adguardhome_btn" style="cursor:pointer" target="_blank" >访问Web管理界面</a>
                                                        <a type="button" id="adguardhome_binary_update" class="adguardhome_btn" style="cursor:pointer" onclick="status_update()" >刷新设置界面</a>
                                                        <a type="button" id="adguardhome_binary_update" class="adguardhome_btn" style="cursor:pointer" onclick="adguardhome_binary_update()" >更新AdGuardHome程序</a>
						    							<a class="adguardhome_btn_update">自动更新</a>
 						    							<a><select id="adguardhome_bin_auto_update" name="adguardhome_bin_auto_update" class="input_option"  >  <option value="0">否</option>  <option value="1">是</option> </select></a>
						    					   </td>
                         </tr>
					  </table>
					  <table  id="adguardhome_detail_table2"  style="display:none;margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable"   >
                          <tr id="adguardhome_dnsmasq_set_tr"  >
                            <th>选项</th>
                            <td>
                                <select   id="adguardhome_dnsmasq_set" name="adguardhome_dnsmasq_set" class="input_option"  >
       								<option value="0">【0】关闭</option>
									<option value="1">【1】ipv4-将dnsmasq的server地址设为AdGuardHome监听地址</option>
									<option value="2">【2】ipv4-将dnsmasq的server地址设为AdGuardHome监听地址并禁用dnsmasq缓存</option>
									<option value="3">【3】ipv4-劫持53端口至AdGuardHome监听地址</option>
									<option value="4">【4】ipv4,6-将dnsmasq的server地址设为AdGuardHome监听地址</option>
									<option value="5">【5】ipv4,6-将dnsmasq的server地址设为AdGuardHome监听地址并禁用dnsmasq缓存</option>
								</select>
                            </td>
                          </tr>
					  </table>
					  <table  id="adguardhome_detail_table3"  style="display:none;margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable"   >
                          <tr id="adguardhome_perp_set_tr"  >
                            <th>守护进程</th>
                            <td>
                                <select   id="adguardhome_perp_set" name="adguardhome_perp_set" class="input_option"  >
       								<option value="0">关闭</option>
									<option value="1">每分钟</option>
									<option value="2">每10分钟</option>
									<option value="3">每30分钟</option>
									<option value="4">每1小时</option>
								</select>
                            </td>
                          </tr>
                          <tr id="adguardhome_upx_set_tr"  >
                            <th>UPX压缩</th>
                            <td>
                                <select   id="adguardhome_upx_set" name="adguardhome_upx_set" class="input_option"  >
       								<option value="0">关闭</option>
									<option value="1">开启</option>
								</select>
                            </td>
                          </tr>
                          <tr id="adguardhome_shadowsocks_patch_set_tr"  >
                            <th>科学上网中国DNS自定义端口补丁</th>
                            <td>
                                <select   id="adguardhome_shadowsocks_patch_set" name="adguardhome_shadowsocks_patch_set" class="input_option"  >
       								<option value="0">关闭</option>
									<option value="1">开启</option>
								</select>
                            </td>
                          </tr>
					  </table>
					  <div id="warnnote1">
						  <div id="adguardhome_note1"class="SimpleNote">
							  <i><li>DNS端口仅支持非53端口，默认［153］。</li></i>
							  <i><li>初次设置需访问Web管理界面进行配置，点击刷新设置界面按钮会重新显示当前设置。</li></i>
							  <i><li>勿将工作目录设定到jffs分区，由于路由jffs分区不支持mmap()模块所需的系统调用，插件仅将配置文件放在/koolshare/adguardhome目录，将AdGuardHome工作目录默认设置到/tmp/adguardhome_workdir，重启路由后丢失AdGuardHome统计数据。</li></li>
							  <i><li>将更新目录设置到外置存储可防止upx压缩时出现磁盘空间不足，例如/tmp/mnt/sda1。</li></li>
							  <i><li>更新AdGuardHome程序仅检查AdGuardHome程序github的Latest标签不含Pre预览版。</li></li>
							  <i><li>设置自动更新后会定时在05:00自动更新AdGuardHome程序。</li></li>
						  </div>
					  </div>
					  <div id="warnnote2" style="display: none;">
						  <div id="adguardhome_note2" class="SimpleNote" >
							  <i><li>与科学上网的DNS冲突。使用科学上网请勿同时开启此选项。可在其它设置里开启科学上网（4.2.2）中国DNS自定义端口补丁。中国DNS自定义设置为AdGuardHome监听地址，例如192.168.1.1#153</li></li>
							  <i><li>选项【1】仅设置ipv4，将dnsmasq的server地址设为AdGuardHome监听地址。AdGuardHome无法显示客服端ip地址。</li></li>
							  <i><li>选项【2】仅设置ipv4，将dnsmasq的server地址设为AdGuardHome监听地址并禁用dnsmasq缓存。AdGuardHome无法显示客服端ip地址。</li></li>
							  <i><li>选项【3】仅设置ipv4，将劫持53端口至AdGuardHome监听地址。</li></li>
						  	  <i><li>选项【4】设置ipv4和ipv6，将dnsmasq的server地址设为AdGuardHome监听地址。AdGuardHome无法显示客服端ip地址。</li></li>
						  	  <i><li>选项【5】设置ipv4和ipv6，将dnsmasq的server地址设为AdGuardHome监听地址并禁用dnsmasq缓存。AdGuardHome无法显示客服端ip地址。</li></li>
						  </div>
					  </div>
					  <div id="warnnote3" style="display: none;">
						  <div id="adguardhome_note3" class="SimpleNote" >
							  <i><li>开启守护进程后根据设置时间检测cron任务以及软件中心守护进程状态，防止cron任务丢失以及因软件中心挂掉导致AdGuardHome程序无法启动。</li></li>
							  <i><li>开启UPX压缩后,更新程序时会用UPX压缩AdGuardHome程序。</li></li>
							  <i><li>开启科学上网中国DNS自定义端口补丁后,科学上网(4.2.2)中国DNS支持自定义端口。例如192.168.1.1#153</li></li>
						  </div>
					  </div>
					</div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div class="apply_gen">
                      <button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">保存&应用</button>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
            <td width="10" align="center" valign="top"></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  </form>
  </td>
  <div id="footer"></div>
</body>
</html>
