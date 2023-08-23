page 90026 Lines
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "product grade sorting line";
    AutoSplitKey = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Defact item No."; Rec."Defact item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Defact Reasn Code"; Rec."Defact Reasn Code")
                {
                    ApplicationArea = All;
                }
                field("Defact Qty"; Rec."Defact Qty")
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