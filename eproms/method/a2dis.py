#!/usr/bin/env python3
"""Apple II ROM disassembler: 6502 + soft-switch/monitor annotation +
high-bit ASCII text detection + unstable-byte flagging."""
import sys, os, re

M={}
tbl="""
00 BRK imp;01 ORA izx;05 ORA zp;06 ASL zp;08 PHP imp;09 ORA imm;0A ASL acc;0D ORA abs;0E ASL abs
10 BPL rel;11 ORA izy;15 ORA zpx;16 ASL zpx;18 CLC imp;19 ORA aby;1D ORA abx;1E ASL abx
20 JSR abs;21 AND izx;24 BIT zp;25 AND zp;26 ROL zp;28 PLP imp;29 AND imm;2A ROL acc;2C BIT abs;2D AND abs;2E ROL abs
30 BMI rel;31 AND izy;35 AND zpx;36 ROL zpx;38 SEC imp;39 AND aby;3D AND abx;3E ROL abx
40 RTI imp;41 EOR izx;45 EOR zp;46 LSR zp;48 PHA imp;49 EOR imm;4A LSR acc;4C JMP abs;4D EOR abs;4E LSR abs
50 BVC rel;51 EOR izy;55 EOR zpx;56 LSR zpx;58 CLI imp;59 EOR aby;5D EOR abx;5E LSR abx
60 RTS imp;61 ADC izx;65 ADC zp;66 ROR zp;68 PLA imp;69 ADC imm;6A ROR acc;6C JMP ind;6D ADC abs;6E ROR abs
70 BVS rel;71 ADC izy;75 ADC zpx;76 ROR zpx;78 SEI imp;79 ADC aby;7D ADC abx;7E ROR abx
81 STA izx;84 STY zp;85 STA zp;86 STX zp;88 DEY imp;8A TXA imp;8C STY abs;8D STA abs;8E STX abs
90 BCC rel;91 STA izy;94 STY zpx;95 STA zpx;96 STX zpy;98 TYA imp;99 STA aby;9A TXS imp;9D STA abx
A0 LDY imm;A1 LDA izx;A2 LDX imm;A4 LDY zp;A5 LDA zp;A6 LDX zp;A8 TAY imp;A9 LDA imm;AA TAX imp;AC LDY abs;AD LDA abs;AE LDX abs
B0 BCS rel;B1 LDA izy;B4 LDY zpx;B5 LDA zpx;B6 LDX zpy;B8 CLV imp;B9 LDA aby;BA TSX imp;BC LDY abx;BD LDA abx;BE LDX aby
C0 CPY imm;C1 CMP izx;C4 CPY zp;C5 CMP zp;C6 DEC zp;C8 INY imp;C9 CMP imm;CA DEX imp;CC CPY abs;CD CMP abs;CE DEC abs
D0 BNE rel;D1 CMP izy;D5 CMP zpx;D6 DEC zpx;D8 CLD imp;D9 CMP aby;DD CMP abx;DE DEC abx
E0 CPX imm;E1 SBC izx;E4 CPX zp;E5 SBC zp;E6 INC zp;E8 INX imp;E9 SBC imm;EA NOP imp;EC CPX abs;ED SBC abs;EE INC abs
F0 BEQ rel;F1 SBC izy;F5 SBC zpx;F6 DEC zpx;F8 SED imp;F9 SBC aby;FD SBC abx;FE INC abx
"""
for e in tbl.replace('\n',';').split(';'):
    e=e.strip()
    if e:
        o,mn,am=e.split(); M[int(o,16)]=(mn,am)
SZ={'imp':1,'acc':1,'imm':2,'zp':2,'zpx':2,'zpy':2,'izx':2,'izy':2,'rel':2,
    'abs':3,'abx':3,'aby':3,'ind':3}

# --- Apple II symbol table (best-effort; from the published Monitor listing) ---
SOFT={0xC000:'KBD',0xC010:'KBDSTRB',0xC020:'TAPEOUT',0xC030:'SPKR',0xC040:'STROBE',
 0xC050:'TXTCLR',0xC051:'TXTSET',0xC052:'MIXCLR',0xC053:'MIXSET',0xC054:'TXTPAGE1',
 0xC055:'TXTPAGE2',0xC056:'LORES',0xC057:'HIRES',0xC058:'AN0off',0xC059:'AN0on',
 0xC05A:'AN1off',0xC05B:'AN1on',0xC05C:'AN2off',0xC05D:'AN2on',0xC05E:'AN3off',
 0xC05F:'AN3on',0xC060:'TAPEIN',0xC061:'PB0',0xC062:'PB1',0xC063:'PB2',0xC064:'PADDL0',
 0xC065:'PADDL1',0xC070:'PTRIG'}
MON={0xF800:'PLOT',0xF80E:'PLOT1',0xF819:'HLINE',0xF828:'VLINE',0xF832:'CLRSCR',
 0xF836:'CLRTOP',0xF847:'GBASCALC',0xF856:'NXTCOL',0xF85F:'SETCOL',0xF871:'SCRN2',
 0xF8D0:'INSTDSP',0xF940:'PRBLNK',0xF941:'PRNTAX',0xF944:'PRBL2',0xF948:'PCADJ',
 0xFA40:'IRQ',0xFA43:'BREAK',0xFA4C:'OLDBRK',0xFA62:'RESET',0xFABA:'SLOOP',
 0xFB09:'TITLE_APPLE][',0xFB1E:'PREAD',0xFB2F:'INIT',0xFB39:'SETTXT',0xFB40:'SETGR',
 0xFB4B:'SETWND',0xFB5B:'TABV',0xFB60:'APPLEII',0xFB6F:'SETPWRC',0xFB78:'VIDWAIT',
 0xFB88:'KBDWAIT',0xFBC1:'BASCALC',0xFBD9:'BELL1',0xFBE4:'BELL2',0xFBF0:'STOADV',
 0xFBF4:'ADVANCE',0xFBFD:'VIDOUT',0xFC10:'BS',0xFC1A:'UP',0xFC22:'VTAB',0xFC24:'VTABZ',
 0xFC42:'CLREOP',0xFC58:'HOME',0xFC62:'CR',0xFC66:'LF',0xFC70:'SCROLL',0xFC9C:'CLREOL',
 0xFCA8:'WAIT',0xFCB4:'NXTA4',0xFCBA:'NXTA1',0xFCC9:'HEADR',0xFD0C:'RDKEY',
 0xFD1B:'KEYIN',0xFD35:'RDCHAR',0xFD3D:'NOTCR',0xFD62:'CANCEL',0xFD67:'GETLNZ',
 0xFD6A:'GETLN',0xFD8B:'CROUT1',0xFD8E:'CROUT',0xFD92:'PRA1',0xFDDA:'PRBYTE',
 0xFDE3:'PRHEX',0xFDED:'COUT',0xFDF0:'COUT1',0xFE2C:'MOVE',0xFE36:'VERIFY',
 0xFE5E:'LIST',0xFE80:'SETINV',0xFE84:'SETNORM',0xFE89:'SETKBD',0xFE93:'SETVID',
 0xFEB6:'GO',0xFECD:'WRITE',0xFEFD:'READ',0xFF2D:'PRERR',0xFF3A:'BELL',
 0xFF3F:'RESTORE',0xFF4A:'SAVE',0xFF59:'OLDRST',0xFF65:'MON',0xFF69:'MONZ',
 0xFF8A:'DIG',0xFFA7:'GETNUM',0xFFC7:'ZMODE'}
ZP={0x20:'WNDLFT',0x21:'WNDWDTH',0x22:'WNDTOP',0x23:'WNDBTM',0x24:'CH',0x25:'CV',
 0x26:'GBASL',0x27:'GBASH',0x28:'BASL',0x29:'BASH',0x2B:'BOOTSLOT',0x2C:'H2',0x2D:'V2',
 0x2E:'MASK',0x30:'COLOR',0x31:'MODE',0x32:'INVFLG',0x33:'PROMPT',0x34:'YSAV',
 0x35:'YSAV1',0x36:'CSWL',0x37:'CSWH',0x38:'KSWL',0x39:'KSWH',0x3A:'PCL',0x3B:'PCH',
 0x3C:'A1L',0x3D:'A1H',0x3E:'A2L',0x3F:'A2H',0x40:'A3L',0x41:'A3H',0x42:'A4L',
 0x43:'A4H',0x44:'A5L',0x45:'ACC',0x46:'XREG',0x47:'YREG',0x48:'STATUS',0x49:'SPNT',
 0x4E:'RNDL',0x4F:'RNDH'}
def sym(a):
    return SOFT.get(a) or MON.get(a)

def find_text(d, minrun=5):
    """Apple II stores text with bit 7 SET. Reject runs that are just code
    bytes which happen to be printable: require a real word in there."""
    spans=[]; i=0; n=len(d)
    while i<n:
        if not (32<=(d[i]&0x7f)<127): i+=1; continue
        j=i
        while j<n and 32<=(d[j]&0x7f)<127: j+=1
        run=d[i:j]
        if len(run)>=minrun:
            txt=''.join(chr(b&0x7f) for b in run)
            best=max((len(m) for m in re.findall(r'[A-Za-z]+', txt)), default=0)
            hi=sum(1 for b in run if b&0x80)/len(run)
            if best>=4 and hi>=0.75:
                spans.append((i,j)); i=j; continue
        i=j if j>i else i+1
    return spans

def disassemble(data, base, unstable=(), title=''):
    n=len(data); text=dict()
    for s,e in find_text(data):
        for k in range(s,e): text[k]=(s,e)
    out=[]
    if title: out+= [f"; {title}", f"; {'='*len(title)}", ""]
    out.append(f"        .ORG ${base:04X}")
    out.append("")
    vec = base+n-6 if base+n==0x10000 else None
    pc=base; done=set()
    while pc < base+n:
        if vec is not None and pc==vec:
            names=['NMI','RESET','IRQ/BRK']
            out.append("\n; ---- 6502 hardware vectors ----")
            for k,nm in enumerate(names):
                lo,hi=data[pc-base],data[pc-base+1]
                out.append(f"{pc:04X}  {lo:02X} {hi:02X}             .WORD ${hi<<8|lo:04X}      ; {nm}"
                           + (f"  -> {sym(hi<<8|lo)}" if sym(hi<<8|lo) else ""))
                pc+=2
            continue
        off=pc-base
        if off in text and text[off][0]==off:
            s,e=text[off]
            raw=data[s:e]
            txt=''.join(chr(b&0x7f) for b in raw).replace('"','\\"')
            out.append(f'{pc:04X}  {" ".join(f"{b:02X}" for b in raw[:6]):<17} .ASC "{txt}"')
            pc += (e-s); continue
        op=data[off]
        lbl=sym(pc)
        if lbl: out.append(f"\n{lbl}:")
        if op in M:
            mn,am=M[op]; sz=SZ[am]
            if off+sz>n:
                out.append(f"{pc:04X}  {op:02X}                .BYTE ${op:02X}"); pc+=1; continue
            b=data[off:off+sz]; note=''
            if am=='imp': a=''
            elif am=='acc': a='A'
            elif am=='imm': a=f'#${b[1]:02X}'
            elif am in ('zp','zpx','zpy'):
                z=ZP.get(b[1]); a=f'${b[1]:02X}'+{'zp':'','zpx':',X','zpy':',Y'}[am]
                if z: note=f'  ; {z}'
            elif am=='izx': a=f'(${b[1]:02X},X)'
            elif am=='izy':
                a=f'(${b[1]:02X}),Y'; z=ZP.get(b[1])
                if z: note=f'  ; {z}'
            elif am=='rel':
                t=pc+2+((b[1]^0x80)-0x80); a=f'${t:04X}'
            else:
                t=b[1]|b[2]<<8
                a={'abs':f'${t:04X}','abx':f'${t:04X},X','aby':f'${t:04X},Y','ind':f'(${t:04X})'}[am]
                s2=sym(t)
                if s2: note=f'  ; {s2}'
            flag=''
            if any(off<=u<off+sz for u in unstable): flag='   ** UNSTABLE READ **'
            out.append(f"{pc:04X}  {' '.join(f'{x:02X}' for x in b):<17} {mn} {a}{note}{flag}")
            pc+=sz
        else:
            out.append(f"{pc:04X}  {op:02X}                .BYTE ${op:02X}      ; invalid opcode")
            pc+=1
    return out

def strings_report(data, base, label):
    lines=[f"### {label}  (${base:04X}-${base+len(data)-1:04X})",""]
    spans=find_text(data)
    if not spans:
        lines.append("_no high-bit text found_"); return lines
    for s,e in spans:
        txt=''.join(chr(b&0x7f) for b in data[s:e])
        lines.append(f"    ${base+s:04X}  {txt!r}")
    return lines
