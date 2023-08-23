table 90005 "SalesLine"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(99; "Document Type"; Enum "Sales Document")
        {
            DataClassification = ToBeClassified;
        }
        field(1; "Type"; Enum "Sales Line")
        {
            DataClassification = ToBeClassified;
        }

        field(2; "No."; Code[20])  // Code แปลงให้เป็นเลขตัวใหญ่และลบช่องว่างท้ายหรือข้างหน้า
        {
            Caption = 'No';
            TableRelation = Item;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                Item.Reset();
                if Item.Get("No.") then begin
                    Validate("Description", Item.Description);
                    Validate("Price", Item."Unit Price");
                end
            end;
        }

        field(3; "Document No."; Code[20]) // Code แปลงให้เป็นเลขตัวใหญ่และลบช่องว่างท้ายหรือข้างหน้า
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer) // ชนิดข้อมูลจำนวนเต็ม  -2,147,483,647 ถึง 2,147,483,647
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Item Reference No"; Code[20]) // Code แปลงให้เป็นเลขตัวใหญ่และลบช่องว่างท้ายหรือข้างหน้า
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Description"; Text[100]) // ข้อความ
        {
            Caption = 'Description';
        }
        field(7; "Location Code: "; Code[20]) // Code แปลงให้เป็นเลขตัวใหญ่และลบช่องว่างท้ายหรือข้างหน้า
        {
            DataClassification = ToBeClassified;
        }

        field(8; "Quantity"; Integer) // จำนวนเต็ม
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                SalesHeader: Record SalesHeader;
            begin
                Amount1 := Quantity * Price;
                SalesHeader.Reset(); // Reset ลบตัวกรองทั้งหมด
                SalesHeader.SetRange("Document Type");
                if SalesHeader.FindSet() then begin
                    SalesHeader.Modify();
                end;
            end;

        }

        // EX 3.
        field(10; "Price"; Decimal) // เลขทศนิยม
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Amount1 := Quantity * Price;
            end;

        }
        field(11; "Amount1"; Decimal) // เลขทศนิยม
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Amount2"; Decimal) // เลขทศนิยม
        {
            Caption = 'Amount2 :';
        }
        field(13; "Shipment Date"; Date) // รูปแบบข้อความที่แสดงของวันที่กำหนดโดยการตั้งค่าภูมิภาคและรูปแบบภาษาของคุณใน Windows
        {
            Caption = 'Shipment Date';
        }
        field(14; "Date"; Date) // รูปแบบข้อความที่แสดงของวันที่กำหนดโดยการตั้งค่าภูมิภาคและรูปแบบภาษาของคุณใน Windows
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; "Document Type", "type", "Document No.", "Line No.") // PK ทั้งหมดชอง SalesLine
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        Total: Decimal;
        Total1: Decimal;

        DeleteCommentSalesLine: Record CommentSalesLine;

    trigger OnInsert()
    begin

    end;


    trigger OnModify()
    begin

    end;
    //--------------------------------------------------------------------------------

    trigger OnDelete() // Delete Comment Line EX.6.2
    begin
        DeleteCommentSalesLine.SetRange("Document Type", "Document Type"); // Comment/SalesLine ที่เหมือนกัน 
        DeleteCommentSalesLine.SetRange("Document No.", "Document No."); //
        DeleteCommentSalesLine.SetRange("Line No.", "Line No.");
        DeleteCommentSalesLine.DeleteAll(); // ลบข้อมูลทั้งหมดที่อยู่ในนั้น
    end;

    trigger OnRename()
    begin

    end;

    //-----------------------------------------------------------
    procedure Comment() // 
    var
        comment: Record "CommentSalesLine";
        showcomment: Page "CommentLine";
    begin
        comment.SetRange("Document Type", "Document Type");
        comment.SetRange("Document No.", "Document No.");
        // comment.SetRange("Line No.", "No.");
        comment.SetRange("Line No.", "Line No.");
        showcomment.SetTableView(comment);
        showcomment.RunModal(); // สร้าง เปิด และ ปิด เพจที่คุณระบุเอาไว้
    end;
    //-----------------------------------------------------------

    //-----------------------------------------------------------
    procedure ItemList() // เลือก Item  ได้หลายรายการ
    var
        ItemList: Page "Item List";
        Item: Record Item;
        SL: Record SalesLine;
        LineNo: Integer;

    begin
        ItemList.LookupMode := true;
        if ItemList.RunModal() = Action::LookupOK then begin
            SL.SetRange("Document Type", "Document Type"); // SETRANGE กับ TABLE ตัวเอง 
            SL.SetRange("Document No.", "Document No.");
            if SL.FindLast() then // FindLast ค้นหาข้อมูลตัวสุดท้ายของตาราง
                LineNo := SL."Line No.";
            Item.SetFilter("No.", ItemList.GetSelectionFilter());
            if Item.FindSet() then
                repeat
                    LineNo += 10000;
                    SL.Init(); // เริ่มต้นบันทึกในตาราง 
                    SL."Document Type" := Rec."Document Type";
                    SL."Document No." := Rec."Document No.";
                    SL."Line No." := LineNo;
                    SL.Insert(true);
                    SL.Validate("No.", Item."No.");
                    SL.Modify(true); // แก้ไขข้อมูลในตาราง
                until Item.Next() = 0;
        end;
    end;
}