page 90010 Line
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SalesLine;
    AutoSplitKey = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                // field("Type:"; Rec."Type")
                // {
                //     ApplicationArea = All;

                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();      // CurrPage = หน้านี้  Update = อัพเดช  รวมคือเมื่อมีการทำอะไรกับ Field นี้จะมีการอัพเดช
                    end;
                }
                // field("Item Reference No"; Rec."Item Reference No")
                // {
                //     ApplicationArea = All;
                // }
                // field("Location Code: "; Rec."Location Code: ")
                // {
                //     ApplicationArea = All;
                // }

                field("Description:"; Rec."Description")
                {
                    ApplicationArea = All;

                }
                field("Quantity:"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        SalesHeader: Record SalesHeader;
                    begin
                        Rec.Amount1 := Rec.Quantity * Rec.Price;
                        Rec.Modify();

                        SumAmount2(); // เรียกใช้ฟังก์ชั่น
                        CurrPage.Update(); // บันทึกเรกคอร์ดปัจจุบันแล้วอัปเดตตัวควบคุมบนเพจ 
                    end;
                }
                field("Price :"; Rec."Price")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        SalesHeader: Record SalesHeader;
                    begin
                        Rec.Amount1 := Rec.Quantity * Rec.Price;
                        Rec.Modify();

                        SumAmount2();
                        CurrPage.Update();      // CurrPage = หน้านี้  Update = อัพเดช  รวมคือเมื่อมีการทำอะไรกับ Field นี้จะมีการอัพเดช
                    end;
                }

                field("Amount1"; Rec."Amount1")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.Amount2 := Rec.Quantity * Rec.Price;
                        Rec.Modify();
                        SumAmount2();
                        CurrPage.Update();      // CurrPage = หน้านี้  Update = อัพเดช  รวมคือเมื่อมีการทำอะไรกับ Field นี้จะมีการอัพเดช
                    end;
                }
                field("Shipment Date"; Rec."Shipment Date")
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
            // action(ActionName)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction();
            //     begin

            //     end;
            // }
            action(comment)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    rec.Comment();
                end;
            }
            action(Item)
            {
                AccessByPermission = tabledata Item = R;
                ApplicationArea = Basic, Suite;
                Ellipsis = true;

                trigger OnAction();
                begin
                    Rec.ItemList();
                    CurrPage.Update(false);
                end;
            }
        }
    }
    procedure SumAmount2()  //การสร้าง Function
    var
        Total: Decimal;
        SalesLine: Record SalesLine;
        CalAmount: Decimal;
        SalesHeader: Record SalesHeader;
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", rec."Document Type");
        SalesLine.SetRange("Document No.", rec."Document No.");
        if SalesLine.FindSet() then begin
            repeat
                Total += SalesLine."Amount1";
            until SalesLine.Next() = 0;
        end;

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetRange("No.", Rec."Document No.");
        if SalesHeader.FindSet() then begin
            SalesHeader.Amount2 := Total;
            SalesHeader.Modify();
        end;
    end;
}
