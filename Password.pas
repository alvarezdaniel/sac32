unit Password;

interface

uses BDE, DB, DBTables, SysUtils;

procedure AddMasterPassword(Table: TTable; pswd: string);
procedure AddAuxPassword(Table: TTable; mstrpswd, pswd: string; rights: PRVType);
procedure RemoveMasterPassword(Table: TTable);
procedure RemoveAuxPassword(Table: TTable; mstrpswd, pswd: string);

implementation

uses Dialogs;

function GetSecNoFromName(hDb: hDBIDb; TblName, pswd: string): word; forward;

procedure AddMasterPassword(Table: TTable; pswd: string);
const
  RESTRUCTURE_TRUE = WordBool(1);

var
  TblDesc: CRTblDesc;
  hDb: hDBIDb;

begin
  { Make sure that the table is opened and is exclusive }
  if (Table.Active = False) or (Table.Exclusive = False) then
    raise EDatabaseError.Create('Table must be opened in exclusive mode to add passwords');
  { Initialize the table descriptor }
  FillChar(TblDesc, SizeOf(CRTblDesc), 0);

  with TblDesc do
  begin
    { Place the table name in descriptor }
    StrPCopy(szTblName, Table.TableName);
    { Place the table type in descriptor }
    StrCopy(szTblType, szPARADOX);
    { Master Password, Password }
    StrPCopy(szPassword, pswd);
    { Set bProtected to True }
    bProtected := RESTRUCTURE_TRUE;
  end;

  { Get the database handle from the cursor handle }
  Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
  { Close the table }
  Table.Close;
  { Add the master password to the Paradox table }
  Check(DbiDoRestructure(hDb, 1, @TblDesc, nil, nil, nil, FALSE));
  { Add the new password to the session }
  //Session.AddPassword(pswd);
  { Re-Open the table }
  Table.Open;
end;


{ In order to add an auxilary password, the master password MUST also be
  added at the same time; even if the master password is already on the
  table!  A privelage type of prvINSDEL gives full rights without the
  ability to restructure or delete.  }
procedure AddAuxPassword(Table: TTable; mstrpswd, pswd: string; rights: PRVType);
const
  RESTRUCTURE_TRUE = WordBool(1);

var
  { Specific information about the table structure, indexes, etc. }
  TblDesc: CRTblDesc;
  { Security descriptor }
  SDesc: SECDesc;
  { Uses as a handle to the database }
  hDb: hDBIDb;
  { crAdd }
  crType: CROpType;
  W: word;

begin
  { Add the master password to the session }
  Session.AddPassword(mstrpswd);
  { Make sure that the table is opened and is exclusive }
  if (Table.Active = False) or (Table.Exclusive = False) then
    raise EDatabaseError.Create('Table must be opened in exclusive mode to add passwords');
  { Initialize the table and security descriptor }
  FillChar(TblDesc, SizeOf(CRTblDesc), #0);
  FillChar(SDesc, SizeOf(SDesc), #0);
  crType := crAdd;
  { Table privileges }
  SDesc.eprvTable := rights;
  { Family rights }
  SDesc.iFamRights := NoFamRights;
  { Aux Password name }
  StrPCopy(SDesc.szPassword, pswd);
  { Set field rights to full }
  for W := 1 to Table.FieldCount do
    SDesc.aprvFld[W - 1] := prvFULL;

  { Place the table name in descriptor }
  StrPCopy(TblDesc.szTblName, Table.TableName);
  { Place the table type in descriptor }
  StrCopy(TblDesc.szTblType, szPARADOX);
  { Number of security definitions }
  TblDesc.iSecRecCount := 1;
  { This should be crAdd }
  TblDesc.pecrSecOp := @crType;
  { Attach the security descriptor to the Table Descriptor }
  TblDesc.psecDesc := @SDesc;
  { Copy in the master password }
  StrPCopy(TblDesc.szPassword, mstrpswd);
  { Set bProtected to True }
  TblDesc.bProtected := RESTRUCTURE_TRUE;

  { Get the database handle from the cursor handle }
  Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
  { Close the table }
  Table.Close;
  { Add the auxilary password to the Paradox table }
  Check(DbiDoRestructure(hDb, 1, @TblDesc, nil, nil, nil, FALSE));
  { Re-Open the table }
  Table.Open;
end;

procedure RemoveMasterPassword(Table: TTable);
const
  RESTRUCTURE_FALSE = WordBool(0);

var
  TblDesc: CRTblDesc;
  hDb: hDBIDb;

begin
  { Make sure that the table is opened and is exclusive }
  if (Table.Active = False) or (Table.Exclusive = False) then
    raise EDatabaseError.Create('Table must be opened in exclusive mode to add passwords');
  { Initialize the table descriptor }
  FillChar(TblDesc, SizeOf(CRTblDesc), 0);

  with TblDesc do
  begin
    { Place the table name in descriptor }
    StrPCopy(szTblName, Table.TableName);
    { Place the table type in descriptor }
    StrCopy(szTblType, szPARADOX);
    { Set bProtected to False }
    bProtected := RESTRUCTURE_FALSE;
  end;

  { Get the database handle from the cursor handle }
  Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
  { Close the table }
  Table.Close;
  { Add the master password to the Paradox table }
  Check(DbiDoRestructure(hDb, 1, @TblDesc, nil, nil, nil, FALSE));
  { Re-Open the table }
  Table.Open;
end;

procedure RemoveAuxPassword(Table: TTable; mstrpswd, pswd: string);
const
  RESTRUCTURE_TRUE = WordBool(1);

var
  { Specific information about the table structure, indexes, etc. }
  TblDesc: CRTblDesc;
  { Security descriptor }
  SDesc: SECDesc;
  { Uses as a handle to the database }
  hDb: hDBIDb;
  { crAdd }
  crType: CROpType;

begin
  { Make sure that the table is opened and is exclusive }
  if (Table.Active = False) or (Table.Exclusive = False) then
    raise EDatabaseError.Create('Table must be opened in exclusive mode to add passwords');
  { Initialize the table and security descriptor }
  FillChar(TblDesc, SizeOf(CRTblDesc), 0);
  FillChar(SDesc, SizeOf(SECDesc), 0);
  crType := crDrop;
  { Descriptor number that specifies the password to remove }
  SDesc.iSecNum := GetSecNoFromName(Table.DbHandle, Table.TableName, pswd);
  if SDesc.iSecNum = 0 then
  begin
    ShowMessage('Could not find auxilary password.');
    Exit;
  end;

  with TblDesc do
  begin
    { Place the table name in descriptor }
    StrPCopy(szTblName, Table.TableName);
    { Place the table type in descriptor }
    StrCopy(szTblType, szPARADOX);
    { Number of security definitions }
    iSecRecCount := 1;
    { This should be crDrop }
    pecrSecOp := @crType;
    { Attach the security descriptor to the Table Descriptor }
    psecDesc := @SDesc;
    { Copy in the master password }
    StrPCopy(szPassword, mstrpswd);
    { Set bProtected to True }
    bProtected := RESTRUCTURE_TRUE;
  end;

  { Get the database handle from the cursor handle }
  Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
  { Close the table }
  Table.Close;
  { Remove the auxilary password to the Paradox table }
  Check(DbiDoRestructure(hDb, 1, @TblDesc, nil, nil, nil, FALSE));
  { Re-Open the table }
  Table.Open;
end;

function GetSecNoFromName(hDb: hDBIDb; TblName, pswd: string): word;
var
  hCur: hDBICur;
  Sec: SECDesc;

begin
  Result := 0;
  Check(DbiOpenSecurityList(hDb, PChar(TblName), nil, hCur));
  try
    Check(DbiSetToBegin(hCur));
    while DbiGetNextRecord(hCur, dbiNOLOCK, @Sec, nil) = DBIERR_NONE do
    begin
      if CompareText(Sec.szPassword, pswd) = 0 then
      begin
        { Set the Security Number to the result }
        Result := Sec.iSecNum;
        break;
      end;
    end;
  finally
    Check(DbiCloseCursor(hCur));
  end;
end;

end.
