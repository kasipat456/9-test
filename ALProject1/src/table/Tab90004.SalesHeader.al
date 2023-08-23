table 90004 "SalesHeader"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document")
        {
            Caption = 'Document Type';
        }
        field(2; "Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "City"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "County"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Contact"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        // Ex 4.
        field(7; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Document Date';

            //TableRelation = "Payment Terms";
            trigger OnValidate()
            var
                // Text000: Label 'You have modified Promised Delivery Date.\\Do you want to update the lines?';
                // Text001: Label 'Confirm';
                Text001: Label 'Shipment Date %1'; //%1,%2 TEST //is before work date  %2
            begin

                if
                    Confirm('You have modified Promised Delivery Date.\\Do you want to update the lines?') then
                    message(Text001, "Document Date"); //"Shipment Date"
                // else
                //     "Document Date" := xRec."Document Date";

                if "Document Date" <> xRec."Document Date" then
                    "Shipment Date" := System.CalcDate('1D', "Document Date");

                Datecal(); // เรียกใช้ Function Datecal 
                exit;
            end;

        }
        //----------------------------------------------------------------
        field(8; Status; Enum "Sales Document Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        //-----------------------------------------------------------------
        field(9; "Vendor Invoice No."; Code[20])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(10; "No."; Code[20])
        {
            Caption = 'No';
        }
        field(11; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
        }
        field(12; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            trigger OnValidate()
            var
            begin
                // Message('test');
            end;
        }
        field(13; "Vendor Shipment No."; Text[100])

        {
            Caption = 'Vendor Shipment No.';
        }

        field(14; "Vendor Number."; Code[20])
        {
            Caption = 'Vendor Number';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vendortable: Record Vendor;
            begin
                Vendortable.Reset();
                if Vendortable.Get("Vendor Number.") then begin
                    Validate("Vendor Name", Vendortable.Name);
                    Validate(City, Vendortable.city);
                    Validate(Address, Vendortable.address);
                    Validate(Contact, Vendortable.Contact);
                    Validate("Post Code", Vendortable."Post Code");
                end
            end;
        }

        // Ex 3. เปลี่ยนวันที่
        field(15; "Shipment Date"; Date)
        {

            Caption = 'Shipment Date';
            trigger OnValidate()
            var
                Text001: Label 'Shipment Date %1';
                SalesLine: Record SalesLine;
                SaleesHeader: Record SalesLine;
            begin
                if // Yes ให้ออกข้อความใน Comfirm/ No ให้ออกข้อความ No Posting
                Confirm('You have modified Promised Delivery Date.\\Do you want to update the lines?') then
                    message(Text001, "Shipment Date")
                ELSE
                    MESSAGE('No Posting');

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", Rec."No.");
                if SalesLine.FindSet() then begin
                    repeat
                        SalesLine."Shipment Date" := Rec."Shipment Date";
                        SalesLine.Modify();

                    // Message(SalesLine."No.");
                    until SalesLine.Next() = 0;
                    exit;

                end;
                DateCal()
            end;
        }

        // EX 4.
        field(16; "Shipment Date Calaulation"; DateFormula) // DateFormula คือ สูตรการคำนวนวันที่
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms"."Due Date Calculation";
            ValidateTableRelation = false; // ValidateTableRelation ตั้งค่าว่าจะตรวจสอบความสัมพันธ์หรือไม่
            trigger OnValidate();
            begin
                Datecal(); // เรียกใช้ฟังก์ชัน
            end;
        }

        // EX 3. FlowField
        field(17; Amount1; Decimal)
        {
            Editable = false;     // ตัวนี้คือตัวปิดไม่ให้แก้ไข
            Caption = 'Amount1 :';
            FieldClass = FlowField;
            CalcFormula = sum("SalesLine"."Amount1" where("Document Type" = field("Document Type"), "Document No." = field("No.")));

            // Amount ของ SaleLine 
        }

        // EX 3.  Codeing 
        field(18; Amount2; Decimal)
        {
            Caption = 'Amount2';
            // Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = sum("SalesLine"."Amount1" where("Document Type" = field("Document Type"), "Document No." = field("No.")));


        }

        field(19; "VAT Registration No"; Text[20])
        {
            Caption = 'VAT Registration No';
            DataClassification = ToBeClassified;
        }
        field(20; Picture; Blob) // ใช้เกี่ยวกับรูปภาพ
        {
            Caption = 'Picture';
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.") // PK SalesHeader
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        DeleteSalesLine: Record "SalesLine";

        DeleteComment: Record "CommentSalesLine";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete() // Delete SalesLine and CommentLine EX.6.1
    begin
        DeleteSalesLine.Reset();
        DeleteSalesLine.SetRange("Document Type", "Document Type"); //T SalesLine / Header
        DeleteSalesLine.SetRange("Document No.", "No.");
        IF DeleteSalesLine.FindSet() then
            DeleteSalesLine.DeleteAll();
        DeleteComment.SetRange("Document No.", "No."); // T CommentLine // H No.
        DeleteComment.DeleteAll();

    end;

    trigger OnRename()
    begin

    end;

    //----------------------------------------------------------------------------------------- Ex.4
    procedure DateCal() // Function คำนวนวันใหม่ตามวันที่อ้างไว้

    begin
        if rec."Document Date" <> 0D then begin
            rec.Validate("Shipment Date", CalcDate("Shipment Date Calaulation", rec."Document Date"));
        end else begin
        end;
    end;
    //-------------------------------------------------------------------------------------------------

}