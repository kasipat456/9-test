page 90023 "CommentLine"
{
    PageType = List; //list ข้อมูลเพื่อดู
    SourceTable = CommentSalesLine; //Relation เพื่อเชื่อมต่อข้อมูล
    AutoSplitKey = true; // สร้างคีย์โดยอัตโนมัติสำหรับเรคคอร์ดใหม่ที่อยู่ระหว่างเรคคอร์ดปัจจุบันและเรคคอร์ดก่อนหน้าหรือไม่
    DataCaptionFields = "Document Line No", No; // ตั้งค่าฟิลด์ที่ปรากฏทางด้านซ้ายของคำบรรยายบนหน้าที่แสดงเนื้อหาของตารางนี้
    DelayedInsert = true; // ตั้งค่าที่ระบุว่าผู้ใช้ต้องทิ้งบันทึกก่อนที่จะแทรกลงในฐานข้อมูลหรือไม่ 
    LinksAllowed = false; // ตั้งค่าว่าจะอนุญาตให้ใช้ลิงก์หรือไม่
    MultipleNewLines = true; // ตั้งค่าที่กำหนดว่าผู้ใช้สามารถเพิ่มบรรทัดใหม่หลายบรรทัดระหว่างเรกคอร์ดได้หรือไม่
    Caption = 'CommentLine';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General01)
            {
                ShowCaption = false;
                field(Date; Rec.Date)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Date';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Comment';
                }
            }
        }
    }
}