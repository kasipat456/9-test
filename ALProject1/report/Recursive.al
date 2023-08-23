report 90007 Recursive
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Recursive';
    RDLCLayout = 'Layouts/Recursive.rdl';


    dataset
    {
        dataitem(RecursiveTable; RecursiveTable)
        {
            trigger OnAfterGetRecord()
            begin
                RecurseItem(PutNumber);
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            column(Item; tmp.Item)
            {

            }
            column(Parent; tmp.Parent)
            {

            }
            trigger OnPreDataItem() // OnPreDataItem --> ทำงานก่อนที่จะประมวลผลรายการข้อมูล
            begin
                tmp.Reset();
                Reset();
                SetRange(Number, 1, tmp.Count);
            end;

            trigger OnAfterGetRecord() // OnAfterGetRecord --> ทำงานหลังจากเรียกระเบียนจากตาราง แต่ก่อนที่จะแสดงต่อผู้ใช้
            begin
                if Number = 1 then
                    tmp.FindSet() // FindSet --> ค้นหาชุดของระเบียนในตารางตามคีย์และตัวกรองปัจจุบัน
                else
                    tmp.Next()
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field("N0. of PutNumber"; PutNumber)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

    }
    procedure RecurseItem(var KeyNumberNo: Code[20]) //ฟังชั่นวนตัวเอง
    var
        RecursiveItem: Record RecursiveTable;
    begin
        SaveTempTable(KeyNumberNo);  //เรียกฟังชั่นหลักการทำงาน
                                     //*-------------------------***//
        RecursiveItem.Reset; //Resetค่า tmpItem
        RecursiveItem.SetRange(Parent, KeyNumberNo); //หลังจากเค้าหาItemแล้ว หลังจากนั้นต้องเชื่อมParent ของทางฟังชั่น

        IF RecursiveItem.FindSet() then
            Repeat

                RecurseItem(RecursiveItem.Item); //เรียกตัวเอง แล้วก็กำหนดเงือนไขลูกจากบนลงล่าง

            until RecursiveItem.NEXT = 0;
    end;

    procedure SaveTempTable(var KeyNumberNo: Code[20])//ฟังชั่นหลัก
    begin
        //เงือนไขที่ใช้คือเราต้องการดูลูกมีใครบ้าง ดังนั้นตอนกรอกข้อมูลเลยจะต้อง SetRange ค่าParent temporary กับ ค่า var ที่รับมา
        tmp.SetRange(Parent, KeyNumberNo); //' '== 1  

        if not tmp.FindSet then begin
            intEntryNo += 1;
            clear(tmp); /// -----------ล้างค่าของตัวแปรเดียว
                        //------------------------- นอกจากนี้ยังล้างตัวกรองทั้งหมดที่ตั้งค่าไว้หากตัวแปรเป็นเรกคอร์ดและรีเซ็ตคีย์เป็นคีย์หลักและ บริษัท
            tmp.Item := format(intEntryNo);

            tmp.Parent := KeyNumberNo;//เอาข้อมูลจากที่ทำงานยัดTmp.Parent
                                      //*-------------------------***//
            tmp.insert(); //--------------------------insert ข้อมูล
        end;
    end;


    var
        tmp: Record RecursiveTable temporary;
        PutNumber: Code[30];

        intEntryNo: Integer;
}