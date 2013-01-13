{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnPascalGrammar;
{* |<PRE>
================================================================================
* ������ƣ�CnPack �����ʽ��ר��
* ��Ԫ���ƣ�Object Pascal �﷨EBNF����
* ��Ԫ���ߣ�CnPack������
* ��    ע��Object Pascal �﷨ EBNF ��������������Ƕ ASM
* ����ƽ̨��Win2003 + Delphi 5.0
* ���ݲ��ԣ�not test yet
* �� �� ����not test hell
* ��Ԫ��ʶ��$Id: CnPascalGrammar.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2003-12-16 V0.3
*               ����������Delphi Help - Object Pascal Gramer��
*               ԭʼ�ļ���һЩ����һֱ��½���޸��С�
*               ���﷨Ŀǰ�� CnCodeFormater �в��ֲ�ͬ���������ο�
*           2007-10-11
*               ½���޸���
================================================================================
|</PRE>}

{ *****************************************************************************

  Goal -> (Program | Package  | Library  | Unit)

  Program -> [PROGRAM Ident ['(' IdentList ')'] ';']
             ProgramBlock '.'

  Unit -> UNIT Ident ';'
          InterfaceSection
          ImplementationSection
          [InitSection]
          END '.'

  Package -> PACKAGE Ident ';'
             [RequiresClause]
             [ContainsClause]
             END '.'

  Library -> LIBRARY Ident ';'
             ProgramBlock '.'

  ProgramBlock -> [UsesClause]
                  Block

  UsesClause -> USES IdentList ';'
  InterfaceSection -> INTERFACE
                      [UsesClause]
                      [InterfaceDecl]...

  InterfaceDecl -> ConstSection
                -> TypeSection
                -> VarSection
                -> ExportsSection
                -> ExportedHeading

  ExportedHeading -> ProcedureHeading ';' [Directive]
                  -> FunctionHeading ';' [Directive]

  ImplementationSection -> IMPLEMENTATION
                           [UsesClause]
                           [DeclSection]...

  Block -> [DeclSection]
           CompoundStmt

  DeclSection -> LabelDeclSection
              -> ConstSection
              -> TypeSection
              -> VarSection
              -> ExportsSection
              -> ProcedureDeclSection

  ExportsSection -> EXPORTS ExportsList ';'
  ExportsList -> ( ExportsDecl ',')...
  ExportsDecl -> Ident [FormalParameters] [':' (SimpleType | STRING)] [Directive]
  
  LabelDeclSection -> LABEL LabelId
  ConstSection -> CONST (ConstantDecl ';')...
                  RESOURCESTRING (ConstantDecl ';')...
                  
  ConstantDecl -> Ident '=' ConstExpr
               -> Ident ':' TypeId '=' TypedConstant

  TypeSection -> TYPE (TypeDecl ';')...
  TypeDecl -> Ident '=' Type
           -> Ident '=' RestrictedType

  TypedConstant -> (ConstExpr | SetConstructor | ArrayConstant | RecordConstant)
  ArrayConstant -> '(' TypedConstant/','... ')'
  RecordConstant -> '(' RecordFieldConstant/';'... ')'
  RecordFieldConstant -> Ident ':' TypedConstant
  Type -> TypeId
       -> SimpleType
       -> StrucType
       -> PointerType
       -> StringType
       -> ProcedureType
       -> VariantType
       -> ClassRefType

  RestrictedType -> ObjectType
                 -> ClassType
                 -> InterfaceType

  ClassRefType -> CLASS OF TypeId
  SimpleType -> (OrdinalType | RealType)
  RealType -> REAL48
           -> REAL
           -> SINGLE
           -> DOUBLE
           -> EXTENDED
           -> CURRENCY
           -> COMP

  OrdinalType -> (SubrangeType | EnumeratedType | OrdIdent)
  OrdIdent -> SHORTINT
           -> SMALLINT
           -> INTEGER
           -> BYTE
           -> LONGINT
           -> INT64
           -> WORD
           -> BOOLEAN
           -> CHAR
           -> WIDECHAR
           -> LONGWORD
           -> PCHAR

  VariantType -> VARIANT
              -> OLEVARIANT

  SubrangeType -> ConstExpr '..' ConstExpr

  EnumeratedType -> '(' EnumeratedList ')'
  EnumeratedList -> EmumeratedIdent/','...
  EmumeratedIdent -> Ident ['=' ConstExpr]
  
  StringType -> STRING
             -> ANSISTRING
             -> WIDESTRING
             -> STRING '[' ConstExpr ']'

  StrucType -> [PACKED] (ArrayType | SetType | FileType | RecType)
  ArrayType -> ARRAY ['[' OrdinalType/','... ']'] OF Type
  RecType -> RECORD [FieldList] END
  FieldList ->  FieldDecl/';'... [VariantSection] [';']
  FieldDecl -> IdentList ':' Type
  VariantSection -> CASE [Ident ':'] TypeId OF RecVariant/';'...
  RecVariant -> ConstExpr/','...  ':' '(' [FieldList] ')'
  SetType -> SET OF OrdinalType
  FileType -> FILE [OF TypeId]

  PointerType -> '^' TypeId
  ProcedureType -> (ProcedureHeading | FunctionHeading) [OF OBJECT]
  VarSection -> VAR | THREADVAR (VarDecl ';')...
  VarDecl -> IdentList ':' Type [(ABSOLUTE (Ident | ConstExpr)) | '=' TypedConstant]
  Expression -> SimpleExpression [RelOp SimpleExpression]...
  SimpleExpression -> ['+' | '-'] Term [AddOp Term]...
  Term -> Factor [MulOp Factor]...
  Factor -> Designator ['(' ExprList ')']
         -> '@' Designator
         -> Number
         -> String
         -> NIL
         -> '(' Expression ')'
         -> NOT Factor
         -> SetConstructor
         -> TypeId '(' Expression ')'

  RelOp -> '>'
        -> '<'
        -> '<='
        -> '>='
        -> '<>'
        -> IN
        -> IS
        -> AS

  AddOp -> '+'
        -> '-'
        -> OR
        -> XOR

  MulOp -> '*'
        -> '/'
        -> DIV
        -> MOD
        -> AND
        -> SHL
        -> SHR

  Designator -> QualId ['.' Ident | '[' ExprList ']' | '^']...

  SetConstructor -> '[' [SetElement/','...] ']'
  SetElement -> Expression ['..' Expression]
  ExprList -> Expression/','...
  Statement -> [LabelId ':'] [SimpleStatement | StructStmt]
  StmtList -> Statement/';'...
  SimpleStatement -> Designator ['(' ExprList ')']
                  -> Designator ':=' Expression
                  -> INHERITED
                  -> GOTO LabelId

  StructStmt -> CompoundStmt
             -> ConditionalStmt
             -> LoopStmt
             -> WithStmt

  CompoundStmt -> BEGIN StmtList END
  ConditionalStmt -> IfStmt
                  -> CaseStmt

  IfStmt -> IF Expression THEN Statement [ELSE Statement]
  CaseStmt -> CASE Expression OF CaseSelector/';'... [ELSE StmtList] [';'] END
  CaseSelector -> CaseLabel/','... ':' Statement
  CaseLabel -> ConstExpr ['..' ConstExpr]
  LoopStmt -> RepeatStmt
           -> WhileStmt
           -> ForStmt

  RepeatStmt -> REPEAT StmtList UNTIL Expression
  WhileStmt -> WHILE Expression DO Statement
  ForStmt -> FOR QualId ':=' Expression (TO | DOWNTO) Expression DO Statement
  WithStmt -> WITH IdentList DO Statement
  ProcedureDeclSection -> ProcedureDecl
                       -> FunctionDecl

  ProcedureDecl -> ProcedureHeading ';' [Directive]
                   Block ';'

  FunctionDecl -> FunctionHeading ';' [Directive]
                  Block ';'

  FunctionHeading -> FUNCTION Ident [FormalParameters] ':' (SimpleType | STRING)
  ProcedureHeading -> PROCEDURE Ident [FormalParameters]
  FormalParameters -> '(' FormalParm/';'... ')'
  FormalParm -> [VAR | CONST | OUT] Parameter
  Parameter -> IdentList  [':' ([ARRAY OF] SimpleType | STRING | FILE)]
            -> Ident ':' (SimpleType | STRING) '=' ConstExpr

  Directive -> CDECL
            -> REGISTER
            -> DYNAMIC
            -> VIRTUAL
            -> EXPORT
            -> EXTERNAL
            -> FAR
            -> FORWARD
            -> MESSAGE
            -> OVERRIDE
            -> OVERLOAD
            -> PASCAL
            -> REINTRODUCE
            -> SAFECALL
            -> STDCALL

  ObjectType -> OBJECT [ObjHeritage] [ObjFieldList] [MethodList] END
  ObjHeritage -> '(' QualId ')'
  MethodList -> (MethodHeading [';' VIRTUAL])/';'...
  MethodHeading -> ProcedureHeading
                -> FunctionHeading
                -> ConstructorHeading
                -> DestructorHeading
                -> PROCEDURE | FUNCTION InterfaceId.Ident '=' Ident

  ConstructorHeading -> CONSTRUCTOR Ident [FormalParameters]
  DestructorHeading -> DESTRUCTOR Ident [FormalParameters]
  ObjFieldList -> (IdentList ':' Type)/';'...
  InitSection -> INITIALIZATION StmtList [FINALIZATION StmtList]
              -> BEGIN StmtList END

  ClassType -> CLASS [ClassHeritage]
               [ClassFieldList]
               [ClassMethodList]
               [ClassPropertyList]
               END

  ClassHeritage -> '(' IdentList ')'
  ClassVisibility -> [PUBLIC | PROTECTED | PRIVATE | PUBLISHED]
  ClassFieldList -> (ClassVisibility ObjFieldList)/';'...
  ClassMethodList -> (ClassVisibility MethodList)/';'...
  ClassPropertyList -> (ClassVisibility PropertyList ';')...
  PropertyList -> PROPERTY  Ident [PropertyInterface]  PropertySpecifiers
  PropertyInterface -> [PropertyParameterList] ':' Ident
  PropertyParameterList -> '[' (IdentList ':' TypeId)/';'... ']'

  PropertySpecifiers -> [INDEX ConstExpr]
                        [READ Ident]
                        [WRITE Ident]
                        [STORED (Ident | Constant)]
                        [(DEFAULT ConstExpr) | NODEFAULT]
                        [IMPLEMENTS TypeId]

  InterfaceType -> INTERFACE [InterfaceHeritage] | DISPINTERFACE
                   [GUID]
                   [InterfaceMemberList]
                   END
  InterfaceHeritage -> '(' IdentList ')'
  InterfaceMemberList -> ([InterfaceMember ';']) ...
  InterfaceMember -> InterfaceMethod | InterfaceProperty
  
  (Note: InterfaceMethod / InterfaceProperty use ClassMethod / ClassProperty)

  RequiresClause -> REQUIRES IdentList... ';'
  ContainsClause -> CONTAINS IdentList... ';'
  IdentList -> Ident/','...
  QualId -> [UnitId '.'] Ident
  QualID -> '(' Designator [AS TypeId]')'
         -> [UnitId '.'] Ident
         -> (pointervar + expr)

  TypeId -> [UnitId '.'] <type-identifier>
  Ident -> <identifier>
  ConstExpr -> <constant-expression>
  UnitId -> <unit-identifier>
  LabelId -> <label-identifier>
  Number -> <number>
  String -> <string>

 ***************************************************************************** }

interface

implementation

end.
