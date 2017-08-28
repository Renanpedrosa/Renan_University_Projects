
_InitUSBdsc:
;USBdsc.c,232 :: 		void InitUSBdsc()
;USBdsc.c,234 :: 		Byte_tmp_0[0] = NUM_ENDPOINTS;
	MOVLW       2
	MOVWF       _Byte_tmp_0+0 
;USBdsc.c,235 :: 		Byte_tmp_0[0] = ConfigDescr_wTotalLength;
	MOVLW       41
	MOVWF       _Byte_tmp_0+0 
;USBdsc.c,236 :: 		Byte_tmp_0[0] = HID_ReportDesc_len;
	MOVLW       47
	MOVWF       _Byte_tmp_0+0 
;USBdsc.c,237 :: 		Byte_tmp_0[0] = Low_HID_ReportDesc_len;
	MOVLW       47
	MOVWF       _Byte_tmp_0+0 
;USBdsc.c,238 :: 		Byte_tmp_0[0] = High_HID_ReportDesc_len;
	CLRF        _Byte_tmp_0+0 
;USBdsc.c,239 :: 		Byte_tmp_0[0] = Low_HID_PACKET_SIZE;
	MOVLW       64
	MOVWF       _Byte_tmp_0+0 
;USBdsc.c,240 :: 		Byte_tmp_0[0] = High_HID_PACKET_SIZE;
	CLRF        _Byte_tmp_0+0 
;USBdsc.c,250 :: 		}
	RETURN      0
; end of _InitUSBdsc
