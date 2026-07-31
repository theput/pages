; Apple II Integer BASIC (upper 6K) + Autostart Monitor, $E800-$FFFF
; From the AMD AM2716DC four-chip set. $E000-$E7FF is MISSING -- that chip is dead.
; WARNING: the $E800 block carries known bit-3 read errors (see the page).
; ==============================================================================

        .ORG $E800

E800  F2                .BYTE $F2      ; invalid opcode
E801  20 15 E7          JSR $E715
E804  B5 50             LDA $50,X
E806  85 D2             STA $D2   ** UNSTABLE READ **
E808  B5 70             LDA $70,X
E80A  85 DB             STA $DB
E80C  A5 CE             LDA $CE
E80E  91 D2             STA ($D2),Y
E810  C0 A5             CPY #$A5
E812  C7                .BYTE $C7      ; invalid opcode
E813  4C 07 F2          JMP $F207
E816  60                RTS 
E817  68                PLA    ** UNSTABLE READ **
E818  60                RTS 
E819  24 D5             BIT $D5
E81B  10 05             BPL $E822
E81D  20 8E F5          JSR $F58E
E820  46 D5             LSR $D5
E822  60                RTS 
E823  A0 F7             LDY #$F7
E825  84 D7             STY $D7
E827  60                RTS 
E828  20 CD E7          JSR $E7CD
E82B  F0 07             BEQ $E834
E82D  A9 25             LDA #$25
E82F  85 D6             STA $D6
E831  80                .BYTE $80      ; invalid opcode
E832  84 D4             STY $D4
E834  E0 60             CPX #$60   ** UNSTABLE READ **
E836  A5 C2             LDA $C2
E838  A4 C3             LDY $C3
E83A  D0 5A             BNE $E896
E83C  A0 41             LDY #$41
E83E  A5 F4             LDA $F4
E840  C1 10             CMP ($10,X)
E842  B0 5E             BCS $E8A2
E844  A0 E6             LDY #$E6   ** UNSTABLE READ **
E846  F4                .BYTE $F4      ; invalid opcode
E847  A5 E0             LDA $E0
E849  99 00 01          STA $0100,Y
E84C  A5 E1             LDA $E1
E84E  91 10             STA ($10),Y
E850  01 A5             ORA ($A5,X)
E852  D4                .BYTE $D4      ; invalid opcode
E853  99 20 01          STA $0120,Y
E856  A5 D5             LDA $D5
E858  91 30             STA ($30),Y  ; COLOR
E85A  01 20             ORA ($20,X)
E85C  15 E7             ORA $E7,X
E85E  20 65 E5          JSR $E565
E861  90 04             BCC $E867
E863  A0 37             LDY #$37
E865  D0 33             BNE $E89A
E867  A5 E4             LDA $E4
E869  A4 E5             LDY $E5
E86B  85 DC             STA $DC
E86D  84 D5             STY $D5
E86F  10 69             BPL $E8DA
E871  03                .BYTE $03      ; invalid opcode
E872  90 01             BCC $E875
E874  C0 A2             CPY #$A2
E876  F7                .BYTE $F7      ; invalid opcode
E877  86 D1             STX $D1
E879  92                .BYTE $92      ; invalid opcode
E87A  85 E0             STA $E0
E87C  84 E1             STY $E1
E87E  20 26 F0          JSR $F026
E881  A0 00             LDY #$00
E883  20 79 E6          JSR $E679
E886  24 D9             BIT $D9
E888  10 41             BPL $E8CB
E88A  18                CLC 
E88B  A0 00             LDY #$00
E88D  A5 D4             LDA $D4
E88F  71 D4             ADC ($D4),Y
E891  A4 DD             LDY $DD
E893  90 01             BCC $E896
E895  C0 C5 44 D0 D1 C4 .ASC "@EDPQDEPE 1FQD`c B%tpwFt(9"
E8AF  17                .BYTE $17      ; invalid opcode
E8B0  01 85             ORA ($85,X)
E8B2  DC                .BYTE $DC      ; invalid opcode
E8B3  B9 2F 01          LDA $012F,Y
E8B6  85 D5             STA $D5
E8B8  BE F7 00          LDX $00F7,Y   ** UNSTABLE READ **
E8BB  B9 0F 01          LDA $010F,Y
E8BE  A0 82             LDY #$82
E8C0  44                .BYTE $44      ; invalid opcode
E8C1  75 E8             ADC $E8,X
E8C3  A0 63             LDY #$63
E8C5  20 C4 E3          JSR $E3C4
E8C8  A0 01             LDY #$01
E8CA  B1 DC             LDA ($DC),Y
E8CC  AA                TAX 
E8CD  C8                INY 
E8CE  B1 DC             LDA ($DC),Y
E8D0  20 13 E5          JSR $E513
E8D3  4C B3 E2          JMP $E2B3
E8D6  C6 F3             DEC $F3
E8D8  A0 53             LDY #$53
E8DA  A5 F3             LDA $F3   ** UNSTABLE READ **
E8DC  F0 C4             BEQ $E8A2
E8DE  A8                TAY 
E8DF  B5 50             LDA $50,X
E8E1  D1 3F             CMP ($3F),Y  ; A2H
E8E3  01 D0             ORA ($D0,X)
E8E5  F0 B5             BEQ $E89C
E8E7  70 D1             BVS $E8BA
E8E9  47                .BYTE $47      ; invalid opcode
E8EA  01 D0             ORA ($D0,X)
E8EC  E9 B1             SBC #$B1
E8EE  5F                .BYTE $5F      ; invalid opcode
E8EF  01 85             ORA ($85,X)
E8F1  DA                .BYTE $DA      ; invalid opcode
E8F2  B9 6F 01          LDA $016F,Y
E8F5  85 D3             STA $D3
E8F7  20 15 E7          JSR $E715
E8FA  C2                .BYTE $C2      ; invalid opcode
E8FB  20 93 E7          JSR $E793
E8FE  20 01 E8          JSR $E801
E901  CA                DEX 
E902  A4 FB             LDY $FB
E904  B9 C7 01          LDA $01C7,Y   ** UNSTABLE READ **
E907  95 9F             STA $9F,X
E909  B9 BF 01          LDA $01BF,Y
E90C  A0 00             LDY #$00
E90E  20 08 E7          JSR $E708
E911  20 82 E7          JSR $E782
E914  20 59 E7          JSR $E759
E917  20 15 E7          JSR $E715
E91A  A4 FB             LDY $FB
E91C  A5 CE             LDA $CE
E91E  F0 05             BEQ $E925
E920  51 67             EOR ($67),Y
E922  01 10             ORA ($10,X)
E924  12                .BYTE $12      ; invalid opcode
E925  B9 77 01          LDA $0177,Y
E928  85 D4             STA $D4
E92A  B9 8F 01          LDA $018F,Y
E92D  85 DD             STA $DD
E92F  BE 9F 01          LDX $019F,Y
E932  B9 AF 01          LDA $01AF,Y
E935  D0 87             BNE $E8BE
E937  C6 FB             DEC $FB
E939  60                RTS 
E93A  A0 54             LDY #$54
E93C  A5 F3             LDA $F3
E93E  C1 10             CMP ($10,X)   ** UNSTABLE READ **
E940  F0 92             BEQ $E8D4   ** UNSTABLE READ **
E942  E6 F3             INC $F3
E944  A8                TAY 
E945  B5 50             LDA $50,X
E947  99 40 01          STA $0140,Y
E94A  B5 78             LDA $78,X
E94C  44                .BYTE $44      ; invalid opcode
E94D  88                DEY 
E94E  F2                .BYTE $F2      ; invalid opcode
E94F  60                RTS 
E950  20 15 E7          JSR $E715
E953  A4 FB             LDY $FB
E955  A5 CE             LDA $CE
E957  91 B7             STA ($B7),Y
E959  01 A5             ORA ($A5,X)
E95B  C7                .BYTE $C7      ; invalid opcode
E95C  99 CF 01          STA $01CF,Y
E95F  A1 01             LDA ($01,X)
E961  91 5F             STA ($5F),Y
E963  01 A9             ORA ($A9,X)
E965  00                BRK 
E966  91 67             STA ($67),Y   ** UNSTABLE READ **
E968  01 A5             ORA ($A5,X)
E96A  DC                .BYTE $DC      ; invalid opcode
E96B  91 7F             STA ($7F),Y
E96D  01 A5             ORA ($A5,X)
E96F  DD 99 8F          CMP $8F99,X
E972  01 A5             ORA ($A5,X)
E974  E0 99             CPX #$99
E976  97                .BYTE $97      ; invalid opcode
E977  01 A5             ORA ($A5,X)
E979  E1 91             SBC ($91,X)
E97B  A7                .BYTE $A7      ; invalid opcode
E97C  01 60             ORA ($60,X)
E97E  20 15 00          JSR $0015
E981  00                BRK 
E982  00                BRK 
E983  A3                .BYTE $A3      ; invalid opcode
E984  03                .BYTE $03      ; invalid opcode
E985  03                .BYTE $03      ; invalid opcode
E986  03                .BYTE $03      ; invalid opcode
E987  03                .BYTE $03      ; invalid opcode
E988  03                .BYTE $03      ; invalid opcode
E989  03                .BYTE $03      ; invalid opcode
E98A  03                .BYTE $03      ; invalid opcode
E98B  03                .BYTE $03      ; invalid opcode
E98C  03                .BYTE $03      ; invalid opcode
E98D  03                .BYTE $03      ; invalid opcode
E98E  03                .BYTE $03      ; invalid opcode
E98F  03                .BYTE $03      ; invalid opcode
E990  03                .BYTE $03      ; invalid opcode
E991  03                .BYTE $03      ; invalid opcode
E992  37                .BYTE $37      ; invalid opcode
E993  3F                .BYTE $3F      ; invalid opcode
E994  C0 C0             CPY #$C0
E996  3C                .BYTE $3C      ; invalid opcode
E997  34                .BYTE $34      ; invalid opcode
E998  3C                .BYTE $3C      ; invalid opcode
E999  34                .BYTE $34      ; invalid opcode
E99A  34                .BYTE $34      ; invalid opcode
E99B  3C                .BYTE $3C      ; invalid opcode
E99C  34                .BYTE $34      ; invalid opcode
E99D  30 0F             BMI $E9AE
E99F  C0 C3             CPY #$C3
E9A1  F7                .BYTE $F7      ; invalid opcode
E9A2  55 00             EOR $00,X
E9A4  AB                .BYTE $AB      ; invalid opcode
E9A5  AB                .BYTE $AB      ; invalid opcode
E9A6  03                .BYTE $03      ; invalid opcode
E9A7  03                .BYTE $03      ; invalid opcode
E9A8  FF                .BYTE $FF      ; invalid opcode
E9A9  F7 55 F7 F7 55 CF .ASC "wUwwUOGOGOwUFFFUppGOU"
E9BE  01 55             ORA ($55,X)
E9C0  F7                .BYTE $F7      ; invalid opcode
E9C1  FF                .BYTE $FF      ; invalid opcode
E9C2  55 03             EOR $03,X
E9C4  03                .BYTE $03      ; invalid opcode
E9C5  03                .BYTE $03      ; invalid opcode
E9C6  03                .BYTE $03      ; invalid opcode
E9C7  03                .BYTE $03      ; invalid opcode
E9C8  03                .BYTE $03      ; invalid opcode
E9C9  03                .BYTE $03      ; invalid opcode
E9CA  03                .BYTE $03      ; invalid opcode
E9CB  03                .BYTE $03      ; invalid opcode
E9CC  03                .BYTE $03      ; invalid opcode
E9CD  03                .BYTE $03      ; invalid opcode
E9CE  03                .BYTE $03      ; invalid opcode
E9CF  03                .BYTE $03      ; invalid opcode
E9D0  03                .BYTE $03      ; invalid opcode
E9D1  03                .BYTE $03      ; invalid opcode
E9D2  03                .BYTE $03      ; invalid opcode
E9D3  03                .BYTE $03      ; invalid opcode
E9D4  03                .BYTE $03      ; invalid opcode
E9D5  03                .BYTE $03      ; invalid opcode
E9D6  03                .BYTE $03      ; invalid opcode
E9D7  03                .BYTE $03      ; invalid opcode
E9D8  03                .BYTE $03      ; invalid opcode
E9D9  03                .BYTE $03      ; invalid opcode
E9DA  03                .BYTE $03      ; invalid opcode
E9DB  03                .BYTE $03      ; invalid opcode
E9DC  03                .BYTE $03      ; invalid opcode
E9DD  00                BRK 
E9DE  A3                .BYTE $A3      ; invalid opcode
E9DF  03                .BYTE $03      ; invalid opcode
E9E0  57                .BYTE $57      ; invalid opcode
E9E1  03                .BYTE $03      ; invalid opcode
E9E2  03                .BYTE $03      ; invalid opcode
E9E3  03                .BYTE $03      ; invalid opcode
E9E4  03                .BYTE $03      ; invalid opcode
E9E5  07                .BYTE $07      ; invalid opcode
E9E6  03                .BYTE $03      ; invalid opcode
E9E7  03                .BYTE $03      ; invalid opcode
E9E8  03                .BYTE $03      ; invalid opcode
E9E9  03                .BYTE $03      ; invalid opcode
E9EA  03                .BYTE $03      ; invalid opcode
E9EB  03                .BYTE $03      ; invalid opcode
E9EC  03                .BYTE $03      ; invalid opcode
E9ED  03                .BYTE $03      ; invalid opcode
E9EE  03                .BYTE $03      ; invalid opcode
E9EF  03                .BYTE $03      ; invalid opcode
E9F0  03                .BYTE $03      ; invalid opcode
E9F1  03                .BYTE $03      ; invalid opcode
E9F2  A2 F7             LDX #$F7   ** UNSTABLE READ **
E9F4  03                .BYTE $03      ; invalid opcode
E9F5  03                .BYTE $03      ; invalid opcode
E9F6  03                .BYTE $03      ; invalid opcode
E9F7  03                .BYTE $03      ; invalid opcode
E9F8  03                .BYTE $03      ; invalid opcode
E9F9  03                .BYTE $03      ; invalid opcode
E9FA  03                .BYTE $03      ; invalid opcode
E9FB  03                .BYTE $03      ; invalid opcode
E9FC  03                .BYTE $03      ; invalid opcode
E9FD  03                .BYTE $03      ; invalid opcode
E9FE  03                .BYTE $03      ; invalid opcode
E9FF  03                .BYTE $03      ; invalid opcode
EA00  17                .BYTE $17      ; invalid opcode
EA01  F7                .BYTE $F7      ; invalid opcode
EA02  FF                .BYTE $FF      ; invalid opcode
EA03  19 DF 42          ORA $42DF,Y
EA06  0A                ASL A
EA07  F2                .BYTE $F2      ; invalid opcode
EA08  EC 87 6F          CPX $6F87
EA0B  AD B7 E2          LDA $E2B7
EA0E  F8                SED 
EA0F  54                .BYTE $54      ; invalid opcode
EA10  45 C9             EOR $C9   ** UNSTABLE READ **
EA12  85 82             STA $82
EA14  22                .BYTE $22      ; invalid opcode
EA15  10 33             BPL $EA4A
EA17  4A                LSR A
EA18  5B                .BYTE $5B      ; invalid opcode
EA19  46 53             LSR $53
EA1B  42                .BYTE $42      ; invalid opcode
EA1C  49 66             EOR #$66
EA1E  65 7A             ADC $7A
EA20  71 FF             ADC ($FF),Y
EA22  23                .BYTE $23      ; invalid opcode
EA23  09 5B             ORA #$5B
EA25  16 B6             ASL $B6,X
EA27  C3                .BYTE $C3      ; invalid opcode
EA28  F7                .BYTE $F7      ; invalid opcode
EA29  FF                .BYTE $FF      ; invalid opcode
EA2A  FB                .BYTE $FB      ; invalid opcode
EA2B  F7                .BYTE $F7      ; invalid opcode
EA2C  FF                .BYTE $FF      ; invalid opcode
EA2D  24 F6             BIT $F6
EA2F  4E 51 50          LSR $5051
EA32  33                .BYTE $33      ; invalid opcode
EA33  F7                .BYTE $F7      ; invalid opcode
EA34  23                .BYTE $23      ; invalid opcode
EA35  A3                .BYTE $A3      ; invalid opcode
EA36  6F                .BYTE $6F      ; invalid opcode
EA37  36 23             ROL $23,X  ; WNDBTM
EA39  D7                .BYTE $D7      ; invalid opcode
EA3A  1C                .BYTE $1C      ; invalid opcode
EA3B  22                .BYTE $22      ; invalid opcode
EA3C  1D 82 A3          ORA $A382,X
EA3F  23                .BYTE $23      ; invalid opcode
EA40  F7                .BYTE $F7      ; invalid opcode
EA41  F7                .BYTE $F7      ; invalid opcode
EA42  21 30             AND ($30,X)
EA44  16 03             ASL $03,X
EA46  C4 20             CPY $20  ; WNDLFT
EA48  00                BRK 
EA49  C1 BA             CMP ($BA,X)
EA4B  39 40 A0          AND $A040,Y
EA4E  30 1E             BMI $EA6E
EA50  A4 D3             LDY $D3
EA52  B6 BC             LDX $BC,Y
EA54  AA                TAX 
EA55  3A                .BYTE $3A      ; invalid opcode
EA56  01 50             ORA ($50,X)
EA58  79 D0 D8          ADC $D8D0,Y
EA5B  A5 3C             LDA $3C  ; A1L   ** UNSTABLE READ **
EA5D  F7                .BYTE $F7      ; invalid opcode
EA5E  16 53             ASL $53,X
EA60  20 03 C4          JSR $C403   ** UNSTABLE READ **
EA63  1D 08 00          ORA $0008,X
EA66  4E 00 36          LSR $3600
EA69  00                BRK 
EA6A  A6 B0             LDX $B0
EA6C  00                BRK 
EA6D  B4 C6             LDY $C6,X
EA6F  57                .BYTE $57      ; invalid opcode
EA70  84 01             STY $01
EA72  27                .BYTE $27      ; invalid opcode
EA73  FF                .BYTE $FF      ; invalid opcode
EA74  5D 35 43          EOR $4335,X
EA77  67                .BYTE $67      ; invalid opcode
EA78  E0 E1             CPX #$E1
EA7A  76 04             ROR $04,X
EA7C  05 71             ORA $71
EA7E  C9 12             CMP #$12
EA80  E8                INX 
EA81  FF                .BYTE $FF      ; invalid opcode
EA82  FF                .BYTE $FF      ; invalid opcode
EA83  E8 F0 F1 F3 EF E7 .ASC "hpqsogcceeggnppggboggrrrgrrrbsw`ahhgkw"
EAA9  FF                .BYTE $FF      ; invalid opcode
EAAA  E0 FF             CPX #$FF
EAAC  F7 EF EE EF E7 E7 .ASC "wonoggs"
EAB3  FF                .BYTE $FF      ; invalid opcode
EAB4  E8 E7 E7 E7 E0 E1 .ASC "hggg`abfsbb`wwaagng`fgs{snagg`ooki`ar`h`hw``hng`ogfgngfnonfnahh"
EAF3  FF                .BYTE $FF      ; invalid opcode
EAF4  E0 E0 E0 F1 F2 F2 .ASC "```qrrqssqst632767TGO LGNGSYNTAPMEM FULLTOG MANY PARENSSTRANGFO EFDBAD BRAFC@16 GOSUBSBAD RETURN16 FGRSBAD NEXTSTOPPED AT \"*\"  ERR"
EB76  05 BE             ORA $BE
EB78  B2                .BYTE $B2      ; invalid opcode
EB79  B5 35             LDA $35,X  ; YSAV1
EB7B  D2                .BYTE $D2      ; invalid opcode
EB7C  C1 CE             CMP ($CE,X)
EB7E  C7                .BYTE $C7      ; invalid opcode
EB7F  45 C4             EOR $C4
EB81  C1 4D             CMP ($4D,X)
EB83  D3                .BYTE $D3      ; invalid opcode
EB84  D4                .BYTE $D4      ; invalid opcode
EB85  D2                .BYTE $D2      ; invalid opcode
EB86  A0 CF             LDY #$CF
EB88  D6 C6             DEC $C6,X
EB8A  4C D4 0D          JMP $0DD4
EB8D  D2 C5 D4 D9 D0 C5 .ASC "RETYPE LIFE"
EB98  8D 3F 46          STA $463F
EB9B  D9 90 03          CMP $0390,Y
EB9E  4C C3 E0          JMP $E0C3
EBA1  A6 CF             LDX $CF
EBA3  9A                TXS 
EBA4  A6 CE             LDX $CE   ** UNSTABLE READ **
EBA6  A0 8D             LDY #$8D
EBA8  D0 02             BNE $EBAC
EBAA  A0 99             LDY #$99
EBAC  20 C4 E3          JSR $E3C4
EBAF  86 CE             STX $CE
EBB1  BA                TSX    ** UNSTABLE READ **
EBB2  86 CF             STX $CF
EBB4  20 66 F3          JSR $F366
EBB7  84 F1             STY $F1
EBB9  A9 F7             LDA #$F7   ** UNSTABLE READ **
EBBB  85 C8             STA $C8
EBBD  02                .BYTE $02      ; invalid opcode
EBBE  85 D9             STA $D9
EBC0  A2 20             LDX #$20
EBC2  A1 15             LDA ($15,X)
EBC4  20 91 E4          JSR $E491
EBC7  E6 D9             INC $D9
EBC9  A6 CE             LDX $CE
EBCB  A4 C8             LDY $C8
EBCD  0A                ASL A
EBCE  85 CE             STA $CE
EBD0  C8                INY 
EBD1  B1 00             LDA ($00),Y
EBD3  02                .BYTE $02      ; invalid opcode
EBD4  C9 80             CMP #$80
EBD6  F0 D2             BEQ $EBAA
EBD8  49 B0             EOR #$B0   ** UNSTABLE READ **
EBDA  C9 02             CMP #$02
EBDC  B0 F0             BCS $EBCE
EBDE  C8                INY 
EBDF  C0 84             CPY #$84
EBE1  C0 B9             CPY #$B9
EBE3  00                BRK 
EBE4  02                .BYTE $02      ; invalid opcode
EBE5  40                RTI 
EBE6  B9 FF 01          LDA $01FF,Y
EBE9  A0 00             LDY #$00
EBEB  20 08 E7          JSR $E708
EBEE  60                RTS 
EBEF  95 A0             STA $A0,X
EBF1  A5 CE             LDA $CE
EBF3  C9 33             CMP #$33
EBF5  D0 03             BNE $EBFA
EBF7  20 6F E7          JSR $E76F
EBFA  44                .BYTE $44      ; invalid opcode
EBFB  01 E0             ORA ($E0,X)
EBFD  FF                .BYTE $FF      ; invalid opcode
EBFE  F7                .BYTE $F7      ; invalid opcode
EBFF  FF                .BYTE $FF      ; invalid opcode
EC00  50 20             BVC $EC22
EC02  4F                .BYTE $4F      ; invalid opcode
EC03  C0 F4             CPY #$F4
EC05  A1 E4             LDA ($E4,X)
EC07  AF                .BYTE $AF      ; invalid opcode
EC08  A5 F2             LDA $F2
EC0A  AF                .BYTE $AF      ; invalid opcode
EC0B  E4 AE             CPX $AE
EC0D  A1 F0             LDA ($F0,X)
EC0F  A5 B4             LDA $B4
EC11  B3                .BYTE $B3      ; invalid opcode
EC12  E7                .BYTE $E7      ; invalid opcode
EC13  B4 EE             LDY $EE,X
EC15  A5 A0             LDA $A0
EC17  B4 54             LDY $54,X   ** UNSTABLE READ **
EC19  80                .BYTE $80      ; invalid opcode
EC1A  00                BRK 
EC1B  40                RTI 
EC1C  60                RTS 
EC1D  8D 60 8B          STA $8B60
EC20  77                .BYTE $77      ; invalid opcode
EC21  1D 20 7E          ORA $7E20,X
EC24  84 33             STY $33  ; PROMPT
EC26  00                BRK 
EC27  00                BRK 
EC28  60                RTS 
EC29  03                .BYTE $03      ; invalid opcode
EC2A  B7                .BYTE $B7      ; invalid opcode
EC2B  12                .BYTE $12      ; invalid opcode
EC2C  47                .BYTE $47      ; invalid opcode
EC2D  83                .BYTE $83      ; invalid opcode
EC2E  AE A9 67          LDX $67A9
EC31  83                .BYTE $83      ; invalid opcode
EC32  B2                .BYTE $B2      ; invalid opcode
EC33  B0 E5             BCS $EC1A
EC35  A3                .BYTE $A3      ; invalid opcode
EC36  A1 B2             LDA ($B2,X)
EC38  B4 71             LDY $71,X
EC3A  B0 B3             BCS $EBEF
EC3C  A4 69             LDY $69
EC3E  B0 B3             BCS $EBF3
EC40  A4 E5             LDY $E5
EC42  A3                .BYTE $A3      ; invalid opcode
EC43  A1 B2             LDA ($B2,X)
EC45  B4 A7             LDY $A7,X
EC47  AE 79 B0          LDX $B079
EC4A  B3                .BYTE $B3      ; invalid opcode
EC4B  A4 A7             LDY $A7
EC4D  AE 69 B0          LDX $B069
EC50  B3                .BYTE $B3      ; invalid opcode
EC51  A4 AF             LDY $AF
EC53  AE F0 A7          LDX $A7F0
EC56  B0 F4             BCS $EC4C
EC58  B3                .BYTE $B3      ; invalid opcode
EC59  A1 AC             LDA ($AC,X)
EC5B  60                RTS 
EC5C  8C 20 B4          STY $B420
EC5F  B3                .BYTE $B3      ; invalid opcode
EC60  A9 AC             LDA #$AC
EC62  00                BRK 
EC63  40                RTI 
EC64  89                .BYTE $89      ; invalid opcode
EC65  C9 47             CMP #$47
EC67  95 17             STA $17,X
EC69  60                RTS    ** UNSTABLE READ **
EC6A  9D 0A 58          STA $580A,X
EC6D  73                .BYTE $73      ; invalid opcode
EC6E  67                .BYTE $67      ; invalid opcode
EC6F  A2 A1             LDX #$A1
EC71  B4 B6             LDY $B6,X
EC73  67                .BYTE $67      ; invalid opcode
EC74  B4 A1             LDY $A1,X
EC76  07                .BYTE $07      ; invalid opcode
EC77  8C 07 AE          STY $AE07
EC7A  A1 AC             LDA ($AC,X)
EC7C  B6 67             LDX $67,Y
EC7E  B4 A1             LDY $A1,X
EC80  07                .BYTE $07      ; invalid opcode
EC81  8C 07 A6          STY $A607
EC84  A9 A4             LDA #$A4
EC86  A8                TAY 
EC87  67                .BYTE $67      ; invalid opcode
EC88  84 07             STY $07
EC8A  B4 AF             LDY $AF,X
EC8C  AC B0 67          LDY $67B0
EC8F  95 B2             STA $B2,X
EC91  A7                .BYTE $A7      ; invalid opcode
EC92  AC AF A3          LDY $A3AF
EC95  67                .BYTE $67      ; invalid opcode
EC96  8C 07 A5          STY $A507
EC99  AB                .BYTE $AB      ; invalid opcode
EC9A  AF                .BYTE $AF      ; invalid opcode
EC9B  B0 F4             BCS $EC91
EC9D  AE A9 B2          LDX $B2A9
ECA0  B0 7F             BCS $ED21
ECA2  0E 27 B4          ASL $B427
ECA5  A6 A1             LDX $A1   ** UNSTABLE READ **
ECA7  B2                .BYTE $B2      ; invalid opcode
ECA8  B0 7F             BCS $ED29
ECAA  0E 28 B4          ASL $B428
ECAD  AE A9 B2          LDX $B2A9
ECB0  B0 64             BCS $ED16
ECB2  07                .BYTE $07      ; invalid opcode
ECB3  A6 A9             LDX $A9
ECB5  67                .BYTE $67      ; invalid opcode
ECB6  AF                .BYTE $AF      ; invalid opcode
ECB7  B4 AF             LDY $AF,X   ** UNSTABLE READ **
ECB9  A7                .BYTE $A7      ; invalid opcode
ECBA  78                SEI 
ECBB  B4 A5             LDY $A5,X
ECBD  AC 6B 77          LDY $776B   ** UNSTABLE READ **
ECC0  02                .BYTE $02      ; invalid opcode
ECC1  AD A5 B2          LDA $B2A5
ECC4  67                .BYTE $67      ; invalid opcode
ECC5  A2 B5             LDX #$B5
ECC7  B3                .BYTE $B3      ; invalid opcode
ECC8  AF                .BYTE $AF      ; invalid opcode
ECC9  A7                .BYTE $A7      ; invalid opcode
ECCA  EE B2 B5          INC $B5B2
ECCD  B4 A5             LDY $A5,X
ECCF  B2                .BYTE $B2      ; invalid opcode
ECD0  7E 84 39          ROR $3984,X
ECD3  B4 B8             LDY $B8,X
ECD5  A5 AE             LDA $AE
ECD7  67                .BYTE $67      ; invalid opcode
ECD8  B0 A5             BCS $EC7F
ECDA  B4 B3             LDY $B3,X
ECDC  27                .BYTE $27      ; invalid opcode
ECDD  A7                .BYTE $A7      ; invalid opcode
ECDE  B4 07             LDY $07,X
ECE0  9D 19 B2          STA $B219,X
ECE3  AF                .BYTE $AF      ; invalid opcode
ECE4  A6 7F             LDX $7F
ECE6  05 37             ORA $37  ; CSWH
ECE8  B4 B5             LDY $B5,X
ECEA  B0 AE             BCS $EC9A
ECEC  A9 7F             LDA #$7F
ECEE  05 28             ORA $28  ; BASL
ECF0  B4 B5             LDY $B5,X
ECF2  B0 AE             BCS $ECA2
ECF4  A9 7F             LDA #$7F
ECF6  05 2A             ORA $2A
ECF8  B4 B5             LDY $B5,X
ECFA  B0 AE             BCS $ECAA
ECFC  A1 E4             LDA ($E4,X)
ECFE  AE A5 00          LDX $00A5
ED01  47                .BYTE $47      ; invalid opcode
ED02  A2 A1             LDX #$A1
ED04  B4 7F             LDY $7F,X
ED06  0D 30 A5          ORA $A530
ED09  A9 A4             LDA #$A4
ED0B  77                .BYTE $77      ; invalid opcode
ED0C  0D 23 A5          ORA $A523
ED0F  A9 A4             LDA #$A4
ED11  67                .BYTE $67      ; invalid opcode
ED12  A4 A4             LDY $A4   ** UNSTABLE READ **
ED14  A1 A3             LDA ($A3,X)
ED16  F2                .BYTE $F2      ; invalid opcode
ED17  A7                .BYTE $A7      ; invalid opcode
ED18  F4                .BYTE $F4      ; invalid opcode
ED19  B8                CLV    ** UNSTABLE READ **
ED1A  A5 B4             LDA $B4
ED1C  00                BRK 
ED1D  4D C4 67          EOR $67C4
ED20  8C 60 8C          STY $8C60   ** UNSTABLE READ **
ED23  DB                .BYTE $DB      ; invalid opcode
ED24  67                .BYTE $67      ; invalid opcode
ED25  9B                .BYTE $9B      ; invalid opcode
ED26  60                RTS 
ED27  93                .BYTE $93      ; invalid opcode
ED28  50 84             BVC $ECAE
ED2A  63                .BYTE $63      ; invalid opcode
ED2B  8C 7F 01          STY $017F   ** UNSTABLE READ **
ED2E  51 07             EOR ($07),Y
ED30  88                DEY 
ED31  21 84             AND ($84,X)
ED33  80                .BYTE $80      ; invalid opcode
ED34  C4 11             CPY $11   ** UNSTABLE READ **
ED36  57                .BYTE $57      ; invalid opcode
ED37  71 07             ADC ($07),Y
ED39  88                DEY 
ED3A  14                .BYTE $14      ; invalid opcode
ED3B  71 07             ADC ($07),Y
ED3D  8C 07 88          STY $8807
ED40  A6 B2             LDX $B2   ** UNSTABLE READ **
ED42  A3                .BYTE $A3      ; invalid opcode
ED43  B3                .BYTE $B3      ; invalid opcode
ED44  71 08             ADC ($08),Y
ED46  80                .BYTE $80      ; invalid opcode
ED47  A3                .BYTE $A3      ; invalid opcode
ED48  B3                .BYTE $B3      ; invalid opcode
ED49  A1 71             LDA ($71,X)
ED4B  08                PHP 
ED4C  80                .BYTE $80      ; invalid opcode
ED4D  AE A5 AC          LDX $ACA5
ED50  60                RTS 
ED51  83                .BYTE $83      ; invalid opcode
ED52  08                PHP 
ED53  68                PLA 
ED54  9D 08 71          STA $7108,X
ED57  07                .BYTE $07      ; invalid opcode
ED58  80                .BYTE $80      ; invalid opcode
ED59  60                RTS 
ED5A  75 B4             ADC $B4,X
ED5C  AF                .BYTE $AF      ; invalid opcode
ED5D  AE 75 8D          LDX $8D75   ** UNSTABLE READ **
ED60  75 8B             ADC $8B,X
ED62  51 07             EOR ($07),Y
ED64  88                DEY 
ED65  19 B0 A4          ORA $A4B0,Y
ED68  AE B2 EC          LDX $ECB2
ED6B  A4 B0             LDY $B0
ED6D  F3                .BYTE $F3      ; invalid opcode
ED6E  A2 A1             LDX #$A1
ED70  EE A7 B3          INC $B3A7
ED73  E4 AE             CPX $AE
ED75  B2                .BYTE $B2      ; invalid opcode
ED76  EB                .BYTE $EB      ; invalid opcode
ED77  A5 A5             LDA $A5
ED79  B0 51             BCS $EDCC
ED7B  07                .BYTE $07      ; invalid opcode
ED7C  88                DEY 
ED7D  39 81 C1          AND $C181,Y
ED80  4F                .BYTE $4F      ; invalid opcode
ED81  77                .BYTE $77      ; invalid opcode
ED82  0F                .BYTE $0F      ; invalid opcode
ED83  27                .BYTE $27      ; invalid opcode
ED84  00                BRK 
ED85  51 06             EOR ($06),Y
ED87  80                .BYTE $80      ; invalid opcode
ED88  29 C2             AND #$C2
ED8A  0C                .BYTE $0C      ; invalid opcode
ED8B  82                .BYTE $82      ; invalid opcode
ED8C  57                .BYTE $57      ; invalid opcode
ED8D  8C 6A 8C          STY $8C6A
ED90  42                .BYTE $42      ; invalid opcode
ED91  AE A5 A0          LDX $A0A5
ED94  B4 60             LDY $60,X
ED96  AE A5 A8          LDX $A8A5
ED99  B4 4F             LDY $4F,X  ; RNDH
ED9B  7E 1E 35          ROR $351E,X
ED9E  8C 27 51          STY $5127
EDA1  07                .BYTE $07      ; invalid opcode
EDA2  88                DEY 
EDA3  09 83             ORA #$83
EDA5  FE E4 AF          INC $AFE4,X
EDA8  AD F2 AF          LDA $AFF2
EDAB  E4 AE             CPX $AE
EDAD  A1 DC             LDA ($DC,X)
EDAF  D6 9C             DEC $9C,X   ** UNSTABLE READ **
EDB1  D5 9C             CMP $9C,X
EDB3  DE DD 9E          DEC $9EDD,X   ** UNSTABLE READ **
EDB6  C3 DD CF C2 CD C3 .ASC "C]OBMC"
EDBC  00                BRK 
EDBD  47                .BYTE $47      ; invalid opcode
EDBE  9A                TXS 
EDBF  AD A5 A5          LDA $A5A5
EDC2  AF                .BYTE $AF      ; invalid opcode
EDC3  AC 67 9A          LDY $9A67
EDC6  AD A5 AD          LDA $ADA5
EDC9  A1 A8             LDA ($A8,X)
EDCB  EE A1 AD          INC $ADA1
EDCE  60                RTS 
EDCF  84 20             STY $20  ; WNDLFT   ** UNSTABLE READ **
EDD1  A7                .BYTE $A7      ; invalid opcode
EDD2  B4 B5             LDY $B5,X
EDD4  A1 F2             LDA ($F2,X)
EDD6  AC A3 F7          LDY $F7A3
EDD9  A5 AE             LDA $AE
EDDB  60                RTS 
EDDC  8C 20 AC          STY $AC20
EDDF  A5 A4             LDA $A4
EDE1  E6 B5             INC $B5
EDE3  B2                .BYTE $B2      ; invalid opcode
EDE4  60                RTS 
EDE5  A6 B5             LDX $B5
EDE7  B2                .BYTE $B2      ; invalid opcode
EDE8  EE A7 A3          INC $A3A7
EDEB  E5 B6             SBC $B6
EDED  A1 B3             LDA ($B3,X)
EDEF  E4 A1             CPX $A1
EDF1  A7                .BYTE $A7      ; invalid opcode
EDF2  AC 72 7E          LDY $7E72
EDF5  92                .BYTE $92      ; invalid opcode
EDF6  22                .BYTE $22      ; invalid opcode
EDF7  20 00 60          JSR $6000
EDFA  03                .BYTE $03      ; invalid opcode
EDFB  BF                .BYTE $BF      ; invalid opcode
EDFC  60                RTS 
EDFD  03                .BYTE $03      ; invalid opcode
EDFE  BF                .BYTE $BF      ; invalid opcode
EDFF  17                .BYTE $17      ; invalid opcode
EE00  20 B1 E7          JSR $E7B1
EE03  E8                INX 
EE04  E8                INX 
EE05  B5 4F             LDA $4F,X  ; RNDH
EE07  85 DA             STA $DA
EE09  B5 77             LDA $77,X
EE0B  85 DB             STA $DB
EE0D  B4 4E             LDY $4E,X  ; RNDL
EE0F  98                TYA 
EE10  D5 76             CMP $76,X
EE12  B0 09             BCS $EE1D
EE14  B1 DA             LDA ($DA),Y
EE16  20 ED FD          JSR $FDED  ; COUT
EE19  C0 4C             CPY #$4C   ** UNSTABLE READ **
EE1B  0F                .BYTE $0F      ; invalid opcode
EE1C  E6 A9             INC $A9
EE1E  FF                .BYTE $FF      ; invalid opcode
EE1F  85 D5             STA $D5
EE21  60                RTS 
EE22  E8                INX 
EE23  A9 00             LDA #$00
EE25  95 78             STA $78,X
EE27  95 A0             STA $A0,X
EE29  B5 77             LDA $77,X
EE2B  38                SEC 
EE2C  F5 4F             SBC $4F,X  ; RNDH
EE2E  95 50             STA $50,X
EE30  4C 23 E8          JMP $E823
EE33  FF                .BYTE $FF      ; invalid opcode
EE34  20 15 E7          JSR $E715
EE37  A5 CF             LDA $CF
EE39  D0 28             BNE $EE63
EE3B  A5 CE             LDA $CE
EE3D  60                RTS 
EE3E  20 34 EE          JSR $EE34
EE41  A4 C8             LDY $C8
EE43  C1 30             CMP ($30,X)
EE45  B0 21             BCS $EE68
EE47  C0 28             CPY #$28   ** UNSTABLE READ **
EE49  B0 1D             BCS $EE68
EE4B  4C 00 F8          JMP $F800  ; PLOT
EE4E  20 34 EE          JSR $EE34
EE51  4C 64 F8          JMP $F864
EE54  46 F8             LSR $F8
EE56  60                RTS 
EE57  20 B3 F3          JSR $F3B3
EE5A  C9 18             CMP #$18
EE5C  B0 02             BCS $EE60
EE5E  85 25             STA $25  ; CV
EE60  4C 22 FC          JMP $FC22  ; VTAB
EE63  A0 77             LDY #$77
EE65  4C E0 E3          JMP $E3E0
EE68  A0 7B             LDY #$7B
EE6A  D0 F9             BNE $EE65
EE6C  20 54 E2          JSR $E254
EE6F  A5 D2             LDA $D2
EE71  D0 07             BNE $EE7A
EE73  A5 DB             LDA $DB   ** UNSTABLE READ **
EE75  D0 03             BNE $EE7A
EE77  4C 7E E7          JMP $E77E
EE7A  06 CE             ASL $CE
EE7C  26 CF             ROL $CF
EE7E  26 E6             ROL $E6
EE80  26 E7             ROL $E7
EE82  A5 E6             LDA $E6
EE84  C5 DA             CMP $DA
EE86  A5 E7             LDA $E7
EE88  E5 DB             SBC $DB
EE8A  90 02             BCC $EE8E
EE8C  85 E7             STA $E7
EE8E  A5 E6             LDA $E6
EE90  E5 DA             SBC $DA
EE92  85 E6             STA $E6
EE94  E6 CE             INC $CE
EE96  88                DEY 
EE97  D0 E1             BNE $EE7A
EE99  60                RTS 
EE9A  FF                .BYTE $FF      ; invalid opcode
EE9B  FF                .BYTE $FF      ; invalid opcode
EE9C  F7                .BYTE $F7      ; invalid opcode
EE9D  FF                .BYTE $FF      ; invalid opcode
EE9E  FF                .BYTE $FF      ; invalid opcode
EE9F  F7                .BYTE $F7      ; invalid opcode
EEA0  20 15 E7          JSR $E715
EEA3  6C C6 00          JMP ($00C6)
EEA6  20 34 EE          JSR $EE34
EEA9  C5 C0             CMP $C0   ** UNSTABLE READ **
EEAB  90 B3             BCC $EE60
EEAD  85 2C             STA $2C  ; H2   ** UNSTABLE READ **
EEAF  60                RTS 
EEB0  20 34 EE          JSR $EE34
EEB3  C9 30             CMP #$30
EEB5  B0 B1             BCS $EE68
EEB7  A4 C8             LDY $C8
EEB9  4C 19 F8          JMP $F819  ; HLINE
EEBC  20 34 EE          JSR $EE34
EEBF  C5 C0             CMP $C0
EEC1  90 A5             BCC $EE68
EEC3  85 2D             STA $2D  ; V2
EEC5  60                RTS 
EEC6  20 34 EE          JSR $EE34
EEC9  C9 20             CMP #$20
EECB  B0 9B             BCS $EE68
EECD  A8                TAY 
EECE  A5 C8             LDA $C8
EED0  4C 28 F8          JMP $F828  ; VLINE
EED3  98                TYA 
EED4  AA                TAX 
EED5  A0 6E             LDY #$6E
EED7  20 C4 E3          JSR $E3C4
EEDA  8A                TXA 
EEDB  A8                TAY 
EEDC  20 C4 E3          JSR $E3C4
EEDF  A0 72             LDY #$72
EEE1  4C 61 F1          JMP $F161
EEE4  20 3F F2          JSR $F23F
EEE7  06 CE             ASL $CE
EEE9  26 CF             ROL $CF
EEEB  30 FA             BMI $EEE7
EEED  B0 DC             BCS $EECB
EEEF  D0 04             BNE $EEF5
EEF1  C5 C6             CMP $C6
EEF3  B0 D6             BCS $EECB
EEF5  60                RTS 
EEF6  20 15 E7          JSR $E715
EEF9  B1 CE             LDA ($CE),Y
EEFB  94 9F             STY $9F,X
EEFD  4C 08 E7          JMP $E708
EF00  20 34 EE          JSR $EE34
EF03  A5 CE             LDA $CE
EF05  85 C0             STA $C0
EF07  60                RTS 
EF08  20 15 E7          JSR $E715
EF0B  A5 C8             LDA $C8
EF0D  91 C6             STA ($C6),Y
EF0F  60                RTS 
EF10  20 6C E6          JSR $E66C
EF13  A5 CE             LDA $CE
EF15  85 E6             STA $E6
EF17  A5 C7             LDA $C7
EF19  85 E7             STA $E7
EF1B  4C 44 E2          JMP $E244
EF1E  20 E4 E6          JSR $E6E4
EF21  4C 34 E1          JMP $E134
EF24  20 E4 E6          JSR $E6E4
EF27  B4 70             LDY $70,X
EF29  B5 50             LDA $50,X
EF2B  61 FE             ADC ($FE,X)
EF2D  B0 01             BCS $EF30
EF2F  88                DEY 
EF30  85 D2             STA $D2
EF32  84 D3             STY $D3
EF34  18                CLC 
EF35  65 CE             ADC $CE
EF37  95 50             STA $50,X
EF39  98                TYA 
EF3A  65 C7             ADC $C7
EF3C  95 78             STA $78,X
EF3E  A0 00             LDY #$00
EF40  B5 50             LDA $50,X
EF42  D1 DA             CMP ($DA),Y
EF44  C0 B5             CPY #$B5
EF46  78                SEI 
EF47  F1 D2             SBC ($D2),Y
EF49  B0 80             BCS $EECB
EF4B  4C 23 E8          JMP $E823   ** UNSTABLE READ **
EF4E  20 15 E7          JSR $E715
EF51  A5 4E             LDA $4E  ; RNDL
EF53  20 08 E7          JSR $E708
EF56  A5 47             LDA $47  ; YREG
EF58  D0 04             BNE $EF5E
EF5A  C5 46             CMP $46  ; XREG
EF5C  69 00             ADC #$00
EF5E  21 77             AND ($77,X)
EF60  85 4F             STA $4F  ; RNDH
EF62  95 A0             STA $A0,X
EF64  A0 11             LDY #$11
EF66  A5 47             LDA $47  ; YREG
EF68  02                .BYTE $02      ; invalid opcode
EF69  10 69             BPL $EFD4
EF6B  40                RTI 
EF6C  0A                ASL A
EF6D  26 46             ROL $46  ; XREG
EF6F  26 47             ROL $47  ; YREG
EF71  80                .BYTE $80      ; invalid opcode
EF72  D0 F2             BNE $EF66
EF74  A5 CE             LDA $CE
EF76  20 08 E7          JSR $E708
EF79  A5 CF             LDA $CF
EF7B  95 A0             STA $A0,X
EF7D  4C 7A E2          JMP $E27A
EF80  20 15 E7          JSR $E715
EF83  A4 CE             LDY $CE
EF85  C4 4A             CPY $4A
EF87  A5 CF             LDA $CF   ** UNSTABLE READ **
EF89  E5 43             SBC $43  ; A4H
EF8B  90 1E             BCC $EFAB
EF8D  84 44             STY $44  ; A5L
EF8F  A5 CF             LDA $CF   ** UNSTABLE READ **
EF91  85 4D             STA $4D
EF93  4C A5 E5          JMP $E5A5
EF96  20 15 E7          JSR $E715
EF99  A4 CE             LDY $CE
EF9B  C4 44             CPY $44  ; A5L
EF9D  A5 CF             LDA $CF
EF9F  E5 45             SBC $45  ; ACC
EFA1  B0 08             BCS $EFAB   ** UNSTABLE READ **
EFA3  84 4A             STY $4A
EFA5  A5 C7             LDA $C7   ** UNSTABLE READ **
EFA7  85 43             STA $43  ; A4H
EFA9  90 E0             BCC $EF8B
EFAB  4C C3 EE          JMP $EEC3
EFAE  FF                .BYTE $FF      ; invalid opcode
EFAF  FF                .BYTE $FF      ; invalid opcode
EFB0  FF                .BYTE $FF      ; invalid opcode
EFB1  FF                .BYTE $FF      ; invalid opcode
EFB2  FF                .BYTE $FF      ; invalid opcode
EFB3  F7                .BYTE $F7      ; invalid opcode
EFB4  FF                .BYTE $FF      ; invalid opcode
EFB5  F7                .BYTE $F7      ; invalid opcode
EFB6  20 71 E1          JSR $E171
EFB9  44                .BYTE $44      ; invalid opcode
EFBA  BF                .BYTE $BF      ; invalid opcode
EFBB  EF                .BYTE $EF      ; invalid opcode
EFBC  20 03 E6          JSR $E603
EFBF  A1 FF             LDA ($FF,X)   ** UNSTABLE READ **
EFC1  85 C0             STA $C0
EFC3  A9 80             LDA #$80
EFC5  8D 00 02          STA $0200
EFC8  60                RTS 
EFC9  20 36 E7          JSR $E736
EFCC  E8                INX 
EFCD  20 36 E7          JSR $E736
EFD0  B5 50             LDA $50,X
EFD2  60                RTS 
EFD3  A9 00             LDA #$00
EFD5  85 4A             STA $4A
EFD7  85 4C             STA $4C
EFD9  A9 08             LDA #$08
EFDB  85 4B             STA $4B
EFDD  A9 10             LDA #$10
EFDF  85 4D             STA $4D
EFE1  44                .BYTE $44      ; invalid opcode
EFE2  AD E5 D5          LDA $D5E5
EFE5  78                SEI 
EFE6  D0 01             BNE $EFE9
EFE8  10 44             BPL $F02E
EFEA  02                .BYTE $02      ; invalid opcode
EFEB  E1 20             SBC ($20,X)
EFED  B7                .BYTE $B7      ; invalid opcode
EFEE  E5 4C             SBC $4C
EFF0  36 E8             ROL $E8,X
EFF2  20 B7 E5          JSR $E5B7
EFF5  4C 53 E8          JMP $E853
EFF8  E0 80             CPX #$80
EFFA  D0 01             BNE $EFFD
EFFC  80                .BYTE $80      ; invalid opcode
EFFD  44                .BYTE $44      ; invalid opcode
EFFE  04                .BYTE $04      ; invalid opcode
EFFF  1A                .BYTE $1A      ; invalid opcode
F000  A0 00             LDY #$00
F002  84 A0             STY $A0
F004  84 4A             STY $4A
F006  84 4C             STY $4C
F008  A9 08             LDA #$08
F00A  85 4B             STA $4B
F00C  85 4D             STA $4D
F00E  E6 4D             INC $4D
F010  B1 4C             LDA ($4C),Y
F012  49 FF             EOR #$FF
F014  91 4C             STA ($4C),Y
F016  D1 4C             CMP ($4C),Y
F018  D0 08             BNE $F022
F01A  49 FF             EOR #$FF
F01C  91 4C             STA ($4C),Y
F01E  D1 4C             CMP ($4C),Y
F020  F0 EC             BEQ $F00E
F022  4C AD E5          JMP $E5AD
F025  4C 79 F1          JMP $F179
F028  20 32 F0          JSR $F032
F02B  4C BE E8          JMP $E8BE
F02E  A6 E0             LDX $E0
F030  A5 E1             LDA $E1
F032  AC 00 C0          LDY $C000  ; KBD
F035  C0 83             CPY #$83
F037  D0 EC             BNE $F025
F039  2C 10 C0          BIT $C010  ; KBDSTRB
F03C  86 50             STX $50
F03E  85 51             STA $51
F040  A5 DC             LDA $DC
F042  85 78             STA $78
F044  A5 DD             LDA $DD
F046  85 79             STA $79
F048  4C C3 E8          JMP $E8C3
F04B  FF                .BYTE $FF      ; invalid opcode
F04C  FF                .BYTE $FF      ; invalid opcode
F04D  20 15 E7          JSR $E715
F050  86 D8             STX $D8
F052  A2 FE             LDX #$FE
F054  38                SEC 
F055  B5 D0             LDA $D0,X
F057  95 E6             STA $E6,X
F059  B5 4E             LDA $4E,X  ; RNDL
F05B  F5 D0             SBC $D0,X
F05D  95 DC             STA $DC,X
F05F  E8                INX 
F060  D0 F3             BNE $F055
F062  90 4B             BCC $F0AF
F064  CA                DEX 
F065  B5 CB             LDA $CB,X
F067  95 E7             STA $E7,X
F069  F5 DB             SBC $DB,X
F06B  95 E5             STA $E5,X
F06D  E8                INX 
F06E  F0 F5             BEQ $F065
F070  90 0A             BCC $F07C
F072  A5 CC             LDA $CC
F074  C5 E4             CMP $E4
F076  A5 CD             LDA $CD
F078  E5 E5             SBC $E5
F07A  90 13             BCC $F08F
F07C  4C 6B E3          JMP $E36B
F07F  B1 E6             LDA ($E6),Y
F081  91 E4             STA ($E4),Y
F083  E6 E4             INC $E4
F085  D0 02             BNE $F089
F087  E6 E5 E6 E6 D0    .ASC "feffP"
F08C  02                .BYTE $02      ; invalid opcode
F08D  E6 E7             INC $E7
F08F  A5 E6             LDA $E6
F091  C5 4C             CMP $4C
F093  A5 E7             LDA $E7
F095  E5 4D             SBC $4D
F097  90 E6             BCC $F07F
F099  A2 FE             LDX #$FE
F09B  B5 E6             LDA $E6,X
F09D  95 4E             STA $4E,X  ; RNDL
F09F  B5 CC             LDA $CC,X
F0A1  F5 DC             SBC $DC,X
F0A3  95 CC             STA $CC,X
F0A5  E8                INX 
F0A6  D0 F3             BNE $F09B
F0A8  A6 D8             LDX $D8
F0AA  60                RTS 
F0AB  B1 4C             LDA ($4C),Y
F0AD  91 CE             STA ($CE),Y
F0AF  A5 CE             LDA $CE
F0B1  D0 02             BNE $F0B5
F0B3  C6 CF C6 CE A5 4C .ASC "FOFN%LP"
F0BA  02                .BYTE $02      ; invalid opcode
F0BB  C6 4D             DEC $4D
F0BD  C6 4C             DEC $4C
F0BF  C5 CA             CMP $CA
F0C1  A5 4D             LDA $4D
F0C3  E5 CB             SBC $CB
F0C5  90 E4             BCC $F0AB
F0C7  B0 D0             BCS $F099
F0C9  20 15 E7          JSR $E715
F0CC  A4 CE             LDY $CE
F0CE  C0 CA             CPY #$CA
F0D0  A5 CF             LDA $CF
F0D2  E5 CB             SBC $CB
F0D4  B0 A6             BCS $F07C
F0D6  84 4A             STY $4A
F0D8  A5 CF             LDA $CF
F0DA  85 4B             STA $4B
F0DC  4C B7 E5          JMP $E5B7
F0DF  86 D8             STX $D8
F0E1  20 1E F1          JSR $F11E
F0E4  20 FD FE          JSR $FEFD  ; READ
F0E7  A2 FF             LDX #$FF
F0E9  38                SEC 
F0EA  B5 4D             LDA $4D,X
F0EC  F5 CF             SBC $CF,X
F0EE  95 DB             STA $DB,X
F0F0  E8                INX 
F0F1  F0 F7             BEQ $F0EA
F0F3  90 87             BCC $F07C
F0F5  A5 CC             LDA $CC
F0F7  C5 DA             CMP $DA
F0F9  A5 CD             LDA $CD
F0FB  E5 DB             SBC $DB
F0FD  B0 D5             BCS $F0D4
F0FF  A5 CE             LDA $CE
F101  D0 04             BNE $F107
F103  A5 CF             LDA $CF
F105  F0 11             BEQ $F118
F107  A5 DA             LDA $DA
F109  85 CA             STA $CA
F10B  A5 DB             LDA $DB
F10D  85 CB             STA $CB
F10F  20 2C F1          JSR $F12C
F112  20 FD FE          JSR $FEFD  ; READ
F115  A6 D8             LDX $D8
F117  60                RTS 
F118  20 3A FF          JSR $FF3A  ; BELL
F11B  4C 15 F1          JMP $F115
F11E  A0 CE             LDY #$CE
F120  84 3C             STY $3C  ; A1L
F122  C0 84             CPY #$84
F124  3E A0 00          ROL $00A0,X
F127  84 3D             STY $3D  ; A1H
F129  84 3F             STY $3F  ; A2H
F12B  60                RTS 
F12C  B5 CA             LDA $CA,X
F12E  95 3C             STA $3C,X  ; A1L
F130  B4 4C             LDY $4C,X
F132  94 3E             STY $3E,X  ; A2L
F134  CA                DEX 
F135  10 F5             BPL $F12C
F137  A5 3E             LDA $3E  ; A2L
F139  D0 02             BNE $F13D
F13B  C6 3F             DEC $3F  ; A2H
F13D  C6 3E             DEC $3E  ; A2L
F13F  60                RTS 
F140  86 D8             STX $D8
F142  38                SEC 
F143  A2 FF             LDX #$FF
F145  B5 4D             LDA $4D,X
F147  F5 CB             SBC $CB,X
F149  95 CF             STA $CF,X
F14B  E8                INX 
F14C  F0 F7             BEQ $F145
F14E  20 1E F1          JSR $F11E
F151  20 CD FE          JSR $FECD  ; WRITE
F154  A2 01             LDX #$01
F156  20 2C F1          JSR $F12C
F159  A9 1A             LDA #$1A
F15B  20 CF FE          JSR $FECF
F15E  A6 D8             LDX $D8
F160  60                RTS 
F161  20 C4 E3          JSR $E3C4
F164  4C 3A FF          JMP $FF3A  ; BELL
F167  A5 FC             LDA $FC
F169  D0 03             BNE $F16E
F16B  4C A5 E8          JMP $E8A5
F16E  C6 FC             DEC $FC
F170  60                RTS 
F171  A9 FF             LDA #$FF
F173  85 A0             STA $A0
F175  60                RTS 
F176  46 A0             LSR $A0
F178  60                RTS 
F179  24 A0             BIT $A0
F17B  10 19             BPL $F196
F17D  A9 A3             LDA #$A3
F17F  20 ED FD          JSR $FDED  ; COUT
F182  A0 01             LDY #$01
F184  B1 DC             LDA ($DC),Y
F186  AA                TAX 
F187  C8                INY 
F188  B1 DC             LDA ($DC),Y
F18A  20 1B E5          JSR $E51B
F18D  A9 A0             LDA #$A0
F18F  4C ED FD          JMP $FDED  ; COUT
F192  A5 DC             LDA $DC
F194  A4 DD             LDY $DD
F196  60                RTS 
F197  C1 00             CMP ($00,X)
F199  7F                .BYTE $7F      ; invalid opcode
F19A  D1 CC C7 CF CE C5 .ASC "QLGONE"
F1A0  9A                TXS 
F1A1  98                TYA 
F1A2  8D 96 95          STA $9596
F1A5  93                .BYTE $93      ; invalid opcode
F1A6  BF                .BYTE $BF      ; invalid opcode
F1A7  B2                .BYTE $B2      ; invalid opcode
F1A8  32                .BYTE $32      ; invalid opcode
F1A9  12                .BYTE $12      ; invalid opcode
F1AA  0F                .BYTE $0F      ; invalid opcode
F1AB  BC B0 AC          LDY $ACB0,X
F1AE  BE 35 0C          LDX $0C35,Y
F1B1  61 30             ADC ($30,X)
F1B3  10 0B             BPL $F1C0
F1B5  DD FB A0          CMP $A0FB,X
F1B8  00                BRK 
F1B9  20 C7 E7          JSR $E7C7
F1BC  A9 A0             LDA #$A0
F1BE  4C ED FD          JMP $FDED  ; COUT
F1C1  00                BRK 
F1C2  00                BRK 
F1C3  00                BRK 
F1C4  00                BRK 
F1C5  00                BRK 
F1C6  00                BRK 
F1C7  00                BRK 
F1C8  00                BRK 
F1C9  A4 4A             LDY $4A
F1CB  A5 4B             LDA $4B
F1CD  48                PHA 
F1CE  C4 DA             CPY $DA
F1D0  E5 DB             SBC $DB
F1D2  B0 1C             BCS $F1F0
F1D4  68                PLA 
F1D5  84 D0             STY $D0
F1D7  85 D1             STA $D1
F1D9  A0 FF             LDY #$FF
F1DB  C8                INY 
F1DC  B1 D0             LDA ($D0),Y
F1DE  30 FB             BMI $F1DB
F1E0  C9 40             CMP #$40
F1E2  F0 F7             BEQ $F1DB
F1E4  C8                INY 
F1E5  C0 B1             CPY #$B1   ** UNSTABLE READ **
F1E7  D0 48             BNE $F231
F1E9  88                DEY 
F1EA  B1 D0             LDA ($D0),Y
F1EC  A8                TAY 
F1ED  68                PLA 
F1EE  D0 DD             BNE $F1CD
F1F0  68                PLA 
F1F1  A0 00             LDY #$00
F1F3  B1 D0             LDA ($D0),Y
F1F5  30 05             BMI $F1FC
F1F7  4A                LSR A
F1F8  F0 08             BEQ $F202
F1FA  A9 A4             LDA #$A4
F1FC  20 ED FD          JSR $FDED  ; COUT
F1FF  C8                INY 
F200  D0 F1             BNE $F1F3
F202  A9 BD             LDA #$BD
F204  4C ED FD          JMP $FDED  ; COUT
F207  91 DA             STA ($DA),Y   ** UNSTABLE READ **
F209  E0 B5             CPX #$B5   ** UNSTABLE READ **
F20B  9F                .BYTE $9F      ; invalid opcode
F20C  F0 30             BEQ $F23E
F20E  4C D5 F3          JMP $F3D5
F211  A0 30             LDY #$30
F213  07                .BYTE $07      ; invalid opcode
F214  A5 DC             LDA $DC
F216  A4 DD             LDY $DD
F218  20 7D F1          JSR $F17D
F21B  20 C9 F1          JSR $F1C9
F21E  A6 D8             LDX $D8
F220  4C B7 F1          JMP $F1B7
F223  E8                INX 
F224  E8                INX 
F225  B5 9F             LDA $9F,X
F227  F0 1F             BEQ $F248
F229  4C E0 F3          JMP $F3E0
F22C  30 07             BMI $F235
F22E  A5 DC             LDA $DC
F230  A4 DD             LDY $DD
F232  20 7D F1          JSR $F17D
F235  20 C9 F1          JSR $F1C9
F238  A6 D0             LDX $D0   ** UNSTABLE READ **
F23A  4C 09 F4          JMP $F409
F23D  E8                INX 
F23E  60                RTS 
F23F  20 15 E7          JSR $E715
F242  E6 CE             INC $CE
F244  D0 02             BNE $F248
F246  E6 CF             INC $CF
F248  60                RTS 
F249  20 5B F2          JSR $F25B
F24C  D0 15             BNE $F263
F24E  20 53 F2          JSR $F253
F251  D0 10             BNE $F263
F253  20 82 E7          JSR $E782
F256  20 6F E7          JSR $E76F
F259  50 03             BVC $F25E
F25B  20 82 E7          JSR $E782
F25E  20 59 E7          JSR $E759
F261  56 50             LSR $50,X
F263  4C 36 E7          JMP $E736
F266  20 C9 EF          JSR $EFC9
F269  15 4F             ORA $4F,X  ; RNDH
F26B  10 05             BPL $F272
F26D  20 C9 EF          JSR $EFC9
F270  35 4F             AND $4F,X  ; RNDH
F272  95 50             STA $50,X
F274  10 ED             BPL $F263
F276  4C C9 EF          JMP $EFC9
F279  20 15 E7          JSR $E715
F27C  A4 F3             LDY $F3   ** UNSTABLE READ **
F27E  A5 CE             LDA $CE
F280  99 5F 01          STA $015F,Y
F283  A5 CF             LDA $CF
F285  4C 66 E9          JMP $E966
F288  99 50 01          STA $0150,Y
F28B  88                DEY 
F28C  30 51             BMI $F2DF
F28E  B9 40 01          LDA $0140,Y
F291  D5 50             CMP $50,X
F293  D0 F6             BNE $F28B
F295  B9 50 01          LDA $0150,Y
F298  D5 78 D0 EF C6 FB .ASC "UxPoF{9A"
F2A0  01 99             ORA ($99,X)
F2A2  40                RTI 
F2A3  01 B9             ORA ($B9,X)
F2A5  51 01             EOR ($01),Y
F2A7  99 50 01          STA $0150,Y
F2AA  B9 C1 01          LDA $01C1,Y
F2AD  99 C0 01          STA $01C0,Y
F2B0  B9 D1 01          LDA $01D1,Y
F2B3  91 D0             STA ($D0),Y   ** UNSTABLE READ **
F2B5  01 B9             ORA ($B9,X)
F2B7  61 01             ADC ($01,X)
F2B9  99 60 01          STA $0160,Y
F2BC  B9 71 01          LDA $0171,Y
F2BF  99 70 01          STA $0170,Y
F2C2  B9 81 01          LDA $0181,Y
F2C5  99 80 01          STA $0180,Y
F2C8  B9 91 01          LDA $0191,Y
F2CB  99 90 01          STA $0190,Y
F2CE  B9 A1 01          LDA $01A1,Y
F2D1  99 A0 01          STA $01A0,Y
F2D4  B9 A1 01          LDA $01A1,Y
F2D7  99 A0 01          STA $01A0,Y
F2DA  C8                INY 
F2DB  C4 FB             CPY $FB
F2DD  90 BF             BCC $F29E
F2DF  60                RTS 
F2E0  E8                INX 
F2E1  A9 00             LDA #$00
F2E3  48                PHA 
F2E4  B5 50             LDA $50,X
F2E6  38                SEC 
F2E7  E9 03             SBC #$03
F2E9  85 CE             STA $CE
F2EB  B5 78             LDA $78,X
F2ED  E9 00             SBC #$00
F2EF  85 CF             STA $CF
F2F1  68                PLA 
F2F2  A0 00             LDY #$00
F2F4  91 CE             STA ($CE),Y
F2F6  E8                INX 
F2F7  60                RTS 
F2F8  C9 85             CMP #$85
F2FA  B0 03             BCS $F2FF
F2FC  4C C0 E4          JMP $E4C0
F2FF  A0 02             LDY #$02
F301  4C 48 E4          JMP $E448
F304  E8                INX 
F305  A9 01             LDA #$01
F307  D0 DA             BNE $F2E3
F309  E8                INX 
F30A  A5 78             LDA $78
F30C  85 DC             STA $DC
F30E  A5 79             LDA $79
F310  85 DD             STA $DD
F312  A5 50             LDA $50
F314  A4 51             LDY $51
F316  4C 75 E8          JMP $E875
F319  A9 01             LDA #$01
F31B  D0 C6             BNE $F2E3
F31D  B5 50             LDA $50,X
F31F  D5 78             CMP $78,X
F321  90 03             BCC $F326
F323  4C 68 EE          JMP $EE68
F326  A8                TAY 
F327  B5 51             LDA $51,X
F329  85 CE             STA $CE
F32B  B5 79             LDA $79,X
F32D  85 CF             STA $CF
F32F  B1 CE             LDA ($CE),Y
F331  A0 00             LDY #$00
F333  E8                INX 
F334  E8                INX 
F335  20 08 E7          JSR $E708
F338  4C 04 F4          JMP $F404
F33B  20 34 EE          JSR $EE34
F33E  86 D8             STX $D8
F340  29 03             AND #$03
F342  AA                TAX 
F343  20 1E FB          JSR $FB1E  ; PREAD
F346  A6 D8             LDX $D8
F348  98                TYA 
F349  A0 00             LDY #$00
F34B  20 08 E7          JSR $E708
F34E  94 A0             STY $A0,X
F350  60                RTS 
F351  20 75 FD          JSR $FD75
F354  8A                TXA 
F355  48                PHA 
F356  BD 00 02          LDA $0200,X
F359  C9 83             CMP #$83
F35B  D0 03             BNE $F360
F35D  4C 03 E0          JMP $E003
F360  CA                DEX 
F361  10 F3             BPL $F356
F363  68                PLA 
F364  AA                TAX 
F365  60                RTS 
F366  20 80 E2          JSR $E280
F369  98                TYA 
F36A  AA                TAX 
F36B  20 54 F3          JSR $F354
F36E  8A                TXA 
F36F  A8                TAY 
F370  60                RTS 
F371  20 15 E7          JSR $E715
F374  A5 CF             LDA $CF
F376  10 08             BPL $F380
F378  98                TYA 
F379  CA                DEX 
F37A  20 08 E7          JSR $E708
F37D  94 A0             STY $A0,X
F37F  60                RTS 
F380  85 D1             STA $D1
F382  A5 CE             LDA $CE
F384  85 D0             STA $D0
F386  20 15 E7          JSR $E715
F389  A5 CE             LDA $CE
F38B  85 D2             STA $D2
F38D  A5 CF             LDA $CF
F38F  85 D3             STA $D3
F391  A9 01             LDA #$01
F393  20 08 E7          JSR $E708
F396  94 A0             STY $A0,X
F398  A5 D0             LDA $D0
F39A  D0 04             BNE $F3A0
F39C  C6 D1             DEC $D1
F39E  30 DF             BMI $F37F
F3A0  C6 D0             DEC $D0
F3A2  A5 D2             LDA $D2
F3A4  A0 00             LDY #$00
F3A6  20 08 E7          JSR $E708
F3A9  A5 D3             LDA $D3
F3AB  95 A0             STA $A0,X
F3AD  20 22 E2          JSR $E222
F3B0  4C 98 F3          JMP $F398
F3B3  20 34 EE          JSR $EE34
F3B6  18                CLC 
F3B7  69 FF             ADC #$FF
F3B9  60                RTS 
F3BA  20 B1 E7          JSR $E7B1
F3BD  46 D5             LSR $D5
F3BF  60                RTS 
F3C0  86 D9             STX $D9
F3C2  9A                TXS 
F3C3  20 2E F0          JSR $F02E
F3C6  4C 83 E8          JMP $E883
F3C9  20 34 EE          JSR $EE34
F3CC  86 D8             STX $D8
F3CE  20 95 FE          JSR $FE95
F3D1  A6 D8             LDX $D8
F3D3  60                RTS 
F3D4  FE 24 D9          INC $D924,X
F3D7  10 E0             BPL $F3B9
F3D9  86 D8             STX $D8
F3DB  24 A0             BIT $A0
F3DD  4C 12 F2          JMP $F212
F3E0  24 D9             BIT $D9
F3E2  10 D5             BPL $F3B9
F3E4  86 D8             STX $D8
F3E6  24 A0             BIT $A0
F3E8  4C 2C F2          JMP $F22C
F3EB  A0 00             LDY #$00
F3ED  4C FF E6          JMP $E6FF
F3F0  A8                TAY 
F3F1  20 8E FD          JSR $FD8E  ; CROUT
F3F4  98                TYA 
F3F5  38                SEC 
F3F6  E5 21             SBC $21  ; WNDWDTH
F3F8  B0 F6             BCS $F3F0
F3FA  84 24             STY $24  ; CH
F3FC  60                RTS 
F3FD  00                BRK 
F3FE  00                BRK 
F3FF  00                BRK 
F400  FF                .BYTE $FF      ; invalid opcode
F401  FF                .BYTE $FF      ; invalid opcode
F402  FF                .BYTE $FF      ; invalid opcode
F403  FF                .BYTE $FF      ; invalid opcode
F404  94 A0             STY $A0,X
F406  4C 23 E8          JMP $E823
F409  A0 00             LDY #$00
F40B  F0 04             BEQ $F411
F40D  20 ED FD          JSR $FDED  ; COUT
F410  C8                INY 
F411  B1 DA             LDA ($DA),Y
F413  30 F8             BMI $F40D
F415  A9 FF             LDA #$FF
F417  85 D5             STA $D5
F419  60                RTS 
F41A  20 34 EE          JSR $EE34
F41D  86 D8             STX $D8
F41F  20 8B FE          JSR $FE8B
F422  A6 D8             LDX $D8
F424  60                RTS 
F425  18                CLC 
F426  A2 02             LDX #$02
F428  B5 F9             LDA $F9,X
F42A  75 F5             ADC $F5,X
F42C  95 F9             STA $F9,X
F42E  CA                DEX 
F42F  10 F7             BPL $F428
F431  60                RTS 
F432  06 F3             ASL $F3
F434  20 37 F4          JSR $F437
F437  24 F9             BIT $F9
F439  10 05             BPL $F440
F43B  20 A4 F4          JSR $F4A4
F43E  E6 F3             INC $F3
F440  38                SEC 
F441  A2 04             LDX #$04
F443  94 FB             STY $FB,X
F445  B5 F7             LDA $F7,X
F447  B4 F3             LDY $F3,X
F449  94 F7             STY $F7,X
F44B  95 F3             STA $F3,X
F44D  CA                DEX 
F44E  D0 F3             BNE $F443
F450  60                RTS 
F451  A9 8E             LDA #$8E
F453  85 F8             STA $F8
F455  A5 F9             LDA $F9
F457  C9 C0             CMP #$C0
F459  30 0C             BMI $F467
F45B  C6 F8             DEC $F8
F45D  06 FB             ASL $FB
F45F  26 FA             ROL $FA
F461  26 F9             ROL $F9
F463  A5 F8             LDA $F8
F465  D0 EE             BNE $F455
F467  60                RTS 
F468  20 A4 F4          JSR $F4A4
F46B  20 7B F4          JSR $F47B
F46E  A5 F4             LDA $F4
F470  C5 F8             CMP $F8
F472  D0 F7             BNE $F46B
F474  20 25 F4          JSR $F425
F477  50 EA             BVC $F463
F479  70 05             BVS $F480
F47B  90 C4             BCC $F441
F47D  A5 F9             LDA $F9
F47F  0A                ASL A
F480  E6 F8             INC $F8
F482  F0 75             BEQ $F4F9
F484  A2 FA             LDX #$FA
F486  76 FF             ROR $FF,X
F488  E8                INX 
F489  D0 FB             BNE $F486
F48B  60                RTS 
F48C  20 32 F4          JSR $F432
F48F  65 F8             ADC $F8
F491  20 E2 F4          JSR $F4E2
F494  18                CLC 
F495  20 84 F4          JSR $F484
F498  90 03             BCC $F49D
F49A  20 25 F4          JSR $F425
F49D  88                DEY 
F49E  10 F5             BPL $F495
F4A0  46 F3             LSR $F3
F4A2  90 BF             BCC $F463
F4A4  38                SEC 
F4A5  A2 03             LDX #$03
F4A7  A9 00             LDA #$00
F4A9  F5 F8             SBC $F8,X
F4AB  95 F8             STA $F8,X
F4AD  CA                DEX 
F4AE  D0 F7             BNE $F4A7
F4B0  F0 C5             BEQ $F477
F4B2  20 32 F4          JSR $F432
F4B5  E5 F8             SBC $F8
F4B7  20 E2 F4          JSR $F4E2
F4BA  38                SEC 
F4BB  A2 02             LDX #$02
F4BD  B5 F5             LDA $F5,X
F4BF  F5 FC             SBC $FC,X
F4C1  48                PHA 
F4C2  CA                DEX 
F4C3  10 F8             BPL $F4BD
F4C5  A2 FD             LDX #$FD
F4C7  68                PLA 
F4C8  90 02             BCC $F4CC
F4CA  95 F8             STA $F8,X
F4CC  E8                INX 
F4CD  D0 F8             BNE $F4C7
F4CF  26 FB             ROL $FB
F4D1  26 FA             ROL $FA
F4D3  26 F9             ROL $F9
F4D5  06 F7             ASL $F7
F4D7  26 F6             ROL $F6
F4D9  26 F5             ROL $F5
F4DB  B0 1C             BCS $F4F9
F4DD  88                DEY 
F4DE  D0 DA             BNE $F4BA
F4E0  F0 BE             BEQ $F4A0
F4E2  86 FB             STX $FB
F4E4  86 FA             STX $FA
F4E6  86 F9             STX $F9
F4E8  B0 0D             BCS $F4F7
F4EA  30 04             BMI $F4F0
F4EC  68                PLA 
F4ED  68                PLA 
F4EE  90 B2             BCC $F4A2
F4F0  49 80             EOR #$80
F4F2  85 F8             STA $F8
F4F4  A0 17             LDY #$17
F4F6  60                RTS 
F4F7  10 F7             BPL $F4F0
F4F9  4C F5 03          JMP $03F5
F4FC  FF                .BYTE $FF      ; invalid opcode
F4FD  FF                .BYTE $FF      ; invalid opcode
F4FE  FF                .BYTE $FF      ; invalid opcode
F4FF  FF                .BYTE $FF      ; invalid opcode
F500  E9 81             SBC #$81
F502  4A                LSR A
F503  D0 14             BNE $F519
F505  A4 3F             LDY $3F  ; A2H
F507  A6 3E             LDX $3E  ; A2L
F509  D0 01             BNE $F50C
F50B  88                DEY 
F50C  CA                DEX 
F50D  8A                TXA 
F50E  18                CLC 
F50F  E5 3A             SBC $3A  ; PCL
F511  85 3E             STA $3E  ; A2L
F513  10 01             BPL $F516
F515  C8                INY 
F516  98                TYA 
F517  E5 3B             SBC $3B  ; PCH
F519  D0 6B             BNE $F586
F51B  A4 2F             LDY $2F
F51D  B9 3D 00          LDA $003D,Y
F520  91 3A             STA ($3A),Y  ; PCL
F522  88                DEY 
F523  10 F8             BPL $F51D
F525  20 1A FC          JSR $FC1A  ; UP
F528  20 1A FC          JSR $FC1A  ; UP
F52B  20 D0 F8          JSR $F8D0  ; INSTDSP
F52E  20 53 F9          JSR $F953
F531  84 3B             STY $3B  ; PCH
F533  85 3A             STA $3A  ; PCL
F535  4C 95 F5          JMP $F595
F538  20 BE FF          JSR $FFBE
F53B  A4 34             LDY $34  ; YSAV
F53D  20 A7 FF          JSR $FFA7  ; GETNUM
F540  84 34             STY $34  ; YSAV
F542  A0 17             LDY #$17
F544  88                DEY 
F545  30 4B             BMI $F592
F547  D9 CC FF          CMP $FFCC,Y
F54A  D0 F8             BNE $F544
F54C  C0 15             CPY #$15
F54E  D0 E8             BNE $F538
F550  A5 31             LDA $31  ; MODE
F552  A0 00             LDY #$00
F554  C6 34             DEC $34  ; YSAV
F556  20 00 FE          JSR $FE00
F559  4C 95 F5          JMP $F595
F55C  A5 3D             LDA $3D  ; A1H
F55E  20 8E F8          JSR $F88E
F561  AA                TAX 
F562  BD 00 FA          LDA $FA00,X
F565  C5 42             CMP $42  ; A4L
F567  D0 13             BNE $F57C
F569  BD C0 F9 C5 43 D0 .ASC "=@yECP"
F56F  0C                .BYTE $0C      ; invalid opcode
F570  A5 44             LDA $44  ; A5L
F572  A4 2E             LDY $2E  ; MASK
F574  C0 9D             CPY #$9D
F576  F0 88             BEQ $F500
F578  C5 2E             CMP $2E  ; MASK
F57A  F0 9F             BEQ $F51B
F57C  C6 3D             DEC $3D  ; A1H
F57E  D0 DC             BNE $F55C
F580  E6 44             INC $44  ; A5L
F582  C6 35             DEC $35  ; YSAV1
F584  F0 D6             BEQ $F55C
F586  A4 34             LDY $34  ; YSAV
F588  98                TYA 
F589  AA                TAX 
F58A  20 4A F9          JSR $F94A
F58D  A9 DE             LDA #$DE
F58F  20 ED FD          JSR $FDED  ; COUT
F592  20 3A FF          JSR $FF3A  ; BELL
F595  A9 A1             LDA #$A1
F597  85 33             STA $33  ; PROMPT
F599  20 67 FD          JSR $FD67  ; GETLNZ
F59C  20 C7 FF          JSR $FFC7  ; ZMODE
F59F  AD 00 02          LDA $0200
F5A2  C9 A0             CMP #$A0
F5A4  F0 13             BEQ $F5B9
F5A6  C8                INY 
F5A7  C9 A4             CMP #$A4
F5A9  F0 92             BEQ $F53D
F5AB  88                DEY 
F5AC  20 A7 FF          JSR $FFA7  ; GETNUM
F5AF  C9 93             CMP #$93
F5B1  D0 D5             BNE $F588
F5B3  8A                TXA 
F5B4  F0 D2             BEQ $F588
F5B6  20 78 FE          JSR $FE78
F5B9  A9 03             LDA #$03
F5BB  85 3D             STA $3D  ; A1H
F5BD  20 34 F6          JSR $F634
F5C0  0A                ASL A
F5C1  E9 BE             SBC #$BE
F5C3  C9 C2             CMP #$C2
F5C5  90 C1             BCC $F588
F5C7  0A                ASL A
F5C8  0A                ASL A
F5C9  A2 04             LDX #$04
F5CB  0A                ASL A
F5CC  26 42             ROL $42  ; A4L
F5CE  26 43             ROL $43  ; A4H
F5D0  CA                DEX 
F5D1  10 F8             BPL $F5CB
F5D3  C6 3D             DEC $3D  ; A1H
F5D5  F0 F4             BEQ $F5CB
F5D7  10 E4             BPL $F5BD
F5D9  A2 05             LDX #$05
F5DB  20 34 F6          JSR $F634
F5DE  84 34             STY $34  ; YSAV
F5E0  DD B4 F9          CMP $F9B4,X
F5E3  D0 13             BNE $F5F8
F5E5  20 34 F6          JSR $F634
F5E8  DD BA F9          CMP $F9BA,X
F5EB  F0 0D             BEQ $F5FA
F5ED  BD BA F9          LDA $F9BA,X
F5F0  F0 07             BEQ $F5F9
F5F2  C9 A4             CMP #$A4
F5F4  F0 03             BEQ $F5F9
F5F6  A4 34             LDY $34  ; YSAV
F5F8  18                CLC 
F5F9  88                DEY 
F5FA  26 44             ROL $44  ; A5L
F5FC  E0 03             CPX #$03
F5FE  D0 0D             BNE $F60D
F600  20 A7 FF          JSR $FFA7  ; GETNUM
F603  A5 3F             LDA $3F  ; A2H
F605  F0 01             BEQ $F608
F607  E8                INX 
F608  86 35             STX $35  ; YSAV1
F60A  A2 03             LDX #$03
F60C  88                DEY 
F60D  86 3D             STX $3D  ; A1H
F60F  CA                DEX 
F610  10 C9             BPL $F5DB
F612  A5 44             LDA $44  ; A5L
F614  0A                ASL A
F615  0A                ASL A
F616  05 35             ORA $35  ; YSAV1
F618  C9 20             CMP #$20
F61A  B0 06             BCS $F622
F61C  A6 35             LDX $35  ; YSAV1
F61E  F0 02             BEQ $F622
F620  09 80             ORA #$80
F622  85 44             STA $44  ; A5L
F624  84 34             STY $34  ; YSAV
F626  B9 00 02          LDA $0200,Y
F629  C9 BB             CMP #$BB
F62B  F0 04             BEQ $F631
F62D  C9 8D             CMP #$8D
F62F  D0 80             BNE $F5B1
F631  4C 5C F5          JMP $F55C
F634  B9 00 02          LDA $0200,Y
F637  C8                INY 
F638  C9 A0             CMP #$A0
F63A  F0 F8             BEQ $F634
F63C  60                RTS 
F63D  20 7D F4          JSR $F47D
F640  A5 F8             LDA $F8
F642  10 13             BPL $F657
F644  C9 8E             CMP #$8E
F646  D0 F5             BNE $F63D
F648  24 F9             BIT $F9
F64A  10 0A             BPL $F656
F64C  A5 FB             LDA $FB
F64E  F0 06             BEQ $F656
F650  E6 FA             INC $FA
F652  D0 02             BNE $F656
F654  E6 F9             INC $F9
F656  60                RTS 
F657  A9 00             LDA #$00
F659  85 F9             STA $F9
F65B  85 FA             STA $FA
F65D  60                RTS 
F65E  FF                .BYTE $FF      ; invalid opcode
F65F  FF                .BYTE $FF      ; invalid opcode
F660  FF                .BYTE $FF      ; invalid opcode
F661  FF                .BYTE $FF      ; invalid opcode
F662  FF                .BYTE $FF      ; invalid opcode
F663  FF                .BYTE $FF      ; invalid opcode
F664  FF                .BYTE $FF      ; invalid opcode
F665  FF                .BYTE $FF      ; invalid opcode
F666  4C 92 F5          JMP $F592
F669  84 58             STY $58
F66B  86 57             STX $57
F66D  85 56             STA $56
F66F  08                PHP 
F670  68                PLA 
F671  85 59             STA $59
F673  BA                TSX 
F674  E8                INX 
F675  E8                INX 
F676  BD 00 01          LDA $0100,X
F679  0A                ASL A
F67A  0A                ASL A
F67B  0A                ASL A
F67C  0A                ASL A
F67D  60                RTS 
F67E  A4 58             LDY $58
F680  A6 57             LDX $57
F682  A5 59             LDA $59
F684  48                PHA 
F685  A5 56             LDA $56
F687  28                PLP 
F688  60                RTS 
F689  20 4A FF          JSR $FF4A  ; SAVE
F68C  68                PLA 
F68D  85 1E             STA $1E
F68F  68                PLA 
F690  85 1F             STA $1F
F692  20 98 F6          JSR $F698
F695  4C 92 F6          JMP $F692
F698  E6 1E             INC $1E
F69A  D0 02             BNE $F69E
F69C  E6 1F             INC $1F
F69E  A9 F7             LDA #$F7
F6A0  48                PHA 
F6A1  A0 00             LDY #$00
F6A3  B1 1E             LDA ($1E),Y
F6A5  29 0F             AND #$0F
F6A7  0A                ASL A
F6A8  AA                TAX 
F6A9  4A                LSR A
F6AA  51 1E             EOR ($1E),Y
F6AC  F0 0B             BEQ $F6B9
F6AE  86 1D             STX $1D
F6B0  4A                LSR A
F6B1  4A                LSR A
F6B2  4A                LSR A
F6B3  A8                TAY 
F6B4  B9 E1 F6          LDA $F6E1,Y
F6B7  48                PHA 
F6B8  60                RTS 
F6B9  E6 1E             INC $1E
F6BB  D0 02             BNE $F6BF
F6BD  E6 1F             INC $1F
F6BF  BD E4 F6          LDA $F6E4,X
F6C2  48                PHA 
F6C3  A5 1D             LDA $1D
F6C5  4A                LSR A
F6C6  60                RTS 
F6C7  68                PLA 
F6C8  68                PLA 
F6C9  20 3F FF          JSR $FF3F  ; RESTORE
F6CC  6C 1E 00          JMP ($001E)
F6CF  B1 1E             LDA ($1E),Y
F6D1  95 01             STA $01,X
F6D3  88                DEY 
F6D4  B1 1E             LDA ($1E),Y
F6D6  95 00             STA $00,X
F6D8  98                TYA 
F6D9  38                SEC 
F6DA  65 1E             ADC $1E
F6DC  85 1E             STA $1E
F6DE  90 02             BCC $F6E2
F6E0  E6 1F             INC $1F
F6E2  60                RTS 
F6E3  02                .BYTE $02      ; invalid opcode
F6E4  F9 04 9D          SBC $9D04,Y
F6E7  0D 9E 25          ORA $259E
F6EA  AF                .BYTE $AF      ; invalid opcode
F6EB  16 B2             ASL $B2,X
F6ED  47                .BYTE $47      ; invalid opcode
F6EE  B9 51 C0          LDA $C051,Y  ; TXTSET
F6F1  2F                .BYTE $2F      ; invalid opcode
F6F2  C9 5B             CMP #$5B
F6F4  D2                .BYTE $D2      ; invalid opcode
F6F5  85 DD             STA $DD
F6F7  6E 05 33          ROR $3305
F6FA  E8                INX 
F6FB  70 93             BVS $F690
F6FD  1E E7 65          ASL $65E7,X
F700  E7                .BYTE $E7      ; invalid opcode
F701  E7                .BYTE $E7      ; invalid opcode
F702  E7                .BYTE $E7      ; invalid opcode
F703  10 CA             BPL $F6CF
F705  B5 00             LDA $00,X
F707  85 00             STA $00
F709  B5 01             LDA $01,X
F70B  85 01             STA $01
F70D  60                RTS 
F70E  A5 00             LDA $00
F710  95 00             STA $00,X
F712  A5 01             LDA $01
F714  95 01             STA $01,X
F716  60                RTS 
F717  A5 00             LDA $00
F719  81 00             STA ($00,X)
F71B  A0 00             LDY #$00
F71D  84 1D             STY $1D
F71F  F6 00             DEC $00,X
F721  D0 02             BNE $F725
F723  F6 01             DEC $01,X
F725  60                RTS 
F726  A1 00             LDA ($00,X)
F728  85 00             STA $00
F72A  A0 00             LDY #$00
F72C  84 01             STY $01
F72E  F0 ED             BEQ $F71D
F730  A0 00             LDY #$00
F732  F0 06             BEQ $F73A
F734  20 66 F7          JSR $F766
F737  A1 00             LDA ($00,X)
F739  A8                TAY 
F73A  20 66 F7          JSR $F766
F73D  A1 00             LDA ($00,X)
F73F  85 00             STA $00
F741  84 01             STY $01
F743  A0 00             LDY #$00
F745  84 1D             STY $1D
F747  60                RTS 
F748  20 26 F7          JSR $F726
F74B  A1 00             LDA ($00,X)
F74D  85 01             STA $01
F74F  4C 1F F7          JMP $F71F
F752  20 17 F7          JSR $F717
F755  A5 01             LDA $01
F757  81 00             STA ($00,X)
F759  4C 1F F7          JMP $F71F
F75C  20 66 F7          JSR $F766
F75F  A5 00             LDA $00
F761  81 00             STA ($00,X)
F763  4C 43 F7          JMP $F743
F766  B5 00             LDA $00,X
F768  D0 02             BNE $F76C
F76A  D6 01             DEC $01,X
F76C  D6 00             DEC $00,X
F76E  60                RTS 
F76F  A0 00             LDY #$00
F771  38                SEC 
F772  A5 00             LDA $00
F774  F5 00             SBC $00,X
F776  99 00 00          STA $0000,Y
F779  A5 01             LDA $01
F77B  F5 01             SBC $01,X
F77D  99 01 00          STA $0001,Y
F780  98                TYA 
F781  69 00             ADC #$00
F783  85 1D             STA $1D
F785  60                RTS 
F786  A5 00             LDA $00
F788  75 00             ADC $00,X
F78A  85 00             STA $00
F78C  A5 01             LDA $01
F78E  75 01             ADC $01,X
F790  A0 00             LDY #$00
F792  F0 E9             BEQ $F77D
F794  A5 1E             LDA $1E
F796  20 19 F7          JSR $F719
F799  A5 1F             LDA $1F
F79B  20 19 F7          JSR $F719
F79E  18                CLC 
F79F  B0 0E             BCS $F7AF
F7A1  B1 1E             LDA ($1E),Y
F7A3  10 01             BPL $F7A6
F7A5  88                DEY 
F7A6  65 1E             ADC $1E
F7A8  85 1E             STA $1E
F7AA  98                TYA 
F7AB  65 1F             ADC $1F
F7AD  85 1F             STA $1F
F7AF  60                RTS 
F7B0  B0 EC             BCS $F79E
F7B2  60                RTS 
F7B3  0A                ASL A
F7B4  AA                TAX 
F7B5  B5 01             LDA $01,X
F7B7  10 E8             BPL $F7A1
F7B9  60                RTS 
F7BA  0A                ASL A
F7BB  AA                TAX 
F7BC  B5 01             LDA $01,X
F7BE  30 E1             BMI $F7A1
F7C0  60                RTS 
F7C1  0A                ASL A
F7C2  AA                TAX 
F7C3  B5 00             LDA $00,X
F7C5  15 01             ORA $01,X
F7C7  F0 D8             BEQ $F7A1
F7C9  60                RTS 
F7CA  0A                ASL A
F7CB  AA                TAX 
F7CC  B5 00             LDA $00,X
F7CE  15 01             ORA $01,X
F7D0  D0 CF             BNE $F7A1
F7D2  60                RTS 
F7D3  0A                ASL A
F7D4  AA                TAX 
F7D5  B5 00             LDA $00,X
F7D7  35 01             AND $01,X
F7D9  49 FF             EOR #$FF
F7DB  F0 C4             BEQ $F7A1
F7DD  60                RTS 
F7DE  0A                ASL A
F7DF  AA                TAX 
F7E0  B5 00             LDA $00,X
F7E2  35 01             AND $01,X
F7E4  49 FF             EOR #$FF
F7E6  D0 B9             BNE $F7A1
F7E8  60                RTS 
F7E9  A2 18             LDX #$18
F7EB  20 66 F7          JSR $F766
F7EE  A1 00             LDA ($00,X)
F7F0  85 1F             STA $1F
F7F2  20 66 F7          JSR $F766
F7F5  A1 00             LDA ($00,X)
F7F7  85 1E             STA $1E
F7F9  60                RTS 
F7FA  4C C7 F6          JMP $F6C7
F7FD  F6 FF             DEC $FF,X
F7FF  1A                .BYTE $1A      ; invalid opcode

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
