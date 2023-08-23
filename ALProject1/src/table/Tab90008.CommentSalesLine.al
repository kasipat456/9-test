table 90008 "CommentSalesLine"
{
    Caption = 'CommentSalesLine';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; No; Code[50])
        {
            Caption = 'No';
        }

        field(2; Date; Date)
        {
            Caption = 'Date';
        }

        field(3; Comment; Text[200])
        {
            Caption = 'Comment';
        }
        field(4; "Document Line No"; Integer)
        {
            Caption = 'Document Line No';
        }
        field(5; "Comment Line No."; Integer)
        {
            Caption = 'Comment Line No.';
        }

        field(6; "Type"; Enum "Sales Line")
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(99; "Document Type"; Enum "Sales Document")
        {
            DataClassification = ToBeClassified;
            // DataClassification ระบุการจัดประเภทที่จะใช้กับข้อมูลที่มีอยู่ในตาราง 

        }
    }

    keys
    {

        key(Key1; "Document Type", "type", "Document No.", "Line No.", "Comment Line No.") //3 key ต้อง3vkey เพราะมันต้องนอมอไหล PK CommentSalesLine 
        {
            Clustered = true; // ตั้งค่าที่ระบุว่าคีย์กำหนดดัชนีคลัสเตอร์ในฐานข้อมูลด้วยหรือไม่
        }


    }
}
