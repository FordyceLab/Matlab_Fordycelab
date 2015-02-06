function [methodinfo,structs,enuminfo,ThunkLibName]=MBT
%MBT Create structures to define interfaces found in 'MBT'.

%This function was generated by loadlibrary.m parser version 1.1.6.32 on Mon Apr 11 18:43:38 2011
%perl options:'MBT.i -outfile=MBT.m'
ival={cell(1,0)}; % change 0 to the actual number of functions to preallocate the data.
structs=[];enuminfo=[];fcnNum=1;
fcns=struct('name',ival,'calltype',ival,'LHS',ival,'RHS',ival,'alias',ival);
ThunkLibName=[];
% LONG WINAPI MBTInit (); 
fcns.name{fcnNum}='MBTInit'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% LONG WINAPI MBTExit (); 
fcns.name{fcnNum}='MBTExit'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}=[];fcnNum=fcnNum+1;
% LONG WINAPI MBTConnect ( IN LPCTSTR szHostAddress , IN WORD port , IN BOOL useTCPorUDP , IN DWORD requestTimeout , OUT HANDLE * hSocket ); 
fcns.name{fcnNum}='MBTConnect'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'stringPtr', 'uint16', 'int', 'ulong', 'longPtr'};fcnNum=fcnNum+1;
% LONG WINAPI MBTDisconnect ( IN HANDLE hSocket ); 
fcns.name{fcnNum}='MBTDisconnect'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'long'};fcnNum=fcnNum+1;
% LONG WINAPI MBTReadRegisters ( IN HANDLE hSocket , IN BYTE tableType , IN WORD dataStartAddress , IN WORD numWords , OUT LPBYTE pReadBuffer , OPTIONAL IN MBTReadCompleted fpReadCompletedCallback = NULL , OPTIONAL IN DWORD callbackContext = 0 ); 
fcns.name{fcnNum}='MBTReadRegisters'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'long', 'uint8', 'uint16', 'uint16', 'voidPtr', 'long', 'long'};fcnNum=fcnNum+1;
% LONG WINAPI MBTWriteRegisters ( IN HANDLE hSocket , IN WORD dataStartAddress , IN WORD numWords , IN LPBYTE pWriteBuffer , OPTIONAL IN MBTWriteCompleted fpWriteCompletedCallback = NULL , OPTIONAL IN DWORD callbackContext = 0 ); 
fcns.name{fcnNum}='MBTWriteRegisters'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'long', 'uint16', 'uint16', 'voidPtr', 'long', 'long'};fcnNum=fcnNum+1;
% LONG WINAPI MBTReadCoils ( IN HANDLE hSocket , IN BYTE tableType , IN WORD dataStartAddress , IN WORD numBits , OUT LPBYTE pReadBuffer , OPTIONAL IN MBTReadCompleted fpReadCompletedCallback = NULL , OPTIONAL IN DWORD callbackContext = 0 ); 
fcns.name{fcnNum}='MBTReadCoils'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'long', 'uint8', 'uint16', 'uint16', 'voidPtr', 'long', 'long'};fcnNum=fcnNum+1;
% LONG WINAPI MBTWriteCoils ( IN HANDLE hSocket , IN WORD dataStartAddress , IN WORD numBits , IN LPBYTE pWriteBuffer , OPTIONAL IN MBTWriteCompleted fpWriteCompletedCallback = NULL , OPTIONAL IN DWORD callbackContext = 0 ); 
fcns.name{fcnNum}='MBTWriteCoils'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'long', 'uint16', 'uint16', 'voidPtr', 'long', 'long'};fcnNum=fcnNum+1;
% LONG WINAPI MBTReadExceptionStatus ( IN HANDLE hSocket , OUT LPBYTE pExceptionStatus , OPTIONAL IN MBTReadCompleted fpReadCompletedCallback = NULL , OPTIONAL IN DWORD callbackContext = 0 ); 
fcns.name{fcnNum}='MBTReadExceptionStatus'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'long', 'voidPtr', 'long', 'long'};fcnNum=fcnNum+1;
% WORD WINAPI MBTSwapWord ( const WORD wData ); 
fcns.name{fcnNum}='MBTSwapWord'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint16'; fcns.RHS{fcnNum}={'uint16'};fcnNum=fcnNum+1;
% DWORD WINAPI MBTSwapDWord ( const DWORD dwData ); 
fcns.name{fcnNum}='MBTSwapDWord'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'uint32'};fcnNum=fcnNum+1;
methodinfo=fcns;