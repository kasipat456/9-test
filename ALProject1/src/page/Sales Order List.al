page 90011 SalesOrderList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SalesHeader;
    CardPageId = SalesHeader;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;

                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;

                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;

                }

                field("Tax Invoice Date"; Rec."Tax Invoice Date")
                {
                    ApplicationArea = All;

                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;

                }
                field("Shipment Date Calaulation"; Rec."Shipment Date Calaulation")
                {
                    ApplicationArea = All;

                }
                field(Amount1; Rec.Amount1)
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
