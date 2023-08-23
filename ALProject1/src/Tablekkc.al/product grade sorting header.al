table 90010 "product grade sorting header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Caption = 'Document No';
            DataClassification = ToBeClassified; // ระบุการจัดประเภทที่จะใช้กับข้อมูลที่มีอยู่ในตาราง

            trigger OnValidate() // ทำงานเมื่อมีการตรวจสอบอินพุตของผู้ใช้
            begin
                if "Document No" <> xRec."Document No" then begin // ถ้าเราเปลี่ยน document No แล้วไม่ได้อยู่ใน inventory setup ค่าจะว่าง
                    InvenSetup.Get();
                    NoSeriesMgt.TestManual(InvenSetup."Document No");
                    "No.Series" := '';
                end;
            end;

        }

        field(2; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(3; "Item A"; Code[20])
        {
            Caption = 'สินค้าเกรด A';
            TableRelation = Item;

        }
        field(4; "Item C"; Code[20])
        {
            Caption = 'สินค้าเกรด C';
            TableRelation = Item;
        }
        field(5; "Item Scap"; Code[20])
        {
            TableRelation = Item;
        }
        field(6; "Grade A"; Decimal)
        {
            Caption = 'เกรด A';
            DataClassification = ToBeClassified;
        }
        field(7; "Grade C"; Decimal)
        {
            Caption = 'เกรด C';
            DataClassification = ToBeClassified;

        }
        field(8; "Grade Scap"; Decimal)
        {
            Caption = 'เกรด Scap';
            DataClassification = ToBeClassified;
        }
        field(9; "Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "No.Series"; Code[20])
        {
            Caption = 'No.Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; "Grade C number"; Decimal)
        {
            Caption = 'เกรด C จำนวน';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Grade A number"; Decimal)
        {
            Caption = 'เกรด A จำนวน';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Grade Scap number"; Decimal)
        {
            Caption = 'เกรด scap จำนวน';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "C Var.%"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Scap Var.%"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "A. Var.%"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Total"; Decimal)
        {
            Caption = 'จำนวน';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        InvenSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement; // Codeunit ตั้งค่าความสามารถในการช่วยแก้ไขสำหรับกล่องข้อความ 

    trigger OnInsert()
    begin
        if "Document No" = '' then begin // ถ้า Document เป็นค่าว่าง 
            InvenSetup.Get();
            InvenSetup.TestField("Document No"); // ทดสอบว่าข้อมูลตรงกันไหม
            NoSeriesMgt.InitSeries(InvenSetup."Document No", xRec."No.Series", 0D, "Document No", "No.Series"); //ก็ไปทำฟังชั่น get doc no ใน no series
        end;
        InitRecord();
    end;



    // trigger OnModify()
    // begin

    // end;

    // trigger OnDelete()
    // begin

    // end;

    // trigger OnRename()
    // begin

    // end;

    procedure InitRecord() // ใช้ข้างนอกและข้างในได้  InitRecord เริ่มต้นการบัทึกลงตาราง
    begin
        "Document Date" := WorkDate();
    end;

    procedure AssistEdit(OldCertofAnalysis: Record "product grade sorting header"): Boolean
    begin
        InvenSetup.Get(); // เรียกใช้ฟังชั่น ให้ get ข้อมูลใน inventory setup โดยใช้คำสั่ง get
        TestNoSeries(); // จากนั้นให้ไปเข้าฟังชั่น TestNoseries
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldCertofAnalysis."No.Series", "No.Series") then begin // ถ้าเข้าเงื่อนไขก็นำ noseries มาใส่
            TestNoSeries();
            NoSeriesMgt.SetSeries("Document No");
            exit(true);
        end;
    end;

    local procedure TestNoSeries() // ใช้ได้แค่ภายใน

    begin
        InvenSetup.TestField("Document No"); // มันจะทำการ testfield ว่ามันmatch กันไหม ละอาข้อมูลมา
    end;

    local procedure GetNoSeriesCode(): Code[20]
    begin
        exit(InvenSetup."Document No"); // ตรงนี้คือจังหวะเอา no series มาใสใน Document No
    end;



}