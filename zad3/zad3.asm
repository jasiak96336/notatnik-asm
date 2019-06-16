
PrzejdŸ do treœci
Korzystanie z us³ugi Gmail z czytnikami ekranu
3 z 99
zadania assembler
Micha³ Jasiak <michaljasiak04@gmail.com>
	
Za³¹cznikisob., 1 cze, 08:13
	
do g.bialic

6 za³¹czników
	
	
	

include \masm32\include\masm32rt.inc

ID_DLG_MAIN = 100
ID_OTWORZ = 1020
ID_KONIEC = 1030

ID_ZAPISZ = 1040
ID_EDIT = 101

OFN_ENABLESIZING = 00800000h
OFN_FORCESHOWHIDDEN = 10000000h

.data?
hInstance dd ?
hFile dd ?
oofn OPENFILENAME <>
sofn OPENFILENAME <>

bufor db 30000 dup(?)
xRead dd ?
xWrite dd ?
.data
filter db 'Pliki Tekstowe',NULL,'*.txt',NULL, 'Pliki asemblera',NULL,'*.asm',NULL
custFilter db 256 dup(NULL)
fname db 256 dup(NULL)
ftitle db 256 dup(NULL)
initDir db 'C:\',NULL
oDlgTitle db 'Otwórz',NULL

sdlgTitle db 'Zapisz',NULL

.code
DlgProc proc hDlg,uMsg,wParam,lParam:DWORD
pushad

.IF uMsg==WM_CLOSE
INVOKE EndDialog,hDlg,0
.ELSEIF uMsg==WM_COMMAND
.IF wParam==ID_KONIEC
INVOKE EndDialog,hDlg,0
.ELSEIF wParam==ID_OTWORZ
mov oofn.lStructSize,SIZEOF oofn

push hDlg
pop oofn.hwndOwner

push hInstance
pop oofn.hInstance

mov oofn.lpstrFilter,OFFSET filter

mov oofn.lpstrCustomFilter,OFFSET custFilter
mov oofn.nMaxCustFilter,SIZEOF custFilter ;256

mov oofn.nFilterIndex,0
mov oofn.lpstrFile,OFFSET fname
mov oofn.nMaxFile,256

mov oofn.lpstrFileTitle,OFFSET ftitle
mov oofn.nMaxFileTitle,SIZEOF ftitle

mov oofn.lpstrInitialDir,OFFSET initDir

mov oofn.lpstrTitle,OFFSET oDlgTitle

mov oofn.Flags,OFN_ENABLESIZING OR \
OFN_EXPLORER OR \
OFN_FORCESHOWHIDDEN OR \
OFN_PATHMUSTEXIST OR \
OFN_OVERWRITEPROMPT OR \
OFN_HIDEREADONLY OR \
OFN_FILEMUSTEXIST OR \
OFN_NODEREFERENCELINKS
mov oofn.nFileOffset,0
mov oofn.lpfnHook,NULL
mov oofn.lpTemplateName,NULL

INVOKE GetOpenFileName,ADDR oofn
.IF eax!=NULL
INVOKE CreateFile,OFFSET fname,GENERIC_READ,NULL,NULL,\
OPEN_EXISTING,NULL,NULL
mov hFile,eax
.IF hFile!=NULL
INVOKE ReadFile,hFile,OFFSET bufor,SIZEOF bufor, ADDR xRead,NULL
.IF eax!=0
INVOKE SetDlgItemText,hDlg, ID_EDIT,OFFSET bufor
INVOKE SendMessage,hDlg,WM_SETTEXT,0,OFFSET ftitle
.ENDIF
INVOKE CloseHandle,hFile
.ENDIF
.ENDIF
.ELSEIF wParam==ID_ZAPISZ
mov sofn.lStructSize,SIZEOF sofn

push hDlg
pop sofn.hwndOwner

push hInstance
pop sofn.hInstance

mov sofn.lpstrFilter,OFFSET filter

mov sofn.lpstrCustomFilter,OFFSET custFilter
mov sofn.nMaxCustFilter,SIZEOF custFilter
mov sofn.nFilterIndex,0

mov sofn.lpstrFile,OFFSET fname
mov sofn.nMaxFile,256

mov sofn.lpstrFileTitle,OFFSET ftitle
mov sofn.nMaxFileTitle,SIZEOF ftitle

mov sofn.lpstrInitialDir,OFFSET initDir


mov sofn.lpstrTitle,OFFSET sdlgTitle

mov sofn.Flags,OFN_ENABLESIZING OR \
OFN_EXPLORER OR \
OFN_FORCESHOWHIDDEN OR \
OFN_PATHMUSTEXIST OR \
OFN_OVERWRITEPROMPT OR \
OFN_HIDEREADONLY OR \
OFN_NODEREFERENCELINKS
mov sofn.nFileOffset,0
mov sofn.lpfnHook,NULL
mov sofn.lpTemplateName,NULL

INVOKE GetSaveFileName,OFFSET sofn
.IF eax!=NULL
INVOKE CreateFile,OFFSET fname,GENERIC_WRITE,NULL,NULL,CREATE_ALWAYS,NULL,NULL 
mov hFile,eax
.IF hFile!=NULL
INVOKE GetDlgItemText,hDlg,ID_EDIT,OFFSET bufor,SIZEOF bufor
mov xWrite,eax
INVOKE WriteFile,hFile,OFFSET bufor,xWrite, ADDR xWrite,NULL
INVOKE CloseHandle,hFile
.ENDIF
.ENDIF
.ENDIF
.ENDIF

popad
xor eax,eax
ret
DlgProc endp

Start:

INVOKE GetModuleHandle,NULL
mov hInstance,eax

INVOKE DialogBoxParam,hInstance,ID_DLG_MAIN,0,ADDR DlgProc,0

INVOKE ExitProcess,0
END Start

zad3.asm
Wyœwietlanie zad3.asm.