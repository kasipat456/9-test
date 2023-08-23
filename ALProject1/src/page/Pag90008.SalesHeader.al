page 90008 "SalesHeader"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = SalesHeader;
    RefreshOnActivate = true; // ตั้งค่าคุณสมบัตินี้ในเพจที่คุณต้องการรีเฟรชข้อมูลเมื่อผู้ใช้ย้อนกลับจากเพจอื่น

    layout
    {
        area(Content)
        {

            group(General)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address where the customer is located.';
                }
                field("Vendor Number."; Rec."Vendor Number.")
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
                    ToolTip = 'Specifies the number of the contact person that the sales document will be sent to.';

                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field("Shipment Date Calaulation"; Rec."Shipment Date Calaulation")
                {
                    ApplicationArea = All;
                }
                field(Amount1; Rec.Amount1)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                }

                field(Amount2; Rec.Amount2)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                }
                // ------------------------------------------------------------------------------------
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    // StyleExpr = StatusStyleTxt;
                    QuickEntry = false;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                }
                // ---------------------------------------------------------------------------------------

            }
            part(SalesLines; Line)
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;   // คือ ความสัมพันของหน้าที่มีการเชื่อมต่อกัน

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Report_PurchaseOrder)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "SalesHeader";
                    report2: Report Report_TWo;
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindSet() then begin
                        Report.RunModal(Report::"Report_TWo", true, true, SalesHeader);
                    end;
                end;
            }
            // action(Report_PurchaseOrder2)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     var
            //         SalesHeader: Record "SalesHeader";
            //         report2: Report Report_three;
            //     begin
            //         SalesHeader.Reset();
            //         SalesHeader.SetRange("No.", rec."No.");
            //         if SalesHeader.FindSet() then begin
            //             Report.RunModal(Report::"Report_three", true, true, SalesHeader);
            //         end;
            //     end;
            // }
            action(Report_Wizard)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "SalesHeader";
                    Report_SalesOrder: Report Report_SalesOrder;
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindSet() then begin
                        Report.RunModal(Report::"Report_SalesOrder", true, true, SalesHeader);
                    end;
                end;
            }
            action(Report_Original)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "SalesHeader";
                    Report_Original: Report Report_Original;
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", rec."No.");
                    if SalesHeader.FindSet() then begin
                        Report.RunModal(Report::"Report_Original", true, true, SalesHeader);
                    end;
                end;
            }

            action(Report_Recursive)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecursiveTable: Record "RecursiveTable";
                    Report_Recursive: Report Recursive;
                begin
                    RecursiveTable.Reset();
                    RecursiveTable.SetRange(Item);
                    if RecursiveTable.FindSet() then begin
                        Report.RunModal(Report::"Recursive", true, true);
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}