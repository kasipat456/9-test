page 90013 RecursiveList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = RecursiveTable;
    CardPageId = RecursiveHeader;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Item; Rec.Item)
                {
                    ApplicationArea = All;

                }
                field(Parent; Rec.Parent)
                {
                    ApplicationArea = All;

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Recursive") //-----Recursive ตรงนี้เป็นตัวที่เราเลือกเมนู
            {
                ApplicationArea = Dimensions;
                Caption = 'Recursive';
                ToolTip = 'Recursive Header'; // ToolTip ตั้งค่าสตริงที่ใช้สำหรับคำแนะนำเครื่องมือของการดำเนินการ ฟิลด์ FactBox หรือปุ่มกิจกรรม

                trigger OnAction()
                var
                    RecursiveReport: Report Recursive_Funtion; ///--------------------------Report
                    Recursivtemp: Record RecursiveTable temporary; ///--------------Record
                begin
                    // if Recursive_Item.findset() then
                    //     Report.Run(50134, true, true, "Recursive_Item");
                    RecursiveReport.SetTableView(Recursivtemp); ///ตัวนี้จะไปเอาฟังชั่นใน var แต่ถ้าtemporary ในนี้จะต้องสร้างมาใหม่
                    RecursiveReport.RunModal();
                end;
            }
            action("OnlyRecursive") //Recursive ตรงนี้เป็นตัวที่เราเลือกเมนู
            {
                ApplicationArea = Dimensions;
                Caption = 'OnlyRecursive';
                ToolTip = 'Recursive Header';

                trigger OnAction()
                var
                    Only_RecursiveReport: Report Recursive;
                    Only_tmp: Record RecursiveTable temporary;
                begin
                    Only_RecursiveReport.SetTableView(Only_tmp);
                    Only_RecursiveReport.RunModal();
                end;
            }
        }
    }
}