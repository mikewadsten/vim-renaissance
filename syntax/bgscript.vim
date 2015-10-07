" Vim syntax file
" Language:	BASIC
" Maintainer:	Allan Kelly <allan@fruitloaf.co.uk>
" Last Change:  2011 Dec 25 by Thilo Six

" First version based on Micro$soft QBASIC circa 1989, as documented in
" 'Learn BASIC Now' by Halvorson&Rygmyr. Microsoft Press 1989.
" This syntax file not a complete implementation yet.  Send suggestions to the
" maintainer.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" A bunch of useful BASIC keywords
syn keyword basicStatement	BEEP beep Beep BLOAD bload Bload BSAVE bsave Bsave
syn keyword basicStatement	CALL call Call ABSOLUTE absolute Absolute
syn keyword basicStatement	CHAIN chain Chain CHDIR chdir Chdir
syn keyword basicStatement	CIRCLE circle Circle CLEAR clear Clear
syn keyword basicStatement	CLOSE close Close CLS cls Cls COLOR color Color
syn keyword basicStatement	COM com Com COMMON common Common
syn keyword basicStatement	CONST const Const DATA data Data
syn keyword basicStatement	DECLARE declare Declare DEF def Def
syn keyword basicStatement	DEFDBL defdbl Defdbl DEFINT defint Defint
syn keyword basicStatement	DEFLNG deflng Deflng DEFSNG defsng Defsng
syn keyword basicStatement	DEFSTR defstr Defstr DIM dim Dim
syn keyword basicStatement	DO do Do LOOP loop Loop
syn keyword basicStatement	DRAW draw Draw END end End
syn keyword basicStatement	ENVIRON environ Environ ERASE erase Erase
syn keyword basicStatement	ERROR error Error EXIT exit Exit
syn keyword basicStatement	FIELD field Field FILES files Files
syn keyword basicStatement	FOR for For NEXT next Next
syn keyword basicStatement	FUNCTION function Function GET get Get
syn keyword basicStatement	GOSUB gosub Gosub GOTO goto Goto
syn keyword basicStatement	IF if If THEN then Then ELSE else Else
syn keyword basicStatement	INPUT input Input INPUT# input# Input#
syn keyword basicStatement	IOCTL ioctl Ioctl KEY key Key
syn keyword basicStatement	KILL kill Kill LET let Let
syn keyword basicStatement	LINE line Line LOCATE locate Locate
syn keyword basicStatement	LOCK lock Lock UNLOCK unlock Unlock
syn keyword basicStatement	LPRINT lprint Lprint USING using Using
syn keyword basicStatement	LSET lset Lset MKDIR mkdir Mkdir
syn keyword basicStatement	NAME name Name ON on On
syn keyword basicStatement	ERROR error Error OPEN open Open
syn keyword basicStatement	OPTION option Option BASE base Base
" syn keyword basicStatement	OUT out Out PAINT paint Paint
syn keyword basicStatement	PALETTE palette Palette PCOPY pcopy Pcopy
syn keyword basicStatement	PEN pen Pen PLAY play Play
syn keyword basicStatement	PMAP pmap Pmap POKE poke Poke
syn keyword basicStatement	PRESET preset Preset PRINT print Print
syn keyword basicStatement	PRINT# print# Print# USING using Using
syn keyword basicStatement	PSET pset Pset PUT put Put
syn keyword basicStatement	RANDOMIZE randomize Randomize READ read Read
syn keyword basicStatement	REDIM redim Redim RESET reset Reset
syn keyword basicStatement	RESTORE restore Restore RESUME resume Resume
syn keyword basicStatement	RETURN return Return RMDIR rmdir Rmdir
syn keyword basicStatement	RSET rset Rset RUN run Run
syn keyword basicStatement	SEEK seek Seek SELECT select Select
syn keyword basicStatement	CASE case Case SHARED shared Shared
syn keyword basicStatement	SHELL shell Shell SLEEP sleep Sleep
syn keyword basicStatement	SOUND sound Sound STATIC static Static
syn keyword basicStatement	STOP stop Stop STRIG strig Strig
syn keyword basicStatement	SUB sub Sub SWAP swap Swap
syn keyword basicStatement	SYSTEM system System TIMER timer Timer
syn keyword basicStatement	TROFF troff Troff TRON tron Tron
syn keyword basicStatement	TYPE type Type UNLOCK unlock Unlock
syn keyword basicStatement	VIEW view View WAIT wait Wait
syn keyword basicStatement	WHILE while While WEND wend Wend
syn keyword basicStatement	WIDTH width Width WINDOW window Window
syn keyword basicStatement	WRITE write Write DATE$ date$ Date$
syn keyword basicStatement	MID$ mid$ Mid$ TIME$ time$ Time$

syn keyword bgscriptKeyword event

syn keyword basicFunction	ABS abs Abs ASC asc Asc
syn keyword basicFunction	ATN atn Atn CDBL cdbl Cdbl
syn keyword basicFunction	CINT cint Cint CLNG clng Clng
syn keyword basicFunction	COS cos Cos CSNG csng Csng
syn keyword basicFunction	CSRLIN csrlin Csrlin CVD cvd Cvd
syn keyword basicFunction	CVDMBF cvdmbf Cvdmbf CVI cvi Cvi
syn keyword basicFunction	CVL cvl Cvl CVS cvs Cvs
syn keyword basicFunction	CVSMBF cvsmbf Cvsmbf EOF eof Eof
syn keyword basicFunction	ERDEV erdev Erdev ERL erl Erl
syn keyword basicFunction	ERR err Err EXP exp Exp
syn keyword basicFunction	FILEATTR fileattr Fileattr FIX fix Fix
syn keyword basicFunction	FRE fre Fre FREEFILE freefile Freefile
syn keyword basicFunction	INP inp Inp INSTR instr Instr
syn keyword basicFunction	INT int Int LBOUND lbound Lbound
syn keyword basicFunction	LEN len Len LOC loc Loc
syn keyword basicFunction	LOF lof Lof LOG log Log
syn keyword basicFunction	LPOS lpos Lpos PEEK peek Peek
syn keyword basicFunction	PEN pen Pen POINT point Point
syn keyword basicFunction	POS pos Pos RND rnd Rnd
syn keyword basicFunction	SADD sadd Sadd SCREEN screen Screen
syn keyword basicFunction	SEEK seek Seek SETMEM setmem Setmem
syn keyword basicFunction	SGN sgn Sgn SIN sin Sin
syn keyword basicFunction	SPC spc Spc SQR sqr Sqr
syn keyword basicFunction	STICK stick Stick STRIG strig Strig
syn keyword basicFunction	TAB tab Tab TAN tan Tan
syn keyword basicFunction	UBOUND ubound Ubound VAL val Val
syn keyword basicFunction	VALPTR valptr Valptr VALSEG valseg Valseg
syn keyword basicFunction	VARPTR varptr Varptr VARSEG varseg Varseg
syn keyword basicFunction	CHR$ Chr$ chr$ COMMAND$ command$ Command$
syn keyword basicFunction	DATE$ date$ Date$ ENVIRON$ environ$ Environ$
syn keyword basicFunction	ERDEV$ erdev$ Erdev$ HEX$ hex$ Hex$
syn keyword basicFunction	INKEY$ inkey$ Inkey$ INPUT$ input$ Input$
syn keyword basicFunction	IOCTL$ ioctl$ Ioctl$ LCASES$ lcases$ Lcases$
syn keyword basicFunction	LAFT$ laft$ Laft$ LTRIM$ ltrim$ Ltrim$
syn keyword basicFunction	MID$ mid$ Mid$ MKDMBF$ mkdmbf$ Mkdmbf$
syn keyword basicFunction	MKD$ mkd$ Mkd$ MKI$ mki$ Mki$
syn keyword basicFunction	MKL$ mkl$ Mkl$ MKSMBF$ mksmbf$ Mksmbf$
syn keyword basicFunction	MKS$ mks$ Mks$ OCT$ oct$ Oct$
syn keyword basicFunction	RIGHT$ right$ Right$ RTRIM$ rtrim$ Rtrim$
syn keyword basicFunction	SPACE$ space$ Space$ STR$ str$ Str$
syn keyword basicFunction	STRING$ string$ String$ TIME$ time$ Time$
syn keyword basicFunction	UCASE$ ucase$ Ucase$ VARPTR$ varptr$ Varptr$
syn keyword basicTodo contained	TODO

syn keyword bgscriptFunction system_reset system_hello system_address_get system_reg_write system_reg_read system_get_counters system_get_connections system_read_memory system_get_info system_endpoint_tx system_whitelist_append system_whitelist_remove system_whitelist_clear system_endpoint_rx system_endpoint_set_watermarks system_aes_setkey system_aes_encrypt system_aes_decrypt flash_ps_defrag flash_ps_dump flash_ps_erase_all flash_ps_save flash_ps_load flash_ps_erase flash_erase_page flash_write_data flash_read_data attributes_write attributes_read attributes_read_type attributes_user_read_response attributes_user_write_response connection_disconnect connection_get_rssi connection_update connection_version_update connection_channel_map_get connection_channel_map_set connection_features_get connection_get_status connection_raw_tx attclient_find_by_type_value attclient_read_by_group_type attclient_read_by_type attclient_find_information attclient_read_by_handle attclient_attribute_write attclient_write_command attclient_indicate_confirm attclient_read_long attclient_prepare_write attclient_execute_write attclient_read_multiple sm_encrypt_start sm_set_bondable_mode sm_delete_bonding sm_set_parameters sm_passkey_entry sm_get_bonds sm_set_oob_data gap_set_privacy_flags gap_set_mode gap_discover gap_connect_direct gap_end_procedure gap_connect_selective gap_set_filtering gap_set_scan_parameters gap_set_adv_parameters gap_set_adv_data gap_set_directed_connectable_mode hardware_io_port_config_irq hardware_set_soft_timer hardware_adc_read hardware_io_port_config_direction hardware_io_port_config_function hardware_io_port_config_pull hardware_io_port_write hardware_io_port_read hardware_spi_config hardware_spi_transfer hardware_i2c_read hardware_i2c_write hardware_set_txpower hardware_timer_comparator hardware_io_port_irq_enable hardware_io_port_irq_direction hardware_analog_comparator_enable hardware_analog_comparator_read hardware_analog_comparator_config_irq hardware_set_rxgain hardware_usb_enable test_phy_tx test_phy_rx test_phy_end test_phy_reset test_get_channel_map test_debug test_channel_mode dfu_reset dfu_flash_set_address dfu_flash_upload dfu_flash_upload_finish dfu_reset dfu_flash_set_address dfu_flash_upload dfu_flash_upload_finish system_sync system_reset system_hello system_set_max_power_saving_state config_get_mac config_set_mac sme_wifi_on sme_wifi_off sme_power_on sme_start_scan sme_stop_scan sme_set_password sme_connect_bssid sme_connect_ssid sme_disconnect sme_set_scan_channels sme_set_operating_mode sme_start_ap_mode sme_stop_ap_mode sme_scan_results_sort_rssi sme_ap_client_disconnect sme_set_ap_password sme_set_ap_max_clients sme_start_wps sme_stop_wps sme_get_signal_quality sme_set_eap_configuration sme_set_eap_type_username sme_set_eap_type_password sme_set_eap_type_ca_certificate sme_set_eap_type_server_common_name sme_set_eap_type_user_certificate sme_set_eap_type_user_private_key sme_set_eap_type_user_private_key_password tcpip_start_tcp_server tcpip_tcp_connect tcpip_start_udp_server tcpip_udp_connect tcpip_configure tcpip_dns_configure tcpip_dns_gethostbyname tcpip_udp_bind tcpip_dhcp_set_hostname tcpip_ssl_connect tcpip_ssl_set_authmode endpoint_send endpoint_set_streaming endpoint_set_active endpoint_set_streaming_destination endpoint_close endpoint_set_transmit_size endpoint_disable hardware_set_soft_timer hardware_external_interrupt_config hardware_change_notification_config hardware_change_notification_pullup hardware_io_port_config_direction hardware_io_port_config_open_drain hardware_io_port_write hardware_io_port_read hardware_output_compare hardware_adc_read hardware_rtc_init hardware_rtc_set_time hardware_rtc_get_time hardware_rtc_set_alarm flash_ps_defrag flash_ps_dump flash_ps_erase_all flash_ps_save flash_ps_load flash_ps_erase i2c_start_read i2c_start_write i2c_stop https_enable ethernet_set_dataroute ethernet_close ethernet_connected
syn keyword bgscriptFunction system_boot system_debug system_endpoint_watermark_rx system_endpoint_watermark_tx system_script_failure system_no_license_key system_protocol_error flash_ps_key attributes_value attributes_user_read_request attributes_status connection_status connection_version_ind connection_feature_ind connection_raw_rx connection_disconnected attclient_indicated attclient_procedure_completed attclient_group_found attclient_attribute_found attclient_find_information_found attclient_attribute_value attclient_read_multiple_response sm_smp_data sm_bonding_fail sm_passkey_display sm_passkey_request sm_bond_status gap_scan_response gap_mode_changed hardware_io_port_status hardware_soft_timer hardware_adc_result hardware_analog_comparator_status dfu_boot dfu_boot system_boot system_state system_sw_exception system_power_saving_state config_mac_address sme_wifi_is_on sme_wifi_is_off sme_scan_result sme_scan_result_drop sme_scanned sme_connected sme_disconnected sme_interface_status sme_connect_failed sme_connect_retry sme_ap_mode_started sme_ap_mode_stopped sme_ap_mode_failed sme_ap_client_joined sme_ap_client_left sme_scan_sort_result sme_scan_sort_finished sme_wps_stopped sme_wps_completed sme_wps_failed sme_wps_credential_ssid sme_wps_credential_password sme_signal_quality tcpip_configuration tcpip_dns_configuration tcpip_endpoint_status tcpip_dns_gethostbyname_result tcpip_udp_data tcpip_ssl_verify_result endpoint_syntax_error endpoint_data endpoint_status endpoint_closing endpoint_error hardware_soft_timer hardware_change_notification hardware_external_interrupt hardware_rtc_alarm flash_ps_key flash_ps_key_changed https_on_req https_button ethernet_link_status
syn keyword bgscriptFunction system_endpoint_api system_endpoint_test system_endpoint_script system_endpoint_usb system_endpoint_uart0 system_endpoint_uart1 attributes_attribute_change_reason_write_request attributes_attribute_change_reason_write_command attributes_attribute_change_reason_write_request_user attributes_attribute_status_flag_notify attributes_attribute_status_flag_indicate connection_connected connection_encrypted connection_completed connection_parameters_change attclient_attribute_value_type_read attclient_attribute_value_type_notify attclient_attribute_value_type_indicate attclient_attribute_value_type_read_by_type attclient_attribute_value_type_read_blob attclient_attribute_value_type_indicate_rsp_req sm_bonding_key_ltk sm_bonding_key_addr_public sm_bonding_key_addr_static sm_bonding_key_irk sm_bonding_key_edivrand sm_bonding_key_csrk sm_bonding_key_masterid sm_io_capability_displayonly sm_io_capability_displayyesno sm_io_capability_keyboardonly sm_io_capability_noinputnooutput sm_io_capability_keyboarddisplay gap_address_type_public gap_address_type_random gap_non_discoverable gap_limited_discoverable gap_general_discoverable gap_broadcast gap_user_data gap_non_connectable gap_directed_connectable gap_undirected_connectable gap_scannable_non_connectable gap_discover_limited gap_discover_generic gap_discover_observation gap_ad_type_none gap_ad_type_flags gap_ad_type_services_16bit_more gap_ad_type_services_16bit_all gap_ad_type_services_32bit_more gap_ad_type_services_32bit_all gap_ad_type_services_128bit_more gap_ad_type_services_128bit_all gap_ad_type_localname_short gap_ad_type_localname_complete gap_ad_type_txpower gap_adv_policy_all gap_adv_policy_whitelist_scan gap_adv_policy_whitelist_connect gap_adv_policy_whitelist_all gap_scan_policy_all gap_scan_policy_whitelist system_idle system_powered system_connecting system_connected system_wps endpoint_free endpoint_uart endpoint_usb endpoint_tcp endpoint_tcp_server endpoint_udp endpoint_udp_server endpoint_script endpoint_wait_close endpoint_spi endpoint_i2c endpoint_drop endpoint_ssl hardware_alarm_every_half_second hardware_alarm_every_second hardware_alarm_every_ten_seconds hardware_alarm_every_minute hardware_alarm_every_ten_minutes hardware_alarm_every_hour hardware_alarm_every_day hardware_alarm_every_week hardware_alarm_every_month hardware_alarm_every_year

"integer number, or floating point number without a dot.
syn match  basicNumber		"\<\d\+\>"
"floating point number, with dot
syn match  basicNumber		"\<\d\+\.\d*\>"
"floating point number, starting with a dot
syn match  basicNumber		"\.\d\+\>"

" String and Character contstants
syn match   basicSpecial contained "\\\d\d\d\|\\."
syn region  basicString		  start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=basicSpecial

" syn region  basicComment	start="REM" end="$" contains=basicTodo
" syn region  basicComment	start="^[ \t]*'" end="$" contains=basicTodo
syntax match basicComment "#.*$"
syn region  basicLineNumber	start="^\d" end="\s"
syn match   basicTypeSpecifier  "[a-zA-Z0-9][\$%&!#]"ms=s+1
" Used with OPEN statement
syn match   basicFilenumber  "#\d\+"
"syn sync ccomment basicComment
" syn match   basicMathsOperator "[<>+\*^/\\=-]"
syn match   basicMathsOperator   "-\|=\|[:<>+\*^/\\]\|AND\|OR"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_basic_syntax_inits")
  if version < 508
    let did_basic_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink basicLabel		Label
  HiLink basicConditional	Conditional
  HiLink basicRepeat		Repeat
  HiLink basicLineNumber	Comment
  HiLink basicNumber		Number
  HiLink basicError		Error
  HiLink basicStatement	Statement
  HiLink basicString		String
  HiLink basicComment		Comment
  HiLink basicSpecial		Special
  HiLink basicTodo		Todo
  HiLink basicFunction		Identifier
  HiLink basicTypeSpecifier Type
  HiLink basicFilenumber basicTypeSpecifier
  "hi basicMathsOperator term=bold cterm=bold gui=bold

  HiLink bgscriptKeyword Keyword
  HiLink bgscriptFunction Function

  delcommand HiLink
endif

let b:current_syntax = "basic"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8
