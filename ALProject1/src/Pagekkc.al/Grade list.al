page 90025 "Grade list"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "product grade sorting header";
    CardPageId = "product grade sorting";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}