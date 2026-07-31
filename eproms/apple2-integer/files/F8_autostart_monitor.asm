; Apple II Autostart Monitor  $F800-$FFFF  -- AMD "F8", byte-identical to Mostek "F8" (sha256 29465303e7844fa5...)
; ================================================================================================================

        .ORG $F800


PLOT:
F800  4A                LSR A
F801  08                PHP 
F802  20 47 F8          JSR $F847  ; GBASCALC
F805  28                PLP 
F806  A9 0F             LDA #$0F
F808  90 02             BCC $F80C
F80A  69 E0             ADC #$E0
F80C  85 2E             STA $2E  ; MASK

PLOT1:
F80E  B1 26             LDA ($26),Y  ; GBASL
F810  45 30             EOR $30  ; COLOR
F812  25 2E             AND $2E  ; MASK
F814  51 26             EOR ($26),Y  ; GBASL
F816  91 26             STA ($26),Y  ; GBASL
F818  60                RTS 

HLINE:
F819  20 00 F8          JSR $F800  ; PLOT
F81C  C4 2C             CPY $2C  ; H2
F81E  B0 11             BCS $F831
F820  C8                INY 
F821  20 0E F8          JSR $F80E  ; PLOT1
F824  90 F6             BCC $F81C
F826  69 01             ADC #$01

VLINE:
F828  48                PHA 
F829  20 00 F8          JSR $F800  ; PLOT
F82C  68                PLA 
F82D  C5 2D             CMP $2D  ; V2
F82F  90 F5             BCC $F826
F831  60                RTS 

CLRSCR:
F832  A0 2F             LDY #$2F
F834  D0 02             BNE $F838

CLRTOP:
F836  A0 27             LDY #$27
F838  84 2D             STY $2D  ; V2
F83A  A0 27             LDY #$27
F83C  A9 00             LDA #$00
F83E  85 30             STA $30  ; COLOR
F840  20 28 F8          JSR $F828  ; VLINE
F843  88                DEY 
F844  10 F6             BPL $F83C
F846  60                RTS 

GBASCALC:
F847  48                PHA 
F848  4A                LSR A
F849  29 03             AND #$03
F84B  09 04             ORA #$04
F84D  85 27             STA $27  ; GBASH
F84F  68                PLA 
F850  29 18             AND #$18
F852  90 02             BCC $F856
F854  69 7F             ADC #$7F

NXTCOL:
F856  85 26             STA $26  ; GBASL
F858  0A                ASL A
F859  0A                ASL A
F85A  05 26             ORA $26  ; GBASL
F85C  85 26             STA $26  ; GBASL
F85E  60                RTS 

SETCOL:
F85F  A5 30             LDA $30  ; COLOR
F861  18                CLC 
F862  69 03             ADC #$03
F864  29 0F             AND #$0F
F866  85 30             STA $30  ; COLOR
F868  0A                ASL A
F869  0A                ASL A
F86A  0A                ASL A
F86B  0A                ASL A
F86C  05 30             ORA $30  ; COLOR
F86E  85 30             STA $30  ; COLOR
F870  60                RTS 

SCRN2:
F871  4A                LSR A
F872  08                PHP 
F873  20 47 F8          JSR $F847  ; GBASCALC
F876  B1 26             LDA ($26),Y  ; GBASL
F878  28                PLP 
F879  90 04             BCC $F87F
F87B  4A                LSR A
F87C  4A                LSR A
F87D  4A                LSR A
F87E  4A                LSR A
F87F  29 0F             AND #$0F
F881  60                RTS 
F882  A6 3A             LDX $3A  ; PCL
F884  A4 3B             LDY $3B  ; PCH
F886  20 96 FD          JSR $FD96
F889  20 48 F9          JSR $F948  ; PCADJ
F88C  A1 3A             LDA ($3A,X)
F88E  A8                TAY 
F88F  4A                LSR A
F890  90 09             BCC $F89B
F892  6A                ROR A
F893  B0 10             BCS $F8A5
F895  C9 A2             CMP #$A2
F897  F0 0C             BEQ $F8A5
F899  29 87             AND #$87
F89B  4A                LSR A
F89C  AA                TAX 
F89D  BD 62 F9          LDA $F962,X
F8A0  20 79 F8          JSR $F879
F8A3  D0 04             BNE $F8A9
F8A5  A0 80             LDY #$80
F8A7  A9 00             LDA #$00
F8A9  AA                TAX 
F8AA  BD A6 F9          LDA $F9A6,X
F8AD  85 2E             STA $2E  ; MASK
F8AF  29 03             AND #$03
F8B1  85 2F             STA $2F
F8B3  98                TYA 
F8B4  29 8F             AND #$8F
F8B6  AA                TAX 
F8B7  98                TYA 
F8B8  A0 03             LDY #$03
F8BA  E0 8A             CPX #$8A
F8BC  F0 0B             BEQ $F8C9
F8BE  4A                LSR A
F8BF  90 08             BCC $F8C9
F8C1  4A                LSR A
F8C2  4A                LSR A
F8C3  09 20             ORA #$20
F8C5  88                DEY 
F8C6  D0 FA             BNE $F8C2
F8C8  C8                INY 
F8C9  88                DEY 
F8CA  D0 F2             BNE $F8BE
F8CC  60                RTS 
F8CD  FF                .BYTE $FF      ; invalid opcode
F8CE  FF                .BYTE $FF      ; invalid opcode
F8CF  FF                .BYTE $FF      ; invalid opcode

INSTDSP:
F8D0  20 82 F8          JSR $F882
F8D3  48                PHA 
F8D4  B1 3A             LDA ($3A),Y  ; PCL
F8D6  20 DA FD          JSR $FDDA  ; PRBYTE
F8D9  A2 01             LDX #$01
F8DB  20 4A F9          JSR $F94A
F8DE  C4 2F             CPY $2F
F8E0  C8                INY 
F8E1  90 F1             BCC $F8D4
F8E3  A2 03             LDX #$03
F8E5  C0 04             CPY #$04
F8E7  90 F2             BCC $F8DB
F8E9  68                PLA 
F8EA  A8                TAY 
F8EB  B9 C0 F9          LDA $F9C0,Y
F8EE  85 2C             STA $2C  ; H2
F8F0  B9 00 FA          LDA $FA00,Y
F8F3  85 2D             STA $2D  ; V2
F8F5  A9 00             LDA #$00
F8F7  A0 05             LDY #$05
F8F9  06 2D             ASL $2D  ; V2
F8FB  26 2C             ROL $2C  ; H2
F8FD  2A                ROL A
F8FE  88                DEY 
F8FF  D0 F8             BNE $F8F9
F901  69 BF             ADC #$BF
F903  20 ED FD          JSR $FDED  ; COUT
F906  CA                DEX 
F907  D0 EC             BNE $F8F5
F909  20 48 F9          JSR $F948  ; PCADJ
F90C  A4 2F             LDY $2F
F90E  A2 06             LDX #$06
F910  E0 03             CPX #$03
F912  F0 1C             BEQ $F930
F914  06 2E             ASL $2E  ; MASK
F916  90 0E             BCC $F926
F918  BD B3 F9          LDA $F9B3,X
F91B  20 ED FD          JSR $FDED  ; COUT
F91E  BD B9 F9          LDA $F9B9,X
F921  F0 03             BEQ $F926
F923  20 ED FD          JSR $FDED  ; COUT
F926  CA                DEX 
F927  D0 E7             BNE $F910
F929  60                RTS 
F92A  88                DEY 
F92B  30 E7             BMI $F914
F92D  20 DA FD          JSR $FDDA  ; PRBYTE
F930  A5 2E             LDA $2E  ; MASK
F932  C9 E8             CMP #$E8
F934  B1 3A             LDA ($3A),Y  ; PCL
F936  90 F2             BCC $F92A
F938  20 56 F9          JSR $F956
F93B  AA                TAX 
F93C  E8                INX 
F93D  D0 01             BNE $F940
F93F  C8                INY 

PRBLNK:
F940  98                TYA 

PRNTAX:
F941  20 DA FD          JSR $FDDA  ; PRBYTE

PRBL2:
F944  8A                TXA 
F945  4C DA FD          JMP $FDDA  ; PRBYTE

PCADJ:
F948  A2 03             LDX #$03
F94A  A9 A0             LDA #$A0
F94C  20 ED FD          JSR $FDED  ; COUT
F94F  CA                DEX 
F950  D0 F8             BNE $F94A
F952  60                RTS 
F953  38                SEC 
F954  A5 2F             LDA $2F
F956  A4 3B             LDY $3B  ; PCH
F958  AA                TAX 
F959  10 01             BPL $F95C
F95B  88                DEY 
F95C  65 3A             ADC $3A  ; PCL
F95E  90 01             BCC $F961
F960  C8                INY 
F961  60                RTS 
F962  04                .BYTE $04      ; invalid opcode
F963  20 54 30          JSR $3054
F966  0D 80 04          ORA $0480
F969  90 03             BCC $F96E
F96B  22                .BYTE $22      ; invalid opcode
F96C  54                .BYTE $54      ; invalid opcode
F96D  33                .BYTE $33      ; invalid opcode
F96E  0D 80 04          ORA $0480
F971  90 04             BCC $F977
F973  20 54 33          JSR $3354
F976  0D 80 04          ORA $0480
F979  90 04             BCC $F97F
F97B  20 54 3B          JSR $3B54
F97E  0D 80 04          ORA $0480
F981  90 00             BCC $F983
F983  22                .BYTE $22      ; invalid opcode
F984  44                .BYTE $44      ; invalid opcode
F985  33                .BYTE $33      ; invalid opcode
F986  0D C8 44          ORA $44C8
F989  00                BRK 
F98A  11 22             ORA ($22),Y  ; WNDTOP
F98C  44                .BYTE $44      ; invalid opcode
F98D  33                .BYTE $33      ; invalid opcode
F98E  0D C8 44          ORA $44C8
F991  A9 01             LDA #$01
F993  22                .BYTE $22      ; invalid opcode
F994  44                .BYTE $44      ; invalid opcode
F995  33                .BYTE $33      ; invalid opcode
F996  0D 80 04          ORA $0480
F999  90 01             BCC $F99C
F99B  22                .BYTE $22      ; invalid opcode
F99C  44                .BYTE $44      ; invalid opcode
F99D  33                .BYTE $33      ; invalid opcode
F99E  0D 80 04          ORA $0480
F9A1  90 26             BCC $F9C9
F9A3  31 87             AND ($87),Y
F9A5  9A                TXS 
F9A6  00                BRK 
F9A7  21 81             AND ($81,X)
F9A9  82                .BYTE $82      ; invalid opcode
F9AA  00                BRK 
F9AB  00                BRK 
F9AC  59 4D 91          EOR $914D,Y
F9AF  92                .BYTE $92      ; invalid opcode
F9B0  86 4A             STX $4A
F9B2  85 9D             STA $9D
F9B4  AC A9 AC          LDY $ACA9
F9B7  A3                .BYTE $A3      ; invalid opcode
F9B8  A8                TAY 
F9B9  A4 D9             LDY $D9
F9BB  00                BRK 
F9BC  D8                CLD 
F9BD  A4 A4             LDY $A4
F9BF  00                BRK 
F9C0  1C                .BYTE $1C      ; invalid opcode
F9C1  8A                TXA 
F9C2  1C                .BYTE $1C      ; invalid opcode
F9C3  23                .BYTE $23      ; invalid opcode
F9C4  5D 8B 1B          EOR $1B8B,X
F9C7  A1 9D             LDA ($9D,X)
F9C9  8A                TXA 
F9CA  1D 23 9D          ORA $9D23,X
F9CD  8B                .BYTE $8B      ; invalid opcode
F9CE  1D A1 00          ORA $00A1,X
F9D1  29 19             AND #$19
F9D3  AE 69 A8          LDX $A869
F9D6  19 23 24          ORA $2423,Y
F9D9  53                .BYTE $53      ; invalid opcode
F9DA  1B                .BYTE $1B      ; invalid opcode
F9DB  23                .BYTE $23      ; invalid opcode
F9DC  24 53             BIT $53
F9DE  19 A1 00          ORA $00A1,Y
F9E1  1A                .BYTE $1A      ; invalid opcode
F9E2  5B                .BYTE $5B      ; invalid opcode
F9E3  5B                .BYTE $5B      ; invalid opcode
F9E4  A5 69             LDA $69
F9E6  24 24             BIT $24  ; CH
F9E8  AE AE A8          LDX $A8AE
F9EB  AD 29 00          LDA $0029
F9EE  7C                .BYTE $7C      ; invalid opcode
F9EF  00                BRK 
F9F0  15 9C             ORA $9C,X
F9F2  6D 9C A5          ADC $A59C
F9F5  69 29             ADC #$29
F9F7  53                .BYTE $53      ; invalid opcode
F9F8  84 13             STY $13
F9FA  34                .BYTE $34      ; invalid opcode
F9FB  11 A5             ORA ($A5),Y
F9FD  69 23             ADC #$23
F9FF  A0 D8             LDY #$D8
FA01  62                .BYTE $62      ; invalid opcode
FA02  5A                .BYTE $5A      ; invalid opcode
FA03  48                PHA 
FA04  26 62             ROL $62
FA06  94 88             STY $88,X
FA08  54                .BYTE $54      ; invalid opcode
FA09  44                .BYTE $44      ; invalid opcode
FA0A  C8                INY 
FA0B  54                .BYTE $54      ; invalid opcode
FA0C  68                PLA 
FA0D  44                .BYTE $44      ; invalid opcode
FA0E  E8                INX 
FA0F  94 00             STY $00,X
FA11  B4 08             LDY $08,X
FA13  84 74             STY $74
FA15  B4 28             LDY $28,X  ; BASL
FA17  6E 74 F4          ROR $F474
FA1A  CC 4A 72          CPY $724A
FA1D  F2                .BYTE $F2      ; invalid opcode
FA1E  A4 8A             LDY $8A
FA20  00                BRK 
FA21  AA                TAX 
FA22  A2 A2             LDX #$A2
FA24  74                .BYTE $74      ; invalid opcode
FA25  74                .BYTE $74      ; invalid opcode
FA26  74                .BYTE $74      ; invalid opcode
FA27  72                .BYTE $72      ; invalid opcode
FA28  44                .BYTE $44      ; invalid opcode
FA29  68                PLA 
FA2A  B2                .BYTE $B2      ; invalid opcode
FA2B  32                .BYTE $32      ; invalid opcode
FA2C  B2                .BYTE $B2      ; invalid opcode
FA2D  00                BRK 
FA2E  22                .BYTE $22      ; invalid opcode
FA2F  00                BRK 
FA30  1A                .BYTE $1A      ; invalid opcode
FA31  1A                .BYTE $1A      ; invalid opcode
FA32  26 26             ROL $26  ; GBASL
FA34  72                .BYTE $72      ; invalid opcode
FA35  72                .BYTE $72      ; invalid opcode
FA36  88                DEY 
FA37  C8                INY 
FA38  C4 CA             CPY $CA
FA3A  26 48             ROL $48  ; STATUS
FA3C  44                .BYTE $44      ; invalid opcode
FA3D  44                .BYTE $44      ; invalid opcode
FA3E  A2 C8             LDX #$C8

IRQ:
FA40  85 45             STA $45  ; ACC
FA42  68                PLA 

BREAK:
FA43  48                PHA 
FA44  0A                ASL A
FA45  0A                ASL A
FA46  0A                ASL A
FA47  30 03             BMI $FA4C
FA49  6C FE 03          JMP ($03FE)

OLDBRK:
FA4C  28                PLP 
FA4D  20 4C FF          JSR $FF4C
FA50  68                PLA 
FA51  85 3A             STA $3A  ; PCL
FA53  68                PLA 
FA54  85 3B             STA $3B  ; PCH
FA56  6C F0 03          JMP ($03F0)
FA59  20 82 F8          JSR $F882
FA5C  20 DA FA          JSR $FADA
FA5F  4C 65 FF          JMP $FF65  ; MON

RESET:
FA62  D8                CLD 
FA63  20 84 FE          JSR $FE84  ; SETNORM
FA66  20 2F FB          JSR $FB2F  ; INIT
FA69  20 93 FE          JSR $FE93  ; SETVID
FA6C  20 89 FE          JSR $FE89  ; SETKBD
FA6F  AD 58 C0          LDA $C058  ; AN0off
FA72  AD 5A C0          LDA $C05A  ; AN1off
FA75  AD 5D C0          LDA $C05D  ; AN2on
FA78  AD 5F C0          LDA $C05F  ; AN3on
FA7B  AD FF CF          LDA $CFFF
FA7E  2C 10 C0          BIT $C010  ; KBDSTRB
FA81  D8                CLD 
FA82  20 3A FF          JSR $FF3A  ; BELL
FA85  AD F3 03          LDA $03F3
FA88  49 A5             EOR #$A5
FA8A  CD F4 03          CMP $03F4
FA8D  D0 17             BNE $FAA6
FA8F  AD F2 03          LDA $03F2
FA92  D0 0F             BNE $FAA3
FA94  A9 E0             LDA #$E0
FA96  CD F3 03          CMP $03F3
FA99  D0 08             BNE $FAA3
FA9B  A0 03             LDY #$03
FA9D  8C F2 03          STY $03F2
FAA0  4C 00 E0          JMP $E000
FAA3  6C F2 03          JMP ($03F2)
FAA6  20 60 FB          JSR $FB60  ; APPLEII
FAA9  A2 05             LDX #$05
FAAB  BD FC FA          LDA $FAFC,X
FAAE  9D EF 03          STA $03EF,X
FAB1  CA                DEX 
FAB2  D0 F7             BNE $FAAB
FAB4  A9 C8             LDA #$C8
FAB6  86 00             STX $00
FAB8  85 01             STA $01

SLOOP:
FABA  A0 07             LDY #$07
FABC  C6 01             DEC $01
FABE  A5 01             LDA $01
FAC0  C9 C0             CMP #$C0
FAC2  F0 D7             BEQ $FA9B
FAC4  8D F8 07          STA $07F8
FAC7  B1 00             LDA ($00),Y
FAC9  D9 01 FB          CMP $FB01,Y
FACC  D0 EC             BNE $FABA
FACE  88                DEY 
FACF  88                DEY 
FAD0  10 F5             BPL $FAC7
FAD2  6C 00 00          JMP ($0000)
FAD5  EA                NOP 
FAD6  EA                NOP 
FAD7  20 8E FD          JSR $FD8E  ; CROUT
FADA  A9 45             LDA #$45
FADC  85 40             STA $40  ; A3L
FADE  A9 00             LDA #$00
FAE0  85 41             STA $41  ; A3H
FAE2  A2 FB             LDX #$FB
FAE4  A9 A0             LDA #$A0
FAE6  20 ED FD          JSR $FDED  ; COUT
FAE9  BD 1E FA          LDA $FA1E,X
FAEC  20 ED FD          JSR $FDED  ; COUT
FAEF  A9 BD             LDA #$BD
FAF1  20 ED FD          JSR $FDED  ; COUT
FAF4  B5 4A             LDA $4A,X
FAF6  20 DA FD          JSR $FDDA  ; PRBYTE
FAF9  E8                INX 
FAFA  30 E8             BMI $FAE4
FAFC  60                RTS 
FAFD  59 FA 00          EOR $00FA,Y
FB00  E0 45             CPX #$45
FB02  20 FF 00          JSR $00FF
FB05  FF                .BYTE $FF      ; invalid opcode
FB06  03                .BYTE $03      ; invalid opcode
FB07  FF                .BYTE $FF      ; invalid opcode
FB08  3C C1 D0 D0 CC C5 .ASC "<APPLE ][DBA"
FB14  FF                .BYTE $FF      ; invalid opcode
FB15  C3                .BYTE $C3      ; invalid opcode
FB16  FF                .BYTE $FF      ; invalid opcode
FB17  FF                .BYTE $FF      ; invalid opcode
FB18  FF                .BYTE $FF      ; invalid opcode
FB19  C1 D8 D9 D0 D3 AD .ASC "AXYPS-p@ "
FB22  00                BRK 
FB23  EA                NOP 
FB24  EA                NOP 
FB25  BD 64 C0          LDA $C064,X  ; PADDL0
FB28  10 04             BPL $FB2E
FB2A  C8                INY 
FB2B  D0 F8             BNE $FB25
FB2D  88                DEY 
FB2E  60                RTS 

INIT:
FB2F  A9 00             LDA #$00
FB31  85 48             STA $48  ; STATUS
FB33  AD 56 C0          LDA $C056  ; LORES
FB36  AD 54 C0          LDA $C054  ; TXTPAGE1

SETTXT:
FB39  AD 51 C0          LDA $C051  ; TXTSET
FB3C  A9 00             LDA #$00
FB3E  F0 0B             BEQ $FB4B

SETGR:
FB40  AD 50 C0          LDA $C050  ; TXTCLR
FB43  AD 53 C0          LDA $C053  ; MIXSET
FB46  20 36 F8          JSR $F836  ; CLRTOP
FB49  A9 14             LDA #$14

SETWND:
FB4B  85 22             STA $22  ; WNDTOP
FB4D  A9 00             LDA #$00
FB4F  85 20             STA $20  ; WNDLFT
FB51  A9 28             LDA #$28
FB53  85 21             STA $21  ; WNDWDTH
FB55  A9 18             LDA #$18
FB57  85 23             STA $23  ; WNDBTM
FB59  A9 17             LDA #$17

TABV:
FB5B  85 25             STA $25  ; CV
FB5D  4C 22 FC          JMP $FC22  ; VTAB

APPLEII:
FB60  20 58 FC          JSR $FC58  ; HOME
FB63  A0 08             LDY #$08
FB65  B9 08 FB          LDA $FB08,Y
FB68  99 0E 04          STA $040E,Y
FB6B  88                DEY 
FB6C  D0 F7             BNE $FB65
FB6E  60                RTS 

SETPWRC:
FB6F  AD F3 03          LDA $03F3
FB72  49 A5             EOR #$A5
FB74  8D F4 03          STA $03F4
FB77  60                RTS 

VIDWAIT:
FB78  C9 8D             CMP #$8D
FB7A  D0 18             BNE $FB94
FB7C  AC 00 C0          LDY $C000  ; KBD
FB7F  10 13             BPL $FB94
FB81  C0 93             CPY #$93
FB83  D0 0F             BNE $FB94
FB85  2C 10 C0          BIT $C010  ; KBDSTRB

KBDWAIT:
FB88  AC 00 C0          LDY $C000  ; KBD
FB8B  10 FB             BPL $FB88
FB8D  C0 83             CPY #$83
FB8F  F0 03             BEQ $FB94
FB91  2C 10 C0          BIT $C010  ; KBDSTRB
FB94  4C FD FB          JMP $FBFD  ; VIDOUT
FB97  38                SEC 
FB98  4C 2C FC          JMP $FC2C
FB9B  A8                TAY 
FB9C  B9 48 FA          LDA $FA48,Y
FB9F  20 97 FB          JSR $FB97
FBA2  20 0C FD          JSR $FD0C  ; RDKEY
FBA5  C9 CE             CMP #$CE
FBA7  B0 EE             BCS $FB97
FBA9  C9 C9             CMP #$C9
FBAB  90 EA             BCC $FB97
FBAD  C9 CC             CMP #$CC
FBAF  F0 E6             BEQ $FB97
FBB1  D0 E8             BNE $FB9B
FBB3  EA                NOP 
FBB4  EA                NOP 
FBB5  EA                NOP 
FBB6  EA                NOP 
FBB7  EA                NOP 
FBB8  EA                NOP 
FBB9  EA                NOP 
FBBA  EA                NOP 
FBBB  EA                NOP 
FBBC  EA                NOP 
FBBD  EA                NOP 
FBBE  EA                NOP 
FBBF  EA                NOP 
FBC0  EA                NOP 

BASCALC:
FBC1  48                PHA 
FBC2  4A                LSR A
FBC3  29 03             AND #$03
FBC5  09 04             ORA #$04
FBC7  85 29             STA $29  ; BASH
FBC9  68                PLA 
FBCA  29 18             AND #$18
FBCC  90 02             BCC $FBD0
FBCE  69 7F             ADC #$7F
FBD0  85 28             STA $28  ; BASL
FBD2  0A                ASL A
FBD3  0A                ASL A
FBD4  05 28             ORA $28  ; BASL
FBD6  85 28             STA $28  ; BASL
FBD8  60                RTS 

BELL1:
FBD9  C9 87             CMP #$87
FBDB  D0 12             BNE $FBEF
FBDD  A9 40             LDA #$40
FBDF  20 A8 FC          JSR $FCA8  ; WAIT
FBE2  A0 C0             LDY #$C0

BELL2:
FBE4  A9 0C             LDA #$0C
FBE6  20 A8 FC          JSR $FCA8  ; WAIT
FBE9  AD 30 C0          LDA $C030  ; SPKR
FBEC  88                DEY 
FBED  D0 F5             BNE $FBE4
FBEF  60                RTS 

STOADV:
FBF0  A4 24             LDY $24  ; CH
FBF2  91 28             STA ($28),Y  ; BASL

ADVANCE:
FBF4  E6 24             INC $24  ; CH
FBF6  A5 24             LDA $24  ; CH
FBF8  C5 21             CMP $21  ; WNDWDTH
FBFA  B0 66             BCS $FC62
FBFC  60                RTS 

VIDOUT:
FBFD  C9 A0             CMP #$A0
FBFF  B0 EF             BCS $FBF0
FC01  A8                TAY 
FC02  10 EC             BPL $FBF0
FC04  C9 8D             CMP #$8D
FC06  F0 5A             BEQ $FC62
FC08  C9 8A             CMP #$8A
FC0A  F0 5A             BEQ $FC66
FC0C  C9 88             CMP #$88
FC0E  D0 C9             BNE $FBD9

BS:
FC10  C6 24             DEC $24  ; CH
FC12  10 E8             BPL $FBFC
FC14  A5 21             LDA $21  ; WNDWDTH
FC16  85 24             STA $24  ; CH
FC18  C6 24             DEC $24  ; CH

UP:
FC1A  A5 22             LDA $22  ; WNDTOP
FC1C  C5 25             CMP $25  ; CV
FC1E  B0 0B             BCS $FC2B
FC20  C6 25             DEC $25  ; CV

VTAB:
FC22  A5 25             LDA $25  ; CV

VTABZ:
FC24  20 C1 FB          JSR $FBC1  ; BASCALC
FC27  65 20             ADC $20  ; WNDLFT
FC29  85 28             STA $28  ; BASL
FC2B  60                RTS 
FC2C  49 C0             EOR #$C0
FC2E  F0 28             BEQ $FC58
FC30  69 FD             ADC #$FD
FC32  90 C0             BCC $FBF4
FC34  F0 DA             BEQ $FC10
FC36  69 FD             ADC #$FD
FC38  90 2C             BCC $FC66
FC3A  F0 DE             BEQ $FC1A
FC3C  69 FD             ADC #$FD
FC3E  90 5C             BCC $FC9C
FC40  D0 E9             BNE $FC2B

CLREOP:
FC42  A4 24             LDY $24  ; CH
FC44  A5 25             LDA $25  ; CV
FC46  48                PHA 
FC47  20 24 FC          JSR $FC24  ; VTABZ
FC4A  20 9E FC          JSR $FC9E
FC4D  A0 00             LDY #$00
FC4F  68                PLA 
FC50  69 00             ADC #$00
FC52  C5 23             CMP $23  ; WNDBTM
FC54  90 F0             BCC $FC46
FC56  B0 CA             BCS $FC22

HOME:
FC58  A5 22             LDA $22  ; WNDTOP
FC5A  85 25             STA $25  ; CV
FC5C  A0 00             LDY #$00
FC5E  84 24             STY $24  ; CH
FC60  F0 E4             BEQ $FC46

CR:
FC62  A9 00             LDA #$00
FC64  85 24             STA $24  ; CH

LF:
FC66  E6 25             INC $25  ; CV
FC68  A5 25             LDA $25  ; CV
FC6A  C5 23             CMP $23  ; WNDBTM
FC6C  90 B6             BCC $FC24
FC6E  C6 25             DEC $25  ; CV

SCROLL:
FC70  A5 22             LDA $22  ; WNDTOP
FC72  48                PHA 
FC73  20 24 FC          JSR $FC24  ; VTABZ
FC76  A5 28             LDA $28  ; BASL
FC78  85 2A             STA $2A
FC7A  A5 29             LDA $29  ; BASH
FC7C  85 2B             STA $2B  ; BOOTSLOT
FC7E  A4 21             LDY $21  ; WNDWDTH
FC80  88                DEY 
FC81  68                PLA 
FC82  69 01             ADC #$01
FC84  C5 23             CMP $23  ; WNDBTM
FC86  B0 0D             BCS $FC95
FC88  48                PHA 
FC89  20 24 FC          JSR $FC24  ; VTABZ
FC8C  B1 28             LDA ($28),Y  ; BASL
FC8E  91 2A             STA ($2A),Y
FC90  88                DEY 
FC91  10 F9             BPL $FC8C
FC93  30 E1             BMI $FC76
FC95  A0 00             LDY #$00
FC97  20 9E FC          JSR $FC9E
FC9A  B0 86             BCS $FC22

CLREOL:
FC9C  A4 24             LDY $24  ; CH
FC9E  A9 A0             LDA #$A0
FCA0  91 28             STA ($28),Y  ; BASL
FCA2  C8                INY 
FCA3  C4 21             CPY $21  ; WNDWDTH
FCA5  90 F9             BCC $FCA0
FCA7  60                RTS 

WAIT:
FCA8  38                SEC 
FCA9  48                PHA 
FCAA  E9 01             SBC #$01
FCAC  D0 FC             BNE $FCAA
FCAE  68                PLA 
FCAF  E9 01             SBC #$01
FCB1  D0 F6             BNE $FCA9
FCB3  60                RTS 

NXTA4:
FCB4  E6 42             INC $42  ; A4L
FCB6  D0 02             BNE $FCBA
FCB8  E6 43             INC $43  ; A4H

NXTA1:
FCBA  A5 3C             LDA $3C  ; A1L
FCBC  C5 3E             CMP $3E  ; A2L
FCBE  A5 3D             LDA $3D  ; A1H
FCC0  E5 3F             SBC $3F  ; A2H
FCC2  E6 3C             INC $3C  ; A1L
FCC4  D0 02             BNE $FCC8
FCC6  E6 3D             INC $3D  ; A1H
FCC8  60                RTS 

HEADR:
FCC9  A0 4B             LDY #$4B
FCCB  20 DB FC          JSR $FCDB
FCCE  D0 F9             BNE $FCC9
FCD0  69 FE             ADC #$FE
FCD2  B0 F5             BCS $FCC9
FCD4  A0 21             LDY #$21
FCD6  20 DB FC          JSR $FCDB
FCD9  C8                INY 
FCDA  C8                INY 
FCDB  88                DEY 
FCDC  D0 FD             BNE $FCDB
FCDE  90 05             BCC $FCE5
FCE0  A0 32             LDY #$32
FCE2  88                DEY 
FCE3  D0 FD             BNE $FCE2
FCE5  AC 20 C0          LDY $C020  ; TAPEOUT
FCE8  A0 2C             LDY #$2C
FCEA  CA                DEX 
FCEB  60                RTS 
FCEC  A2 08             LDX #$08
FCEE  48                PHA 
FCEF  20 FA FC          JSR $FCFA
FCF2  68                PLA 
FCF3  2A                ROL A
FCF4  A0 3A             LDY #$3A
FCF6  CA                DEX 
FCF7  D0 F5             BNE $FCEE
FCF9  60                RTS 
FCFA  20 FD FC          JSR $FCFD
FCFD  88                DEY 
FCFE  AD 60 C0          LDA $C060  ; TAPEIN
FD01  45 2F             EOR $2F
FD03  10 F8             BPL $FCFD
FD05  45 2F             EOR $2F
FD07  85 2F             STA $2F
FD09  C0 80             CPY #$80
FD0B  60                RTS 

RDKEY:
FD0C  A4 24             LDY $24  ; CH
FD0E  B1 28             LDA ($28),Y  ; BASL
FD10  48                PHA 
FD11  29 3F             AND #$3F
FD13  09 40             ORA #$40
FD15  91 28             STA ($28),Y  ; BASL
FD17  68                PLA 
FD18  6C 38 00          JMP ($0038)

KEYIN:
FD1B  E6 4E             INC $4E  ; RNDL
FD1D  D0 02             BNE $FD21
FD1F  E6 4F             INC $4F  ; RNDH
FD21  2C 00 C0          BIT $C000  ; KBD
FD24  10 F5             BPL $FD1B
FD26  91 28             STA ($28),Y  ; BASL
FD28  AD 00 C0          LDA $C000  ; KBD
FD2B  2C 10 C0          BIT $C010  ; KBDSTRB
FD2E  60                RTS 
FD2F  20 0C FD          JSR $FD0C  ; RDKEY
FD32  20 A5 FB          JSR $FBA5

RDCHAR:
FD35  20 0C FD          JSR $FD0C  ; RDKEY
FD38  C9 9B             CMP #$9B
FD3A  F0 F3             BEQ $FD2F
FD3C  60                RTS 

NOTCR:
FD3D  A5 32             LDA $32  ; INVFLG
FD3F  48                PHA 
FD40  A9 FF             LDA #$FF
FD42  85 32             STA $32  ; INVFLG
FD44  BD 00 02          LDA $0200,X
FD47  20 ED FD          JSR $FDED  ; COUT
FD4A  68                PLA 
FD4B  85 32             STA $32  ; INVFLG
FD4D  BD 00 02          LDA $0200,X
FD50  C9 88             CMP #$88
FD52  F0 1D             BEQ $FD71
FD54  C9 98             CMP #$98
FD56  F0 0A             BEQ $FD62
FD58  E0 F8             CPX #$F8
FD5A  90 03             BCC $FD5F
FD5C  20 3A FF          JSR $FF3A  ; BELL
FD5F  E8                INX 
FD60  D0 13             BNE $FD75

CANCEL:
FD62  A9 DC             LDA #$DC
FD64  20 ED FD          JSR $FDED  ; COUT

GETLNZ:
FD67  20 8E FD          JSR $FD8E  ; CROUT

GETLN:
FD6A  A5 33             LDA $33  ; PROMPT
FD6C  20 ED FD          JSR $FDED  ; COUT
FD6F  A2 01             LDX #$01
FD71  8A                TXA 
FD72  F0 F3             BEQ $FD67
FD74  CA                DEX 
FD75  20 35 FD          JSR $FD35  ; RDCHAR
FD78  C9 95             CMP #$95
FD7A  D0 02             BNE $FD7E
FD7C  B1 28             LDA ($28),Y  ; BASL
FD7E  C9 E0             CMP #$E0
FD80  90 02             BCC $FD84
FD82  29 DF             AND #$DF
FD84  9D 00 02          STA $0200,X
FD87  C9 8D             CMP #$8D
FD89  D0 B2             BNE $FD3D

CROUT1:
FD8B  20 9C FC          JSR $FC9C  ; CLREOL

CROUT:
FD8E  A9 8D             LDA #$8D
FD90  D0 5B             BNE $FDED

PRA1:
FD92  A4 3D             LDY $3D  ; A1H
FD94  A6 3C             LDX $3C  ; A1L
FD96  20 8E FD          JSR $FD8E  ; CROUT
FD99  20 40 F9          JSR $F940  ; PRBLNK
FD9C  A0 00             LDY #$00
FD9E  A9 AD             LDA #$AD
FDA0  4C ED FD          JMP $FDED  ; COUT
FDA3  A5 3C             LDA $3C  ; A1L
FDA5  09 07             ORA #$07
FDA7  85 3E             STA $3E  ; A2L
FDA9  A5 3D             LDA $3D  ; A1H
FDAB  85 3F             STA $3F  ; A2H
FDAD  A5 3C             LDA $3C  ; A1L
FDAF  29 07             AND #$07
FDB1  D0 03             BNE $FDB6
FDB3  20 92 FD          JSR $FD92  ; PRA1
FDB6  A9 A0             LDA #$A0
FDB8  20 ED FD          JSR $FDED  ; COUT
FDBB  B1 3C             LDA ($3C),Y  ; A1L
FDBD  20 DA FD          JSR $FDDA  ; PRBYTE
FDC0  20 BA FC          JSR $FCBA  ; NXTA1
FDC3  90 E8             BCC $FDAD
FDC5  60                RTS 
FDC6  4A                LSR A
FDC7  90 EA             BCC $FDB3
FDC9  4A                LSR A
FDCA  4A                LSR A
FDCB  A5 3E             LDA $3E  ; A2L
FDCD  90 02             BCC $FDD1
FDCF  49 FF             EOR #$FF
FDD1  65 3C             ADC $3C  ; A1L
FDD3  48                PHA 
FDD4  A9 BD             LDA #$BD
FDD6  20 ED FD          JSR $FDED  ; COUT
FDD9  68                PLA 

PRBYTE:
FDDA  48                PHA 
FDDB  4A                LSR A
FDDC  4A                LSR A
FDDD  4A                LSR A
FDDE  4A                LSR A
FDDF  20 E5 FD          JSR $FDE5
FDE2  68                PLA 

PRHEX:
FDE3  29 0F             AND #$0F
FDE5  09 B0             ORA #$B0
FDE7  C9 BA             CMP #$BA
FDE9  90 02             BCC $FDED
FDEB  69 06             ADC #$06

COUT:
FDED  6C 36 00          JMP ($0036)

COUT1:
FDF0  C9 A0             CMP #$A0
FDF2  90 02             BCC $FDF6
FDF4  25 32             AND $32  ; INVFLG
FDF6  84 35             STY $35  ; YSAV1
FDF8  48                PHA 
FDF9  20 78 FB          JSR $FB78  ; VIDWAIT
FDFC  68                PLA 
FDFD  A4 35             LDY $35  ; YSAV1
FDFF  60                RTS 
FE00  C6 34             DEC $34  ; YSAV
FE02  F0 9F             BEQ $FDA3
FE04  CA                DEX 
FE05  D0 16             BNE $FE1D
FE07  C9 BA             CMP #$BA
FE09  D0 BB             BNE $FDC6
FE0B  85 31             STA $31  ; MODE
FE0D  A5 3E             LDA $3E  ; A2L
FE0F  91 40             STA ($40),Y  ; A3L
FE11  E6 40             INC $40  ; A3L
FE13  D0 02             BNE $FE17
FE15  E6 41             INC $41  ; A3H
FE17  60                RTS 
FE18  A4 34             LDY $34  ; YSAV
FE1A  B9 FF 01          LDA $01FF,Y
FE1D  85 31             STA $31  ; MODE
FE1F  60                RTS 
FE20  A2 01             LDX #$01
FE22  B5 3E             LDA $3E,X  ; A2L
FE24  95 42             STA $42,X  ; A4L
FE26  95 44             STA $44,X  ; A5L
FE28  CA                DEX 
FE29  10 F7             BPL $FE22
FE2B  60                RTS 

MOVE:
FE2C  B1 3C             LDA ($3C),Y  ; A1L
FE2E  91 42             STA ($42),Y  ; A4L
FE30  20 B4 FC          JSR $FCB4  ; NXTA4
FE33  90 F7             BCC $FE2C
FE35  60                RTS 

VERIFY:
FE36  B1 3C             LDA ($3C),Y  ; A1L
FE38  D1 42             CMP ($42),Y  ; A4L
FE3A  F0 1C             BEQ $FE58
FE3C  20 92 FD          JSR $FD92  ; PRA1
FE3F  B1 3C             LDA ($3C),Y  ; A1L
FE41  20 DA FD          JSR $FDDA  ; PRBYTE
FE44  A9 A0             LDA #$A0
FE46  20 ED FD          JSR $FDED  ; COUT
FE49  A9 A8             LDA #$A8
FE4B  20 ED FD          JSR $FDED  ; COUT
FE4E  B1 42             LDA ($42),Y  ; A4L
FE50  20 DA FD          JSR $FDDA  ; PRBYTE
FE53  A9 A9             LDA #$A9
FE55  20 ED FD          JSR $FDED  ; COUT
FE58  20 B4 FC          JSR $FCB4  ; NXTA4
FE5B  90 D9             BCC $FE36
FE5D  60                RTS 

LIST:
FE5E  20 75 FE          JSR $FE75
FE61  A9 14             LDA #$14
FE63  48                PHA 
FE64  20 D0 F8          JSR $F8D0  ; INSTDSP
FE67  20 53 F9          JSR $F953
FE6A  85 3A             STA $3A  ; PCL
FE6C  84 3B             STY $3B  ; PCH
FE6E  68                PLA 
FE6F  38                SEC 
FE70  E9 01             SBC #$01
FE72  D0 EF             BNE $FE63
FE74  60                RTS 
FE75  8A                TXA 
FE76  F0 07             BEQ $FE7F
FE78  B5 3C             LDA $3C,X  ; A1L
FE7A  95 3A             STA $3A,X  ; PCL
FE7C  CA                DEX 
FE7D  10 F9             BPL $FE78
FE7F  60                RTS 

SETINV:
FE80  A0 3F             LDY #$3F
FE82  D0 02             BNE $FE86

SETNORM:
FE84  A0 FF             LDY #$FF
FE86  84 32             STY $32  ; INVFLG
FE88  60                RTS 

SETKBD:
FE89  A9 00             LDA #$00
FE8B  85 3E             STA $3E  ; A2L
FE8D  A2 38             LDX #$38
FE8F  A0 1B             LDY #$1B
FE91  D0 08             BNE $FE9B

SETVID:
FE93  A9 00             LDA #$00
FE95  85 3E             STA $3E  ; A2L
FE97  A2 36             LDX #$36
FE99  A0 F0             LDY #$F0
FE9B  A5 3E             LDA $3E  ; A2L
FE9D  29 0F             AND #$0F
FE9F  F0 06             BEQ $FEA7
FEA1  09 C0             ORA #$C0
FEA3  A0 00             LDY #$00
FEA5  F0 02             BEQ $FEA9
FEA7  A9 FD             LDA #$FD
FEA9  94 00             STY $00,X
FEAB  95 01             STA $01,X
FEAD  60                RTS 
FEAE  EA                NOP 
FEAF  EA                NOP 
FEB0  4C 00 E0          JMP $E000
FEB3  4C 03 E0          JMP $E003

GO:
FEB6  20 75 FE          JSR $FE75
FEB9  20 3F FF          JSR $FF3F  ; RESTORE
FEBC  6C 3A 00          JMP ($003A)
FEBF  4C D7 FA          JMP $FAD7
FEC2  60                RTS 
FEC3  EA                NOP 
FEC4  60                RTS 
FEC5  EA                NOP 
FEC6  EA                NOP 
FEC7  EA                NOP 
FEC8  EA                NOP 
FEC9  EA                NOP 
FECA  4C F8 03          JMP $03F8

WRITE:
FECD  A9 40             LDA #$40
FECF  20 C9 FC          JSR $FCC9  ; HEADR
FED2  A0 27             LDY #$27
FED4  A2 00             LDX #$00
FED6  41 3C             EOR ($3C,X)
FED8  48                PHA 
FED9  A1 3C             LDA ($3C,X)
FEDB  20 ED FE          JSR $FEED
FEDE  20 BA FC          JSR $FCBA  ; NXTA1
FEE1  A0 1D             LDY #$1D
FEE3  68                PLA 
FEE4  90 EE             BCC $FED4
FEE6  A0 22             LDY #$22
FEE8  20 ED FE          JSR $FEED
FEEB  F0 4D             BEQ $FF3A
FEED  A2 10             LDX #$10
FEEF  0A                ASL A
FEF0  20 D6 FC          JSR $FCD6
FEF3  D0 FA             BNE $FEEF
FEF5  60                RTS 
FEF6  20 00 FE          JSR $FE00
FEF9  68                PLA 
FEFA  68                PLA 
FEFB  D0 6C             BNE $FF69

READ:
FEFD  20 FA FC          JSR $FCFA
FF00  A9 16             LDA #$16
FF02  20 C9 FC          JSR $FCC9  ; HEADR
FF05  85 2E             STA $2E  ; MASK
FF07  20 FA FC          JSR $FCFA
FF0A  A0 24             LDY #$24
FF0C  20 FD FC          JSR $FCFD
FF0F  B0 F9             BCS $FF0A
FF11  20 FD FC          JSR $FCFD
FF14  A0 3B             LDY #$3B
FF16  20 EC FC          JSR $FCEC
FF19  81 3C             STA ($3C,X)
FF1B  45 2E             EOR $2E  ; MASK
FF1D  85 2E             STA $2E  ; MASK
FF1F  20 BA FC          JSR $FCBA  ; NXTA1
FF22  A0 35             LDY #$35
FF24  90 F0             BCC $FF16
FF26  20 EC FC          JSR $FCEC
FF29  C5 2E             CMP $2E  ; MASK
FF2B  F0 0D             BEQ $FF3A

PRERR:
FF2D  A9 C5             LDA #$C5
FF2F  20 ED FD          JSR $FDED  ; COUT
FF32  A9 D2             LDA #$D2
FF34  20 ED FD          JSR $FDED  ; COUT
FF37  20 ED FD          JSR $FDED  ; COUT

BELL:
FF3A  A9 87             LDA #$87
FF3C  4C ED FD          JMP $FDED  ; COUT

RESTORE:
FF3F  A5 48             LDA $48  ; STATUS
FF41  48                PHA 
FF42  A5 45             LDA $45  ; ACC
FF44  A6 46             LDX $46  ; XREG
FF46  A4 47             LDY $47  ; YREG
FF48  28                PLP 
FF49  60                RTS 

SAVE:
FF4A  85 45             STA $45  ; ACC
FF4C  86 46             STX $46  ; XREG
FF4E  84 47             STY $47  ; YREG
FF50  08                PHP 
FF51  68                PLA 
FF52  85 48             STA $48  ; STATUS
FF54  BA                TSX 
FF55  86 49             STX $49  ; SPNT
FF57  D8                CLD 
FF58  60                RTS 

OLDRST:
FF59  20 84 FE          JSR $FE84  ; SETNORM
FF5C  20 2F FB          JSR $FB2F  ; INIT
FF5F  20 93 FE          JSR $FE93  ; SETVID
FF62  20 89 FE          JSR $FE89  ; SETKBD

MON:
FF65  D8                CLD 
FF66  20 3A FF          JSR $FF3A  ; BELL

MONZ:
FF69  A9 AA             LDA #$AA
FF6B  85 33             STA $33  ; PROMPT
FF6D  20 67 FD          JSR $FD67  ; GETLNZ
FF70  20 C7 FF          JSR $FFC7  ; ZMODE
FF73  20 A7 FF          JSR $FFA7  ; GETNUM
FF76  84 34             STY $34  ; YSAV
FF78  A0 17             LDY #$17
FF7A  88                DEY 
FF7B  30 E8             BMI $FF65
FF7D  D9 CC FF          CMP $FFCC,Y
FF80  D0 F8             BNE $FF7A
FF82  20 BE FF          JSR $FFBE
FF85  A4 34             LDY $34  ; YSAV
FF87  4C 73 FF          JMP $FF73

DIG:
FF8A  A2 03             LDX #$03
FF8C  0A                ASL A
FF8D  0A                ASL A
FF8E  0A                ASL A
FF8F  0A                ASL A
FF90  0A                ASL A
FF91  26 3E             ROL $3E  ; A2L
FF93  26 3F             ROL $3F  ; A2H
FF95  CA                DEX 
FF96  10 F8             BPL $FF90
FF98  A5 31             LDA $31  ; MODE
FF9A  D0 06             BNE $FFA2
FF9C  B5 3F             LDA $3F,X  ; A2H
FF9E  95 3D             STA $3D,X  ; A1H
FFA0  95 41             STA $41,X  ; A3H
FFA2  E8                INX 
FFA3  F0 F3             BEQ $FF98
FFA5  D0 06             BNE $FFAD

GETNUM:
FFA7  A2 00             LDX #$00
FFA9  86 3E             STX $3E  ; A2L
FFAB  86 3F             STX $3F  ; A2H
FFAD  B9 00 02          LDA $0200,Y
FFB0  C8                INY 
FFB1  49 B0             EOR #$B0
FFB3  C9 0A             CMP #$0A
FFB5  90 D3             BCC $FF8A
FFB7  69 88             ADC #$88
FFB9  C9 FA             CMP #$FA
FFBB  B0 CD             BCS $FF8A
FFBD  60                RTS 
FFBE  A9 FE             LDA #$FE
FFC0  48                PHA 
FFC1  B9 E3 FF          LDA $FFE3,Y
FFC4  48                PHA 
FFC5  A5 31             LDA $31  ; MODE

ZMODE:
FFC7  A0 00             LDY #$00
FFC9  84 31             STY $31  ; MODE
FFCB  60                RTS 
FFCC  BC B2 BE          LDY $BEB2,X
FFCF  B2                .BYTE $B2      ; invalid opcode
FFD0  EF                .BYTE $EF      ; invalid opcode
FFD1  C4 B2             CPY $B2
FFD3  A9 BB             LDA #$BB
FFD5  A6 A4             LDX $A4
FFD7  06 95             ASL $95
FFD9  07                .BYTE $07      ; invalid opcode
FFDA  02                .BYTE $02      ; invalid opcode
FFDB  05 F0             ORA $F0
FFDD  00                BRK 
FFDE  EB                .BYTE $EB      ; invalid opcode
FFDF  93                .BYTE $93      ; invalid opcode
FFE0  A7                .BYTE $A7      ; invalid opcode
FFE1  C6 99             DEC $99
FFE3  B2                .BYTE $B2      ; invalid opcode
FFE4  C9 BE             CMP #$BE
FFE6  C1 35             CMP ($35,X)
FFE8  8C C4 96          STY $96C4
FFEB  AF                .BYTE $AF      ; invalid opcode
FFEC  17                .BYTE $17      ; invalid opcode
FFED  17                .BYTE $17      ; invalid opcode
FFEE  2B                .BYTE $2B      ; invalid opcode
FFEF  1F                .BYTE $1F      ; invalid opcode
FFF0  83                .BYTE $83      ; invalid opcode
FFF1  7F                .BYTE $7F      ; invalid opcode
FFF2  5D CC B5          EOR $B5CC,X
FFF5  FC                .BYTE $FC      ; invalid opcode
FFF6  17                .BYTE $17      ; invalid opcode
FFF7  17                .BYTE $17      ; invalid opcode
FFF8  F5 03             SBC $03,X

; ---- 6502 hardware vectors ----
FFFA  FB 03             .WORD $03FB      ; NMI
FFFC  62 FA             .WORD $FA62      ; RESET  -> RESET
FFFE  40 FA             .WORD $FA40      ; IRQ/BRK  -> IRQ
