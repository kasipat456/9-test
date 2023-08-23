page 90012 RecursiveHeader
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = RecursiveTable;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(Item; Rec.Item)
                {
                    Caption = 'Item';
                    ApplicationArea = All;

                }
                field(Parent; Rec.Parent)
                {
                    Caption = 'Parent';
                    ApplicationArea = All;

                }
            }
        }

    }

}